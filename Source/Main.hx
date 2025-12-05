package;

import controllers.KeyboardController;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.StageDisplayState;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.*;
import lime.system.System;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import haxe.Timer;
import hxvlc.openfl.Video;


import controllers.SerialController;
import controllers.WebsocketController;
import controllers.SignalController;
import controllers.DataController;

class Main extends Sprite {
	
	#if useSerial
	var serialController:SerialController;
	#end

	#if useWebsocket
	var websocketController:WebsocketController;
	#end

	var keyboardController:KeyboardController;

	var doVideoUpdate:Bool = false;

	var tagStartTime:Int = 0;
	var tagTriggerDebounce:Int = 2000; // how long before a new tag can be scanned and trigger a Video
	var currentTag:String;

	var keyBuffer:String = "";

	var ffmpegAvailable:Bool = false;
	var stopUpdateAtNextFrame:Bool = false;

	// UI
	var video:Video;
	var statusText:TextField;
	var background:Bitmap;

	/** 
	 *
	 */
	public function new() {
		super();

		DataController.loadConfig();
		SignalController.tagDetected.add( playVideoByTag );

		initUI();
		
		#if useSerial
		serialController = SerialController.instance;
		serialController.connectSerialPortByIndex(DataController.data.portIndex);
		#end

		#if useWebsocket
		websocketController = WebsocketController.instance;
		websocketController.wsHost = DataController.data.websocketHost;
		websocketController.connect();
		#end

		keyboardController = KeyboardController.instance;
		keyboardController.init(stage);

		initVideo();

		if (DataController.data.fullscreen) {
			goFullScreen();
		}

		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.RESIZE, stage_resize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_onKeyDown);
		
	}

	/**
	 * Create an instructions overlay
	 */
	private function initUI():Void {
		statusText = new TextField();
		statusText.defaultTextFormat = new TextFormat("_sans", 11, 0xFFFFFF);
		statusText.embedFonts = true;
		statusText.antiAliasType = AntiAliasType.ADVANCED;
		statusText.gridFitType = GridFitType.PIXEL;
		statusText.width = stage.stageWidth;
		statusText.height = 100;
		statusText.selectable = false;
		statusText.mouseEnabled = false;
		statusText.text = "";

		if (DataController.data.background != null) {
			background = new Bitmap(Assets.getBitmapData('images/' + DataController.data.background));
			addChild(background);
		}
	}

	/**
	 *	initialize (hxvlc) Video and events
	 */
	private function initVideo() {
		video = new Video();

		video.onOpening.add(function():Void {
			trace("onOpening");
			stage.nativeWindow.addEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.addEventListener(Event.DEACTIVATE, stage_onDeactivate);
			doVideoUpdate = true;
		});

		video.onEndReached.add(function():Void {
			stage.nativeWindow.removeEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.removeEventListener(Event.DEACTIVATE, stage_onDeactivate);
			haxe.Timer.delay( ()->{ removeChild(video);} , 120);
		});

		video.onFormatSetup.add(function():Void {
			trace("onFormatSetup");
		});
	
	}

	/**
	 *
	 */
	function destroyVideo() {
		if (video != null) {
			removeChild(video);
			video.dispose();
			video = null;
		}
	};

	/**
	 * Handle stage enterframe events
	 */
	private inline function stage_onEnterFrame(event:Event):Void {
		
		#if useSerial
		serialController.parseSerial();
		#end

		if (doVideoUpdate) {
			if (video != null && video.bitmapData != null) {
				final aspectRatio:Float = video.bitmapData.width / video.bitmapData.height;

				video.width = stage.stageWidth / stage.stageHeight > aspectRatio ? stage.stageHeight * aspectRatio : stage.stageWidth;
				video.height = stage.stageWidth / stage.stageHeight > aspectRatio ? stage.stageHeight : stage.stageWidth / aspectRatio;
				video.x = (stage.stageWidth - video.width) / 2;
				video.y = (stage.stageHeight - video.height) / 2;
			}
		}

		if (stopUpdateAtNextFrame) {
			doVideoUpdate = false;
			stopUpdateAtNextFrame = false;
		}
	}

	/**
	 * Handle keydown events
	 */
	function stage_onKeyDown(e:KeyboardEvent) {
		// if (e.keyCode == 13) {
		// 	playVideoByTag(keyBuffer);
		// 	keyBuffer = "";
		// } else {
		// 	keyBuffer += String.fromCharCode(e.charCode);
		// }

		if (e.ctrlKey) {
			switch (e.keyCode) {
				case Keyboard.SPACE:
					video.stop();

				#if useSerial
				case Keyboard.T:
					serialController.traceSerialDevices();
				#end

				case Keyboard.COMMA:
					DataController.openConfigJson();

				case Keyboard.H:
					if (contains(statusText)) {
						removeChild(statusText);
					} else {
						addChild(statusText);
					}
			}
		}
	}

	/**
	 * Handle resize events
	 */
	function stage_resize(e:Event) {}

	/**
	 * 
	 */
	public function goFullScreen() {
		stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
	}

	/**
	 * 
	 */
	public function leaveFullScreen() {
		stage.displayState = StageDisplayState.NORMAL;
	}

	/**
	 * 
	 */
	public function toggleFullScreen() {
		if (stage.displayState != StageDisplayState.NORMAL) {
			stage.displayState = StageDisplayState.NORMAL;
		} else {
			goFullScreen();
		}
	}

	/** 
	 * window (re)gained focus
	 */
	private inline function stage_onActivate(event:Event):Void {
		video?.resume();
	}

	/** 
	 * window lost focus
	 */
	private inline function stage_onDeactivate(event:Event):Void {
		video?.pause();
	}

	/**
	 * play video associated with tag
	 */
	private function playVideoByTag(tag:String) {
		if (DataController.waitUntilVideoFinished && video.isPlaying)
			return;

		if (!DataController.retriggerTag && tag == currentTag)
			return;

		tag = tag.toUpperCase();
		var millies = System.getTimer();
		if (millies - tagStartTime < tagTriggerDebounce) {
			trace(' not ready to triger yet.');
			return;
		}
		if (DataController.videoTags.exists(tag)) {
			statusText.text = 'starting video ' + DataController.videoTags.get(tag);
			if (video == null) {
				initVideo();
			}
			video.load(DataController.videoTags.get(tag));
			video.play();
			addChild(video);
			tagStartTime = millies;
		} else {
			statusText.text = 'no such tagged video $tag';
			tagStartTime = millies;
		}
	}
}
