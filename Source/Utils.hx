package;

class Utils {

    public static var ffmpegAvailable:Bool = false;
    
    /**
	 * [Description]
	 */
	public static function isFFmpegAvailable() :Bool{
		var ffcommand = 'ffmpeg -version';
		final process = new sys.io.Process(ffcommand);
		if (process.exitCode() != 0) {
			ffmpegAvailable = false;
			return false;
		}
		final resolution = process.stdout.readLine();
		process.close();
		ffmpegAvailable = true;
        return true;
	}
}