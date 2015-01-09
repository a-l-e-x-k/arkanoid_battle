/**
 * Author: Alexey
 * Date: 8/25/12
 * Time: 4:36 PM
 */
package view.popups.myspells.preview
{
import events.RequestEvent;

import external.caurina.transitions.Tweener;

import model.spells.PreviewStorage;
import model.spells.PreviewsLoader;
	import model.userData.Spells;

	import view.loading.CircleLoadingAnimation;
import utils.EventHub;
import utils.MovieClipContainer;

public class SpellsPreview extends MovieClipContainer
{
	private var _loadingAnimation:CircleLoadingAnimation = new CircleLoadingAnimation();
	private var _currentPreview:AnimatedPreview;
	private var _currentSpellName:String;

	public function SpellsPreview()
	{
		super(new previewWindow(), 515, 75);

		_loadingAnimation.x = 76;
		_loadingAnimation.y = 105;
		_mc.field_mc.addChild(_loadingAnimation);
		showLoading();

		EventHub.addEventListener(RequestEvent.SPELL_PREVIEW_LOADED, onSpellPreviewLoaded);
	}

	private function onSpellPreviewLoaded(event:RequestEvent):void
	{
		if (event.stuff.spellName == _currentSpellName)
		{
			updatePreview();
		}
	}

	public function showPreview(spellName:String):void
	{
		_currentSpellName = spellName;

		if (PreviewStorage.hasPreview(spellName))
			updatePreview();
		else
		{
			showLoading();
			PreviewsLoader.forceLoad(spellName);
		}
	}

	private function updatePreview():void
	{
		var newPreview:AnimatedPreview = PreviewStorage.getPreview(_currentSpellName);
		if (newPreview != _currentPreview)
		{
			tryRemovePreview(_currentPreview);
			_currentPreview = newPreview;
			_currentPreview.reset();
		}

		_mc.oppf_mc.alpha = (_currentSpellName == Spells.CHARM_BALLS || _currentSpellName == Spells.FREEZE) ? 0.8 : 0;

		if (!_mc.field_mc.contains(_currentPreview))
			_mc.field_mc.addChild(_currentPreview);

		if (newPreview.alpha < 1)
			Tweener.addTween(newPreview, {alpha:1, time:0.5, delay:0.1, transition:"easeOutSine"});

		if (_loadingAnimation.alpha > 0)
			Tweener.addTween(_loadingAnimation, {alpha:0, time:0.5, transition:"easeOutSine"});
	}

	private function showLoading():void
	{
		tryRemovePreview(_currentPreview);
		Tweener.addTween(_loadingAnimation, {alpha:1, time:0.5, transition:"easeOutSine"});
	}

	private function tryRemovePreview(preview:AnimatedPreview):void
	{
		if (preview && _mc.field_mc.contains(preview))
		{
			Tweener.addTween(preview, {alpha:0, time:0.5, transition:"easeOutSine", onComplete:function():void
			{
				_mc.field_mc.removeChild(preview);
			}})
		}
	}
}
}
