/*
 * Comment here.
 */
package 
{
    import mx.containers.Canvas;

    /**
     * Comment here.
     */
    public class RgbCanvas
        extends Canvas
    {
		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;
		private var _rgb:uint;
        
        /**
         * @inheritDoc  
         */
        public function get red():uint
        {
            return _red;
        }
        
        /**
         * @private
         */
        public function set red(value:uint):void
        {
			if (value != _red)
			{
				_red = value;
				invalidateProperties();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get green():uint
        {
            return _green;
        }
        
        /**
         * @private
         */
        public function set green(value:uint):void
        {
			if (value != _green)
			{
				_green = value;
				invalidateProperties();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get blue():uint
        {
            return _blue;
        }
        
        /**
         * @private
         */
        public function set blue(value:uint):void
        {
			if (value != _blue)
			{
				_blue = value;
				invalidateProperties();
			}
        }

		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();

			var rgb:uint = ((red & 0xff) << 16) | ((green & 0xff) << 8) | (blue & 0xff);
			if (_rgb != rgb)
			{
				_rgb = rgb;
				invalidateDisplayList();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(uw:Number, uh:Number):void
		{
            graphics.clear();
			graphics.beginFill(_rgb);
			graphics.drawRect(0, 0, uw, uh);
			graphics.endFill();
		}
    }
}
