namespace ServerSide
{
    public class BigBattleGame : TimeLimitedGame
    {
        public BigBattleGame(string type, string mapID, BasicRoom room)
            : base(type, mapID, room, 180)
        {
        }
    }
}