package controllers;

import hxSerial.Serial;

class SerialController {
    
	public static var instance(default, null):SerialController = new SerialController();

	public var deviceList:Array<String> = [];
	
	var serialPortIndex:Int = 0;
	var serialConnected:Bool = false;
	var serialBuffer:String = "";
	var serialLine:String;
	var storedPortPath:String;
	var serialObj:Serial;

 	private function new() {}
	
    /**
	 * output the index and paths of serial devices
	 */
	public function traceSerialDevices() {
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
	 * [Description]
	 * @param s 
	 */
	public function autoDiscoverPort(s:String) {
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
	public function connectSerialPortByIndex(i:Int) {
		#if useSerial
		if (serialObj != null) {
			if (serialObj.isSetup) {
				serialObj.close();
			}
		}

		deviceList = Serial.getDeviceList();

		if (i >= 0 && i < deviceList.length) {
			serialObj = new hxSerial.Serial(deviceList[i], 115200, true);
			serialConnected = true;
			serialPortIndex = i;
		}
		#end
	}

	/**
	 * Connect to the a SerialPort by Path
	 * @param String devicePath
	 */
	public function connectSerialPortByPath(devicePath:String) {
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
			serialConnected = true;
		} else {
			trace('SerialPort $devicePath is not available');
		}
		#end
	}

	/**
	 * Connect to the next SerialPort if available
	 */
	public function nextPort() {
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
	public function previousPort() {
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
	public function parseSerial() {
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
							SignalController.tagDeviceReady.dispatch("READY, waiting for tag");
						}
					} else {
						
						SignalController.tagDetected.dispatch(serialLine);

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
}