// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

import openfl.Vector;
import starling.display.DisplayObject;

/** A TouchEvent is triggered either by touch or mouse input.  
 *  
 *  <p>In Starling, both touch events and mouse events are handled through the same class: 
 *  TouchEvent. To process user input from a touch screen or the mouse, you have to register
 *  an event listener for events of the type <code>TouchEvent.TOUCH</code>. This is the only
 *  event type you need to handle; the long list of mouse event types as they are used in
 *  conventional Flash are mapped to so-called "TouchPhases" instead.</p> 
 * 
 *  <p>The difference between mouse input and touch input is that</p>
 *  
 *  <ul>
 *    <li>only one mouse cursor can be present at a given moment and</li>
 *    <li>only the mouse can "hover" over an object without a pressed button.</li>
 *  </ul> 
 *  
 *  <strong>Which objects receive touch events?</strong>
 * 
 *  <p>In Starling, any display object receives touch events, as long as the  
 *  <code>touchable</code> property of the object and its parents is enabled. There 
 *  is no "InteractiveObject" class in Starling.</p>
 *  
 *  <strong>How to work with individual touches</strong>
 *  
 *  <p>The event contains a list of all touches that are currently present. Each individual
 *  touch is stored in an object of type "Touch". Since you are normally only interested in 
 *  the touches that occurred on top of certain objects, you can query the event for touches
 *  with a specific target:</p>
 * 
 *  <code>var touches:Vector.&lt;Touch&gt; = touchEvent.getTouches(this);</code>
 *  
 *  <p>This will return all touches of "this" or one of its children. When you are not using 
 *  multitouch, you can also access the touch object directly, like this:</p>
 * 
 *  <code>var touch:Touch = touchEvent.getTouch(this);</code>
 *  
 *  @see Touch
 *  @see TouchPhase
 */ 
class TouchEvent extends Event
{
	/** Event type for touch or mouse input. */
	public static var TOUCH:String = "touch";
	
	private var mShiftKey:Bool;
	private var mCtrlKey:Bool;
	private var mTimestamp:Float;
	private var mVisitedObjects:Array<EventDispatcher>;
	
	/** Helper object. */
	private static var sTouches = new Array<Touch>();
	
	public var timestamp(get, null):Float;
	public var touches(get, null):Array<Touch>;
	public var shiftKey(get, null):Bool;
	public var ctrlKey(get, null):Bool;
	
	/** Creates a new TouchEvent instance. */
	public function new(type:String, touches:Vector<Touch>, shiftKey:Bool=false, ctrlKey:Bool=false, bubbles:Bool=true)
	{
		super(type, bubbles, touches);
		
		mShiftKey = shiftKey;
		mCtrlKey = ctrlKey;
		mTimestamp = -1.0;
		mVisitedObjects = new Array<EventDispatcher>();
		
		var numTouches:Int=touches.length;
		for (i in 0...numTouches)
			if (touches[i].timestamp > mTimestamp)
				mTimestamp = touches[i].timestamp;
	}
	
	/** Returns a list of touches that originated over a certain target. If you pass a
	 *  'result' vector, the touches will be added to this vector instead of creating a new 
	 *  object. */
	public function getTouches(target:DisplayObject, phase:String=null, result:Vector<Touch>=null):Vector<Touch>
	{
		if (result == null) result = new Vector<Touch>();
		var allTouches:Vector<Touch> = cast data;
		var numTouches:Int = allTouches.length;
		
		for (i in 0...numTouches)
		{
			var touch:Touch = allTouches[i];
			var correctTarget:Bool = touch.isTouching(target);
			var correctPhase:Bool = (phase == null || phase == touch.phase);
				
			if (correctTarget && correctPhase)
				result[result.length] = touch; // avoiding 'push'
		}
		return result;
	}
	
	/** Returns a touch that originated over a certain target. 
	 * 
	 *  @param target   The object that was touched; may also be a parent of the actual
	 *                  touch-target.
	 *  @param phase    The phase the touch must be in, or null if you don't care.
	 *  @param id       The ID of the requested touch, or -1 if you don't care.
	 */
	public function getTouch(target:DisplayObject, phase:String=null, id:Int=-1):Touch
	{
		sTouches = getTouches(target, phase, sTouches);
		var numTouches:Int = sTouches.length;
		
		if (numTouches > 0) 
		{
			var touch:Touch = null;
			
			if (id < 0) touch = sTouches[0];
			else
			{
				for (i in 0...numTouches)
					if (sTouches[i].id == id) { touch = sTouches[i]; break; }
			}
			
			sTouches.splice(0, sTouches.length);
			return touch;
		}
		else return null;
	}
	
	/** Indicates if a target is currently being touched or hovered over. */
	public function interactsWith(target:DisplayObject):Bool
	{
		var result:Bool = false;
		sTouches = getTouches(target, null, sTouches);
		
		for (j in 0...sTouches.length) 
		{
			var i = sTouches.length - 1 - j;
			if (sTouches[i].phase != TouchPhase.ENDED)
			{
				result = true;
				break;
			}
		}
		
		sTouches.splice(0, sTouches.length);
		return result;
	}
	
	// custom dispatching
	
	/** @private
	 *  Dispatches the event along a custom bubble chain. During the lifetime of the event,
	 *  each object is visited only once. */
	/*internal*/ 
	public function dispatch(chain:Array<EventDispatcher>):Void
	{
		//trace("CHECK");
		if (chain != null && cast(chain.length))
		{
			var chainLength:Int = bubbles ? chain.length : 1;
			var previousTarget:EventDispatcher = target;
			var eventDispatcher:EventDispatcher = cast chain[0];
			
			setTarget(eventDispatcher);
			
			for (i in 0...chainLength)
			{
				var chainElement:EventDispatcher = cast chain[i];
				if (mVisitedObjects.indexOf(chainElement) == -1)
				{
					var stopPropagation:Bool = chainElement.invokeEvent(this);
					mVisitedObjects[mVisitedObjects.length] = chainElement;
					if (stopPropagation) break;
				}
			}
			
			setTarget(previousTarget);
		}
	}
	
	// properties
	
	/** The time the event occurred (in seconds since application launch). */
	private function get_timestamp():Float { return mTimestamp; }
	
	/** All touches that are currently available. */
	private function get_touches():Array<Touch> { return (cast data).concat(); }
	
	/** Indicates if the shift key was pressed when the event occurred. */
	private function get_shiftKey():Bool { return mShiftKey; }
	
	/** Indicates if the ctrl key was pressed when the event occurred. (Mac OS: Cmd or Ctrl) */
	private function get_ctrlKey():Bool { return mCtrlKey; }
}