package com.brompton.event
{
    import flash.events.Event;

    public final class BPAssetEvent extends Event
    {
        //Lua 
        public static const LUA_LOAD_COMPLETE:String = "LUA_LOAD_COMPLETE";
        
        //
        public static const ASSET_LOAD_COMPLETE:String = "ASSET_LOAD_COMPLETE";
        
        private var m_sName:String;
        private var m_sPath:String;
        
        public function get sName() : String { return m_sName; }
        public function set sName(sName:String) : void { m_sName = sName; }
        public function get sPath() : String { return m_sPath; }
        public function set sPath(sPath:String) : void { m_sPath = sPath; }
        
        public function BPAssetEvent(type:String) 
        {
            super(type);
        }
    }
}