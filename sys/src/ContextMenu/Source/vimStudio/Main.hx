package vimStudio;

import openfl.Lib;
import openfl.display.*;
import openfl.system.System;
import openfl.events.MouseEvent;

import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Floating;

import haxe.Json;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;

class Main extends Sprite {
	var ul:VBox;
	
	function retAction (action:String) : Void {
		Sys.stdout().writeString(action);
		System.exit(0);
	}
	
	function setParentRecusively (ext_menu:Array<String>, o:Dynamic) : Void {
		if (o.items == null)
			return;
		
		if (o.id > "") {
			var separator_added:Bool = false;
			
			for (i in 0...ext_menu.length) {
				for (extMenuFile in FileSystem.readDirectory(ext_menu[i])) {
					if (Path.withoutDirectory(Path.withoutExtension(extMenuFile)) == o.id) {
						if (!separator_added) {
							o.items.unshift({});
							separator_added = true;
						}
						
						o.items.unshift(Json.parse(File.getContent(Path.join([ext_menu[i], extMenuFile]))));
					}
				}
			}
		}
		
		for (n in cast(o.items, Array<Dynamic>)) {
			n.parent = o;
			setParentRecusively(ext_menu, n);
		}
	}
	
	function showItemsList (currItem:Dynamic) : Void {
		if (currItem.items == null)
			return;
		
		while(ul.numChildren > 0)
			ul.removeChildAt(0);
		
		for(childItem in cast(currItem.items, Array<Dynamic>)) {
			if (childItem.text > "" && (childItem.id > "" || childItem.nw_id > "")) {
				var li_item:Button = new Button();
				li_item.text = childItem.text;
				
				if (childItem.nw_id > "") {
					switch (childItem.nw_id) {
						case "next":
							li_item.onPress = function(e:MouseEvent) showItemsList(childItem);
						case "back":
							li_item.onPress = function(e:MouseEvent) showItemsList(childItem.parent.parent);
						case "close":
							li_item.onPress = function(e:MouseEvent) retAction("");
						default:
					}
				}
				else if (childItem.id > "")
					li_item.onPress = function(e:MouseEvent) retAction(childItem.id);
				
				ul.addChild(li_item);
			}
			else {
				// add separator
			}
		}
		
		this.stage.window.width = cast(ul.w, Int);
		this.stage.window.height = cast(ul.h, Int);
	}
	
	public function new () {
		Sys.setCwd(Path.directory(FileSystem.fullPath(
			#if neko
				neko.vm.Module.local().name
			#elseif cpp
				Sys.executablePath()
			#end
		)));
		
		super();
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		Lib.current.stage.addChild(this);
		
		UIBuilder.init();
		var window:Floating = UIBuilder.buildFn("vimStudio/Main.xml")();
		
		ul = cast(window.getChild("ul"), VBox);
		
		var ext_menu:Array<String> = Sys.args();
		var menu:Dynamic = Json.parse(File.getContent(Path.join(["..", "menu", ext_menu.shift() + ".json"])));
		
		setParentRecusively(ext_menu, menu);
		showItemsList(menu);
		
		window.show();
	}
}
