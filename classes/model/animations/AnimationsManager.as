/**
 * Author: Alexey
 * Date: 7/31/12
 * Time: 2:24 AM
 */
package model.animations
{
    import events.RequestEvent;

    import starling.display.MovieClip;

    import utils.EventHub;
    import utils.ObjectsPool;

    import view.animations.BoomSmokeCreator;
    import view.animations.SmokeCreator;
    import view.animations.SpeedUpFireCreator;
    import view.animations.ballFires.BlueFireAnimationCreator;
    import view.animations.ballFires.RedFireAnimationCreator;

    public class AnimationsManager
{
	public static const BLUE_FIRE:int = 0;
	public static const RED_FIRE:int = 1;
	public static const SPEED_UP_FIRE:int = 2;
	public static const SMOKE:int = 3;
	public static const BOOM_SMOKE:int = 4;

	private static var blueFireCreator:BlueFireAnimationCreator;
	private static var redFireCreator:RedFireAnimationCreator;
	private static var speedUpFireCreator:SpeedUpFireCreator;
	private static var smokeCreator:SmokeCreator;
	private static var boomSmokeCreator:BoomSmokeCreator;

	private static var blueFirePool:ObjectsPool;
	private static var redFirePool:ObjectsPool;
	private static var speedUpFirePool:ObjectsPool;
	private static var smokePool:ObjectsPool;
	private static var boomSmokePool:ObjectsPool;

	private static var blueFireReady:Boolean = false;
	private static var redFireReady:Boolean = false;
	private static var speedUpFireReady:Boolean = false;
	private static var smokeReady:Boolean = false;
	private static var boomSmokeReady:Boolean = false;

	/**
	 * Creates animations and dispatches "ready event when all animations are created"
	 */
	public static function init():void
	{
		blueFireCreator = new BlueFireAnimationCreator(82, 500, 500);
		blueFireCreator.addEventListener(RequestEvent.IMREADY, onBlueFireReady);

		redFireCreator = new RedFireAnimationCreator(82, 500, 750);
		redFireCreator.addEventListener(RequestEvent.IMREADY, onRedFireReady);

		speedUpFireCreator = new SpeedUpFireCreator(100, 4, 1000);
		speedUpFireCreator.addEventListener(RequestEvent.IMREADY, onSpeedUpFireReady);

		smokeCreator = new SmokeCreator(150, 4, 1250);
		smokeCreator.addEventListener(RequestEvent.IMREADY, onSmokeReady);

		boomSmokeCreator = new BoomSmokeCreator(30, 50, 0);
		boomSmokeCreator.addEventListener(RequestEvent.IMREADY, onBoomSmokeReady);
	}

	public static function getAnimation(animationType:int):MovieClip
	{
		var pool:ObjectsPool = getPoolByAnimationType(animationType);
		if (pool)
			return pool.getObject() as MovieClip;
		else
			throw new Error("Wrong animation type specified when requesting animation: " + animationType);
	}

	public static function putAnimation(animationType:int, obj:MovieClip):void
	{
		var pool:ObjectsPool = getPoolByAnimationType(animationType);
		if (pool)
			pool.returnObject(obj);
		else
			throw new Error("Wrong animation type specified when returning animation: " + animationType);
	}

	private static function getPoolByAnimationType(animationType:int):ObjectsPool
	{
		var pool:ObjectsPool;
		switch (animationType)
		{
			case BLUE_FIRE:
				pool = blueFirePool;
				break;
			case RED_FIRE:
				pool = redFirePool;
				break;
			case SPEED_UP_FIRE:
				pool = speedUpFirePool;
				break;
			case SMOKE:
				pool = smokePool;
				break;
			case BOOM_SMOKE:
				pool = boomSmokePool;
				break;
		}
		return pool;
	}

	private static function onSmokeReady(event:RequestEvent):void
	{
		traceme("onSmokeReady", Relations.LOADING);

		smokePool = new ObjectsPool(event.stuff.items);
		smokeReady = true;
		smokeCreator.removeEventListener(RequestEvent.IMREADY, onSmokeReady);
		smokeCreator = null;

		tryDispatchReady();
	}

	private static function onBoomSmokeReady(event:RequestEvent):void
	{
		traceme("onBoomSmokeReady", Relations.LOADING);

		boomSmokePool = new ObjectsPool(event.stuff.items);
		boomSmokeReady = true;
		boomSmokeCreator.removeEventListener(RequestEvent.IMREADY, onBoomSmokeReady);
		boomSmokeCreator = null;

		tryDispatchReady();
	}

	private static function onSpeedUpFireReady(event:RequestEvent):void
	{
		traceme("onSpeedUpFireReady", Relations.LOADING);

		speedUpFirePool = new ObjectsPool(event.stuff.items);
		speedUpFireReady = true;
		speedUpFireCreator.removeEventListener(RequestEvent.IMREADY, onSpeedUpFireReady);
		speedUpFireCreator = null;

		tryDispatchReady();
	}

	private static function onRedFireReady(event:RequestEvent):void
	{
		traceme("onRedFireReady", Relations.LOADING);

		redFirePool = new ObjectsPool(event.stuff.items);
		redFireReady = true;
		redFireCreator.removeEventListener(RequestEvent.IMREADY, onRedFireReady);
		redFireCreator = null;

		tryDispatchReady();
	}

	private static function onBlueFireReady(event:RequestEvent):void
	{
		traceme("blueFireReady", Relations.LOADING);

		blueFirePool = new ObjectsPool(event.stuff.items);
		blueFireReady = true;
		blueFireCreator.removeEventListener(RequestEvent.IMREADY, onBlueFireReady);
		blueFireCreator = null;

		tryDispatchReady();
	}

	private static function tryDispatchReady():void
	{
		trace("tryDispatchReady" + blueFireReady + redFireReady + speedUpFireReady + smokeReady);

		if (blueFireReady && redFireReady && speedUpFireReady && smokeReady && boomSmokeReady)
			EventHub.dispatch(new RequestEvent(RequestEvent.ANIMATIONS_MANAGER_READY));
	}
}
}
