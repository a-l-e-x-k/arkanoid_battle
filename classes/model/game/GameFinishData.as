/**
 * Author: Alexey
 * Date: 9/9/12
 * Time: 12:45 AM
 */
package model.game
{
import flash.utils.Dictionary;

import playerio.Message;

public class GameFinishData
{
	private var _players:Dictionary = new Dictionary();
    private var _coinsAdded:uint;
    private var _newRank:int;
    private var _newRankProgress:int;
    private var _newRankProtectionCount:int;

	public function GameFinishData(msg:Message)
	{
		var playerDatas:Array = msg.getString(0).split(",");
		var playerDataArr:Array;
		for each (var playerData:String in playerDatas)
		{
			playerDataArr = playerData.split(":");
			_players[playerDataArr[0]] = playerDataArr[1];
		}
        _coinsAdded = msg.getUInt(2);
        _newRank = msg.getUInt(3);
        _newRankProgress = msg.getUInt(4);
        _newRankProtectionCount = msg.getUInt(5);
	}

	public function get winner():String
	{
		var winnerID:String = "nobody";
		var maxScore:int = 0;
		for (var playerID:String in _players)
		{
			if (_players[playerID] > maxScore)
			{
				maxScore = _players[playerID];
				winnerID = playerID;
			}

            if (maxScore == _players[playerID] && winnerID != playerID)
            {
                winnerID = "nobody";
                break;
            }
		}
		return winnerID;
	}

	public function getPlayerPoints(playerID:String):int
	{
		return _players[playerID];
	}

    public function get coinsAdded():uint
    {
        return _coinsAdded;
    }

    public function get newRank():int
    {
        return _newRank;
    }

    public function get newRankProgress():int
    {
        return _newRankProgress;
    }

    public function get newRankProtectionCount():int
    {
        return _newRankProtectionCount;
    }
}
}
