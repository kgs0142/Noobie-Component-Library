package com.brompton.component.system.script 
{
	import com.brompton.component.BPBaseComponent;
	import com.brompton.component.system.script.BPLuaAlchemy;
    
	/**
     * The script manager (using Lua)
     * @author Husky
     */
    public class BPLuaManager extends BPBaseComponent 
    {
        ///LuaAlchemy
        private var m_cLuaAlchemy:BPLuaAlchemy;
        
        public function BPLuaManager() 
        {
            
        }
        //luaAlchemy public functions----------------------------------------------
        /**
         * Do a piece of string in lua.
         * @param sScript the lua script to execute (eg. "setInfo(1, 'abc', flxSprite, {1,2,3})").
         * @return If successful, the remaining values are the Lua return values. If failed, the second value is the error. 
         */
        public function DoString(sScript:String) : Array
        {
            return m_cLuaAlchemy.doString(sScript);
        }
        
        /**
         * Do a piece of string in lua, and has a callback.
         * @param sScript the lua script to execute.
         * @param fnCallback the callback called when script executing complete.
         */
        public function DoStringAsync(sScript:String, fnCallback:Function) : void
        {
            m_cLuaAlchemy.doStringAsync(sScript, fnCallback);
        }
        
        /**
         * Set global variable in lua script using AS3 type.
         * @param sNameInLua the name in lua script.
         * @param value the value of the sNameInLua in lua using.
         */
        public function SetGlobal(sNameInLua:String, value:*) : void
        {
            m_cLuaAlchemy.setGlobal(sNameInLua, value);
        }
        
        /**
         * Set global variable in lua script using Lua type (as possibly).
         * @param sNameInLua the name in lua script.
         * @param value the value of the sNameInLua in lua using.
         */
        public function SetGlobalLuaValue(sNameInLua:String, value:*) : void
        {
            m_cLuaAlchemy.setGlobalLuaValue(sNameInLua, value);
        }
        
        /**
         * Call the public function in lua script
         * @param sFnNameInLua the function name (eg. "setInfo").
         * @param ...aParam the params if has (eg. 1, 'abc', flxSprite, {1,2,3}).
         * @return
         */
        public function CallGlobal(sFnNameInLua:String, ...aParam) : Array
        {
            return m_cLuaAlchemy.callGlobal(sFnNameInLua, aParam);
        }
        //-----------------------------------------------------------------------------
        
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