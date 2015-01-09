/**
 * Author: Alexey
 * Date: 6/28/12
 * Time: 9:43 PM
 */
package model.game.ball
{
	import model.constants.GameConfig;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import view.game.field.*;
	import view.game.field.cells.StarlingCell;

	/**
 * Determines whether ball hit cells.
 */
public class BallHittester
{
	public function BallHittester()
	{
	}

	/**
	 * Checks for cells which are around and "hit tests" them by comparing coordinates.
	 * @param ball
	 * @param field
	 * @param shieldProtection
	 */
	public static function hitTest(ball:BallModel, field:BaseField, shieldProtection:Boolean):void
	{
		var currentCellI:int = Math.floor(ball.x / GameConfig.BRICK_WIDTH);
		var currentCellJ:int = Math.floor(ball.y / GameConfig.BRICK_HEIGHT);

		var nearByCellsData:AroundCellData = new AroundCellData(field.cellsGrid, currentCellI, currentCellJ);
		var nearByCells:Vector.<StarlingCell> = nearByCellsData.nearbyCells;

		hitTestFieldSides(nearByCellsData, ball, field, shieldProtection);
		if (!ball.stealthMode) //if stealth (during switching presets) -> don't hittest cells
			hitTestCells(nearByCells, ball);
	}

	private static function hitTestFieldSides(nearByCellsData:AroundCellData, ball:BallModel, field:BaseField, shieldProtection:Boolean):void
	{
		if (ballAtCriticalZone(ball, field) && ball.goingDown)  //currentCellJ > 25 so no unnecessary hittesting
		{
            field.saveCriticalHit(field.bouncer.x);

            if (ball.x > field.bouncer.x && ball.x < (field.bouncer.x + GameConfig.BOUNCER_WIDTH))
			{
                SoundAssetManager.playSound(SoundAsset.BOUNCER_HIT);
				ball.bounceOff(false, (ball.x - field.bouncer.x) / GameConfig.BOUNCER_WIDTH);
				if (ball.stealthMode && !field.gameFinished)
					ball.goOutOfStealth();

				trace("[Hit bouncer]: " + field.bouncer.x + " : " + ball.x + "  " + ball.y + " tick: " + field.currentTick, (field is PlayerField ? " [Player] " : " [NPC] "));
			}
            else if (shieldProtection)
            {
                trace("YYYY: sheild protection on. tick: " + field.currentTick);
                if (ball.y + GameConfig.BALL_RADIUS >= field.bouncer.y + GameConfig.BOUNCER_WATER_DEPTH)
                {
                    trace("YYYY: shield protection on and bounce off at: " + ball.y + " tick: " + field.currentTick);
                    SoundAssetManager.playSound(SoundAsset.WATER);
                    ball.bounceOff(false);
                    if (ball.stealthMode && !field.gameFinished)
                        ball.goOutOfStealth();
                }
            }
			else
			{
                SoundAssetManager.playSound(SoundAsset.MISSED_BOUNCER);
				trace("[Missed bouncer]: " + field.bouncer.x + " : " + ball.x + "  " + ball.y + " tick: " + field.currentTick, (field is PlayerField ? " [Player] " : " [NPC] "));
				ball.die();
			}

            if (!shieldProtection)
			    ball.resetY(field.bouncer.y - GameConfig.BALL_RADIUS); //making sure ball will bounce off always from the same point
		}
		else if ((nearByCellsData.leftBorderNearby && ball.x - GameConfig.BALL_RADIUS <= 0 && ball.goingLeft) || (nearByCellsData.rightBorderNearby && ball.x + GameConfig.BALL_RADIUS >= GameConfig.FIELD_WIDTH_PX && ball.goingRight))
			ball.bounceOff(true);
		else if (nearByCellsData.topBorderNearby && ball.y - GameConfig.BALL_RADIUS <= 0 && ball.goingUp)
			ball.bounceOff(false);
	}

	private static function hitTestCells(nearByCells:Vector.<StarlingCell>, ball:BallModel):void
	{
		if (nearByCells.length > 0)
		{
			for (var i:int = 0; i < nearByCells.length; i++)
			{
//				trace("Cell around i: " + nearByCells[i].j + " cell.j: " + nearByCells[i].i );

				if (ball.y - GameConfig.BALL_RADIUS <= (nearByCells[i].y + GameConfig.BRICK_HEIGHT) && ball.y - GameConfig.BALL_RADIUS >= nearByCells[i].y && ballInXTunnel(nearByCells[i], ball) && ball.goingUp) //cell on top
				{
					nearByCells[i].clearBrick();
					ball.bounceOff(false);
				}
				else if ((ball.y + GameConfig.BALL_RADIUS) >= nearByCells[i].y && (ball.y + GameConfig.BALL_RADIUS) <= (nearByCells[i].y + GameConfig.BRICK_HEIGHT) && ballInXTunnel(nearByCells[i], ball) && ball.goingDown) //cell on bottom
				{
					nearByCells[i].clearBrick();
					ball.bounceOff(false);
				}
				else if (ball.x - GameConfig.BALL_RADIUS <= (nearByCells[i].x + GameConfig.BRICK_WIDTH) && ball.x - GameConfig.BALL_RADIUS >= nearByCells[i].x && ballInYTunnel(nearByCells[i], ball) && ball.goingLeft) //cell on left
				{
					nearByCells[i].clearBrick();
					ball.bounceOff(true);
				}
				else if ((ball.x + GameConfig.BALL_RADIUS) >= nearByCells[i].x && (ball.x + GameConfig.BALL_RADIUS) <= (nearByCells[i].x + GameConfig.BRICK_WIDTH) && ballInYTunnel(nearByCells[i], ball) && ball.goingRight) //cell on right
				{
					nearByCells[i].clearBrick();
					ball.bounceOff(true);
				}
			}
		}
	}

	private static function ballInXTunnel(cell:StarlingCell, ball:BallModel):Boolean
	{
		return ball.x >= cell.x && ball.x <= (cell.x + GameConfig.BRICK_WIDTH);
	}

	private static function ballInYTunnel(cell:StarlingCell, ball:BallModel):Boolean
	{
		return ball.y >= cell.y && ball.y <= (cell.y + GameConfig.BRICK_HEIGHT);
	}

	private static function ballAtCriticalZone(ball:BallModel, field:BaseField):Boolean
	{
		return ball.y + GameConfig.BALL_RADIUS >= field.bouncer.y;
	}
}
}
