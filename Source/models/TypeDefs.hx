package models;

typedef AppData = {
	var portIndex:Int;
	var portName:String;
	var videoPath:String;
	var videoTags:Array<VideoTag>;
}

typedef VideoTag = {
    var tag:String;
    var filename:String;
}