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

/** This class is an enumeration of constant values used in setting the 
 *  autoSize property of the TextField class. */ 
@:enum abstract TextFieldAutoSize(String) from String to String {
	/** No auto-sizing will happen. */
	var NONE = "none";
	
	/** The text field will grow to the right; no line-breaks will be added.
	 *  The height of the text field remains unchanged. */ 
	var HORIZONTAL = "horizontal";
	
	/** The text field will grow to the bottom, adding line-breaks when necessary.
	  * The width of the text field remains unchanged. */
	var VERTICAL = "vertical";
	
	/** The text field will grow to the right and bottom; no line-breaks will be added. */
	var BOTH_DIRECTIONS = "bothDirections";
}