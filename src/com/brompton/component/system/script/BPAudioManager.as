package com.brompton.component.system.script 
{
	import com.brompton.component.BPBaseComponent;
	
	/**
     * ...
     * @author Husky
     */
    public class BPAudioManager extends BPBaseComponent 
    {
        
        public function BPAudioManager() 
        {
            
        }
        
        public override function Initial() : void 
        {
            //Need import all class lua will use.
        }

		public override function Create() : void
        {
            m_cLuaAlchemy = new BPLuaAlchemy();
        }

        public override function Update() : void
        {
        }

        public override function Release() : void
        {
        }
    }
}