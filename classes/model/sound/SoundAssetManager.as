package model.sound
{
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    import model.ServerTalker;

    import model.constants.GameConfig;
    import model.userData.UserData;

    import utils.Misc;

    /**
     * ...
     * @author Alexey Kuznetsov
     */
    public final class SoundAssetManager
    {
        public static const SOUND_FOLDER:String = "http://cdn.playerio.com/" + GameConfig.GAME_ID + "/sounds/";
        public static const MUSIC_FOLDER:String = "http://cdn.playerio.com/" + GameConfig.GAME_ID + "/music/";
        public static var sounds:Dictionary = new Dictionary();
        public static var soundChannel:SoundChannel;

        public static function init():void
        {
            trace("SoundAssetManager: init: sounds: " + UserData.soundsOn + " music: " + UserData.musicOn);

            if (UserData.soundsOn)
            {
                loadSoundsForGame();
            }

            if (UserData.musicOn)
            {
                loadMusicForGame();
            }
        }

        public static function setMusicOn():void
        {
            trace("SoundAssetManager: setMusicOn: ");
            UserData.musicOn = true;
            ServerTalker.turnMusicOnoff(true);
            playBackgroundMusic();
        }

        public static function setMusicOff():void
        {
            trace("SoundAssetManager: setMusicOff: ");

            UserData.musicOn = false;
            ServerTalker.turnMusicOnoff(false);
            if (soundChannel != null)
            {
                soundChannel.stop();
            }
        }

        public static function setSoundsOn():void
        {
            trace("SoundAssetManager: setSoundsOn: ");

            UserData.soundsOn = true;
            ServerTalker.turnSoundsOnoff(true);
            if (sounds[SoundAsset.BOUNCER_HIT] == null) //sounds were not loaded yet
            {
                loadSoundsForGame();
            }
        }

        public static function setSoundsOff():void
        {
            trace("SoundAssetManager: setSoundsOff: ");
            UserData.soundsOn = false;
            ServerTalker.turnSoundsOnoff(false);
        }

        public static function playSound(soundName:String):void
        {
            if (sounds[soundName] && UserData.soundsOn)
            {
                var allGroupSounds:Array;
                var sound:Sound;

                if (soundName == SoundAsset.BOUNCER_HIT) //there are so many...
                {
                    allGroupSounds = SoundAsset.BOUNCER_SOUNDS;
                    sound = sounds[allGroupSounds[Misc.randomNumber(allGroupSounds.length - 1)]];
                }
                else if (soundName == SoundAsset.BRICK_HIT)
                {
                    allGroupSounds = SoundAsset.BRICK_SOUNDS;
                    sound = sounds[allGroupSounds[Misc.randomNumber(allGroupSounds.length - 1)]];
                }
                else if (soundName == SoundAsset.FREEZE)
                {
                    allGroupSounds = SoundAsset.FREEZE_SOUNDS;
                    sound = sounds[allGroupSounds[Misc.randomNumber(allGroupSounds.length - 1)]];
                }
                else if (soundName == SoundAsset.LIGHTNING)
                {
                    allGroupSounds = SoundAsset.LIGHTNING_SOUNDS;
                    sound = sounds[allGroupSounds[Misc.randomNumber(allGroupSounds.length - 1)]];
                }
                else
                {
                    sound = sounds[soundName];
                }

                var volume:Number = 0.2;
                if (soundName == SoundAsset.WIGGLE)
                    volume = 0.1;

                trace("SoundAssetManager: playSound: " + soundName);

                var volumeTrans:SoundTransform = new SoundTransform(volume);
                sound.play(0, 0, volumeTrans);
            }
            else
            {
                trace("Can't play sound: " + soundName + "! It is not loaded!");
            }
        }

        private static function playBackgroundMusic(e:Event = null):void
        {
            trace("SoundAssetManager: playBackgroundMusic: ");
            if (sounds[SoundAsset.MUSIC_LOOP])
            {
                var volumeAdjust:SoundTransform = new SoundTransform(0.2);
                soundChannel = (sounds[SoundAsset.MUSIC_LOOP] as Sound).play(90, 999999, volumeAdjust);
                soundChannel.addEventListener(Event.SOUND_COMPLETE, playBackgroundMusic);
            }
            else //maybe music was turned off and then turned on -> load music now
            {
                loadMusicForGame();
            }
        }

        /**
         * Loading all sounds for the game
         */
        public static function loadSoundsForGame():void
        {
            trace("SoundAssetManager: loadSoundsForGame: ");
            var allSounds:Array = SoundAsset.getAllSoundsNames();
            var so:Sound;
            var req:URLRequest;
            for each (var soundName:String in allSounds)
            {
                so = new Sound();
                req = new URLRequest(SOUND_FOLDER + soundName);
                so.load(req);
                sounds[soundName] = so;
            }
        }

        public static function loadMusicForGame():void
        {
            trace("SoundAssetManager: loadMusicForGame: ");
            var music:Sound = new Sound();
            var request:URLRequest = new URLRequest(MUSIC_FOLDER + SoundAsset.MUSIC_LOOP);
            music.load(request);
            music.addEventListener(Event.COMPLETE, playBackgroundMusic);
            sounds[SoundAsset.MUSIC_LOOP] = music;
        }
    }
}