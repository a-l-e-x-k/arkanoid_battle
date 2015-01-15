/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/25/12
 * Time: 10:12 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.finishGame
{
    import events.RequestEvent;

    import caurina.transitions.Tweener;
    import caurina.transitions.properties.ColorShortcuts;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;

    import model.constants.Ranks;

    import utils.EventHub;
    import utils.Misc;

    import view.topBar.RankUnit;

    public class AnimatedRankUnit extends Sprite
    {
        private const PROGRESS_TWEEN_TIME:Number = 1;
        private const RANK_SPIN_TIME:Number = 3;

        public function AnimatedRankUnit(prevRank:int, prevRankProgress:int, newRank:int, newRankProgress:int, prevRankProtectionCount:int, newRankProtectionCount:int)
        {
            ColorShortcuts.init(); //for color tween

            var ru:RankUnit = new RankUnit(prevRank, prevRankProgress, prevRankProtectionCount);
            ru.x = 380;
            ru.y = 263;
            addChild(ru);

            var rankUp:Boolean = newRank > prevRank || (newRank >= prevRank && newRankProgress > prevRankProgress); //if player gained rank points spin clockwise. Otherwise counterclockwise

            if(!rankUp) //rank down :)
            {
                ru.rankProtection.updateTo(newRankProtectionCount);
            }

            if (prevRank == newRank)
            {
                showProgressAnimation(ru, prevRankProgress, newRankProgress, newRank, prevRank);
            }
            else
            {
                animateRankIcon(ru.currentRankPic, newRank, rankUp);
                animateRankIcon(ru.nextRankPic, newRank + 1, rankUp);
                showProgressAnimation(ru, prevRankProgress, newRankProgress, newRank, prevRank);
            }
        }

        private function animateRankIcon(currentRankPic:MovieClip, targetRank:int, rankUp:Boolean):void
        {
            var blurFil:BlurFilter = new BlurFilter(0, 0, 3);
            currentRankPic.mc.t_txt.filters = [blurFil];
            currentRankPic.mc.color_mc.filters = [blurFil];

            Tweener.addTween(currentRankPic.mc.color_mc, {_color: Ranks.getColorByRank(targetRank), time: RANK_SPIN_TIME, transition: "easeOutSine"});
            Tweener.addTween(currentRankPic, {rotation: rankUp ? 1800 : -1800, time: RANK_SPIN_TIME, transition: "easeOutSine"}); //5 revolutions

            Tweener.addTween(blurFil, {blurX: 8, blurY: 8, time: RANK_SPIN_TIME / 2,
                onUpdate: function ():void
                {
                    currentRankPic.mc.t_txt.filters = [blurFil];
                },
                onComplete: function ():void //fade in blur
                {
                    RankUnit.setRankText(currentRankPic, targetRank);
                    Tweener.addTween(blurFil, {blurX: 0, blurY: 0, time: RANK_SPIN_TIME / 2,
                        onUpdate: function ():void
                        {
                            currentRankPic.mc.max_mc.filters = [blurFil];
                            currentRankPic.mc.t_txt.filters = [blurFil];
                        },
                        onComplete: function ():void
                        {
                            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED)); //update rank at top bar
                        }}); //fade out blur
                }});
        }

        private function showProgressAnimation(ru:RankUnit, prevProgress:int, newRankProgress:int, currentRank:int, prevRank:int):void
        {
            var idsToColorise:Array = [];
            var idsToDecolorise:Array = [];
            var stepMC:MovieClip;
            var color:uint = Ranks.getColorByRank(currentRank);

            if (newRankProgress > prevProgress) //colorise
            {
                for (var i:int = prevProgress + 1; i <= newRankProgress; i++)
                {
                    idsToColorise.push(i);
                }
            }
            else //decolorise or colorise ranking up
            {
                if (currentRank > prevRank) //rank up
                {
                    for (var r:int = 1; r < 6; r++) //hide all (so that colorising anim for new rank will start from scratch)
                    {
                        ru.mc.mc["part" + r + "_mc"].alpha = 0;
                    }

                    for (var l:int = 1; l <= newRankProgress; l++)
                    {
                        idsToColorise.push(l);
                    }
                }
                else if (currentRank < prevRank)
                {
                    for (var w:int = 1; w < 6; w++) //make all steps of new rank color
                    {
                        stepMC = ru.mc.mc["part" + w + "_mc"];
                        stepMC.alpha = 1;
                        Misc.applyColorTransform(stepMC.color_mc, color);
                    }

                    for (var v:int = 5; v > newRankProgress; v--)
                    {
                        idsToDecolorise.push(v);
                    }
                }
                else //decrease within a rank
                {
                    for (var j:int = prevProgress; j > newRankProgress; j--)
                    {
                        idsToDecolorise.push(j);
                    }
                }
            }

            for (var k:int = 0; k < idsToColorise.length; k++)
            {
                stepMC = ru.mc.mc["part" + idsToColorise[k] + "_mc"];
                stepMC.alpha = 0;
                Misc.applyColorTransform(stepMC.color_mc, color);
                Tweener.addTween(stepMC, {alpha: 1, time: PROGRESS_TWEEN_TIME, delay: (k + 1), transition: "easeOutQuart"});
            }

            for (w = 0; w < idsToDecolorise.length; w++)
            {
                stepMC = ru.mc.mc["part" + idsToDecolorise[w] + "_mc"];
                stepMC.alpha = 1;
                Misc.applyColorTransform(stepMC.color_mc, color);
                Tweener.addTween(stepMC, {alpha: 0, time: PROGRESS_TWEEN_TIME, delay: (w + 1), transition: "easeOutQuart"});
            }

            Misc.delayCallback(function ():void
            {
                EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED)); //update progress at top bar
            }, PROGRESS_TWEEN_TIME);
        }
    }
}
