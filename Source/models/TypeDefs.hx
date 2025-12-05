package models;

typedef AppData = {
	var portIndex:Int;
	var fullscreen:Bool;
	var portName:String;
	var videoPath:String;
	var background:String;
	var videoTags:Array<VideoTag>;
	var websocketHost:String;
}

typedef VideoTag = {
    var tag:String;
    var filename:String;
}