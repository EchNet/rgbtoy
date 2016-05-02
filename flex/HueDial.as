/*
 * Comment here.
 */
package 
{
    import mx.containers.Canvas;
    import flash.display.Graphics;
    import flash.display.GradientType;

    /**
     * Comment here.
     */
    public class HueDial
        extends Canvas
    {
		private var _hue:uint;
		private var _radius:uint;
        
        /**
         * @inheritDoc  
         */
        public function get hue():uint
        {
            return _hue;
        }
        
        /**
         * @private
         */
        public function set hue(value:uint):void
        {
			if (value != _hue)
			{
				_hue = value;
				invalidateDisplayList();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get radius():uint
        {
            return _radius;
        }
        
        /**
         * @private
         */
        public function set radius(value:uint):void
        {
			if (value != _radius)
			{
				_radius = value;
				invalidateDisplayList();
			}
        }

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(uw:Number, uh:Number):void
		{
            graphics.clear();

			graphics.beginFill(0xffffff);
			graphics.drawCircle(_radius, _radius, _radius);
			graphics.endFill();

			graphics.beginFill(0x000000);
			graphics.drawCircle(_radius, _radius, 2);
			graphics.endFill();

			graphics.beginFill(0xff0000);
			graphics.drawCircle(radius + radius, radius, 6);
			graphics.endFill();

			graphics.beginFill(0x00ff00);
			graphics.drawCircle((Math.cos(Math.PI * 2.0 / 3.0) * radius) + radius, (Math.sin(Math.PI * 2.0 / 3.0) * radius) + radius, 6);
			graphics.endFill();

			graphics.beginFill(0x0000ff);
			graphics.drawCircle((Math.cos(Math.PI * 4.0 / 3.0) * radius) + radius, (Math.sin(Math.PI * 4.0 / 3.0) * radius) + radius, 6);
			graphics.endFill();

            graphics.lineStyle(2, 0x000000);
            graphics.moveTo(_radius, _radius);

            var radians:Number = (hue * Math.PI) / 180.0;
            var x:Number = (Math.cos(radians) * radius) + radius;
            var y:Number = (Math.sin(radians) * radius) + radius;
            graphics.lineTo(x, y);
		}
    }
}
