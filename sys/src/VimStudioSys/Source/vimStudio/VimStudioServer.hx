package vimStudio;

import sys.net.Host;
import haxe.io.Path;
import haxe.io.Bytes;
import sys.net.Socket;
import sys.FileSystem;
import haxe.io.BytesInput;

#if neko
	import neko.vm.Thread;
	import neko.net.ThreadServer;
#elseif cpp
	import cpp.vm.Thread;
	import cpp.net.ThreadServer;
#end

import vimStudio.Debug;
import rn.dataTree.projectTree.*;

import rn.typext.hlp.FileSystemHelper;

using StringTools;
using rn.typext.ext.StringExtender;

typedef Client = {
	var socket : Socket; 
}

class VimStudioServer extends ThreadServer<Client, String> {
	static var srvThr:Thread = null;
	var treeList:Map<String, ProjectTree> = new Map<String, ProjectTree>();
	
	override function clientConnected (socket:Socket) : Client return { socket: socket };
	
	override function readClientMessage (client:Client, buf:Bytes, pos:Int, len:Int) {
		var requestStr:String = new BytesInput(buf).readUntil(0);
		var request:Array<String> = requestStr.split(":").map(function (param) return param.replace("&#58;", ":").replace("\\ ", " ").trim());
		var response:String = "1";
		
		var writeResponse:Dynamic = function (client:Client, response:String) : Void {
			client.socket.write(response.trim());
			client.socket.output.writeByte(0);
		}
		
		switch(request[0]) {
			case "server":
				switch(request[1]) {
					case "get_projects":
						response = "";
						for (tree in this.treeList)
							response += "proj: " + tree.projectPath + "\r\n";
					case "shutdown":
						Debug.closeLogFile();
						writeResponse(client, response);
						srvThr = null;
					default:
						response = "0";
				}
			case "debug":
				switch(request[1]) {
					case "openLogFile":
						Debug.openLogFile(request[2]);
					case "writeLog":
						Debug.writeLog(request[2].replace("&#58;", ":"));
					case "closeLogFile":
						Debug.closeLogFile();
					default:
						response = "0";
				}
			case "project":
				var path:String = FileSystem.exists(request[2]) ? FileSystem.fullPath(request[2]) : request[2];
				var tree:ProjectTree = this.treeList.exists(path) ? this.treeList.get(path) : null;
				switch(request[1]) {
					case "update_project":
						tree.loadTreeFromProjectDir();
						tree.save();
					case "get_mask":
						response = tree.printMaskToString();
					case "get_conf_property":
						response = Std.string(tree.config.getSetting(request[3], request[4]));
					case "set_conf_property":
						tree.config.setSetting(request[3], request[4], request[5].replace(":", "&#58;").toDynamic());
					case "close_project":
						this.treeList.remove(path);
					case "create_project":
						deleteProject(path);
						tree = new ProjectTree(path);
						this.treeList.set(tree.projectPath, tree);
						if (request.length < 4)
							tree.save();
						else if (!tree.extractTemplate(request[3])) {
							FileSystemHelper.delete(Path.withoutExtension(tree.projectPath));
							FileSystemHelper.delete(Path.withExtension(tree.projectPath, "json"));
							this.treeList.remove(tree.projectPath);
						}
					case "update_mask":
						tree.printMaskToFile();
					case "delete_project":
						deleteProject(path);
					case "rename_project":
						tree.rename(request[3]);
						tree.save();
						this.treeList.remove(path);
						this.treeList.set(tree.projectPath, tree);
					case "rename_file_by_index":
						tree.renameFileItemAt(Std.parseInt(request[3]), request[4]);
						tree.save();
					case "open_project":
						tree = new ProjectTree(path);
						this.treeList.set(tree.projectPath, tree);
					case "get_path_by_index":
						response = tree.getItemPathAt(Std.parseInt(request[3]));
					case "get_type_by_index":
						switch (tree.getItemTypeAt(Std.parseInt(request[3]))) {
							case ProjectTreeItemType.ProjectItem: response = "p";
							case ProjectTreeItemType.DirectoryItem: response = "d";
							case ProjectTreeItemType.FileItem: response = "f";
							default:
						}
					case "get_childs_count_by_index":
						response = Std.string(tree.getChildsCountAt(Std.parseInt(request[3])));
					case "insert_file_into_index":
						response = tree.addFileTo(request[4], Std.parseInt(request[5]) == 1, Std.parseInt(request[3])) ? "1" : "0";
						tree.save();
					case "delete_file_by_index":
						tree.removeFileItemAt(Std.parseInt(request[3]), request[3] == "1");
						tree.save();
					case "copy_file_by_index":
						tree.copyTo(Std.parseInt(request[3]), Std.parseInt(request[4]));
						tree.save();
					case "move_file_by_index":
						tree.moveTo(Std.parseInt(request[3]), Std.parseInt(request[4]));
						tree.save();
					case "exec_by_index":
						tree.execFileItemAt(Std.parseInt(request[3]));
					case "exec_parent_dir_by_index":
						tree.execParentDirAt(Std.parseInt(request[3]));
					case "init_template":
						response = ProjectTemplate.extract(tree, request[3], Std.parseInt(request[4]), request[5]) ? "1" : "0";
					case "search_text_by_index":
						response = tree.searchTextAt(Std.parseInt(request[3]), request[4]);
					default:
						response = "0";
				}
			default:
				response = "0";
		}
		
		writeResponse(client, response);
		
		return { msg: requestStr, bytes: requestStr.length };
	}
	
	function deleteProject (projectPath:String) : Bool {
		if (FileSystem.exists(projectPath)) {
			if (this.treeList.exists(projectPath)) {
				var tree:ProjectTree = this.treeList.get(projectPath);
				if (FileSystem.fullPath(projectPath) == tree.projectPath) {
					tree.delete();
					this.treeList.remove(projectPath);
					return true;
				}
			}
			
			ProjectTree.deleteProject(projectPath);
		}
		
		return false;
	}
	
	public static function main () : Void {
		Sys.setCwd(Path.directory(FileSystem.fullPath(
			#if neko
				neko.vm.Module.local().name
			#elseif cpp
				Sys.executablePath()
			#end
		)));
		
		var config:Config = new Config("VimStudioConfig.json");
		var server = new VimStudioServer();
		
		try {
			srvThr = Thread.create(function () server.run(config.getSettingStr("vimStudio", "Host"), config.getSettingInt("vimStudio", "Port")));
		}
		catch (e:Dynamic) {
			srvThr = null;
		}
		
		while (srvThr != null)
			Sys.sleep(.1);
	}
}
