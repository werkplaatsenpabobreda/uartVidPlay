package ui;

import openfl.display.Sprite;
import openfl.events.Event;

class ConnectDot extends Sprite {
	public var connected(default, set):Bool;
	public var radius:Int = 8;
	function set_connected(c:Bool):Bool {
		connected = c;
		draw();
		return connected;
	}

	/**
	 * [Description]
	 */
	public function new() {
		super();

		addEventListener(Event.ADDED_TO_STAGE, stage_added);
	}

	/**
	 * [Description]
	 * @param e 
	 */
	function stage_added(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, stage_added);
		init();
	}

	/**
	 * [Description]x
	 */
	function init() {
		draw();
	}

	/**
	 * [Description]
	 */
	function draw() {
		this.graphics.clear();
		this.graphics.beginFill(connected ? 0x00ff00 : 0xAA6600);
		this.graphics.drawCircle(0, 0, radius);
		this.graphics.endFill();

		this.x = this.y = this.width *.5 + 4;
	}
}
