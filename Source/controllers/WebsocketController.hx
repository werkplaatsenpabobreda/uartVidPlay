package controllers;

import hx.ws.WebSocket;
import haxe.Json;
import haxe.io.Bytes;

typedef JsonMessage = {
	var msg:String;
	var data:Dynamic;
}

class WebsocketController {

    public static var instance(default, null):WebsocketController = new WebsocketController();
    
	public var wsHost:String = "localhost";
	public var wsPort:Int = 80;

	var ws:WebSocket;
    
	private function new() {}

	public function connect() {
       
		try {
			var ws = new WebSocket('${wsHost}');

			ws.onerror = function(e) {
				trace('websocket error ${e}');
			}

			ws.onclose = function() {
				//trace('websocket close');
				haxe.Timer.delay(connect, 5000);
			}

			ws.onopen = function() {
                //trace('websocket opened');
				ws.send(Json.stringify({msg: "clientType", data: "TagToVideo App v1.0"}));
			}

			ws.onmessage = function(data) {
               // trace('websocket onmessage');
				var parameters:Array<Dynamic>;
				var isJson = true;
				var msg:String = "";
				var jsonData:JsonMessage = {msg: "", data: ""};

				parameters = data.getParameters();

				if (parameters != null) {
					if (parameters.length > 0) {
						try {
							jsonData = Json.parse(parameters[0]);
							if (jsonData.msg != null) {
								msg = jsonData.msg;
							}
						} catch (e) {
							isJson = false;
							msg = Std.string(parameters[0]);
							jsonData = {msg: msg, data: msg}
						}
					}

					if (msg == "tagDetected" && isJson) {
						haxe.Timer.delay(() -> {
							if (jsonData != null) {
								SignalController.tagDetected.dispatch(Std.string(jsonData.data));
							}
						}, 50);
					}
				}
			}
		} catch (e) {
			haxe.Timer.delay(connect, 5000);
		}
	}
}
