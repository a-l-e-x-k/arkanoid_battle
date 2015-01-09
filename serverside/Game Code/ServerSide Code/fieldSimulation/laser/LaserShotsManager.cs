using System;
using System.Collections;

namespace ServerSide
{
    public class LaserShotsManager
    {
        private const int BULLET_MOVE_STEP_SIZE = 10; //px

        private const int BULLET_MOVE_STEPS_COUNT = 2;
            //have to make it in 2 steps (like ball movement. Otherwise can hit 2 bricks at one time)

        private const int BULLETS_IN_SHOT = 5;
        private const int BULLET_LAUNCH_INTERVAL = 6; //amount of game ticks
        private const int BULLET_Y_SHIFT = 6;
        private const int BULLET_START_X_SHIFT = 9;
        private readonly ArrayList _activeBullets = new ArrayList();
        private readonly Bouncer _bouncerLink;

        private readonly FieldCells _cellsLink;
        private readonly FieldSimulation _fieldLink;
        private int _bulletsLaunched = 999; //so it won't launch at game start
        private int _launchCounter;

        public LaserShotsManager(FieldCells cellsLink, Bouncer bouncerLink, FieldSimulation sim)
        {
            _cellsLink = cellsLink;
            _bouncerLink = bouncerLink;
            _fieldLink = sim;
        }

        public void shoot()
        {
            _launchCounter = 0;
            _bulletsLaunched = 0;
            shootBullet(); //first one
        }

        private void shootBullet()
        {
            var newBullet = new LaserBullet();
            newBullet.upateCoordinates(_bouncerLink.x + (GameConfig.BOUNCER_WIDTH/2) - BULLET_START_X_SHIFT,
                _bouncerLink.y);
            _activeBullets.Add(newBullet);
            _bulletsLaunched++;

            Console.WriteLine("[Shoot laser bullet]: at: " + _fieldLink.ballsManager.currentTick + " #: " +
                              _bulletsLaunched + " launch counter: " + _launchCounter + " x: " + newBullet.x + " y: " +
                              newBullet.y);
        }

        public void tick()
        {
            _launchCounter++;
            tryLaunchNewBullet();

            for (int j = 0; j < BULLET_MOVE_STEPS_COUNT; j++)
            {
                foreach (LaserBullet b in _activeBullets)
                {
                    b.upateCoordinates(b.x, b.y - BULLET_MOVE_STEP_SIZE);
                    hitTestBulletWithCells(b);
                }

                LaserBullet bu;
                for (int i = 0; i < _activeBullets.Count; i++)
                {
                    bu = _activeBullets[i] as LaserBullet;
                    if (bu.dead)
                    {
                        Console.WriteLine("[Killing bullet] tick: " + _fieldLink.ballsManager.currentTick);
                        _activeBullets.RemoveAt(i); //kill bullet
                    }
                }
            }
        }

        private void tryLaunchNewBullet()
        {
            if (_bulletsLaunched < BULLETS_IN_SHOT && _launchCounter%BULLET_LAUNCH_INTERVAL == 0)
            {
                shootBullet();
            }
        }

        private void hitTestBulletWithCells(LaserBullet b)
        {
            if (b.y < -100) //went out of the screen
            {
                b.die();
                return;
            }

            Cell[,] cells = _cellsLink.cells;
            Cell cell;
            double realBulletX = b.x + GameConfig.LASER_BULLET_WIDTH/2;
            double realBulletY = b.y + BULLET_Y_SHIFT;

            for (int i = 0; i < _cellsLink.rowsCount; i++)
            {
                for (int j = 0; j < _cellsLink.columnsCount; j++)
                {
                    cell = cells[i, j];
                    if (cell.notEmpty)
                    {
                        if ((realBulletX >= cell.x && realBulletX <= (cell.x + GameConfig.BRICK_WIDTH)) &&
                            (cell.y + GameConfig.BRICK_HEIGHT >= realBulletY && cell.y <= realBulletY)) //hit a cell
                        {
                            b.die();
                            cell.clearBrick(_fieldLink.ballsManager.currentTick);
                            break;
                        }
                    }
                }
            }
        }
    }
}