package;

import openfl.display.StageDisplayState;
import haxe.io.Path;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import lime.system.System;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.*;
import hxvlc.openfl.Video;
import hxSerial.Serial;
import controllers.DataController;

class Main extends Sprite {
	var serialObj:hxSerial.Serial;
	var deviceList:Array<String> = [];
	var storedPortPath:String;
	var serialConnected:Bool = false;
	var serialPortIndex:Int = 0;
	var serialBuffer:String = "";
	var serialLine:String;

	var doVideoUpdate:Bool = false;

	var tagStartTime:Int = 0;
	var tagTriggerDebounce:Int = 2000; // how long before a new tag can be scanned and trigger a Video
	var currentTag:String;

	// UI
	var video:Video;
	var statusText:TextField;

	var ffmpegAvailable:Bool = false;

	/** 
	 *
	 */
	public function new() {
		super();

		DataController.loadConfig();

		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.RESIZE, stage_resize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_onKeyDown);


		initUI();
		initSerial();
		initVideo();

		if(DataController.data.fullscreen){
			goFullScreen();
		}
	}

	/**
	 * 
	 */
	private function initSerial():Void {
		connectSerialPortByIndex(DataController.data.portIndex);
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
		
	}

	/**
	 *	initialize (hxvlc) Video and events
	 */
	private function initVideo() {
		video = new Video();
		video.onOpening.add(function():Void {
			stage.nativeWindow.addEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.addEventListener(Event.DEACTIVATE, stage_onDeactivate);
		});
		video.onEndReached.add(function():Void {
			stage.nativeWindow.removeEventListener(Event.ACTIVATE, stage_onActivate);
			stage.nativeWindow.removeEventListener(Event.DEACTIVATE, stage_onDeactivate);
			doVideoUpdate = false;
			if (video != null) {
				removeChild(video);
				video.dispose();
				video = null;
			}
		});
		video.onFormatSetup.add(function():Void {
			doVideoUpdate = true;
		});
		addChild(video);
	}

	/**
	 * Handle stage enterframe events
	 */
	private inline function stage_onEnterFrame(event:Event):Void {
		parseSerial();

		if (doVideoUpdate) {
			if (video != null && video.bitmapData != null) {
				final aspectRatio:Float = video.bitmapData.width / video.bitmapData.height;

				video.width = stage.stageWidth / stage.stageHeight > aspectRatio ? stage.stageHeight * aspectRatio : stage.stageWidth;
				video.height = stage.stageWidth / stage.stageHeight > aspectRatio ? stage.stageHeight : stage.stageWidth / aspectRatio;
				video.x = (stage.stageWidth - video.width) / 2;
				video.y = (stage.stageHeight - video.height) / 2;
			}
		}
	}

	/**
	 * Handle keydown events
	 */
	function stage_onKeyDown(e:KeyboardEvent) {
		switch (e.keyCode) {
			case Keyboard.COMMA:
				if(e.commandKey){
					DataController.openConfigJson();
				}
			case Keyboard.D:
			case Keyboard.T:
				if(contains(statusText)){
					removeChild(statusText);
				}else{
					addChild(statusText);
				}
		}
	}

	/**
	 * Handle resize events
	 */
	function stage_resize(e:Event){

	}
	/**
	 * 
	 */
	public function goFullScreen() {
		trace('goFullScreen');
		stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
	}

	/**
	 * 
	 */
	public function leaveFullScreen() {
		stage.displayState = StageDisplayState.NORMAL;
	}

	public function toggleFullScreen(){
		if (stage.displayState != StageDisplayState.NORMAL) {
			stage.displayState = StageDisplayState.NORMAL;
		}else{
			goFullScreen();
		}
	}

	/**
	 * output the index and paths of serial devices
	 */
	function traceSerialDevices() {
		if (deviceList != null && deviceList.length > 0) {
			for (j in 0...deviceList.length - 1) {
				trace(j, deviceList[j]);
			}
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
	 * Connect to the a SerialPort by Index
	 * @param i PortIndex
	 */
	function connectSerialPortByIndex(i:Int) {
		if (serialObj != null) {
			if (serialObj.isSetup) {
				serialObj.close();
			}
		}

		deviceList = Serial.getDeviceList();

		if (i >= 0 && i < deviceList.length) {
			serialObj = new hxSerial.Serial(deviceList[i], 115200, true);
			statusText.text = 'connected to ${serialObj.portName}';
			serialConnected = true;
			serialPortIndex = i;
		} else {
			statusText.text = 'SerialPort index $i is not available';
		}
	}

	/**
	 * Connect to the a SerialPort by Path
	 * @param String devicePath
	 */
	function connectSerialPortByPath(devicePath:String) {
		if (serialObj != null) {
			if (serialObj.isSetup) {
				serialObj.close();
			}
		}

		deviceList = Serial.getDeviceList();
		serialPortIndex = deviceList.indexOf(devicePath);
		if (serialPortIndex != -1) {
			serialObj = new hxSerial.Serial(deviceList[serialPortIndex], 115200, true);
			statusText.text = 'connected to ${serialObj.portName}';
			serialConnected = true;
		} else {
			statusText.text = 'SerialPort $devicePath is not available';
			trace('SerialPort $devicePath is not available');
		}
	}

	/**
	 * Connect to the next SerialPort if available
	 */
	function nextPort() {
		if (deviceList != null) {
			if (serialPortIndex < deviceList.length - 2) {
				connectSerialPortByIndex(serialPortIndex + 1);
			}
		}
	}

	/**
	 *  Connect to the previous SerialPort if available
	 */
	function previousPort() {
		if (deviceList != null) {
			if (serialPortIndex > 0) {
				connectSerialPortByIndex(serialPortIndex - 1);
			} else {
				connectSerialPortByIndex(0);
			}
		}
	}

	/**
	 * parse serial data
	 */
	function parseSerial() {
		// TODO: THIS COULD BE HANDLED A LOT BETTER
		if (serialConnected) {
			var bytesAvailable = serialObj.available();
			if (bytesAvailable > 0) {
				//trace('bytesAvailable $bytesAvailable ');
				serialBuffer += serialObj.readBytes(bytesAvailable).toString();
				// remove any \r characters
				serialBuffer = StringTools.replace(serialBuffer, "\r", "");

				// if there's a line feed?
				if (serialBuffer.indexOf('\n') != -1) {
					// is the newline at the end of the buffer?
					var noBytesAfterNewline = serialBuffer.lastIndexOf('\n') == serialBuffer.length - 1;

					// split lines
					var lines:Array<String> = serialBuffer.split("\n");

					// microbit seems to be sending a space (char 32) filled buffer.
					serialLine = StringTools.trim(lines[0]);
					//trace(serialLine);
					if(serialLine=="INITIALIZING" || serialLine=="READY"){
						serialBuffer="";
						if(serialLine=="READY"){
							statusText.text = "READY, waiting for tag";
						}
					}else{
						playVideoByTag(serialLine);
						if(noBytesAfterNewline){
							serialBuffer="";
						}else{
							// todo handle bufferRemainder
							serialBuffer="";
						}
					}
					
				}
			}
		}
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
			statusText.text = 'starting video ' + DataController.videoTags.get(tag) ;
			video.load(DataController.videoTags.get(tag));
			video.play();
			tagStartTime = millies;
		} else {
			statusText.text = 'no such tagged video $tag';
			tagStartTime = millies;
		}
	}


}
