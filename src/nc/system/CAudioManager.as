package nc.system 
{
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	/**
     * ...
     * @author Husky
     */
    public class CAudioManager 
    {
        private static var ms_Instance:CAudioManager;
        private var m_objMapping:Object;
        
        //private var m_sndChannel:SoundChannel;
        private var m_Snd:Sound;
        
        private var m_sndCMusic:SoundChannel;
        private var m_sndMusic:Sound;
        
        public function PlaySnd(sName:String, nVolume:Number = 1.0) : void
        {
            if (m_objMapping.hasOwnProperty(sName) == false)
            {
                return;
            }
            
            //FlxG.play(m_objMapping[sName], nVolume);
            
            m_Snd = new m_objMapping[sName]();
            m_Snd.play();
        }
        
        public function PlayMusic(sName:String, nVolume:Number = 1.0) : void
        {
            if (m_objMapping.hasOwnProperty(sName) == false)
            {
                return;
            }
            
            //FlxG.playMusic(m_objMapping[sName], nVolume);
            
            if (m_sndCMusic != null)
            {
                m_sndCMusic.stop();
                m_sndCMusic.removeEventListener(Event.SOUND_COMPLETE, MusicCompleteHD);
            }
            
            m_sndMusic = new m_objMapping[sName]();
            m_sndCMusic = m_sndMusic.play();
            m_sndCMusic.addEventListener(Event.SOUND_COMPLETE, MusicCompleteHD);
        }
        
        public function stopMusic() : void
        {
            //if (FlxG.music)
                //FlxG.music.stop();
            if (m_sndCMusic != null)
            {
                m_sndCMusic.stop();
                m_sndCMusic.removeEventListener(Event.SOUND_COMPLETE, MusicCompleteHD);
            }
        }
        
        private function MusicCompleteHD(e:Event) : void
        {
            if (m_sndCMusic != null)
            {
                m_sndCMusic.removeEventListener(Event.SOUND_COMPLETE, MusicCompleteHD);
                
                m_sndCMusic.stop();
                m_sndCMusic = m_sndMusic.play();
                m_sndCMusic.addEventListener(Event.SOUND_COMPLETE, MusicCompleteHD);
            }
        }
        
        public function Create() : void
        {
            m_objMapping = 
            {
                //"TitleMusic": TitleMusic,
                //"Music001" : Music001
                //"HeartBeat" : HeartBeat,
                //"Lighting" : Lighting,
                //"HeartBeatFast" : HeartBeatFast,
                //"HeartBeatSlow" : HeartBeatSlow,
                //"Dead" : Dead,
                //"Blizzard" : Blizzard,
                //"Eat" : Eat,
                //"Music001" : Music001,
                //"Music002" : Music002,
                //"Ending" : Ending
            };
        }
        
        public function CAudioManager(proxy:CSSingletonProxy)
        {
            if (proxy == null) 
            {
                throw new Error("Singleton create error.");
            }
        }
        
        public static function Get() : CAudioManager
        {
            if (!ms_Instance)
            {
                ms_Instance = new CAudioManager(new CSSingletonProxy());
            }
            
            return ms_Instance;
        }
    }
}

class CSSingletonProxy { }