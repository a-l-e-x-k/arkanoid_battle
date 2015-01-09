using System;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public abstract class TimeLimitedGame : Game
    {
        private int currentTick;
        private Timer gameTimer;
        private BasicRoom room;
        private string type;

        public TimeLimitedGame(string type, string mapID, BasicRoom room, int ggameLength)
            : base(type, mapID, room, ggameLength)
        {
        }

        protected override void specificGameStart()
        {
            gameTimer = roomLink.AddTimer(onGameTimerTick, 1000);
        }

        protected override bool specificPowerupCheck()
        {
            return gameLength - currentTick > 2; //1-2 seconds left
        }

        protected override void specialGameFinish()
        {
            Console.WriteLine("Normal game finish!");
            gameTimer.Stop();
        }

        private void onGameTimerTick()
        {
            currentTick++;
            if (currentTick == gameLength + 3) //upto 3 secs allowed for latency things
            {
                gameTimer.Stop();
                forceFinishGame();
            }
            else if (currentTick == gameLength - 1)
                makeNPCsFinish();
        }
    }
}