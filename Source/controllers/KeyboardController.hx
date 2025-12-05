package controllers;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Stage;

class KeyboardController {
	
    public static var instance(default, null):KeyboardController = new KeyboardController();
    
    private function new() {}

    var keyBuffer:String = "";


    public function init(stage:Stage){
        stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_onKeyDown);
    }

    /**
	 * Handle keydown events
	 */
	function stage_onKeyDown(e:KeyboardEvent) {
		if (e.keyCode == 13) {
			SignalController.tagDetected.dispatch(keyBuffer);
			keyBuffer = "";
		} else {
			keyBuffer += String.fromCharCode(e.charCode);
		}
	}
}
