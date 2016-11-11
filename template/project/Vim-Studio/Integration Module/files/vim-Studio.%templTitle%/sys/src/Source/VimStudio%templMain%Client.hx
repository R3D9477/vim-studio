package;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;

using StringTools;

class VimStudio%templMain%Client {
	static function echoRequest (request:Array<String>) : String
		return (new Process("neko", ["../../vim-studio/sys/VimStudioClient.n"].concat(request))).stdout.readAll().toString();
	
	public static function main () : Void {
		Sys.setCwd(Path.directory(FileSystem.fullPath(
			#if neko
				neko.vm.Module.local().name
			#elseif cpp
				Sys.executablePath()
			#end
		)));
		
		var args:Array<String> = Sys.args().map(function (arg:String) return arg.trim());
		
		switch(args[0]) {
			case "%templMain%":
				switch (args[1]) {
					case "%templMain%":
						//...
						//...
						//...
						Sys.stdout().writeString("1");
					default:
						Sys.stdout().writeString("0");
				}
			default:
				Sys.stdout().writeString(echoRequest(args));
		}
	}
}
