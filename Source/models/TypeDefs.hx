package models;

typedef AppData = {

	var fullscreen:Bool;
	var hideMouse:Bool;
	var autoDiscoverPort:Bool;
	var usePortPath:Bool;
	var portIndex:Int;
	var portPath:String;
	var background:String;
	var videoTags:Array<VideoTag>;
	var websocketHost:String;
}

typedef VideoTag = {
    var tag:String;
    var filename:String;
}