package vimStudio;

import sys.io.File;
import haxe.io.Path;
import sys.io.FileOutput;

using DateTools;

class Debug {
	private static var logFile:FileOutput = null;
	
	public static function openLogFile (logDirPath:String) : Void {
		if (logFile != null)
			closeLogFile();
		
		logFile = File.write(Path.join([logDirPath, "log-" + Date.now().format("%d%m%Y-%H%M%S") + ".txt"]), false);
	}
	
	public static function writeLog (logMsg:String) : Void
		if (logFile != null) logFile.writeString(logMsg + "\r\n");
	
	public static function closeLogFile () : Void
		if (logFile != null) { logFile.close(); logFile = null; }
}
