// ***************************************************************************
// Wheel.as
//
// Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

package com.thenduks.ilac {
  
  import flash.display.CapsStyle;
  import flash.display.GradientType;
  import flash.display.LineScaleMode;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  import flash.geom.Point;
  
  import mx.managers.CursorManager;

  public class Wheel extends Sprite {
    private static const DEFAULT_RADIUS:Number  = 100;
    private var cursorID:int;
	public var radius:Number = DEFAULT_RADIUS;
    [Embed(source="colorpicker.gif")]
    private var colorPickerIcon:Class;

    public function Wheel() {
      createListeners();
    }

    private function createListeners():void {
      addEventListener( MouseEvent.ROLL_OVER, setCursor );
      addEventListener( MouseEvent.ROLL_OUT, removeCursor );
    }

    private function setCursor( event:MouseEvent ):void {
      cursorID = CursorManager.setCursor( colorPickerIcon, 2, -8, -23 );
    }

    private function removeCursor( event:MouseEvent ):void {
      if( cursorID ) { CursorManager.removeCursor( cursorID ); }
    }

    public function draw( radius:Number = DEFAULT_RADIUS ):void {
	  this.radius = radius;
      var radians:Number;
      var color:Number;
      var objMatrix:Matrix;
      var iThickness:int;

      graphics.clear();

      iThickness = 1 + int( radius / 50 );

      // Loop from '0' to '360' degrees, drawing lines from the center
      // of the wheel outward the length of the specified radius.
      for( var i:int = 0; i < 360; i++ ) {
        // Convert the degree to radians.
        radians = i * ( Math.PI / 180 );

		var col:Array = ColorUtil.HSVtoRGB(i,1,1); 
		color = col[0] << 16 | col[1] << 8 | col[2];
        
		var pos:Point = getPos(color);
		
		
		//pos = getPos(getColor(pos.x, pos.y), radius); //Self test
		
        // Create a matrix for the lines gradient color.
        objMatrix = new Matrix();
        objMatrix.createGradientBox( radius * 2, radius * 2, radians, 0, 0 );

        // Create and drawn the line.
        graphics.lineStyle( iThickness, 0, 1, false,
                            LineScaleMode.NONE, CapsStyle.NONE );
        graphics.lineGradientStyle( GradientType.LINEAR, [0xFFFFFF, color],
                                    [100, 100], [127, 255], objMatrix );
        graphics.moveTo( radius, radius );
        graphics.lineTo(pos.x,pos.y);
      }
    }
	
	public function getPos(color:uint):Point{
		var hsv:Array = ColorUtil.RGBtoHSV(color);
		var radian:Number = hsv[0] / 180 * Math.PI;
		var colorRadius:Number = hsv[1] * radius;
		var x:Number = radius + Math.cos( radian ) * colorRadius;
		var y:Number = radius + Math.sin( radian ) * colorRadius;
		return new Point(x, y);
	}
	
	public function getColor(x:int, y:int, v:Number = 1):uint{
		var h:Number = Math.atan2((x - radius) / radius, (y -radius) / radius);
		var s:Number =  new Point(x - radius,y - radius).length / radius;
		h = -h / Math.PI * 180 + 90;
		return ColorUtil.toRGBint(ColorUtil.HSVtoRGB(h, s,v));
	}
  }
}
