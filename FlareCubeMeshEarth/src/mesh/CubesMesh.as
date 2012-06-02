package mesh
{
	import flare.basic.Scene3D;
	import flare.core.*;
	import flare.materials.*;
	import flare.materials.filters.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Ariel Nehmad
	 */
	public class CubesMesh extends Mesh3D
	{
		private var _material:Shader3D
		private var _needToUpload:Boolean = false;
		private var _length:int;
		
		public function CubesMesh() 
		{
			
		}
		
		private function setSurfaces():void {
			var mtx:Matrix = new Matrix(); 
				mtx.createGradientBox( 256, 10 );
				
			var shp:Shape = new Shape();
				shp.graphics.beginGradientFill( GradientType.LINEAR, [0x00FCFF, 0xB48AFF, 0xF72335, 0xFFD73A ], null, null, mtx );
				shp.graphics.drawRect( 0, 0, 256, 10 );
				
			var bmp:BitmapData = new BitmapData(256, 2, false, 0 );
				bmp.draw( shp );
			
			setTtexture(bmp);
		}
		
		public function setTtexture(texture:BitmapData):void 
		{
			_material = new Shader3D( "grayScale" );
			_material.filters.push(new TextureFilter( new Texture3D(texture) ) );
			_material.build();
			
			surfaces[0] = new Surface3D();
			surfaces[0].material = _material;
			surfaces[0].addVertexData( Surface3D.POSITION );
			surfaces[0].addVertexData( Surface3D.UV0 );
			surfaces[0].addVertexData( Surface3D.NORMAL );
			
		}
		
		public function addCube( x:Number, y:Number, z:Number, size:Number = 5, u:Number = 0, v:Number = 0, lookAt:Array = null ):void
		{
			if (!_material) {
				setSurfaces();
			}
			
			// gets the last used surface.
			var surf:Surface3D = surfaces[surfaces.length - 1];
			
			// each surface could not have more than 65000 vertex.
			if ( surf.vertexVector.length / surf.sizePerVertex >= 65000 )
			{
				surf = new Surface3D();
				surf.addVertexData( Surface3D.POSITION );
				surf.addVertexData( Surface3D.UV0 );
				surf.addVertexData( Surface3D.NORMAL );
				surf.material = _material;
				surfaces.push( surf );
			}
			
			_length ++;
			
			
			setVertexVector3(surf, x, y, z, size, u, v,lookAt);
			_needToUpload = true;
		}
		
		private function getPositionList(x:Number, y:Number, z:Number, size:Number, lookAt:Array = null):Vector.<Vector3D> {
			var s:Number = size * 0.5;
			
			var sphere:Pivot3D = new Pivot3D();
			sphere.setPosition(x, y, z);
			
			var sp0:Pivot3D = new Pivot3D();
			sp0.setPosition(-s, s, -s);
			sp0.parent = sphere;
			var sp1:Pivot3D = new Pivot3D();
			sp1.setPosition(s, s, -s);
			sp1.parent = sphere;
			var sp2:Pivot3D = new Pivot3D();
			sp2.setPosition(-s, -s, -s);
			sp2.parent = sphere;
			var sp3:Pivot3D = new Pivot3D();
			sp3.setPosition(s, -s, -s);
			sp3.parent = sphere;
			
			var sp4:Pivot3D = new Pivot3D();
			sp4.setPosition(-s, -s, s);
			sp4.parent = sphere;
			var sp5:Pivot3D = new Pivot3D();
			sp5.setPosition(s, -s, s);
			sp5.parent = sphere;
			var sp6:Pivot3D = new Pivot3D();
			sp6.setPosition(-s, s, s);
			sp6.parent = sphere;
			var sp7:Pivot3D = new Pivot3D();
			sp7.setPosition(s, s, s);
			sp7.parent = sphere;
			
			if(lookAt){
				sphere.lookAt.apply(this, lookAt);
			}
			
			var result:Vector.<Vector3D> = new Vector.<Vector3D>();
			result.push(sp0.global.position);
			result.push(sp1.global.position);
			result.push(sp2.global.position);
			result.push(sp3.global.position);
			result.push(sp4.global.position);
			result.push(sp5.global.position);
			result.push(sp6.global.position);
			result.push(sp7.global.position);
			
			return result;
		}
		
		private function setVertexVector3(surf:Surface3D, x:Number, y:Number, z:Number, size:Number = 5, u:Number = 0, v:Number = 0, lookAt:Array = null ):void 
		{
			var s:Number = size * 0.5;
			
			var i:int = surf.vertexVector.length / surf.sizePerVertex;
			
			var pozList:Vector.<Vector3D> = getPositionList(x, y, z, size, lookAt);
			
			surf.vertexVector.push(
			
				// front
				pozList[0].x,  pozList[0].y, pozList[0].z, 	u, v,	0, 0, -1,
				pozList[1].x,  pozList[1].y, pozList[1].z, 	u, v,	0, 0, -1,
				pozList[2].x, pozList[2].y, pozList[2].z, 	u, v,	0, 0, -1,
				pozList[3].x, pozList[3].y, pozList[3].z, 	u, v,	0, 0, -1,
				// back
				pozList[4].x, pozList[4].y,  pozList[4].z, 	u, v,	0, 0, 1,
				pozList[5].x, pozList[5].y,  pozList[5].z, 	u, v,	0, 0, 1,
				pozList[6].x,  pozList[6].y,  pozList[6].z, 	u, v,	0, 0, 1,
				pozList[7].x,  pozList[7].y,  pozList[7].z, 	u, v,	0, 0, 1,
				// left
				pozList[6].x,  pozList[6].y,  pozList[6].z, 	u, v,	-1, 0, 0,
				pozList[0].x,  pozList[0].y, pozList[0].z, 	u, v,	-1, 0, 0,
				pozList[4].x, pozList[4].y,  pozList[4].z, 	u, v,	-1, 0, 0,
				pozList[2].x, pozList[2].y, pozList[2].z, 	u, v,	-1, 0, 0,
				// right
				pozList[1].x,  pozList[1].y, pozList[1].z, 	u, v,	1, 0, 0,
				pozList[7].x,  pozList[7].y,  pozList[7].z, 	u, v,	1, 0, 0,
				pozList[3].x, pozList[3].y, pozList[3].z, 	u, v,	1, 0, 0,
				pozList[5].x, pozList[5].y,  pozList[5].z, 	u, v,	1, 0, 0,
				// top
				pozList[6].x,  pozList[6].y,  pozList[6].z, 	u, v,	0, 1, 0,
				pozList[7].x,  pozList[7].y,  pozList[7].z, 	u, v,	0, 1, 0,
				pozList[0].x,  pozList[0].y, pozList[0].z, 	u, v,	0, 1, 0,
				pozList[1].x,  pozList[1].y, pozList[1].z, 	u, v,	0, 1, 0,
				// bottom
				pozList[2].x, pozList[2].y, pozList[2].z, 	u, v,	0, -1, 0,
				pozList[3].x, pozList[3].y, pozList[3].z, 	u, v,	0, -1, 0,
				pozList[4].x, pozList[4].y,  pozList[4].z, 	u, v,	0, -1, 0,
				pozList[5].x, pozList[5].y,  pozList[5].z, 	u, v,	0, -1, 0
			
			)
			
			var l:int = i + 24;
			for ( i; i < l; i += 4 )
				surf.indexVector.push( i, i + 1, i + 2, i + 1, i + 3, i + 2 );
			
		}
		
		override public function upload(scene:Scene3D = null, force:Boolean = false, includeChildren:Boolean = true ):Boolean
		{
			_needToUpload = false;
			
			if ( super.upload( scene, force, includeChildren ) == false ) return false;
			
			return true;
		}
		
		public override function draw( includeChildren:Boolean = false ):void 
		{
			if ( _needToUpload && scene ) upload( scene );
			
			if ( _needToUpload ) return;
			
			
			super.draw( includeChildren );
		}
		
		public function get length():int 
		{
			return _length;
		}
		
	}
}