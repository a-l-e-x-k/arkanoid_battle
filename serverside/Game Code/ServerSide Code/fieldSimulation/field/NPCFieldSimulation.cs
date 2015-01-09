using System;
using System.Collections;

namespace ServerSide
{
    public class NPCFieldSimulation : FieldSimulation
    {
        private int _tickNumberWithinChunk;
        public ArrayList criticalHits;

        public NPCFieldSimulation(string mapsProgram, NPCPlayer npclink) : base(mapsProgram, npclink)
        {
        }

        public void simulateEightTicks()
        {
            //may simulate / add powerup requests here
            requestsExecutedAt8Ticks = new ArrayList();

            criticalHits = new ArrayList(); //new crit hits at each tick, because they are sent right after tick ticks
            _tickNumberWithinChunk = 0;

            for (int i = 0; i < 8; i++)
            {
                if (_freezer.state != Freezer.STATE_FULL_SPEED)
                    _freezer.update();

                _ballsManager.moveBalls();
                if (tryExecuteOutstandingRequest(true)) //if ture, then game finished. Period
                    return;

                _tickNumberWithinChunk++;
            }
        }

        public override void saveCriticalHitForNPC()
        {
            double panelBallCenterX = getLowestBallX() - (bouncer.currentWidth/2); //always will hit the ball;
            int randomComponent = playerLink.roomLink.rand.Next((int) (bouncer.currentWidth*0.75));
                //about 25% fuck up. It will be added to the center of panel in random direction
            int directionRandom = playerLink.roomLink.rand.Next(2);
            randomComponent *= (directionRandom == 1 ? 1 : -1); //random direction
            bouncer.x = Math.Min(Math.Max(0, panelBallCenterX + randomComponent),
                GameConfig.FIELD_WIDTH_PX - bouncer.currentWidth); //limit by field size 
            criticalHits.Add(_tickNumberWithinChunk + ":" + bouncer.x);
        }

        private double getLowestBallX()
        {
            double lowestY = 0;
            double lowestBallX = 0;
            foreach (Ball ball in _ballsManager.balls)
            {
                if (ball.y > lowestY)
                {
                    lowestY = ball.y;
                    lowestBallX = ball.x;
                }
            }
            return lowestBallX;
        }
    }
}