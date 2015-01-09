using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class VersionManager
    {
        private readonly BasicRoom _roomLink;

        public VersionManager(BasicRoom roomLink)
        {
            _roomLink = roomLink;
            _roomLink.AddTimer(checkVersion, 10000); //check version every 10 seconds
            checkVersion();
        }

        public void checkVersion()
        {
            _roomLink.PlayerIO.BigDB.Load("Misc", "version",
                delegate(DatabaseObject dbo)
                {
                    if (dbo.GetInt("v") != GameConfig.GAME_VERSION)
                    {
                        foreach (Player pl in _roomLink.Players)
                        {
                            if (!(pl is NPCPlayer))
                                //clients will show the popup whenever user wont be playing (cant do it during battle)
                            {
                                pl.sendMessage(MessageTypes.GAME_UPDATED);
                            }
                        }
                    }
                }, _roomLink.handleError);
        }
    }
}