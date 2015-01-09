using System;
using System.Collections;

namespace ServerSide
{
    internal class BallSplitter
    {
        private const int MINIMUM_ANGLE = 30;

        public static void splitBalls(FieldSimulation field, int targetBallCount)
        {
            var tempArr = new ArrayList(); //thus we wont be operating on target array

            foreach (Ball ball in field.ballsManager.balls) //copy balls
            {
                tempArr.Add(ball);
            }

            foreach (Ball ball in tempArr) //split em (new balls will be added to BaseField)
            {
                splitBall(ball, targetBallCount, field);
            }
        }

        private static void splitBall(Ball ball, int targetBallCount, FieldSimulation field)
        {
            int ballCopiesCount = targetBallCount - 1; //add more balls
            var resultBalls = new ArrayList {ball};
            if (ballCopiesCount > 0)
            {
                for (int i = 0; i < ballCopiesCount; i++)
                {
                    Ball ballCopy = getBallCopy(ball, field);
                    resultBalls.Add(ballCopy);
                }
            }

            double currentAngle = ball.getCurrentAngle();
            double newBallAngle = currentAngle%90;
            double leftover = newBallAngle - MINIMUM_ANGLE;
            double fraction = (leftover*2)/(targetBallCount + 1);

            for (int i = 0; i < resultBalls.Count; i++)
            {
                newBallAngle = currentAngle + leftover - (i + 1)*fraction;
                Console.WriteLine("newBallAngle: " + newBallAngle);

                (resultBalls[i] as Ball).setVector(newBallAngle);

                if (resultBalls[i] != ball) //add new balls to field
                {
                    field.ballsManager.balls.Add(resultBalls[i]);
                }
            }
        }

        private static Ball getBallCopy(Ball targetBall, FieldSimulation fs)
        {
            var copy = new Ball(fs);
            copy.x = targetBall.x;
            copy.y = targetBall.y;
            copy.stealthMode = targetBall.stealthMode;
            copy.dead = targetBall.dead;
            copy.setVector(targetBall.getCurrentAngle());
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