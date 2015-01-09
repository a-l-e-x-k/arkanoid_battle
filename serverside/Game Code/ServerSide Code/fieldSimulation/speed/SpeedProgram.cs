namespace ServerSide
{
    public class SpeedProgram
    {
        public static int getNextSpeed(string gameType, int currentSpeed)
        {
            int nextSpeed = 0;
            if (gameType == GameTypes.FAST_SPRINT || gameType == GameTypes.BIG_BATTLE)
            {
                if (currentSpeed == Speed.SLOW)
                    nextSpeed = Speed.MEDIUM;
                else if (currentSpeed == Speed.MEDIUM)
                    nextSpeed = Speed.FAST;
                else if (currentSpeed == Speed.FAST)
                    nextSpeed = Speed.SUPER_FAST;
                else if (currentSpeed == Speed.SUPER_FAST)
                    nextSpeed = Speed.CRAZY;
                else if (currentSpeed == Speed.CRAZY)
                    nextSpeed = Speed.CRAZY_FAST;
                else if (currentSpeed == Speed.CRAZY_FAST)
                    nextSpeed = Speed.ULTIMATE_MADNESS;
                else if (currentSpeed == Speed.ULTIMATE_MADNESS)
                    nextSpeed = Speed.SUPER_ULTIMATE_MADNESS;
                else if (currentSpeed == Speed.SUPER_ULTIMATE_MADNESS) //can't go over ultimate madness
                    nextSpeed = Speed.SUPER_ULTIMATE_MADNESS;
            }
            return nextSpeed;
        }


        /*private Dictionary<int, int> _data;

		public SpeedProgram(bool loungeProgram)
		{
			if (loungeProgram)
				createLoungeProgram();
			else 
				createRushProgram();
		}

		
		private void createLoungeProgram()
		{
			_data = new Dictionary<int, int>();
			_data[0] = Speed.SLOW;
		}

		private void createRushProgram()
		{
			_data = new Dictionary<int, int>();
			_data[0] = Speed.SLOW;
			_data[secondsToTicks(6)] = Speed.MEDIUM; //6 seconds passed
			_data[secondsToTicks(16)] = Speed.FAST; //10 more secs
			_data[secondsToTicks(36)] = Speed.SUPER_FAST; //10 more secs
			_data[secondsToTicks(50)] = Speed.CRAZY; //10 more secs
			_data[secondsToTicks(65)] = Speed.CRAZY_FAST; //10 more secs
			_data[secondsToTicks(81)] = Speed.ULTIMATE_MADNESS; //10 more secs
			_data[secondsToTicks(101)] = Speed.SUPER_ULTIMATE_MADNESS; //10 more secs
			_data[secondsToTicks(121)] = Speed.REALLY_ULTIMATE_MADNESS; //10 more secs
			_data[secondsToTicks(143)] = Speed.REALLY_ULTIMATE_MADNESS + 10; //10 more secs
			_data[secondsToTicks(166)] = Speed.REALLY_ULTIMATE_MADNESS + 20; //10 more secs
			_data[secondsToTicks(189)] = Speed.REALLY_ULTIMATE_MADNESS + 30; //10 more secs
			_data[secondsToTicks(219)] = Speed.REALLY_ULTIMATE_MADNESS + 40; //10 more secs
		}

		public string getAsString()
		{
			string result = "";
			foreach (int stepNumber in _data.Keys)
			{
				result += stepNumber + ":" + _data[stepNumber] + ",";
			}
			result = result.Remove(result.Length - 1); //remove last comma
			return result;
		}

		private int secondsToTicks(int seconds)
		{
			return seconds * 33; //Game timer is 30ms timer. so 30 * 33 = 990ms. approx 1 sec
		}

		public Dictionary<int, int> data
		{
			get
			{
				return _data;
			}
		}*/
    }
}