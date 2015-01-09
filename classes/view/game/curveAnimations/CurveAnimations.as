/**
 * Author: Alexey
 * Date: 9/9/12
 * Time: 9:59 PM
 */
package view.game.curveAnimations
{
	import events.RequestEvent;

	import external.caurina.transitions.Tweener;
	import external.caurina.transitions.properties.CurveModifiers;

	import model.StarlingTextures;
	import model.constants.PointsPrizes;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;

	import utils.EventHub;

	import view.game.field.BaseField;

	/**
	 * Customized class for each project.
	 * Knows how to show animation (target point coordinates, anim length, mcs)
	 */
	public class CurveAnimations extends Sprite
	{
		[Embed(source="../../../../assets/starparticle/particle.pex", mimeType="application/octet-stream")]
		private var starParticleXML:Class;

		[Embed(source="../../../../assets/starparticle/texture.png")]
		private var starParticleTexture:Class;

		[Embed(source="../../../../assets/fireparticle/particle2.pex", mimeType="application/octet-stream")]
		private var fireParticleXML:Class;

		[Embed(source="../../../../assets/fireparticle/texture.png")]
		private var fireParticleTexture:Class;

		private const ANIM_TIME:Number = 0.7; //secs
		private const FIREBALL_ANIM_TIME:Number = 1.2; //secs
		private const FADE_OUT_TIME:Number = 0.3; //secs

		public function CurveAnimations()
		{
			CurveModifiers.init();
		}

		/**
		 * @param fromX
		 * @param fromY
		 * @param targetX
		 * @param targetY
		 * @param pointsAmount
		 * @param targetField field, to which points should be added
		 * @param animLength
		 */
		public function showPointsAnim(fromX:int, fromY:int, targetX:int, targetY:int, pointsAmount:int, targetField:BaseField, animLength:Number = ANIM_TIME):void
		{
			var textureID:String;
			switch (pointsAmount)
			{
				case PointsPrizes.CELL_CLEARED:
					textureID = StarlingTextures.POINTS_CELL_CLEARED;
					break;
				case PointsPrizes.LOST_BALL:
					textureID = StarlingTextures.POINTS_LOST_BALL;
					break;
				case PointsPrizes.MEGA:
					textureID = StarlingTextures.POINTS_MEGA;
					break;
			}

			var ptsImg:Image = new Image(StarlingTextures.getTexture(textureID));
			ptsImg.x = fromX;
			ptsImg.y = fromY;

			var particles:ParticleDesignerPS = new ParticleDesignerPS(XML(new starParticleXML()), Texture.fromBitmap(new starParticleTexture()));
			particles.start();
			particles.emitterX = fromX + ptsImg.width / 2;
			particles.emitterY = fromY + ptsImg.height / 2;
			Starling.juggler.add(particles);
			addChild(particles);

			addChild(ptsImg);

			Tweener.addTween([ptsImg, particles], { alpha:0, delay:animLength - FADE_OUT_TIME, time:FADE_OUT_TIME, transition:"easeOutSine"});
			Tweener.addTween(ptsImg, { x:targetX, y:targetY, _bezier:{ x:targetX, y:fromY }, time:animLength, transition:"easeOutSine", onComplete:function ():void
			{
				removeChild(ptsImg);
				EventHub.dispatch(new RequestEvent(RequestEvent.POINTS_ANIM_FINISHED, {pointsAmount:pointsAmount, targetField:targetField}));
			}});

			Tweener.addTween(particles, { emitterX:targetX + ptsImg.width / 2, emitterY:targetY + ptsImg.height / 2,
				_bezier:{ emitterX:targetX + ptsImg.width / 2, emitterY:fromY + ptsImg.height / 2 }, time:animLength, transition:"easeOutSine", onComplete:function ():void
			{
				Starling.juggler.remove(particles);
				particles.stop();
				removeChild(particles);
			}});
		}

		public function showFireballAnim(fromX:int, fromY:int, targetX:int, targetY:int, targetField:BaseField = null, animLength:Number = FIREBALL_ANIM_TIME):void
		{
			var fireball:Image = new Image(StarlingTextures.getTexture(StarlingTextures.FIREBALL));
			fireball.x = fromX;
			fireball.y = fromY;
			fireball.scaleX = 0.4;
			fireball.scaleY = 0.4;

			var particles:ParticleDesignerPS = new ParticleDesignerPS(XML(new fireParticleXML()), Texture.fromBitmap(new fireParticleTexture()));
			particles.start();
			particles.emitterX = fromX + fireball.width / 2;
			particles.emitterY = fromY + fireball.height / 2;
			Starling.juggler.add(particles);
			addChild(particles);

			addChild(fireball);

			Tweener.addTween([fireball, particles], { alpha:0, delay:animLength - FADE_OUT_TIME, time:FADE_OUT_TIME, transition:"easeInExpo"});
			Tweener.addTween(fireball, { scaleX:1, scaleY:1, time:animLength, transition:"easeOutSine"});

			Tweener.addTween(fireball, { x:targetX, y:targetY, _bezier:{ x:targetX, y:fromY }, time:animLength, transition:"easeInSine", onComplete:function ():void
			{
				removeChild(fireball);
				if (targetField)
					EventHub.dispatch(new RequestEvent(RequestEvent.FIREBALL_ANIM_FINISHED, {targetField:targetField}));
			}});

			Tweener.addTween(particles, { emitterX:targetX + fireball.width / 2, emitterY:targetY + fireball.height / 2,
				_bezier:{ emitterX:targetX + fireball.width / 2, emitterY:fromY + fireball.height / 2 },
				time:animLength, transition:"easeInSine", onComplete:function ():void
			{
				Starling.juggler.remove(particles);
				particles.stop();
				removeChild(particles);
			}});
		}
	}
}
