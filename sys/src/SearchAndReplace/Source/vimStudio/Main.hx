package vimStudio;

import openfl.Lib;
import openfl.display.*;
import openfl.system.System;
import openfl.events.MouseEvent;

import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Floating;
import ru.stablex.ui.widgets.InputText;
import ru.stablex.ui.widgets.Checkbox;

using StringTools;

class Main extends Sprite {
	public function new () {
		super();
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		Lib.current.stage.addChild(this);
		
		UIBuilder.init();
		var window:Floating = UIBuilder.buildFn("vimStudio/Main.xml")();
		
		cast(window.getChild("okBtn"), Button).onPress = function (e:MouseEvent) System.exit(1);
		cast(window.getChild("cancelBtn"), Button).onPress = function (e:MouseEvent) System.exit(0);
		
		Lib.current.stage.application.onExit.add(
			function (code:Int) : Void 
				if (code == 1) {
					Sys.stdout().writeString('{ &#34;text&#34;: &#34;${cast(window.getChild("searchInp"), InputText).text}&#34;');
					Sys.stdout().writeString(', &#34;matchCase&#34;: ${cast(window.getChild("matchCaseCb"), Checkbox).selected}');
					
					if (cast(window.getChild("replaceCb"), Checkbox).selected)
						Sys.stdout().writeString(', &#34;replaceWith&#34;: ${cast(window.getChild("replaceWithInp"), InputText).text}');
					
					Sys.stdout().writeString(" }");
				}
		);

		window.show();
	}
}
