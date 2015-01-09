/**
 * Author: Alexey
 * Date: 12/12/12
 * Time: 7:28 PM
 */
package view.lobby.gameSelect.scroller
{
    import events.RequestEvent;

    import external.caurina.transitions.Tweener;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import model.PopupsManager;
    import model.constants.GameTypes;

    import utils.EventHub;

    public class ItemsScroller extends Sprite
    {
        private const TRANSITION_LENGTH:Number = 0.4;
        private const FULL_SIZE:int = 150;
        private const TINY_SIZE:int = 50;
        private const LEFT_POSITION:Point = new Point(10, 75);
        private const MIDDLE_POSITION:Point = new Point(140, 75);
        private const RIGHT_POSITION:Point = new Point(270, 75);
        private const LEFT_TASK:int = 1;
        private const RIGHT_TASK:int = 2;

        private var _currentItem:GameSelectItem;
        private var _items:Vector.<GameSelectItem> = new <GameSelectItem>[];
        private var _tweenFinished:Boolean = true;
        private var _queue:Array = [];

        public function ItemsScroller()
        {
            var itemsTypes:Array = [GameTypes.BIG_BATTLE, GameTypes.FAST_SPRINT, GameTypes.FAST_SPRINT_PRIVATE, GameTypes.FIRST_100, GameTypes.UPSIDE_DOWN];
            var item:GameSelectItem;
            for (var i:int = 0; i < itemsTypes.length; i++)
            {
                item = new GameSelectItem(itemsTypes[i], i);
                item.buttonMode = true;
                item.addEventListener(MouseEvent.CLICK, onItemClicked);
                _items.push(item);
                if (i == 0)
                {
                    setItemPosition(item, LEFT_POSITION);
                    item.width = item.height = TINY_SIZE;
                }
                else if (i == 1)
                {
                    _currentItem = item;
                    setItemPosition(item, MIDDLE_POSITION);
                }
                else if (i == 2)
                {
                    setItemPosition(item, RIGHT_POSITION);
                    item.width = item.height = TINY_SIZE;
                }
                else
                {
                    item.width = item.height = item.alpha = 0;
                    item.mouseEnabled = false;
                }
                addChild(item);
            }
        }

        private function onItemClicked(event:MouseEvent):void
        {
            var clicked:GameSelectItem = event.currentTarget as GameSelectItem;

            if (clicked == _currentItem)
            {
                if (clicked.isPrivateSprint)
                {
                    PopupsManager.showEnterOpponentNicknamePopup();
                }
                else
                {
                    EventHub.dispatch(new RequestEvent(RequestEvent.GO_BATTLE, {type: _currentItem.gameType}));
                }
            }
            else if (clicked == getItemFromLeft(_currentItem))
            {
                addLeftTask();
            }
            else if (clicked == getItemFromRight(_currentItem))
            {
                addRightTask();
            }
        }

        private static function setItemPosition(item:GameSelectItem, pos:Point):void
        {
            item.x = pos.x;
            item.y = pos.y;
        }

        public function addRightTask():void
        {
            _queue.push(RIGHT_TASK);
            checkQueue();
        }

        public function addLeftTask():void
        {
            _queue.push(LEFT_TASK);
            checkQueue();
        }

        private function checkQueue():void
        {
            if (_queue.length > 0 && _tweenFinished)
            {
                if (_queue[0] == LEFT_TASK)
                {
                    goLeft();
                }
                else if (_queue[0] == RIGHT_TASK)
                {
                    goRight();
                }

                _queue.shift();
            }
        }

        private function goRight():void
        {
            var nextMiddleItem:GameSelectItem = getItemFromRight(_currentItem);
            var nextRightItem:GameSelectItem = getItemFromRight(nextMiddleItem);
            var nextLeftItem:GameSelectItem = _currentItem;
            var currentLeftItem:GameSelectItem = getItemFromLeft(_currentItem);

            setItemPosition(nextRightItem, RIGHT_POSITION);
            tweenVisible(nextRightItem);

            tweenToCenter(nextMiddleItem);
            tweenScaleUp(nextMiddleItem);
            _currentItem = nextMiddleItem;

            tweenScaleDown(nextLeftItem);
            tweenToLeft(nextLeftItem);

            tweenToInvisible(currentLeftItem);

            _tweenFinished = false;

            setChildIndex(nextRightItem, 0);
            setChildIndex(currentLeftItem, 1);
            setChildIndex(nextMiddleItem, 2);
            setChildIndex(_currentItem, 3);
        }

        private function goLeft():void
        {
            var nextMiddleItem:GameSelectItem = getItemFromLeft(_currentItem);
            var nextLeftItem:GameSelectItem = getItemFromLeft(nextMiddleItem);
            var nextRightItem:GameSelectItem = _currentItem;
            var currentRightItem:GameSelectItem = getItemFromRight(_currentItem);

            tweenVisible(nextLeftItem);
            setItemPosition(nextLeftItem, LEFT_POSITION);

            tweenToCenter(nextMiddleItem);
            tweenScaleUp(nextMiddleItem);
            _currentItem = nextMiddleItem;

            tweenScaleDown(nextRightItem);
            tweenToRight(nextRightItem);

            tweenToInvisible(currentRightItem);

            _tweenFinished = false;

            setChildIndex(nextLeftItem, 0);
            setChildIndex(currentRightItem, 1);
            setChildIndex(nextMiddleItem, 2);
            setChildIndex(nextRightItem, 3);
        }

        private function tweenVisible(i:GameSelectItem):void
        {
            Tweener.addTween(i, {alpha: 1, width: TINY_SIZE, height: TINY_SIZE, time: TRANSITION_LENGTH, transition: "easeOutSine"});
            i.mouseEnabled = true;
        }

        private function tweenToInvisible(i:GameSelectItem):void
        {
            Tweener.addTween(i, {alpha: 0, width: 0, height: 0, time: TRANSITION_LENGTH, transition: "easeOutSine"});
            i.mouseEnabled = false;
        }

        private function tweenScaleUp(i:GameSelectItem):void
        {
            Tweener.addTween(i, {width: FULL_SIZE, height: FULL_SIZE, time: TRANSITION_LENGTH, transition: "easeOutSine"});
        }

        private function tweenScaleDown(i:GameSelectItem):void
        {
            Tweener.addTween(i, {width: TINY_SIZE, height: TINY_SIZE, time: TRANSITION_LENGTH, transition: "easeOutSine"});
        }

        private function tweenToLeft(i:GameSelectItem):void
        {
            Tweener.addTween(i, {x: LEFT_POSITION.x, y: LEFT_POSITION.y, time: TRANSITION_LENGTH, transition: "easeOutSine"});
        }

        private function tweenToRight(i:GameSelectItem):void
        {
            Tweener.addTween(i, {x: RIGHT_POSITION.x, y: RIGHT_POSITION.y, time: TRANSITION_LENGTH, transition: "easeOutSine"});
        }

        private function tweenToCenter(i:GameSelectItem):void
        {
            Tweener.addTween(i, {x: MIDDLE_POSITION.x, y: MIDDLE_POSITION.y, time: TRANSITION_LENGTH, transition: "easeOutSine", onComplete: onTweenFinished});
        }

        private function onTweenFinished():void
        {
            _tweenFinished = true;
            checkQueue();
        }

        private function getItemFromLeft(item:GameSelectItem):GameSelectItem
        {
            return item.index == 0 ? _items[_items.length - 1] : _items[item.index - 1];
        }

        private function getItemFromRight(item:GameSelectItem):GameSelectItem
        {
            return item.index == _items.length - 1 ? _items[0] : _items[item.index + 1];
        }

        public function get currentGameType():String
        {
            return _currentItem.gameType;
        }

        public function clean():void
        {
            for (var i:int = 0; i < _items.length; i++)
            {
                _items[i].clean();
            }
        }
    }
}
