package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(frameRate = 60, width = 590, height = 590, backgroundColor = 0x000000)]
	public class Main extends Sprite 
	{
		private var _playControl:PlayControl;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_playControl = new PlayControl(false, "tr");
			addChild(new CubeMeshEarth());
			addChild(_playControl);
		}
		
	}
	
}