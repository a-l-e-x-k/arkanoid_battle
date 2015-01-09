using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;

namespace ServerSide
{
    public class RocketLauncher
    {        
        private const int ROCKET_LAUNCH_X = 15;
        private const int ROCKET_LAUNCH_Y = GameConfig.FIELD_HEIGHT_PX - 30;

        private ArrayList _rockets = new ArrayList();
        private BallsManager _ballsManager;

        public RocketLauncher (BallsManager ballsManager)
        {
            _ballsManager = ballsManager;
        }

        public void instaLaunchRocket()
        {
            Rocket r = createRocket();
            r.go();
        }

        private Rocket createRocket()
        {
            Rocket rocket = new Rocket(ROCKET_LAUNCH_X, ROCKET_LAUNCH_Y, _ballsManager);
            rocket.Exploded += removeRocket;
            _rockets.Add(rocket);
            return rocket;
        }

        public void tick()
        {
            foreach (Rocket m in _rockets)
            {
                m.update();
            }
        }

        private void removeRocket(object sender, EventArgs args)
        {
            Rocket r = sender as Rocket;
            r.Exploded -= removeRocket;
            _rockets.Remove(r);
        }
    }
}
