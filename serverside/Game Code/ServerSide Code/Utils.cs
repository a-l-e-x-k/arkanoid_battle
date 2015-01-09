using System;

namespace ServerSide
{
    public class Utils
    {
        public static double ceilWithPrecision(double input, int numOfDigits)
        {
            return Math.Ceiling(input*Math.Pow(10, numOfDigits))/Math.Pow(10, numOfDigits);
        }

        public static double floorWithPrecision(double input, int numOfDigits)
        {
            return Math.Floor(input*Math.Pow(10, numOfDigits))/Math.Pow(10, numOfDigits);
        }

        public static double radians(double degrees)
        {
            return degrees*Math.PI/180;
        }

        public static double degrees(double radians)
        {
            return radians*180/Math.PI;
        }

        public static double unixSecs()
        {
            return Math.Floor((DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds);
        }
    }

    public class Point
    {
        public double x;
        public double y;

        public Point(double xx = 0, double yy = 0)
        {
            x = xx;
            y = yy;
        }
    }
}