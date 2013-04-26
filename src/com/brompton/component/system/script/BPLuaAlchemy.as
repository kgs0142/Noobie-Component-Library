package com.brompton.component.system.script
{
    import luaAlchemy.LuaAlchemy;
    
    internal class BPLuaAlchemy extends LuaAlchemy
    {
        private var m_sName:String;
        
        public function BPLuaAlchemy(arg0:*=null, arg1:Boolean=true)
        {
            super(arg0, arg1);
        }
        
        public override function doString(sText:String) : Array
        {
            var arrResult:Array = super.doString(sText);
            
            if (arrResult[0] === false)
            {
                throw new Error(sName + ": Error executing doString '" + sText + "'");
            }
            
            return arrResult;
        }
        
        public function set sName(sText:String) : void { m_sName = sText; }
        public function get sName() : String { return m_sName; }
    }
}
