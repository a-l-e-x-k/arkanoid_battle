/**
 * Author: Alexey
 * Date: 8/19/12
 * Time: 9:34 PM
 */
package model.spells
{
import view.popups.myspells.*;

import flash.utils.Dictionary;

public class ItemsRearranger
{
	public static function tryRearrangeItems(selectedPlaceID:int, items:Dictionary, itemBeingDragged:SpellItem, places:Array):void
	{
		var freeSlotID:int = -1;

		trace("ItemsRearranger : tryRearrangeItems : " + itemBeingDragged.spellName + " " + selectedPlaceID);

		if (selectedPlaceID > 1) //check items on the left
		{
			freeSlotID = tryGetFreeSlotOnLeft(selectedPlaceID, items, itemBeingDragged);

			if (freeSlotID != -1)
				moveItemsToTheLeft(freeSlotID, items, places, itemBeingDragged, selectedPlaceID);
		}

		if (freeSlotID == -1 && selectedPlaceID < 6) //if free slot on the left was not found and this is not the rightmost item
		{
			freeSlotID = tryGetFreeSlotOnRight(selectedPlaceID, items, itemBeingDragged);

			if (freeSlotID != -1)
				moveItemsToTheRight(freeSlotID, items, places, itemBeingDragged, selectedPlaceID);
		}
	}

	private static function tryGetFreeSlotOnRight(selectedPlaceID:int, items:Dictionary, itemBeingDragged:SpellItem):int
	{
		var currentSlotID:int = selectedPlaceID;
		var slotFree:Boolean = false;
		do
		{
			slotFree = true;
			currentSlotID++;

			for each (var spellItem:SpellItem in items)
			{
				if (spellItem.spellPlace.id == currentSlotID && spellItem != itemBeingDragged)
				{
					slotFree = false;
					break;
				}
			}

			if (slotFree)
				break;
		}
		while (currentSlotID < 5);

		if (slotFree)
			return currentSlotID;

		return -1;
	}

	private static function tryGetFreeSlotOnLeft(selectedPlaceID:int, items:Dictionary, itemBeingDragged:SpellItem):int
	{
		var currentSlotID:int = selectedPlaceID;
		var slotFree:Boolean = false;
		do
		{
			slotFree = true;
			currentSlotID--;

			for each (var spellItem:SpellItem in items)
			{
				if (spellItem.spellPlace.id == currentSlotID && spellItem != itemBeingDragged)
				{
					slotFree = false;
					break;
				}
			}

			if (slotFree)
				break;
		}
		while (currentSlotID > 1);

		if (slotFree)
			return currentSlotID;

		return -1;
	}

	private static function moveItemsToTheRight(freeSlotID:int, items:Dictionary, places:Array, itemBeingDragged:SpellItem, selectedPlaceID:int):void
	{
		var targetSlotID:int;
		for each (var spellItem:SpellItem in items)
		{
			if (spellItem.spellPlace.id < freeSlotID && spellItem.spellPlace.id >= selectedPlaceID && spellItem != itemBeingDragged)
			{
				targetSlotID = spellItem.spellPlace.id + 1; //shift to the right
				spellItem.attachToSkillPlace(places[targetSlotID]);
			}
		}
		itemBeingDragged.attachToSkillPlace(places[selectedPlaceID]);
	}

	private static function moveItemsToTheLeft(freeSlotID:int, items:Dictionary, places:Array, itemBeingDragged:SpellItem, selectedPlaceID:int):void
	{
		var targetSlotID:int;
		for each (var spellItem:SpellItem in items)
		{
			if (spellItem.spellPlace.id > freeSlotID && spellItem.spellPlace.id <= selectedPlaceID && spellItem != itemBeingDragged)
			{
				targetSlotID = spellItem.spellPlace.id - 1; //shift to the left
				spellItem.attachToSkillPlace(places[targetSlotID]);
			}
		}
        itemBeingDragged.attachToSkillPlace(places[selectedPlaceID]);
	}
}
}
