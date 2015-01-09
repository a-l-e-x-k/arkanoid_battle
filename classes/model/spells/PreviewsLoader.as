/**
 * Author: Alexey
 * Date: 8/26/12
 * Time: 4:56 PM
 */
package model.spells
{
import view.popups.myspells.preview.*;

import events.RequestEvent;

import playerio.PlayerIOError;

import model.userData.Spells;

import utils.EventHub;
import model.ServerTalker;

import networking.init.PlayerioInteractions;

public class PreviewsLoader
{
	/**
	 * Put here all model.requests triggered by mouseOver.
	 * Loading such request only once.
	 * If error will occur or anything -> loadNextItem will always be called again
	 */
	private static var requestedAlready:Array = [];

	public static function init():void
	{
		loadNextItem();
	}

	/**
	 * Fuck the query, load right now
	 * @param spellName
	 */
	public static function forceLoad(spellName:String):void
	{
		if (requestedAlready.indexOf(spellName) == -1) //if this preview was not requested before
		{
			trace("PreviewsLoader : forceLoad : Requesting preview: " + spellName);
			requestedAlready.push(spellName);
			loadSpellPreview(spellName);
		}
	}

	private static function loadNextItem():void
	{
		var allSpells:Array = Spells.getAll();
		for each (var spellName:String in allSpells)
		{
			if (!PreviewStorage.hasPreview(spellName))
			{
				loadSpellPreview(spellName);
				return;
			}
		}
		trace("PreviewsLoader : loadNextItem : All spells loaded!");
	}

	private static function loadSpellPreview(spellName:String):void
	{
		ServerTalker.client.bigDB.loadRange("Previews", "spellName", [spellName], 0, 1000, 1000, onPreviewLoaded, onError);
	}

	private static function onError(error:PlayerIOError):void
	{
		PlayerioInteractions.handlePlayerIOError(error);
		loadNextItem();
	}

	private static function onPreviewLoaded(dbarr:Array):void
	{
		if (dbarr.length > 0)
		{
			var prev:AnimatedPreview = new AnimatedPreview(dbarr);
			PreviewStorage.savePreview(prev);
			EventHub.dispatch(new RequestEvent(RequestEvent.SPELL_PREVIEW_LOADED, {spellName:prev.spellName}));
			trace("PreviewsLoader : onPreviewLoaded : " + prev.spellName);
		}
//		else
//			trace("Error. No requested preview exists...");

		loadNextItem();
	}
}
}
