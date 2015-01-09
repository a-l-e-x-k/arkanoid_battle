/**
 * Author: Alexey
 * Date: 11/24/12
 * Time: 11:22 PM
 */
package view.game.curveAnimations
{
	import events.RequestEventStarling;

	import flash.geom.Point;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	import utils.Misc;

	import view.game.field.BaseField;

	public class PrefreezeAnimation extends Sprite
	{
		private const MINIMUM_ANIMATION_LENGTH:int = 1000; //emitting for X seconds minimum. (otherwise stupid 0.5-sec anims could be)
		private const TANGENTIAL_ACCELERATION:int = 200;
		private const ANGLE_DIFFERENCE:int = 30; //for using tangential acceleration
		private const VERTICAL_ANGLE_PRECISION:int = 15; //amount of degrees which is allowed (+/-) as an error when determined whether to use tangential acc

		private var _particles:ParticleDesignerPS;
		private var _targetField:BaseField;
		private var _startedAt:uint;
		private var _active:Boolean = true;

		/**
		 *
		 * @param particleXML
		 * @param particleTexture
		 * @param startPoint
		 * @param targetPoint middle of the target field (used for calculating emitter angle & acceleration)
		 */
		public function PrefreezeAnimation(particleXML:Class, particleTexture:Class, startPoint:Point, targetPoint:Point, targetField:BaseField)
		{
			_targetField = targetField;

			_particles = new ParticleDesignerPS(XML(new particleXML()), Texture.fromBitmap(new particleTexture()));
			_particles.start();
			Starling.juggler.add(_particles);
			addChild(_particles);

			var atan:Number = Math.atan2(targetPoint.y, (targetPoint.x - startPoint.x));
			if (atan < 0)
				atan += 2 * Math.PI;
			var angleToBe:Number = 360 - (atan * 180 / Math.PI);
			trace("PrefreezeAnimation : PrefreezeAnimation : angleToBeangleToBe: " + angleToBe);
			var useTangAcc:Boolean = (Math.abs(270 - angleToBe) > VERTICAL_ANGLE_PRECISION) && (Math.abs(90 - angleToBe) > VERTICAL_ANGLE_PRECISION);
			var an:Number = angleToBe - 270;
			if (an > 0)
			{
				angleToBe -= ANGLE_DIFFERENCE;
				_particles.tangentialAcceleration = useTangAcc ? TANGENTIAL_ACCELERATION : 0;
			}
			else
			{
//				angleToBe += ANGLE_DIFFERENCE; //commenting this out is just a fast hack...
				_particles.tangentialAcceleration = useTangAcc ? -TANGENTIAL_ACCELERATION : 0;
			}

			trace("PrefreezeAnimation : PrefreezeAnimation : angleToBe: " + angleToBe + " : _particles.tangentialAcceleration: " + _particles.tangentialAcceleration);

			_particles.emitAngle = deg2rad(angleToBe);
			_particles.emitAngleVariance = deg2rad(10);
			_particles.lifespan = 1.2 ;
			_particles.lifespanVariance = 0.5;
			_startedAt = new Date().time;
		}

		public function setEmitterPosition(xx:int, yy:int):void
		{
			_particles.emitterX = xx;
			_particles.emitterY = yy - 20;
		}

		public function stop():void
		{
			var timePassed:uint = new Date().time - _startedAt;
			if (timePassed < MINIMUM_ANIMATION_LENGTH)
			{
				Misc.delayCallback(stopParticles, MINIMUM_ANIMATION_LENGTH - timePassed);
			}
			else
				stopParticles();
		}

		private function stopParticles():void
		{
			_active = false;
			_particles.stop();
			Misc.delayCallback(removeFromStage, 5000);
		}

		private function removeFromStage():void
		{
			dispatchEvent(new RequestEventStarling(RequestEventStarling.IMREADY));
			removeChild(_particles, true);
		}

		public function get targetField():BaseField
		{
			return _targetField;
		}

		public function get active():Boolean
		{
			return _active;
		}
	}
}
