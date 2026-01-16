package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.*;

class Message extends Sprite {
	public var msg:String = "";

	private var background:Sprite;
	private var txMsg:TextField;
	private var tf:TextFormat;
	private var padding:Int = 8;
	private var _height = 48;

	public var text(default, set):String = "";

	private function set_text(t:String):String {
		if (txMsg != null) {
			txMsg.text = t;
		}
		return this.text = t;
	}

	public function new() {
		super();

		addEventListener(Event.ADDED_TO_STAGE, stage_added);
	}

	function stage_added(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, stage_added);
		init();
	}

	function init() {
		tf = new TextFormat("_sans", 12, 0xFFFFFF);
		txMsg = new TextField();
		txMsg.defaultTextFormat = tf;
		// txMsg.embedFonts = true;
		txMsg.antiAliasType = AntiAliasType.ADVANCED;
		txMsg.gridFitType = GridFitType.PIXEL;
		txMsg.width = stage.stageWidth;
		txMsg.height = _height - 2 * padding;
		// txMsg.selectable = false;
		txMsg.mouseEnabled = false;
		txMsg.text = text;
		txMsg.x = padding;
		txMsg.y = padding;
		background = new Sprite();
		background.graphics.beginFill(0x000000, .6);
		background.graphics.drawRect(0, 0, stage.stageWidth, _height);
		background.graphics.endFill();
		addChild(background);
		addChild(txMsg);
        this.y = stage.stageHeight - this.height + padding;
	}

	public function redraw() {
		if ( stage != null) {
			background.graphics.clear();
			background.graphics.beginFill(0x000000, .6);
			background.graphics.drawRect(0, 0, stage.stageWidth, _height);
			background.graphics.endFill();
			this.y = stage.stageHeight - this.height + padding;
		}
	}
}
