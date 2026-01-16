package controllers;

import hxSerial.Serial;

class SerialController {
	public static var instance(default, null):SerialController = new SerialController();

	public var deviceList:Array<String> = [];

	var usePortPath:Bool = true;
	var serialPortIndex:Int = 0;
	var serialConnected:Bool = false;
	var serialBuffer:String = "";
	var serialLine:String;
	var serialObj:Serial;

	public var storedPortPath:String;
	public var traceSerialLines:Bool = false;

	private function new() {}

	/**
	 * output the index and paths of serial devices
	 */
	public function traceSerialDevices() {
		deviceList = Serial.getDeviceList();
		if (deviceList.length > 0) {
			trace("found the following serial devices:");
			for (j in 0...deviceList.length) {
				trace('index $j  ${deviceList[j]}');
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
			trace('connecting to ${deviceList[i]}');
			storedPortPath = deviceList[i];
			SignalController.message.dispatch('connecting to serialport $storedPortPath');

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
		if (serialPortIndex == -1) {
			SignalController.message.dispatch('serialport $devicePath is not available');
			traceSerialDevices();
		} else {
			SignalController.message.dispatch('connecting to serialport $devicePath');
			serialObj = new hxSerial.Serial(devicePath, 115200, true);
			serialConnected = true;
			storedPortPath = devicePath;
		}
		#end
	}

	/**
	 * [Description]
	 * @return Bool
	 */
	public function hasDevices():Bool {
		if (deviceList == null) {
			deviceList = Serial.getDeviceList();
		}
		if (deviceList.length > 0) {
			return true;
		} else {
			trace("no serial devices found");
			SignalController.noSerialDeviceError.dispatch('no serial devices found');
			return false;
		}
	}

	/**
	 * Connect to the next SerialPort if available
	 */
	public function nextPort() {
		#if useSerial
		if (!hasDevices())
			return;
		if (serialPortIndex < deviceList.length - 1) {
			serialPortIndex++;
		} else {
			serialPortIndex = 0;
		}
		connectSerialPortByIndex(serialPortIndex);
		#end
	}

	/**
	 *  Connect to the previous SerialPort if available
	 */
	public function previousPort() {
		#if useSerial
		if (!hasDevices())
			return;
		if (serialPortIndex > 0) {
			serialPortIndex--;
		} else {
			serialPortIndex = deviceList.length > 0 ? deviceList.length - 1 : 0;
		}
		connectSerialPortByIndex(serialPortIndex);
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
					if (traceSerialLines) {
						trace(serialLine);
					}
					var uCasedSerialLine = serialLine.toUpperCase();
					if (uCasedSerialLine == "INITIALIZING"
						|| uCasedSerialLine == "READY"
						|| uCasedSerialLine == "DIDN'T FIND PN532 BOARD") {
						serialBuffer = "";
						if (uCasedSerialLine == "READY") {
							SignalController.tagDeviceReady.dispatch("READY, waiting for tag");
							SignalController.message.dispatch("READY, waiting for tag");
						} else if (uCasedSerialLine == "DIDN'T FIND PN532 BOARD") {
							SignalController.tagDeviceError.dispatch(serialLine);
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
