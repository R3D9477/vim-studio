package vimStudio;

import haxe.io.Path;
import sys.net.Host;
import sys.io.Process;
import sys.net.Socket;
import sys.FileSystem;
import systools.Dialogs;

import rn.dataTree.projectTree.*;

using StringTools;

class VimStudioClient {
	static function echoRequest (request:String) : String {
		var cSock:Socket = new Socket();
		
		var config:Config = new Config("VimStudioConfig.json");
		cSock.connect(new Host(config.getSettingStr("vimStudio", "Host")), config.getSettingInt("vimStudio", "Port"));
		
		cSock.write(request);
		var response:String = cSock.input.readUntil(0);
		
		cSock.close();
		return response;
	}
	
	public static function main () {
		Sys.setCwd(Path.directory(FileSystem.fullPath(
			#if neko
				neko.vm.Module.local().name
			#elseif cpp
				Sys.executablePath()
			#end
		)));
		
		var args:Array<String> = Sys.args().map(function (arg:String) return arg.replace("\\ ", " ").trim());
		
		switch(args[0]) {
			case "dialogs":
				switch (args[1]) {
					case "confirm":
						Sys.stdout().writeString(Dialogs.confirm("neko-systools", args[2], true) ? "1" : "0");
					case "choose_name":
						Sys.stdout().writeString(new Process("neko", ["ChooseName.n", args[2]]).stdout.readAll().toString());
					case "choose_dir":
						var selected:String = Dialogs.folder("Select a folder", "");
						Sys.stdout().writeString(selected.length > 0 ? selected : "0");
					case "choose_file":
						var selected:Array<String> = Dialogs.openFile("Select a file", "", {count: 1, descriptions: ["All files"], extensions: ["*.*"]});
						if (selected.length > 0)
							for (s in selected)
								Sys.stdout().writeString(s + "\r\n");
						else
							Sys.stdout().writeString("0");
					case "choose_project":
						var selected:Array<String> = Dialogs.openFile("Select a project", "", {count: 1, descriptions: ["vim-Studio projects"], extensions: ["*.visp"]});
						Sys.stdout().writeString(selected.length > 0 ? selected[0] : "0");
					case "choose_template":
						Sys.stdout().writeString(new Process("neko", ["ChooseTemplate.n"].concat(args.splice(2, args.length))).stdout.readAll().toString());
					case "search_and_replace":
						Sys.stdout().writeString(new Process("neko", ["SearchAndReplace.n"]).stdout.readAll().toString());
					case "context_menu":
						Sys.stdout().writeString(new Process("neko", ["ContextMenu.n"].concat(args.slice(2, args.length))).stdout.readAll().toString());
					default:
						Sys.stdout().writeString("0");
				}
			default:
				var request:String = "";
				for (arg in Sys.args())
					request += (request > "" ? ":" : "") + arg.replace(":", "&#58;");
				Sys.stdout().writeString(echoRequest(request));
		}
	}
}
