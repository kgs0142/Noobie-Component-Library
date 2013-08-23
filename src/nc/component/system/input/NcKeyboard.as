package nc.component.system.input 
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
	/**
     * InputManager, keyboard part.
     * @author Husky
     */
    public class NcKeyboard 
    {
        //Keys--------------------------------------
        public var ESCAPE:Boolean;
		public var F1:Boolean;
		public var F2:Boolean;
		public var F3:Boolean;
		public var F4:Boolean;
		public var F5:Boolean;
		public var F6:Boolean;
		public var F7:Boolean;
		public var F8:Boolean;
		public var F9:Boolean;
		public var F10:Boolean;
		public var F11:Boolean;
		public var F12:Boolean;
		public var ONE:Boolean;
		public var TWO:Boolean;
		public var THREE:Boolean;
		public var FOUR:Boolean;
		public var FIVE:Boolean;
		public var SIX:Boolean;
		public var SEVEN:Boolean;
		public var EIGHT:Boolean;
		public var NINE:Boolean;
		public var ZERO:Boolean;
		public var NUMPADONE:Boolean;
		public var NUMPADTWO:Boolean;
		public var NUMPADTHREE:Boolean;
		public var NUMPADFOUR:Boolean;
		public var NUMPADFIVE:Boolean;
		public var NUMPADSIX:Boolean;
		public var NUMPADSEVEN:Boolean;
		public var NUMPADEIGHT:Boolean;
		public var NUMPADNINE:Boolean;
		public var NUMPADZERO:Boolean;
		public var PAGEUP:Boolean;
		public var PAGEDOWN:Boolean;
		public var HOME:Boolean;
		public var END:Boolean;
		public var INSERT:Boolean;
		public var MINUS:Boolean;
		public var NUMPADMINUS:Boolean;
		public var PLUS:Boolean;
		public var NUMPADPLUS:Boolean;
		public var DELETE:Boolean;
		public var BACKSPACE:Boolean;
		public var TAB:Boolean;
		public var Q:Boolean;
		public var W:Boolean;
		public var E:Boolean;
		public var R:Boolean;
		public var T:Boolean;
		public var Y:Boolean;
		public var U:Boolean;
		public var I:Boolean;
		public var O:Boolean;
		public var P:Boolean;
		public var LBRACKET:Boolean;
		public var RBRACKET:Boolean;
		public var BACKSLASH:Boolean;
		public var CAPSLOCK:Boolean;
		public var A:Boolean;
		public var S:Boolean;
		public var D:Boolean;
		public var F:Boolean;
		public var G:Boolean;
		public var H:Boolean;
		public var J:Boolean;
		public var K:Boolean;
		public var L:Boolean;
		public var SEMICOLON:Boolean;
		public var QUOTE:Boolean;
		public var ENTER:Boolean;
		public var SHIFT:Boolean;
		public var Z:Boolean;
		public var X:Boolean;
		public var C:Boolean;
		public var V:Boolean;
		public var B:Boolean;
		public var N:Boolean;
		public var M:Boolean;
		public var COMMA:Boolean;
		public var PERIOD:Boolean;
		public var NUMPADPERIOD:Boolean;
		public var SLASH:Boolean;
		public var NUMPADSLASH:Boolean;
		public var CONTROL:Boolean;
		public var ALT:Boolean;
		public var SPACE:Boolean;
		public var UP:Boolean;
		public var DOWN:Boolean;
		public var LEFT:Boolean;
		public var RIGHT:Boolean;
        //--------------------------------------
        
        private static const JUST_RELEASE_STATE:int = -1;
        private static const INITIAL_STATE:int = 0;
        private static const PRESS_STATE:int = 1;
        private static const JUST_PRESS_STATE:int = 2;
        
		private static const MAX_KEYS:uint = 256;

        private var m_stage:Stage;
        
		private var m_objLookup:Object;
		private var m_vMapping:Vector.<Object>;
        
        /**
		 * Check to see if this key is pressed.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key is pressed
		 */
		public function Pressed(sKey:String):Boolean { return this[sKey]; }
		
		/**
		 * Check to see if this key was just pressed.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key was just pressed
		 */
		public function JustPressed(sKey:String):Boolean { return m_vMapping[m_objLookup[sKey]].current == JUST_PRESS_STATE; }
		
		/**
		 * Check to see if this key is just released.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key is just released.
		 */
		public function JustReleased(sKey:String):Boolean { return m_vMapping[m_objLookup[sKey]].current == JUST_RELEASE_STATE; }
        
        /**
		 * Look up the key code for any given string name of the key or button.
		 * 
		 * @param	KeyName		The <code>String</code> name of the key.
		 * 
		 * @return	The key code for that key.
		 */
		public function GetKeyCode(sKeyName:String):int
		{
			return m_objLookup[sKeyName];
		}
        
        /**
		 * Check to see if any keys are pressed right now.
		 * 
		 * @return	Whether any keys are currently pressed.
		 */
		public function Any():Boolean
		{
			var ui:uint = 0;
			while (ui < MAX_KEYS)
			{
				var obj:Object = m_vMapping[ui++];
				if ((obj != null) && (obj.current > INITIAL_STATE))
                {
					return true;
                }
			}
            
			return false;
		}
        
        /**
         * Resets all the keys.
         */
        public function Reset():void
        {
            var ui:uint = 0;
            while (ui < MAX_KEYS)
            {
                var obj:Object = m_vMapping[ui++];
                if (obj == null) 
                {
                    continue;
                }
                
                this[obj.name] = false;
                obj.current = INITIAL_STATE;
                obj.last = INITIAL_STATE;
            }
        }
        
        /**
		 * An internal helper function used to build the key array.
		 * 
		 * @param	KeyName		String name of the key (e.g. "LEFT" or "A")
		 * @param	KeyCode		The numeric Flash code for this key.
		 */
		protected function AddKey(sKeyName:String, uiKeyCode:uint) : void
		{
			m_objLookup[sKeyName] = uiKeyCode;
			m_vMapping[uiKeyCode] = {"name": sKeyName, "current": INITIAL_STATE, "last": INITIAL_STATE};
		}
		
        /**
		 * Event handler so FlxGame can toggle keys.
		 * 
		 * @param	FlashEvent	A <code>KeyboardEvent</code> object.
		 */
		public function HandleKeyDown(e:KeyboardEvent):void
		{
			var obj:Object = m_vMapping[e.keyCode];
			if (obj == null) 
            {
                return;
            }
            
            obj.current = (obj.current > INITIAL_STATE) ? PRESS_STATE : JUST_PRESS_STATE;
            
			this[obj.name] = true;
		}
		
		/**
		 * Event handler so FlxGame can toggle keys.
		 * 
		 * @param	FlashEvent	A <code>KeyboardEvent</code> object.
		 */
		public function HandleKeyUp(e:KeyboardEvent):void
		{
			var obj:Object = m_vMapping[e.keyCode];
			if (obj == null) 
            {
                return;
            }
            
            obj.current = (obj.current > INITIAL_STATE) ? JUST_RELEASE_STATE : INITIAL_STATE;
            
			this[obj.name] = false;
		}
        
        /**
		 * Updates the key states (for tracking just pressed, just released, etc).
		 */
		public function Update():void
		{
			var ui:uint = 0;
			while (ui < MAX_KEYS)
			{
				var obj:Object = m_vMapping[ui++];
				if (obj == null) 
                {
                    continue;
                }
                
				if ((obj.last == JUST_RELEASE_STATE) && (obj.current == JUST_RELEASE_STATE))
                {
                    obj.current = INITIAL_STATE;
                }
				else if ((obj.last == JUST_PRESS_STATE) && (obj.current == JUST_PRESS_STATE)) 
                {
                    obj.current = PRESS_STATE;
                }
                
				obj.last = obj.current;
			}
		}
        
		/**
		 * Clean up memory.
		 */
		public function Release():void
		{
            var sKey:String
            for (sKey in m_objLookup)
            {
                delete m_objLookup[sKey];
            }
			m_objLookup = null;
            
            var uiLength:uint = 0;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_vMapping[ui] == null)
                {
                    continue;
                }
                
                var obj:Object = m_vMapping[ui];
                for (sKey in obj)
                {
                    delete obj[sKey];
                }
                m_vMapping[ui] = null;
            }
            
            m_vMapping.splice(0, uiLength);
			m_vMapping = null;
            
            m_stage.removeEventListener(KeyboardEvent.KEY_DOWN, HandleKeyDown);
            m_stage.removeEventListener(KeyboardEvent.KEY_UP, HandleKeyUp);
            m_stage = null;
		}
        
        public function NcKeyboard(stage:Stage) 
        {
            m_objLookup = new Object();
            m_vMapping = new Vector.<Object>(MAX_KEYS);
            
            //Add Keyboard event on stage
            m_stage = stage;
			m_stage.addEventListener(KeyboardEvent.KEY_DOWN, HandleKeyDown);
			m_stage.addEventListener(KeyboardEvent.KEY_UP, HandleKeyUp);
            
            //Keyboard constructor------------------------------------
            var ui:uint;
			
			//LETTERS
			ui = 65;
			while (ui <= 90)
				this.AddKey(String.fromCharCode(ui),ui++);
			
			//NUMBERS
			ui = 48;
			this.AddKey("ZERO", ui++);
			this.AddKey("ONE", ui++);
			this.AddKey("TWO", ui++);
			this.AddKey("THREE", ui++);
			this.AddKey("FOUR", ui++);
			this.AddKey("FIVE", ui++);
			this.AddKey("SIX", ui++);
			this.AddKey("SEVEN", ui++);
			this.AddKey("EIGHT", ui++);
			this.AddKey("NINE", ui++);
            
			ui = 96;
			this.AddKey("NUMPADZERO", ui++);
			this.AddKey("NUMPADONE", ui++);
			this.AddKey("NUMPADTWO", ui++);
			this.AddKey("NUMPADTHREE", ui++);
			this.AddKey("NUMPADFOUR", ui++);
			this.AddKey("NUMPADFIVE", ui++);
			this.AddKey("NUMPADSIX", ui++);
			this.AddKey("NUMPADSEVEN", ui++);
			this.AddKey("NUMPADEIGHT", ui++);
			this.AddKey("NUMPADNINE", ui++);
			this.AddKey("PAGEUP", 33);
			this.AddKey("PAGEDOWN", 34);
			this.AddKey("HOME", 36);
			this.AddKey("END", 35);
			this.AddKey("INSERT", 45);
			
			//FUNCTION KEYS
			ui = 1;
			while (ui <= 12)
				this.AddKey("F" + ui, 111 + (ui++));
			
			//SPECIAL KEYS + PUNCTUATION
			this.AddKey("ESCAPE", 27);
			this.AddKey("MINUS", 189);
			this.AddKey("NUMPADMINUS", 109);
			this.AddKey("PLUS", 187);
			this.AddKey("NUMPADPLUS", 107);
			this.AddKey("DELETE", 46);
			this.AddKey("BACKSPACE", 8);
			this.AddKey("LBRACKET", 219);
			this.AddKey("RBRACKET", 221);
			this.AddKey("BACKSLASH", 220);
			this.AddKey("CAPSLOCK", 20);
			this.AddKey("SEMICOLON", 186);
			this.AddKey("QUOTE", 222);
			this.AddKey("ENTER", 13);
			this.AddKey("SHIFT", 16);
			this.AddKey("COMMA", 188);
			this.AddKey("PERIOD", 190);
			this.AddKey("NUMPADPERIOD", 110);
			this.AddKey("SLASH", 191);
			this.AddKey("NUMPADSLASH", 191);
			this.AddKey("CONTROL", 17);
			this.AddKey("ALT", 18);
			this.AddKey("SPACE", 32);
			this.AddKey("UP", 38);
			this.AddKey("DOWN", 40);
			this.AddKey("LEFT", 37);
			this.AddKey("RIGHT", 39);
			this.AddKey("TAB", 9);
        }
    }
}













