package  
{
	import flare.basic.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import mesh.*;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class CubeMeshEarth extends Sprite
	{
		[Embed(source = "earthmap500b.png")]
		public var mapEmbed:Class;
		
		private var _scene:Scene3D;
		private var _cubes:CubesMesh;
		private var _count:Number = 0;
		
		public function CubeMeshEarth() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = "noScale";
			stage.align = "tl";
			
			_scene = new Viewer3D( this );
			_scene.camera.setPosition( 0, 0, -600 );
			
			_cubes = new CubesMesh();
			
			var map:Bitmap = new mapEmbed();
			
			_cubes.setTtexture((new mapEmbed() as Bitmap).bitmapData);
			
			var w:int;
			var h:int = 100;
			var scale:int = 300;
			
			for (var i:int = 0; i < h; i++) {
				var radius:Number = Math.sin(180 * (i / h) * (Math.PI / 180));//半径
				w = Math.PI * 2 * radius * h * 0.5 * 0.5;
				w = Math.max(w, 1);
                for (var j:int = 0; j < w; j++) {
					
                    var rx:Number = Math.PI * (2 * (j - (w - 1) / 2) / w);
                    var ry:Number = Math.PI * ((i - (h - 1) / 2) / h);
                    var nx:Number = Math.cos(ry) * Math.sin(rx) * scale;
                    var ny:Number = Math.sin(ry) * scale;
                    var nz:Number = Math.cos(ry) * Math.cos(rx) * scale;
					
					_cubes.addCube( -nx, -ny, nz, 7, (j / w), (i / h), [0, 0, 0]);
					
					var ran:Number;
					
					for (var k:int = 0; k < 10; k++) 
					{
						ran = Math.random() * 0.85 + 0.1;
						_cubes.addCube( -nx*ran, -ny*ran, nz*ran, 7*ran, (j / w), (i / h), [0, 0, 0]);
					}
					
                }
            }
			
			trace(_cubes.length);
			
			_scene.addChild( _cubes );
			
			_scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}		
		
		private function updateEvent(e:Event):void 
		{
			if (PlayControl.isPause) {
				_cubes.stop();
				return;
			}
			
			if ( !Input3D.mouseDown )
			{
				_count++
				_cubes.rotateX( 0.03 );
				_cubes.rotateY( -0.22 );
				_scene.camera.translateZ( Math.sin( _count / 300 ) * 1.5 );
			}
		}
	}
}