/**
 * Author: Alexey
 * Date: 10/14/12
 * Time: 1:01 AM
 */
package model.game.particlesAnimations
{
	import model.game.bricks.BrickPresets;
	import model.constants.GameConfig;
	import model.constants.PointsPrizes;

	import starling.core.Starling;

	import view.StarlingLayer;
	import view.game.field.BaseField;
	import view.game.curveAnimations.CurveAnimations;

	public class CurveAnimsShower
	{
		public static function showCellCleared(initiatorField:BaseField, affectedField:BaseField, cellX:int, cellY:int, cellType:int):void
		{
			var curveAnims:CurveAnimations = (Starling.current.root as StarlingLayer).curveAnimations;
			var fromX:int;
			var fromY:int;
			var targetX:int;
			var targetY:int;

			if (cellType == BrickPresets.FIRE_BRICK)
			{
				fromX = cellX + initiatorField.x;
				fromY = cellY + initiatorField.y;
				targetX = affectedField.x + 5;
				targetY = affectedField.y + GameConfig.FIELD_HEIGHT_PX - 50;
				curveAnims.showFireballAnim(fromX, fromY, targetX, targetY, affectedField);
				targetX = affectedField.x + GameConfig.FIELD_WIDTH_PX - 50;
				curveAnims.showFireballAnim(fromX, fromY, targetX, targetY);
			}

			fromX = cellX + initiatorField.x;
			fromY = cellY + initiatorField.y;
			targetX = initiatorField.playerInfo.x + 130 + initiatorField.x;
			targetY = initiatorField.playerInfo.y + 30 + initiatorField.y;
			curveAnims.showPointsAnim(fromX, fromY, targetX, targetY, PointsPrizes.CELL_CLEARED, initiatorField);
		}

		public static function showLostBall(targetField:BaseField, fromX:int, fromY:int):void
		{
			var curveAnims:CurveAnimations = (Starling.current.root as StarlingLayer).curveAnimations;
			var targetX:int = targetField.playerInfo.x + 130 + targetField.x;
			var targetY:int = targetField.playerInfo.y + 30 + targetField.y;
			curveAnims.showPointsAnim(fromX, fromY, targetX, targetY, PointsPrizes.LOST_BALL, targetField, 1.2);
		}
	}
}
