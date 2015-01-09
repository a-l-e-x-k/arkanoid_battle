/**
 * Author: Alexey
 * Date: 8/12/12
 * Time: 11:29 PM
 */
package {

public function traceme(params:Object, relation:String):void
{
	if (Config.TRACING_ALL
			|| (relation == Relations.OPPONENT_FIELD && Config.TRACING_OPPONENT)
			|| (relation == Relations.PLAYER_FIELD && Config.TRACING_PLAYER)
			|| (relation == Relations.LOADING && Config.TRACING_LOADING)
			|| (Config.TRACING_BALLS && relation == Relations.BALLS)
			|| (Config.TRACING_MESSAGES && relation == Relations.MESSAGES))
		trace(params);
}
}
