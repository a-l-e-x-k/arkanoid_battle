/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 2:18 AM
 */
package model.game.bricks
{
    import events.RequestEvent;
    import events.RequestEventStarling;

    import external.caurina.transitions.Tweener;

    import flash.events.EventDispatcher;

    import model.constants.GameConfig;
    import model.constants.Maps;

    import starling.display.Sprite;

    import utils.EventHub;
    import utils.Misc;

    import view.game.field.BaseField;
    import view.game.field.OpponentField;
    import view.game.field.cells.*;

    public class FieldCells extends EventDispatcher
    {
        public static var rowsCount:int = 0;
        public static var columnsCount:int = 0;

        private var _cells:Array = []; //array of rows, each row being array of cells
        private var _allCells:Array = []; //array of all cells

        private var _fieldLink:BaseField;
        private var _view:Sprite;
        private var _mapsProgram:MapsProgram;

        /**
         * Model class, which creates layer (Sprite) for cells and add cells there
         * @param mapsProgramData
         * @param fieldLink
         * @param parent
         */
        public function FieldCells(mapsProgramData:String, fieldLink:BaseField, parent:Sprite)
        {
            _mapsProgram = new MapsProgram(mapsProgramData);
            _fieldLink = fieldLink;
            _view = new Sprite();
            parent.addChild(_view);
            createGrid(_mapsProgram.getNextMapID());
        }

        private function onCellCleared(event:RequestEventStarling):void
        {
            trace("FieldCells: onCellCleared: ");
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_CLEARED_CELL, {x: event.stuff.x, y: event.stuff.y, fieldName: _fieldLink.name, cellType: event.stuff.brickType}));

            if (_fieldLink is OpponentField) //no need for player_cleared_field request. Will execute request from requestData of tick
            {
                return;
            }

            var cell:StarlingCell;
            for (var i:int = 0; i < rowsCount; i++)
            {
                for (var j:int = 0; j < columnsCount; j++)
                {
                    cell = _cells[i][j];
                    if (cell.notEmpty)
                    {
                        return;
                    }
                }
            }

            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_CLEARED_FIELD, {fieldName: _fieldLink.name}));
        }

        public function newMap():void
        {
            clearGrid();
            createGrid(_mapsProgram.getNextMapID());

            var cell:StarlingCell;
            for (var i:int = 0; i < rowsCount; i++)
            {
                for (var j:int = 0; j < columnsCount; j++)
                {
                    cell = _cells[i][j];
                    cell.alpha = 0;
                    Tweener.addTween(cell, {alpha: 1, time: (0.5 + (Misc.randomNumber(50) / 100)), transition: "easeOutSine"});
                }
            }
        }

        private function clearGrid():void
        {
            for (var i:int = 0; i < rowsCount; i++)
            {
                for (var j:int = 0; j < columnsCount; j++)
                {
                    (_cells[i][j] as StarlingCell).removeEventListener(RequestEventStarling.CELL_CLEARED, onCellCleared);
                    (_cells[i][j] as StarlingCell).removeFromParent(true);
                    delete _cells[i][j];
                }
            }
        }

        private function createGrid(mapID:int):void
        {
            rowsCount = GameConfig.FIELD_HEIGHT_PX / GameConfig.BRICK_HEIGHT;
            columnsCount = GameConfig.FIELD_WIDTH_PX / GameConfig.BRICK_WIDTH;

            _cells = [];
            //creating empty field
            for (var i:int = 0; i < rowsCount; i++)
            {
                _cells[i] = [];
                for (var j:int = 0; j < columnsCount; j++)
                {
                    var cell:StarlingCell = new StarlingCell(i, j);
                    cell.addEventListener(RequestEventStarling.CELL_CLEARED, onCellCleared);
                    _view.addChild(cell);
                    _cells[i][j] = cell;
                    _allCells.push(cell);
                }
            }

            //fill it with cells
            var presetData:Array = Maps.getMapCode(mapID).split("|");
            var cellI:int = 0;
            var cellJ:int = 0;
            var brickID:int = 0;
            for (i = 0; i < presetData.length; i++)
            {
                var cellData:Array = presetData[i].split(",");
                cellJ = int(cellData[0]);
                cellI = int(cellData[1]);
                brickID = int(cellData[2]);
                (_cells[cellI][cellJ] as StarlingCell).attachBrick(brickID);
            }
        }

        public function get cells():Array
        {
            return _cells;
        }

        public function get allCells():Array
        {
            return _allCells;
        }
    }
}
