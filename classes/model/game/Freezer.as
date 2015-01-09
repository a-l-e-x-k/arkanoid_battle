/**
 * Author: Alexey
 * Date: 11/24/12
 * Time: 1:50 AM
 */
package model.game
{
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import utils.Misc;

	/**
	 * Used for slowing down / speeing up game when "Freeze" spell is used.
	 * Stores coefficient which is used by various parts of the game to slow things down.
	 * Entity of this class is attached to BaseField
	 */
	public class Freezer
	{
		public static const STATE_FULL_SPEED:int = 0;
		public static const STATE_SLOWING_DOWN:int = 1;
		public static const STATE_FROZEN:int = 2;
		public static const STATE_SPEEDING_UP:int = 3;

		private var _coef:Number = 1; //1 -> no slowdown, 0 -> all stopped
		private var _state:int = STATE_FULL_SPEED;
		private var _currentTick:int = 0; //using Game ticks (approx. 30 times per second)
		private var _slowdownTime:int;
		private var _freezeTime:int;

		/**
		 * @param slowDownTime in game ticks, how long it takes to get from full speed to complete freeze
		 * @param freezeTime
		 */
		public function Freezer(slowDownTime:int, freezeTime:int)
		{
			_slowdownTime = slowDownTime;
			_freezeTime = freezeTime;
		}

		public function update():void
		{
			if (_state == STATE_FULL_SPEED)
			{
				trace("Freezer : update : That's bad! Don't call update on completely unfrozen Freezer. Returning...");
				return;
			}

			_currentTick++;

			if (_state == STATE_SLOWING_DOWN)
			{
				_coef = 1 - Misc.floorWithPrecision(_currentTick / _slowdownTime, 4);
				if (_currentTick == _slowdownTime) //slowdown complete, now we are frozen
				{
					_state = STATE_FROZEN;
				}
			}
			else if (_state == STATE_SPEEDING_UP)
			{
				var cycleLength:int = _slowdownTime + _freezeTime + _slowdownTime;
				_coef = Misc.floorWithPrecision((_currentTick - _slowdownTime - _freezeTime) / _slowdownTime, 4); //how much time passed since speed up started / speed up length
				if (_currentTick == cycleLength) //cycle finished, we are at full speed now
				{
					_state = STATE_FULL_SPEED;
					_currentTick = 0;
					_coef = 1;
				}
			}
			else if (_currentTick == (_slowdownTime + _freezeTime)) //enough being frozen, speed up now
			{
				_state = STATE_SPEEDING_UP;
			}
		}

		public function freeze():void
		{
			_state = STATE_SLOWING_DOWN;
            SoundAssetManager.playSound(SoundAsset.FREEZE);
		}

		public function get coef():Number
		{
			return _coef;
		}

		public function get state():int
		{
			return _state;
		}
	}
}
