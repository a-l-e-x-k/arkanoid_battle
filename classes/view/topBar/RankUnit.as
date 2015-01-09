/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/24/12
 * Time: 1:18 AM
 * To change this template use File | Settings | File Templates.
 */
package view.topBar
{
    import flash.display.MovieClip;

    import model.constants.Ranks;

    import utils.Misc;
    import utils.MovieClipContainer;

    public class RankUnit extends MovieClipContainer
    {
        private var _currentRankPic:MovieClip;
        private var _nextRankPic:MovieClip;
        private var _rankProtection:RankProtectionView;

        public function RankUnit(rankNumber:int, rankProgress:int, rankProtectionCount:int)
        {
            super(new rankbar());

            var color:uint = Ranks.getColorByRank(rankNumber);
            var white:uint = 0xFFFFFF;
            var mcc:MovieClip;
            for (var i:int = 1; i < 6; i++)
            {
                mcc = _mc.mc["part" + i + "_mc"];
                mcc.alpha = rankProgress >= i ? 1 : 0;
                Misc.applyColorTransform(mcc.color_mc, rankProgress >= i ? color : white);
            }

            _currentRankPic = getRankPic(rankNumber);
            _currentRankPic.x = -1;
            _currentRankPic.y = 13.25;
            addChild(_currentRankPic);

            _nextRankPic = getRankPic(rankNumber + 1);
            _nextRankPic.x = 114;
            _nextRankPic.y = 13.25;
            addChild(_nextRankPic);

            _rankProtection = new RankProtectionView(rankProtectionCount);
            _rankProtection.x = 2;
            _rankProtection.y = -15;
            addChild(_rankProtection);
        }

        private static function getRankPic(rank:int):MovieClip
        {
            var rankPicMc:MovieClip;
            rankPicMc = new rankicon();
            Misc.applyColorTransform(rankPicMc.mc.color_mc, Ranks.getColorByRank(rank));
            setRankText(rankPicMc, rank);
            return rankPicMc;
        }

        public static function setRankText(rankPic:MovieClip, rank:int):void
        {
            if (rank < 101)
            {
                rankPic.mc.t_txt.text = rank;
            }
            else
            {
                rankPic.mc.t_txt.visible = false;
                rankPic.mc.max_mc.alpha = 1;
            }
        }

        public function get currentRankPic():MovieClip
        {
            return _currentRankPic;
        }

        public function get nextRankPic():MovieClip
        {
            return _nextRankPic;
        }

        public function get rankProtection():RankProtectionView
        {
            return _rankProtection;
        }
    }
}
