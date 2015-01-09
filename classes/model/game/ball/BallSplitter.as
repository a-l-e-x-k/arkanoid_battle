/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 12:39 AM
 */
package model.game.ball
{
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import view.game.field.BaseField;

    public class BallSplitter
    {
        private static const MINIMUM_ANGLE:int = 30; //minimum angle at which ball may bounce off

        public static function splitBalls(field:BaseField, targetBallCount:int):void
        {
            var tempArr:Array = []; //thus we wont be operating on target array

            for each (var ball:BallModel in field.balls) //copy balls
            {
                tempArr.push(ball);
            }

            for each (ball in tempArr) //split em (new balls will be added to BaseField)
            {
                splitBall(ball, targetBallCount, field);
            }

            SoundAssetManager.playSound(SoundAsset.SPLIT);
        }

        private static function splitBall(ball:BallModel, targetBallCount:int, field:BaseField):void
        {
            var ballCopiesCount:int = targetBallCount - 1; //add more balls
            var resultBalls:Array = [ball];
            if (ballCopiesCount > 0)
            {
                for (var i:int = 0; i < ballCopiesCount; i++)
                {
                    var ballCopy:BallModel = getBallCopy(ball);
                    resultBalls.push(ballCopy);
                }
            }

            var currentAngle:Number = ball.getCurrentAngle();
            var newBallAngle:Number = currentAngle % 90;
            var leftover:Number = newBallAngle - MINIMUM_ANGLE;
            var fraction:Number = (leftover * 2) / (targetBallCount + 1);

            for (i = 0; i < resultBalls.length; i++)
            {
                newBallAngle = currentAngle + leftover - (i + 1) * fraction;
                trace("newBallAngle: " + newBallAngle % 90);

                resultBalls[i].setVector(newBallAngle);
                resultBalls[i].path.updateAngle(newBallAngle);

                if (resultBalls[i] != ball) //add new balls to field
                {
                    field.balls.push(resultBalls[i]);
                }
            }
        }

        private static function getBallCopy(targetBall:BallModel):BallModel
        {
            var copy:BallModel = new BallModel(targetBall.x, targetBall.y, targetBall.view.parent, targetBall.fieldLink);
            copy.stealthMode = targetBall.stealthMode;
            if (targetBall.stealthMode)
            {
                copy.path.alpha = 0.2;
            }
            copy.dead = targetBall.dead;
            copy.setVector(targetBall.getCurrentAngle());
            copy.path.setType(targetBall.path.type);
            copy.path.updateAngle(targetBall.getCurrentAngle());
            if (targetBall.wiggler.wiggling) //copy wiggling params
            {
                copy.goWiggle();
                copy.wiggler.currentShiftX = targetBall.wiggler.currentShiftX;
                copy.wiggler.currentShiftY = targetBall.wiggler.currentShiftY;
                copy.wiggler.currentPerpendicularAngle = targetBall.wiggler.currentPerpendicularAngle;
                copy.wiggler.currentStepNumber = targetBall.wiggler.currentStepNumber;
            }
            return copy;
        }
    }
}
