namespace ServerSide
{
    public class FastSprintGame : TimeLimitedGame
    {
        public FastSprintGame(string type, string mapID, BasicRoom room) : base(type, mapID, room, 60)
        {
        }
    }
}