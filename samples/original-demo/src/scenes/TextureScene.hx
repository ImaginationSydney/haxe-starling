package scenes;

import openfl.errors.Error;
import openfl.utils.ByteArray;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;

class TextureScene extends Scene
{
	public function new()
	{
		super();
		// the flight textures are actually loaded from an atlas texture.
		// the "AssetManager" class wraps it away for us.
		
		var image1:Image = new Image(Game.assets.getTexture("flight_00"));
		image1.x = -20;
		image1.y = 0;
		addChild(image1);
		
		var image2:Image = new Image(Game.assets.getTexture("flight_04"));
		image2.x = 90;
		image2.y = 85;
		addChild(image2);
		
		var image3:Image = new Image(Game.assets.getTexture("flight_08"));
		image3.x = 100;
		image3.y = -60;
		addChild(image3);
		
		
		/*try
		{
			// display a compressed texture
			var compressedTexture:Texture = Game.assets.getTexture("compressed_texture");
			var image:Image = new Image(compressedTexture);
			image.x = Constants.CenterX - image.width / 2;
			image.y = 280;
			addChild(image);
		}
		catch (e:Error)
		{*/
			#if flash
				//var textValue = "Flash Player and AIR must be at less 11.4 and 3.4 respectively (swf-version=17) to see a compressed ATF texture";
				var textValue = "ATF textures currently not supported in the Haxe version of Starling.";
			#else
				var textValue = "ATF textures are not support in non Flash/Air targets.";
			#end
			// if it fails, it's probably not supported
			var textField:TextField = new TextField(220, 128, textValue, "Verdana", 14);
			textField.x = Constants.CenterX - textField.width / 2;
			textField.y = 280;
			addChild(textField);
		//}
	}
}