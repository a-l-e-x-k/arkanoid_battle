/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/21/13
 * Time: 8:38 PM
 * To change this template use File | Settings | File Templates.
 */
package model.game.laser
{
    import model.constants.GameConfig;
    import model.game.bricks.FieldCells;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import starling.display.Sprite;

    import view.game.bouncer.Bouncer;
    import view.game.field.BaseField;
    import view.game.field.cells.StarlingCell;

    public class LaserShotsManager
    {
        private const BULLET_MOVE_STEP_SIZE:int = 10; //px
        private const BULLET_MOVE_STEPS_COUNT:int = 2; //have to make it in 2 steps (like ball movement. Otherwise can hit 2 bricks at one time)
        private const BULLETS_IN_SHOT:int = 5;
        private const BULLET_LAUNCH_INTERVAL:int = 6;
        private const BULLET_Y_SHIFT:int = 6; // px from bullet y to perceived y
        private const BULLET_START_X_SHIFT:Number = 9; // px from bullet y to perceived y

        private var _cellsLink:FieldCells;
        private var _fieldLink:BaseField;
        private var _bulletLayer:Sprite;
        private var _bouncerLink:Bouncer;
        private var _activeBullets:Array = [];
        private var _launchCounter:int = 0;
        private var _bulletsLaunched:int = 999; //so it won't launch at game start

        public function LaserShotsManager(cellsLink:FieldCells, bouncerLink:Bouncer, bulletLayer:Sprite, field:BaseField)
        {
            _cellsLink = cellsLink;
            _bulletLayer = bulletLayer;
            _bouncerLink = bouncerLink;
            _fieldLink = field;
        }

        public function shoot():void
        {
            _launchCounter = 0;
            _bulletsLaunched = 0;
            shootBullet(); //first one
        }

        private function shootBullet():void
        {
            SoundAssetManager.playSound(SoundAsset.LASER);
            var newBullet:LaserBullet = new LaserBullet(_bulletLayer);
            newBullet.upateCoordinates(_bouncerLink.x + (GameConfig.BOUNCER_WIDTH / 2) - BULLET_START_X_SHIFT, _bouncerLink.y);
            _activeBullets.push(newBullet);
            _bulletsLaunched++;
            _fieldLink.saveCriticalHit(_bouncerLink.x);
            trace("[Shoot laser bullet]: at: " + _fieldLink.ballsManager.currentTick + " #: " + _bulletsLaunched + " launch counter: " + _launchCounter + " x: " + newBullet.x + " y: " + newBullet.y);
        }

        public function tick():void
        {
            _launchCounter++;
            tryLaunchNewBullet();

            for (var j:int = 0; j < BULLET_MOVE_STEPS_COUNT; j++)
            {
                for each (var b:LaserBullet in _activeBullets)
                {
                    b.upateCoordinates(b.x, b.y - BULLET_MOVE_STEP_SIZE);
                    hitTestBulletWithCells(b);
                }

                for each (b in _activeBullets) //delete dead ones. Cant do it in one loop, it causes bugs (no good to delete items from collection which is being iterated over)
                {
                    if (b.dead)
                    {
                        trace("[Killing bullet] tick: " + _fieldLink.ballsManager.currentTick);
                        _activeBullets.splice(_activeBullets.indexOf(b), 1); //kill bullet
                    }
                }
            }
        }

        private function tryLaunchNewBullet():void
        {
            if (_bulletsLaunched < BULLETS_IN_SHOT && _launchCounter % BULLET_LAUNCH_INTERVAL == 0)
            {
                shootBullet();
            }
        }

        private function hitTestBulletWithCells(b:LaserBullet):void
        {
            if (b.y < -100) //went out of the screen
            {
                b.die();
                return;
            }

            var cells:Array = _cellsLink.cells;
            var cell:StarlingCell;
            var realBulletX:Number = b.x + GameConfig.LASER_BULLET_WIDTH / 2;
            var realBulletY:Number = b.y + BULLET_Y_SHIFT;
            for (var i:int = 0; i < FieldCells.rowsCount; i++)
            {
                for (var j:int = 0; j < FieldCells.columnsCount; j++)
                {
                    cell = cells[i][j];
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
