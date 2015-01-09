using System;

namespace ServerSide
{
    internal class Tracer
    {
        private const bool TRACING_ALL = false;
        private const bool TRACING_PLAYER = true;
        private const bool TRACING_OPPONENT = true;
        private const bool TRACING_BALLS = false;
        private const bool TRACING_MISC = true;

        public static void t(string str, string relation)
        {
            if (TRACING_ALL
                || (TRACING_PLAYER && relation == Relations.PLAYER_FIELD)
                || (TRACING_OPPONENT && relation == Relations.NPC_FIELD)
                || (TRACING_BALLS && relation == Relations.BALLS)
                || (TRACING_MISC && relation == Relations.MISC_EVENTS))

                Console.WriteLine(str);
        }
    }
}