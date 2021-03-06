// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

import openfl.utils.Dictionary;

import starling.display.Image;
import starling.textures.Texture;

/** A BitmapChar contains the information about one char of a bitmap font.  
 *  <em>You don't have to use this class directly in most cases. 
 *  The TextField class contains methods that handle bitmap fonts for you.</em>    
 */ 
class BitmapChar
{
	private var mTexture:Texture;
	private var mCharID:Int;
	private var mXOffset:Float = 0;
	private var mYOffset:Float = 0;
	private var mXAdvance:Float = 0;
	private var mKernings:Map<Int, Float>;
	
	public var charID(get, null):Int;
	public var xOffset(get, null):Float;
	public var yOffset(get, null):Float;
	public var xAdvance(get, null):Float;
	public var texture(get, null):Texture;
	public var width(get, null):Float;
	public var height(get, null):Float;
	
	/** Creates a char with a texture and its properties. */
	public function new(id:Int, texture:Texture, 
							   xOffset:Float, yOffset:Float, xAdvance:Float)
	{
		mCharID = id;
		mTexture = texture;
		mXOffset = xOffset;
		mYOffset = yOffset;
		mXAdvance = xAdvance;
		mKernings = null;
	}
	
	/** Adds kerning information relative to a specific other character ID. */
	public function addKerning(charID:Int, amount:Float):Void
	{
		if (mKernings == null)
			mKernings = new Map<Int, Float>();
		
		mKernings[charID] = amount;
	}
	
	/** Retrieve kerning information relative to the given character ID. */
	public function getKerning(charID:Int):Float
	{
		if (mKernings == null || mKernings[charID] == null) return 0.0;
		else return mKernings[charID];
	}
	
	/** Creates an image of the char. */
	public function createImage():Image
	{
		return new Image(mTexture);
	}
	
	/** The unicode ID of the char. */
	private function get_charID():Int { return mCharID; }
	
	/** The number of points to move the char in x direction on character arrangement. */
	private function get_xOffset():Float { return mXOffset; }
	
	/** The number of points to move the char in y direction on character arrangement. */
	private function get_yOffset():Float { return mYOffset; }
	
	/** The number of points the cursor has to be moved to the right for the next char. */
	private function get_xAdvance():Float { return mXAdvance; }
	
	/** The texture of the character. */
	private function get_texture():Texture { return mTexture; }
	
	/** The width of the character in points. */
	private function get_width():Float { return mTexture.width; }
	
	/** The height of the character in points. */
	private function get_height():Float { return mTexture.height; }
}