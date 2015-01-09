/**
 * Author: Alexey
 * Date: 8/18/12
 * Time: 2:39 AM
 */
package model.game.gameStart
{
import playerio.Message;

public class GameStartData
{
	private var _mapsProgramData:String; //list of map ids
	private var _oppIDs:String;
	private var _oppPanelConfigurations:Object;
	private var _opponentBouncerIDs:String;
	private var _gameType:String;
	private var _currentSpeed:int;
	private var _testBallNumber:int;
	private var _gameLength:int; //secs
	private var _energyConsumed:int;
	private var _nextEnergyUpdate:Number;

	public function GameStartData(message:Message)
	{
		_mapsProgramData = message.getString(0);
		_oppIDs = message.getString(1);
		_oppPanelConfigurations = JSON.parse(message.getString(2));
		for (var spellName:String in _oppPanelConfigurations)
		{
			_oppPanelConfigurations[spellName] = int(_oppPanelConfigurations[spellName]);
		}
        _opponentBouncerIDs = message.getString(3);
		_gameType = message.getString(4);
		_currentSpeed = message.getInt(5);
		_testBallNumber = message.getInt(6);
		_gameLength = message.getInt(7);
        _energyConsumed = message.getInt(8);
        _nextEnergyUpdate = message.getNumber(9);
	}

	public function get mapsProgramData():String
	{
		return _mapsProgramData;
	}

	public function get oppIDs():String
	{
		return _oppIDs;
	}

	public function get gameType():String
	{
		return _gameType;
	}

	public function get currentSpeed():int
	{
		return _currentSpeed;
	}

	public function get testBallNumber():int
	{
		return _testBallNumber;
	}

	public function get oppPanelConfigurations():Object
	{
		return _oppPanelConfigurations;
	}

	public function get gameLength():int
	{
		return _gameLength;
	}

    public function get energyConsumed():int
    {
        return _energyConsumed;
    }

    public function get nextEnergyUpdate():Number
    {
        return _nextEnergyUpdate;
    }

    public function get opponentBouncerIDs():String
    {
        return _opponentBouncerIDs;
    }
}
}
