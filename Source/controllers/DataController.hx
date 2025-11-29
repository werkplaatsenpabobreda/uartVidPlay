package controllers;

import sys.io.File;
import models.TypeDefs;
import haxe.Json;
#if sys
import haxe.io.Path;
import sys.FileSystem;
import lime.system.System;
#end

class DataController {

	public static var jsonPath:String;
	public static var hasJsonFile:Bool = false;
	public static var data:AppData;
	public static var videoTags:Map<String,String>;
	public static var retriggerTag:Bool = false;
	public static var waitUntilVideoFinished:Bool = false;

	public static function loadConfig() {
		jsonPath = haxe.io.Path.join([lime.system.System.applicationStorageDirectory, "config.json"]);
		hasJsonFile = FileSystem.exists(jsonPath);
		videoTags = new Map<String,String>();
		if (hasJsonFile) {
			try {
				data = Json.parse(sys.io.File.getContent(jsonPath));
				if(data.videoTags !=null && data.videoTags.length > 0){
					for( i in 0...data.videoTags.length){
						videoTags.set( data.videoTags[i].tag.toUpperCase(), data.videoTags[i].filename );
					}
				}

			} catch (e) {
                trace('error loading config');
            }
		}
	}

	public static function saveConfig() {
		try {
			File.saveContent(jsonPath, Json.stringify(data));
		} catch (e) {}
	}


}
