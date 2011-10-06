package net.findzen.display {

	import flash.display.MovieClip;
	import net.findzen.display.Button;

	public class InvisibleButton extends Button {

		public function InvisibleButton($width:Number, $height:Number) {
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0x000000, 0);
			mc.graphics.drawRect(0, 0, $width, $height);
			mc.graphics.endFill();

			super(mc);
		}
	}
}