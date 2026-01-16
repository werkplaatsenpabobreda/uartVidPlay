package controllers;

import signals.Signal1;

class SignalController {
    
    public static var tagDetected:Signal1<String> = new Signal1<String>();
    public static var tagDeviceReady:Signal1<String> = new Signal1<String>();
    public static var tagDeviceError:Signal1<String> = new Signal1<String>();
    public static var noSerialDeviceError:Signal1<String> = new Signal1<String>();
    public static var message:Signal1<String> = new Signal1<String>();
    public static var error:Signal1<String> = new Signal1<String>();
}