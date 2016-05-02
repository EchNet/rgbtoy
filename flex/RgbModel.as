/*
 * Comment here.
 */
package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.events.PropertyChangeEvent;

	[Bindable("propertyChange")]
    /**
     * Comment here.
     */
    public class RgbModel 
		extends EventDispatcher
    {
		public static const FULL_COLOR:Number = 255;

		private var _red:Number = 0.5;
		private var _green:Number = 0.5;
		private var _blue:Number = 0.5;
		private var _min:Number = 0.5;
		private var _max:Number = 0.5;
		private var _hue:Number = 0;
		private var _vSaturation:Number;
		private var _value:Number;
		private var _lSaturation:Number;
		private var _lightness:Number;

		/**
		 * Constructor.
		 */
		public function RgbModel()
		{
			calcHue();
			calcSv();
			calcSl();
		}
        
        /**
         * @inheritDoc  
         */
        public function get red():uint
        {
            return _red * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set red(red:uint):void
        {
			var value:Number = red / FULL_COLOR;
			if (value != _red)
			{
				_red = value;
				recalcForRgbChange();
                dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get green():uint
        {
            return _green * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set green(green:uint):void
        {
			var value:Number = green / FULL_COLOR;
			if (value != _green)
			{
				_green = value;
				recalcForRgbChange();
                dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get blue():uint
        {
            return _blue * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set blue(blue:uint):void
        {
			var value:Number = blue / FULL_COLOR;
			if (value != _blue)
			{
				_blue = value;
				recalcForRgbChange();
                dispatchChange();
			}
        }
        
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
        public function set hue(hue:uint):void
        {
			var value:Number = hue * 1.0;
			if (value != _hue)
			{
				_hue = value;
				calcRgbFromHsv();
                dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get vSaturation():uint
        {
            return _vSaturation * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set vSaturation(vSaturation:uint):void
        {
			var value:Number = vSaturation / FULL_COLOR;
			if (value != _vSaturation)
			{
				_vSaturation = value;
				recalcForSvChange();
				dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get value():uint
        {
            return _value * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set value(val:uint):void
        {
			var value:Number = val / FULL_COLOR;
			if (value != _value)
			{
				_value = value;
				recalcForSvChange();
				dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get lSaturation():uint
        {
            return _lSaturation * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set lSaturation(lSaturation:uint):void
        {
			var value:Number = lSaturation / FULL_COLOR;
			if (value != _lSaturation)
			{
				_lSaturation = value;
				recalcForSlChange();
				dispatchChange();
			}
        }
        
        /**
         * @inheritDoc  
         */
        public function get lightness():uint
        {
            return _lightness * FULL_COLOR;
        }
        
        /**
         * @private
         */
        public function set lightness(lightness:uint):void
        {
			var value:Number = lightness / FULL_COLOR;
			if (value != _lightness)
			{
				_lightness = value;
				recalcForSlChange();
				dispatchChange();
			}
        }

        /**
         * @inheritDoc
         */
        public function get pixelValue():uint
        {
			return ((red & 0xff) << 16) | ((green & 0xff) << 8) | (blue & 0xff);
        }

		private function recalcForRgbChange():void
		{
			calcMinMax();
			calcHue();
			calcSv();
			calcSl();
		}

		private function recalcForSvChange():void
		{
			calcRgbFromHsv();
			calcMinMax();
			calcSl();
		}

		private function recalcForSlChange():void
		{
			calcRgbFromHsl();
			calcMinMax();
			calcSv();
		}

		private function calcMinMax():void
		{
			_min = Math.min(Math.min(_red, _green), _blue);
			_max = Math.max(Math.max(_red, _green), _blue);
		}

		private function calcHue():void
		{
			if (_max == _min)
			{
				// doesn't matter
			}
			else if (_max == _red)
			{
				_hue = (60.0 * ((_green - _blue) / (_max - _min)) + 360.0) % 360;
			}
			else if (_max == _green)
			{
				_hue = 60.0 * ((_blue - _red) / (_max - _min)) + 120.0;
			}
			else if (_max == _blue)
			{
				_hue = 60.0 * ((_red - _green) / (_max - _min)) + 240.0;
			}
		}

		/**
		 *  Calculate the S and V of HSV.
		 */
		private function calcSv():void
		{
			_vSaturation = _max == 0 ? 0 : ((_max - _min) / _max);
			_value = _max;
		}

		/**
		 *  Calculate the S and L of HSL.
		 */
		private function calcSl():void
		{
			var l:Number = (_min + _max) / 2;

			var s:Number = 0;

			if (l != 0)
			{
				s = (_max - _min) / (2 * (l < 0.5 ? l : (1 - l)));
			}

			_lSaturation = s;
			_lightness = l;
		}

		private function calcRgbFromHsv():void
		{
			var s:Number = _vSaturation;
			var v:Number = _value;

			var f:Number = (_hue / 60) - Math.floor(_hue / 60);
			var p:Number = v * (1 - s);
			var q:Number = v * (1 - f * s);
			var t:Number = v * (1 - (1 - f) * s);

			switch (uint(_hue / 60) % 6)
			{
			case 0:
				_red = v;
				_green = t;
				_blue = p;
				break;
			case 1:
				_red = q;
				_green = v;
				_blue = p;
				break;
			case 2:
				_red = p;
				_green = v;
				_blue = t;
				break;
			case 3:
				_red = p;
				_green = q;
				_blue = v;
				break;
			case 4:
				_red = t;
				_green = p;
				_blue = v;
				break;
			case 5:
				_red = v;
				_green = p;
				_blue = q;
				break;
			}
		}

		private function calcRgbFromHsl():void
		{
			var h:Number = _hue;
			var s:Number = _lSaturation;
			var l:Number = _lightness;

			var q:Number = (l < 0.5) ? (l * (1 + s)) : (l + s - (l * s));
			var p:Number = 2 * l - q;
			var hk:Number = h / 360;

			var tR:Number = adjustBy1(hk + (1.0 / 3.0));
			var tG:Number = adjustBy1(hk);
			var tB:Number = adjustBy1(hk - (1.0 / 3.0));

			_red = calcRgbComponent(tR, p, q);
			_green = calcRgbComponent(tG, p, q);
			_blue = calcRgbComponent(tB, p, q);
		}

		private function adjustBy1(n:Number):Number
		{
			if (n < 0) n += 1;
			if (n > 1) n -= 1;
			return n;
		}

		private function calcRgbComponent(tC:Number, p:Number, q:Number):Number
		{
			if (tC < (1.0 / 6.0))
			{
				return p + ((q - p) * 6 * tC);
			}
			else if (tC < 0.5)
			{
				return q;
			}
			else if (tC < (2.0 / 3.0))
			{
				return p + ((q - p) * 6 * ((2.0 / 3.0) - tC));
			}
			else
			{
				return p;
			}
		}

        /**
         * @private
         */
		private function dispatchChange():void
		{
			dispatchEvent(new Event("propertyChange"));
		}
    }
}
