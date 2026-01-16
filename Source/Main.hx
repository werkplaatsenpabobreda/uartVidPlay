package;

import lime.ui.MouseWheelMode;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.StageDisplayState;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.ui.Mouse;
import openfl.ui.Keyboard;
import lime.system.System;
import hxvlc.openfl.Video;
import controllers.SignalController;
import controllers.DataController;
import ui.Message;
import ui.ConnectDot;
#if useKeyboard
import controllers.KeyboardController;
#end
#if useSerial
import controllers.SerialController;
#end
#if useWebsocket
import controllers.WebsocketController;
#end

class Main extends Sprite {
	#if useKeyboard
	var keyboardController:KeyboardController;
	#end

	#if useSerial
	var serialController:SerialController;
	#end

	#if useWebsocket
	var websocketController:WebsocketController;
	#end

	var doVideoUpdate:Bool = false;

	var tagStartTime:Int = 0;
	var tagTriggerDebounce:Int = 2000; // how long before a new tag can be scanned and trigger a Video
	var currentTag:String;

	var ffmpegAvailable:Bool = false;
	var stopUpdateAtNextFrame:Bool = false;

	// UI
	var video:Video;
	var background:Bitmap;
	var message:Message;
	var connectDot:ConnectDot;

	/** 
	 *
	 */
	public function new() {
		super();

		DataController.loadConfig();
		SignalController.tagDetected.add(playVideoByTag);
		SignalController.tagDeviceError.add(showMessage);
		SignalController.tagDeviceReady.add(showConnected);
		#if useSerial
		SignalController.error.add(forceShowMessage);
		#end
		SignalController.message.add(showMessage);

		initUI();

		#if useKeyboard
		keyboardController = KeyboardController.instance;
		keyboardController.init(stage);
		#end

		#if useSerial
		SignalController.noSerialDeviceError.add(forceShowMessage);
		serialController = SerialController.instance;
		if (DataController.data.autoDiscoverPort) {
			serialController.autoDiscoverPort();
			addChild(message);
		} else {
			if (DataController.data.usePortPath || DataController.data.portPath != "") {
				serialController.connectSerialPortByPath(DataController.data.portPath);
				message.text = serialController.storedPortPath;
			} else {
				serialController.connectSerialPortByIndex(DataController.data.portIndex);
			}
		}
		#end

		#if useWebsocket
		websocketController = WebsocketController.instance;
		websocketController.wsHost = DataController.data.websocketHost;
		websocketController.connect();
		#end

		initVideo();

		if (DataController.data.hideMouse) {
			Mouse.hide();
		}

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
		if (DataController.data.background != null && DataController.data.background != "") {
			background = new Bitmap(Assets.getBitmapData('images/' + DataController.data.background));
			addChild(background);
		}

		connectDot = new ConnectDot();
		message = new Message();
		addChild(connectDot);
	}

	/**
	 *	initialize (hxvlc) Video and events
	 */
	private function initVideo() {
		video = new Video();

		video.onOpening.add(function():Void {
			stage.nativeWindow.addEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.addEventListener(Event.DEACTIVATE, stage_onDeactivate);
			doVideoUpdate = true;
		});

		video.onEndReached.add(function():Void {
			stage.nativeWindow.removeEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.removeEventListener(Event.DEACTIVATE, stage_onDeactivate);
			haxe.Timer.delay(() -> {
				SignalController.message.dispatch('done playing video');
				removeChild(video);
			}, 120);
		});

		video.onFormatSetup.add(function():Void {
			// trace("onFormatSetup");
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
	 * [Description]
	 */
	function forceShowMessage(s:String) {
		if (message != null) {
			addChild(message);
			showMessage(s);
		}
	}

	/**
	 * [Description]
	 * @param s 
	 */
	function showMessage(s:String) {
		if (message != null) {
			message.text = s;
		} else {
			trace(s);
		}
	}

	/**
	 * [Description]
	 */
	function showConnected() {
		#if useSerial
		DataController.data.portPath = SerialController.instance.storedPortPath;
		#end
		connectDot.connected = true;
		if (!contains(connectDot)) {
			addChild(connectDot);
		}
		haxe.Timer.delay(() -> {
			if (contains(connectDot)) {
				removeChild(connectDot);
			}
		}, 3000);
	}

	/**
	 * Handle keydown events
	 */
	function stage_onKeyDown(e:KeyboardEvent) {
		if (e.ctrlKey) {
			switch (e.keyCode) {
				#if useSerial
				case Keyboard.R:
					serialController.autoDiscoverPort();
				case Keyboard.D:
					serialController.traceSerialLines = !serialController.traceSerialLines;
				case Keyboard.T:
					serialController.traceSerialDevices();
				case Keyboard.RIGHTBRACKET:
					serialController.nextPort();
				case Keyboard.LEFTBRACKET:
					serialController.previousPort();
				#end

				case Keyboard.SPACE:
					video.stop();

				case Keyboard.COMMA:
					DataController.openConfigJson();
				case Keyboard.PERIOD:
					DataController.saveConfig();

				case Keyboard.M:
					if (contains(message)) {
						removeChild(message);
					} else {
						addChild(message);
					}
				case Keyboard.H:
					DataController.data.hideMouse = !DataController.data.hideMouse;
					if (DataController.data.hideMouse) {
						Mouse.hide();
					} else {
						Mouse.show();
					}
			}
		} else {
			message.text += String.fromCharCode(e.charCode);
		}
	}

	/**
	 * Handle resize events
	 */
	function stage_resize(e:Event) {
		message.redraw();
	}

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
			showMessage(' not ready to trigger tag ${tag} yet.');
			trace(' not ready to trigger tag ${tag} yet.');
			return;
		}
		if (DataController.videoTags.exists(tag)) {
			showMessage('starting video ' + DataController.videoTags.get(tag));
			if (video == null) {
				initVideo();
			}
			if (video.isPlaying) {
				video.stop();
			}
			video.load(DataController.videoTags.get(tag));
			video.play();
			addChild(video);
			tagStartTime = millies;
			if (contains(message)) {
				removeChild(message);
			}
		} else {
			showMessage('no such tagged video $tag');
			tagStartTime = millies;
		}
	}
}
