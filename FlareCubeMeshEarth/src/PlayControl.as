package  
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author umhr
	 */
	public class PlayControl extends Sprite 
	{
		
		private var _pauseCanvas:Sprite = new Sprite();
		private var _playCanvas:Sprite = new Sprite();
		private var _align:String;
		static public var isPause:Boolean;
		public function PlayControl(isPause:Boolean = false, align:String = "tl") 
		{
			PlayControl.isPause = isPause;
			_align = align;
			//this.x = x;
			//this.y = y;
			init();
		}
		private function init():void 
		{
            if (stage) onInit();
            else addEventListener(Event.ADDED_TO_STAGE, onInit);
        }
        
        private function onInit(event:Event = null):void 
        {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_playCanvas.graphics.beginFill(0x666666, 0.5);
			_playCanvas.graphics.drawRect(0, 0, 40, 40);
			_playCanvas.graphics.endFill();
			_playCanvas.graphics.beginFill(0x000000, 0.5);
			_playCanvas.graphics.drawRect(10, 10, 8, 22);
			_playCanvas.graphics.drawRect(22, 10, 8, 22);
			_playCanvas.graphics.endFill();
			
			_playCanvas.addEventListener(MouseEvent.CLICK, playCanvas_click);
			addChild(_playCanvas);
			
			_playCanvas.visible = !isPause;
			
			_pauseCanvas.addEventListener(MouseEvent.CLICK, playCanvas_click);
			
			if (_align == "bl") {
				_playCanvas.y = stage.stageHeight - 40;
			}else if (_align == "tr") {
				_playCanvas.x = stage.stageWidth - 40;
			}else if (_align == "br") {
				_playCanvas.x = stage.stageWidth - 40;
				_playCanvas.y = stage.stageHeight - 40;
			}
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x111111, 0.9);
			shape.graphics.drawRoundRect(0,0, 200, 200,8,8);
			shape.graphics.endFill();
			
			shape.graphics.beginFill(0xFFFFFF, 0.5);
			shape.graphics.moveTo(90 + Math.cos(0) * 60, 100 + Math.sin(0) * 60);
			shape.graphics.lineTo(90+Math.cos(Math.PI*(2/3)) * 60, 100+Math.sin(Math.PI*(2/3)) * 60);
			shape.graphics.lineTo(90+Math.cos(Math.PI*(4/3)) * 60, 100+Math.sin(Math.PI*(4/3)) * 60);
			shape.graphics.lineTo(90+Math.cos(0) * 60, 100+Math.sin(0) * 60);
			shape.graphics.endFill();
			_pauseCanvas.addChild(shape);
			
			drawPauseCanvas();
			
			addChild(_pauseCanvas);
			_pauseCanvas.visible = isPause;
			
		}
		
		private function drawPauseCanvas():void 
		{
			_pauseCanvas.graphics.clear();
			_pauseCanvas.graphics.beginFill(0x111111, 0.7);
			_pauseCanvas.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_pauseCanvas.graphics.endFill();
			if (_pauseCanvas.numChildren > 0) {
				_pauseCanvas.getChildAt(0).x = (_pauseCanvas.width - 200) * 0.5;
				_pauseCanvas.getChildAt(0).y = (_pauseCanvas.height - 200) * 0.5;
			}
		}
		
		private function playCanvas_click(event:MouseEvent):void 
		{
			_playCanvas.visible = _pauseCanvas.visible;
			_pauseCanvas.visible = !_playCanvas.visible;
			
			isPause = _pauseCanvas.visible;
			
			if (_pauseCanvas) {
				drawPauseCanvas();
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
}