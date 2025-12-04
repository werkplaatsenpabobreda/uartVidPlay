package;

import openfl.Assets;
import openfl.display.Bitmap;
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
#if useSerial
import hxSerial.Serial;
#end
import controllers.DataController;

class Main extends Sprite {
	#if useSerial
	var serialObj:hxSerial.Serial;
	#end

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

	var keyBuffer:String = "";

	var ffmpegAvailable:Bool = false;
	var useSerial = false;
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

		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.RESIZE, stage_resize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_onKeyDown);

		initUI();
		#if useSerial
		useSerial = true;
		initSerial();
		#end
		initVideo();

		if (DataController.data.fullscreen) {
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

		if (stopUpdateAtNextFrame) {
			doVideoUpdate = false;
			stopUpdateAtNextFrame = false;
		}
	}

	/**
	 * Handle keydown events
	 */
	function stage_onKeyDown(e:KeyboardEvent) {
		if (e.keyCode == 13) {
			playVideoByTag(keyBuffer);
			keyBuffer = "";
		} else {
			keyBuffer += String.fromCharCode(e.charCode);
		}

		if (e.ctrlKey) {
			switch (e.keyCode) {
				case Keyboard.SPACE:
					video.stop();

				case Keyboard.T:
					traceSerialDevices();

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

	public function toggleFullScreen() {
		if (stage.displayState != StageDisplayState.NORMAL) {
			stage.displayState = StageDisplayState.NORMAL;
		} else {
			goFullScreen();
		}
	}

	/**
	 * output the index and paths of serial devices
	 */
	function traceSerialDevices() {
		if (deviceList == null)
			return;
		if (deviceList.length > 0) {
			for (j in 0...deviceList.length) {
				trace(j, deviceList[j]);
			}
		} else {
			trace("No serial Devices found");
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
	 * [Description]
	 * @param s 
	 */
	private function autoDiscoverPort(s:String) {
		// loop thtough ports
		// connect
		// checkbuffer volor stringParam
		// wait x seconds
		// found stringParam?  set index, return
		// next port
	}

	/**
	 * Connect to the a SerialPort by Index
	 * @param i PortIndex
	 */
	function connectSerialPortByIndex(i:Int) {
		#if useSerial
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
		#end
	}

	/**
	 * Connect to the a SerialPort by Path
	 * @param String devicePath
	 */
	function connectSerialPortByPath(devicePath:String) {
		#if useSerial
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
		#end
	}

	/**
	 * Connect to the next SerialPort if available
	 */
	function nextPort() {
		#if useSerial
		if (deviceList != null) {
			if (serialPortIndex < deviceList.length - 2) {
				connectSerialPortByIndex(serialPortIndex + 1);
			}
		}
		#end
	}

	/**
	 *  Connect to the previous SerialPort if available
	 */
	function previousPort() {
		#if useSerial
		if (deviceList != null) {
			if (serialPortIndex > 0) {
				connectSerialPortByIndex(serialPortIndex - 1);
			} else {
				connectSerialPortByIndex(0);
			}
		}
		#end
	}

	/**
	 * parse serial data
	 */
	function parseSerial() {
		#if useSerial
		// TODO: THIS COULD BE HANDLED A LOT BETTER
		if (serialConnected) {
			var bytesAvailable = serialObj.available();
			if (bytesAvailable > 0) {
				// trace('bytesAvailable $bytesAvailable ');
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
					// trace(serialLine);
					if (serialLine == "INITIALIZING" || serialLine == "READY") {
						serialBuffer = "";
						if (serialLine == "READY") {
							statusText.text = "READY, waiting for tag";
						}
					} else {
						playVideoByTag(serialLine);
						if (noBytesAfterNewline) {
							serialBuffer = "";
						} else {
							// todo handle bufferRemainder
							serialBuffer = "";
						}
					}
				}
			}
		}
		#end
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
