/**
 * Author: Alexey
 * Date: 7/29/12
 * Time: 12:31 AM
 */
package view.game.lightning
{
import events.RequestEvent;

import external.caurina.transitions.Tweener;

import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
import flash.geom.Point;

    import model.constants.GameConfig;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import model.timer.GlobalTimer;

	import model.game.lightning.LightningFadeType;

import view.game.bouncer.Bouncer;

import utils.Misc;

public class LightningGroup extends Sprite
{
	private const ANIM_LENGTH:Number = 0.2; //200ms animation of appearance

	private var _glow:GlowFilter = new GlowFilter();
	private var _lightnings:Array = [];
	private var _panelLink:Bouncer;

	public function LightningGroup(panelLink:Bouncer, centerX:Number, centerY:Number, brickPoints:Array)
	{
		createGlow();

		_panelLink = panelLink;
		var panelPoint:Point = new Point(panelLink.x + GameConfig.BOUNCER_WIDTH / 2, panelLink.y);

		if (brickPoints.length == 1)
		{
			createLightningPair(panelPoint.x, panelPoint.y, brickPoints[0].x, brickPoints[0].y, ANIM_LENGTH, true);
		}
		else
		{
			var firstLighting:Lightning = createLightning(panelPoint.x, panelPoint.y, panelPoint.x, panelPoint.y, 1, LightningFadeType.GENERATION, false, true, brickPoints.length + 1);
			tweenLightningEndPoint(firstLighting, centerX, centerY, ANIM_LENGTH / 2, "easeOutExpo", function():void
			{
				for each (var point:Point in brickPoints)
				{
					createLightningPair(centerX, centerY, point.x, point.y, ANIM_LENGTH / 2);
				}
			});
		}

		Misc.delayCallback(function():void{dispatchEvent(new RequestEvent(RequestEvent.IMREADY));}, ANIM_LENGTH);

		GlobalTimer.addEventListener(TimerEvent.TIMER, onframe);

        SoundAssetManager.playSound(SoundAsset.LIGHTNING);
	}

	private function createLightningPair(startX:Number, startY:Number, targetX:Number, targetY:Number, tweenLength:Number, updateStartPoint:Boolean = false):void
	{
		var mainLightning:Lightning = createLightning(startX, startY, startX, startY, 1, LightningFadeType.GENERATION, false, updateStartPoint);
		var decorLighting:Lightning = createLightning(startX, startY, startX, startY, 1, LightningFadeType.TIP_TO_END, true, updateStartPoint); //another "underlying" lighting with wide weak "roots"
		tweenLightningEndPoint(mainLightning, targetX, targetY, tweenLength, "easeOutExpo");
		tweenLightningEndPoint(decorLighting, targetX, targetY, tweenLength, "easeOutExpo");
	}

	private static function tweenLightningEndPoint(lightning:Lightning, targetEndX:Number, targetEndY:Number, tweenLength:Number, tweenType:String, onComplete:Function = null):void
	{
		Tweener.addTween(lightning, {endX:targetEndX, time:tweenLength, transition:tweenType, onComplete:onComplete});
		Tweener.addTween(lightning, {endY:targetEndY, time:tweenLength, transition:tweenType});
	}

	private function createGlow():void
	{
		_glow.color = 0x56D8FE;
		_glow.strength = 3.5;
		_glow.quality = 3;
		_glow.blurX = _glow.blurY = 10;
	}

	public function createLightning(startX:Number, startY:Number, endX:Number, endY:Number, maxChildren:int, alphaFadeType:String, childrenDetached:Boolean = false, updateStartPoint:Boolean = false, thickness:int = 2):Lightning
	{
		var ll:Lightning = new Lightning(0xffffff, thickness);
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
		ll.updateStartPoint = updateStartPoint;
		ll.childrenDetachedEnd = childrenDetached;
		ll.alphaFadeType = alphaFadeType;
		ll.filters = [_glow];
		addChild(ll);
		_lightnings.push(ll);
		return ll;
	}

	private function onframe(event:TimerEvent):void
	{
		for each (var lightning:Lightning in _lightnings)
		{
			lightning.update();
			if (lightning.updateStartPoint) //update when bouncer is moving
			{
				lightning.startX = _panelLink.x + GameConfig.BOUNCER_WIDTH / 2;
				lightning.startY = _panelLink.y;
			}
		}
	}

	public function die():void
	{
		for (var i:int = _lightnings.length - 1; i >= 0; i--)
		{
			_lightnings[i].kill();
			_lightnings.splice(i, 1);
		}
		GlobalTimer.removeEventListener(TimerEvent.TIMER, onframe);
	}
}
}
