package openfl.display3D.textures; #if !flash


import openfl.display3D.Context3D;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.gl.GLFramebuffer;
import openfl.geom.Rectangle;
import openfl.utils.ArrayBuffer;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;

using openfl.display.BitmapData;


@:final class Texture extends TextureBase {
	
	
	public var optimizeForRenderToTexture:Bool;
	
	public var mipmapsGenerated:Bool;
	
	public function new (context:Context3D, glTexture:GLTexture, optimize:Bool, width:Int, height:Int) {
		
		optimizeForRenderToTexture = optimize;

		mipmapsGenerated = false;
		
		#if (js || neko)
		if (optimizeForRenderToTexture == null) optimizeForRenderToTexture = false;
		#end
		
		super (context, glTexture, width, height);
		
		#if (cpp || neko || nodejs)
		if (optimizeForRenderToTexture) { 
			
			GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 1); 
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
		}
		#end
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void
	{	
		#if openfl_legacy
		var p = BitmapData.getRGBAPixels (bitmapData);
		#elseif js
		var p = ByteArray.__ofBuffer (@:privateAccess (bitmapData.image).data.buffer);
		#else
		var p = @:privateAccess (bitmapData.__image).data.buffer;
		#end

		width = bitmapData.width;
		height = bitmapData.height;

		var source = new UInt8Array (p.length);
		var endian = p.endian;
		p.endian = "littleEndian";
		p.position = 0;

		var i:Int = 0;

		while (p.position < p.length) {

			var c:Int = p.readUnsignedInt ();
			var a:Int = ((c >>> 24) & 0xFF) + 1;

			var r = (((((c       ) & 0xFF) + 1) * a) >>> 8) - 1;
			var g = (((((c >>>  8) & 0xFF) + 1) * a) >>> 8) - 1;
			var b = (((((c >>> 16) & 0xFF) + 1) * a) >>> 8) - 1;

			source[i++] = (r == -1) ? 0 : r;
			source[i++] = (g == -1) ? 0 : g;
			source[i++] = (b == -1) ? 0 : b;
			source[i++] = a - 1;

		}
		p.endian = endian;

		uploadFromUInt8Array(source, miplevel);
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, miplevel:Int = 0):Void {
		
		#if js
		var source = new UInt8Array (data.length);
		data.position = byteArrayOffset;
		
		var i:Int = 0;
		
		while (data.position < data.length) {
			
			source[i] = data.readUnsignedByte ();
			i++;
			
		}
		#else
		var source = new UInt8Array (data);
		#end
		
		uploadFromUInt8Array (source, miplevel);
		
	}
	
	
	public function uploadFromUInt8Array (data:UInt8Array, miplevel:Int = 0):Void {
		
		GL.bindTexture (GL.TEXTURE_2D, glTexture);
		
		if (optimizeForRenderToTexture) {
			
			GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 1);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
		}
		
		GL.texImage2D (GL.TEXTURE_2D, miplevel, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
}


#else
typedef Texture = flash.display3D.textures.Texture;
#end
