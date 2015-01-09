using System;
using System.Collections;

namespace ServerSide
{
	class BallHitTester
	{
		/**
	 * Checks for cells which are around and "hit tests" them by comparing coordinates.
	 * @param ball
	 * @param field
	 */

		public static void hitTest(Ball ball, FieldSimulation field, bool shieldProtection)
		{
			double currentCellI = Math.Floor(ball.x / GameConfig.BRICK_WIDTH);
			double currentCellJ = Math.Floor(ball.y / GameConfig.BRICK_HEIGHT);
			
			AroundCellData nearByCellsData = new AroundCellData(field.fieldCells.cells, (int)currentCellI, (int)currentCellJ, field);
            hitTestFieldSides(nearByCellsData, ball, field, shieldProtection);
			if (ball.stealthMode == false) //if stealth (during switching presets) -> don't hittest cells
                hitTestCells(nearByCellsData._cells, ball);
		}

		private static void hitTestFieldSides(AroundCellData nearByCellsData, Ball ball, FieldSimulation field, bool shieldProtection)
		{
			if (ballAtCriticalZone(ball, field) && ball.goingDown)  //currentCellJ > 25 so no unnecessary hittesting
			{
                field.saveCriticalHitForNPC();

				if (ball.x > field.bouncer.x && ball.x < (field.bouncer.x + field.bouncer.currentWidth)) //hit panel
				{
					Console.WriteLine("[Hit panel]: " + field.bouncer.x + " : " + ball.x + "  " + ball.y + " tick: " + field.ballsManager.currentTick + (field is NPCFieldSimulation ? " [NPC] " : " [Player] "));
					ball.bounceOff(false, (ball.x - field.bouncer.x) / field.bouncer.currentWidth);
					if (ball.stealthMode)
						ball.goOutOfStealth();
				}
                else if (shieldProtection)
                {
                    Console.WriteLine("YYYY: shield protection on. tick: " + field.ballsManager.currentTick);
                    if (ball.y + GameConfig.BALL_RADIUS >= field.bouncer.y + GameConfig.BOUNCER_WATER_DEPTH)
                    {
                        Console.WriteLine("YYYY: shield protection on and bounce off at: " + ball.y + " tick: " + field.ballsManager.currentTick);
                        ball.bounceOff(false);
                        if (ball.stealthMode)
                            ball.goOutOfStealth();
                    }
                }
                else
                {
                    Console.WriteLine("[Missed panel]: " + field.bouncer.x + " : " + ball.x + "  " + ball.y + " tick: " + field.ballsManager.currentTick + (field is NPCFieldSimulation ? " [NPC] " : " [Player] "));
                    ball.die();
                }

                if (!shieldProtection)
				    ball.y = field.bouncer.y - GameConfig.BALL_RADIUS; //making sure ball will bounce off always from the same point
			}
			else if ((nearByCellsData.leftBorderNearby && ball.x - GameConfig.BALL_RADIUS <= 0 && ball.goingLeft) || (nearByCellsData.rightBorderNearby && (ball.x + GameConfig.BALL_RADIUS) >= GameConfig.FIELD_WIDTH_PX && ball.goingRight))
				ball.bounceOff(true);
			else if (nearByCellsData.topBorderNearby && ball.y - GameConfig.BALL_RADIUS <= 0 && ball.goingUp)
				ball.bounceOff(false);
		}

		private static void hitTestCells(ArrayList nearByCells, Ball ball)
		{
			Cell currentCell;
			if (nearByCells.Count > 0)
			{
				for (int i = 0; i < nearByCells.Count; i++)
				{
						//("Cell around i: " + nearByCells[i].j + " cell.j: " + nearByCells[i].i + " currentCellI: " + currentCellI + " currentCellJ: " + currentCellJ + " x: " + x + " y " + y);

					currentCell = nearByCells[i] as Cell;

					if (ball.y - GameConfig.BALL_RADIUS <= (currentCell.y + GameConfig.BRICK_HEIGHT) && ball.y - GameConfig.BALL_RADIUS >= currentCell.y && ballInXTunnel(currentCell, ball) && ball.goingUp) //cell on top
					{
						currentCell.clearBrick();
						ball.bounceOff(false);
					}
					else if ((ball.y + GameConfig.BALL_RADIUS) >= currentCell.y && (ball.y + GameConfig.BALL_RADIUS) <= (currentCell.y + GameConfig.BRICK_HEIGHT) && ballInXTunnel(currentCell, ball) && ball.goingDown) //cell on bottom
					{
						currentCell.clearBrick();
						ball.bounceOff(false);
					}
					else if (ball.x - GameConfig.BALL_RADIUS <= (currentCell.x + GameConfig.BRICK_WIDTH) && ball.x - GameConfig.BALL_RADIUS >= currentCell.x && ballInYTunnel(currentCell, ball) && ball.goingLeft) //cell on left
					{
						currentCell.clearBrick();
						ball.bounceOff(true);
					}
					else if ((ball.x + GameConfig.BALL_RADIUS) >= currentCell.x && (ball.x + GameConfig.BALL_RADIUS) <= (currentCell.x + GameConfig.BRICK_WIDTH) && ballInYTunnel(currentCell, ball) && ball.goingRight) //cell on right
					{
						currentCell.clearBrick();
						ball.bounceOff(true);
					}
				}
			}
		}

		private static bool ballInXTunnel(Cell cell, Ball ball)
		{
			return ball.x >= cell.x && ball.x <= (cell.x + GameConfig.BRICK_WIDTH);
		}

		private static bool ballInYTunnel(Cell cell, Ball ball)
		{
			return ball.y >= cell.y && ball.y <= (cell.y + GameConfig.BRICK_HEIGHT);
		}

		private static bool ballAtCriticalZone(Ball ball, FieldSimulation field)
		{
			return ball.y + GameConfig.BALL_RADIUS >= field.bouncer.y;
		}
	}
}
