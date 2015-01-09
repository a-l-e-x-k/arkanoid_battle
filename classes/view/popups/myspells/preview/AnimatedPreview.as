/**
 * Author: Alexey
 * Date: 8/25/12
 * Time: 4:42 PM
 */
package view.popups.myspells.preview
{
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    import model.timer.GlobalTimer;

    import utils.animations.AnimClip;

    public class AnimatedPreview extends MovieClip
    {
        private const WIDTH:int = 166;
        private const HEIGHT:int = 220;

        public var spellName:String = "";
        private var _mc:AnimClip = new AnimClip();
        private var _loads:Array = []; //solves issue with not resizing previews in PepperFlash player (weirldy resizing only 1 loader (which triggered event) is not enough)

        public function AnimatedPreview(parts:Array)
        {
            var picRect:Rectangle;
            var currentPreviewFrame:int = 1;

            for each (var part:Object in parts) //preview is splitten in objects of max size of ~400kb
            {
                spellName = part.spellName; //yeah, name / width / height properties are duplicated in each "part object". What a pity.
                for each (var byteArray:ByteArray in part.frames) //"frames" array contains byteArrays each of which is a frame
                {
                    picRect = new Rectangle(0, 0, part.areaWidth, part.areaHeight);
                    var load:Loader = new Loader();
                    load.contentLoaderInfo.addEventListener(Event.COMPLETE, res);
                    load.loadBytes(byteArray);
                    _mc.goto(currentPreviewFrame);
                    _mc.addChild(load);
                    _loads.push(load);
                    currentPreviewFrame++;
                }
            }
            _mc.addLoop(_mc.getFramesCount(), 1);
            _mc.goto(1);
            _mc.stop();
            addChild(_mc);

            alpha = 0; //when loaded first time there will be an alpha-tween
            GlobalTimer.addEventListener(TimerEvent.TIMER, gotoNextFrame);
        }

        /**
         * Preview is recorded at 30FPS, game's FPS is 60. => slow down by using game timer
         */
        private function gotoNextFrame(event:TimerEvent):void
        {
            _mc.tick();
        }

        public function reset():void
        {
            _mc.goto(1);
        }

        public function res(e:Event = null):void
        {
            for each (var loader:Loader in _loads)
            {
                loader.width = WIDTH;
                loader.height = HEIGHT;
            }
        }
    }
}
