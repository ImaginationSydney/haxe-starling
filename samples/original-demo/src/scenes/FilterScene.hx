package scenes;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Lib;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.filters.DisplacementMapFilter;
import starling.text.TextField;
import starling.textures.Texture;

class FilterScene extends Scene
{
	private var mButton:Button;
	private var mImage:Image;
	private var mInfoText:TextField;
	private var mFilterInfos:Array<Dynamic>;
	var displacementFilter:DisplacementMapFilter;
	
	public function new()
	{
		super();
		
		mButton = new Button(Game.assets.getTexture("button_normal"), "Switch Filter");
		mButton.name = "switchFilers";
		mButton.x = Math.round(Constants.CenterX - mButton.width / 2);
		mButton.y = 15;
		mButton.addEventListener(Event.TRIGGERED, onButtonTriggered);
		addChild(mButton);
		
		mImage = new Image(Game.assets.getTexture("starling_rocket"));
		mImage.x = cast(Constants.CenterX - mImage.width / 2);
		mImage.y = 170;
		addChild(mImage);
		
		mInfoText = new TextField(300, 32, "", "Verdana", 19);
		mInfoText.x = 10;
		mInfoText.y = 330;
		addChild(mInfoText);
		
		initFilters();
		onButtonTriggered();
	}
	
	private function onButtonTriggered():Void
	{
		var filterInfo:Array<Dynamic> = mFilterInfos.shift();
		mFilterInfos.push(filterInfo);
		
		mInfoText.text = filterInfo[0];
		mImage.filter = filterInfo[1];
	}
	
	private function initFilters():Void
	{
		mFilterInfos = [
			["Identity", new ColorMatrixFilter()],
			["Blur", new BlurFilter()],
			["Drop Shadow", BlurFilter.createDropShadow()],
			["Glow", BlurFilter.createGlow()]
		];
		var displacementMap = Texture.fromBitmapData(Assets.getBitmapData("assets/textures/perlinNoise.png"), false, false, scale);
		
		displacementFilter = new DisplacementMapFilter(displacementMap, null,BitmapDataChannel.RED, BitmapDataChannel.GREEN, 25, 25);
		mFilterInfos.push(["Displacement Map", displacementFilter]);
		
		var invertFilter:ColorMatrixFilter = new ColorMatrixFilter();
		invertFilter.invert();
		mFilterInfos.push(["Invert", invertFilter]);
		
		var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
		grayscaleFilter.adjustSaturation(-1);
		mFilterInfos.push(["Grayscale", grayscaleFilter]);
		
		var saturationFilter:ColorMatrixFilter = new ColorMatrixFilter();
		saturationFilter.adjustSaturation(1);
		mFilterInfos.push(["Saturation", saturationFilter]);
		
		var contrastFilter:ColorMatrixFilter = new ColorMatrixFilter();
		contrastFilter.adjustContrast(0.75);
		mFilterInfos.push(["Contrast", contrastFilter]);

		var brightnessFilter:ColorMatrixFilter = new ColorMatrixFilter();
		brightnessFilter.adjustBrightness(-0.25);
		mFilterInfos.push(["Brightness", brightnessFilter]);

		var hueFilter:ColorMatrixFilter = new ColorMatrixFilter();
		hueFilter.adjustHue(1);
		mFilterInfos.push(["Hue", hueFilter]);
	}
}