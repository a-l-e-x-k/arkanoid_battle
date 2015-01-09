/**
 * Author: Alexey
 * Date: 7/29/12
 * Time: 12:31 AM
 */
package
{
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;

public class LightningGroup extends Sprite
{
	private var _glow:GlowFilter = new GlowFilter();
	private var _lightnings:Array = [];

	public function LightningGroup(startX:Number, startY:Number, endPoints:Array)
	{
		createGlow();

		for (var i:int = 0; i < endPoints.length; i++)
		{
			createLightning(startX, startY, endPoints[i].x, endPoints[i].y, 1, LightningFadeType.GENERATION);
			createLightning(startX, startY, endPoints[i].x, endPoints[i].y, 2, LightningFadeType.TIP_TO_END, true); //another "underlying" lighting with wide weak "roots"
		}

		addEventListener(Event.ENTER_FRAME, onframe);
	}

	private function createGlow():void
	{
		_glow.color = 0x56D8FE;
		_glow.strength = 3.5;
		_glow.quality = 3;
		_glow.blurX = _glow.blurY = 10;
	}

	public function createLightning(startX:Number, startY:Number, endX:Number, endY:Number, maxChildren:int, alphaFadeType:String, childrenDetached:Boolean = false):void
	{
		var ll:Lightning = new Lightning(0xffffff, 2);
		ll.blendMode = BlendMode.ADD;
		ll.childrenDetachedEnd = true;
		ll.childrenLifeSpanMin = .1;
		ll.childrenLifeSpanMax = 2;
		ll.childrenMaxCount = maxChildren;
		ll.childrenMaxCountDecay = .5;
		ll.childrenProbability = .3;
		ll.steps = 50;
		ll.startX = startX;
		ll.startY = startY;
		ll.endX = endX;
		ll.endY = endY;
		ll.childrenDetachedEnd = childrenDetached;
		ll.alphaFadeType = alphaFadeType;
		ll.filters = [_glow];
		addChild(ll);

		_lightnings.push(ll);
	}

	private function onframe(event:Event):void
	{
		for each (var lightning:Lightning in _lightnings)
		{
			lightning.update();
		}
	}
}
}
