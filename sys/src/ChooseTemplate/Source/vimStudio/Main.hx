package vimStudio;

import openfl.Lib;
import openfl.display.*;
import openfl.system.System;
import openfl.events.MouseEvent;

import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Floating;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.layouts.Row;
import ru.stablex.ui.skins.Paint;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

import rn.typext.hlp.FileSystemHelper;

using StringTools;

class Main extends Sprite {
	var selTemplPath:String = "";
	
	public function new () {
		super();
		
		var configPath:String =
			Path.withExtension(FileSystem.fullPath(
				#if neko
					neko.vm.Module.local().name
				#elseif cpp
					Sys.executablePath()
				#end
			), "json");
		
		var configData:Dynamic = FileSystem.exists(configPath) ? Json.parse(File.getContent(configPath)) : {
			"width": Lib.application.window.width,
			"height": Lib.application.window.height,
			"x": Lib.application.window.x,
			"y": Lib.application.window.y
		};
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.application.window.resize(configData.width, configData.height);
		Lib.application.window.move(configData.x, configData.y);
		
		Lib.current.stage.addChild(this);
		
		UIBuilder.init();
		var window:Floating = UIBuilder.buildFn("vimStudio/Main.xml")();
		
		cast(window.getChild("okBtn"), Button).onPress = function (e:MouseEvent) System.exit(1);
		cast(window.getChild("cancelBtn"), Button).onPress = function (e:MouseEvent) System.exit(0);
		
		var templateInfo:Text = cast(window.getChild("templateInfo"), Text);
		var selectedTemplate:Text = cast(window.getChild("selectedTemplate"), Text);
		
		var lastTemplatePath:String = "";
		
		var templatesList:VBox = cast(window.getChild("templatesList"), VBox);
		cast(templatesList.layout, Row).rows = new Array<Float>();
		
		for (templateSrc in Sys.args())
			if (FileSystem.exists(templateSrc))
				FileSystemHelper.iterateFilesTree(templateSrc, function (file:String)
					if (file.indexOf(Path.addTrailingSlash(lastTemplatePath)) < 0 || lastTemplatePath == "")
						if (FileSystem.exists(Path.join([file, "init.json"]))) {
							lastTemplatePath = file;
							
							var templateSelector:Button = new Button();
							templateSelector.text = file.replace(templateSrc, "");
							
							templateSelector.onPress = function (e:MouseEvent) {
								this.selTemplPath = file;
								selectedTemplate.text = templateSelector.text;
								
								templateInfo.text = FileSystem.exists(Path.join([file, "info.txt"])) ? File.getContent(Path.join([file, "info.txt"])) : "";
							}
							
							cast(templatesList.layout, Row).rows.push(templateSelector.h);
							templatesList.addChild(templateSelector);
						}
				);
		
		templatesList.refresh();
		
		Lib.current.stage.application.window.onResize.add(function (width:Int, height:Int) {
			configData.width = width;
			configData.height = height;
		});
		
		Lib.current.stage.application.window.onMove.add(function (x:Float, y:Float) {
			configData.x = x;
			configData.y = y;
		});
		
		Lib.current.stage.application.onExit.add(
			function (code:Int) : Void {
				File.saveContent(configPath, Json.stringify(configData, null, "	"));
				
				if (code == 1 && this.selTemplPath > "")
					Sys.stdout().writeString(this.selTemplPath);
			}
		);
		
		window.show();
	}
}
