package nc.component.system.input 
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.ui.Mouse;
	/**
     * InputManager, moust part.
     * @author Husky
     */
    public class NcMouse extends Point
    {
        //[Embed(source="../../../data/cursor.png")] protected var ImgDefaultCursor:Class;
        protected var m_clzImgDefaultCursor:Class;
        
        //Add for differ Mouse Events
        public static const LEFT:String = "left";
        public static const MIDDLE:String = "middle";
        public static const RIGHT:String = "right";
        
        //
        private static const MOUSE_NORMAL:int       = 0;
        private static const MOUSE_LEFT_PRESS:int   = 1;
        private static const MOUSE_LEFT_DOWN:int    = 2;
        private static const MOUSE_LEFT_UP:int      = 3;        
        private static const MOUSE_MIDDLE_PRESS:int = 4;
        private static const MOUSE_MIDDLE_DOWN:int  = 5;
        private static const MOUSE_MIDDLE_UP:int    = 6;        
        private static const MOUSE_RIGHT_PRESS:int  = 7;
        private static const MOUSE_RIGHT_DOWN:int   = 8;
        private static const MOUSE_RIGHT_UP:int     = 9;
        
        /**
		 * Current "delta" value of mouse wheel.  If the wheel was just scrolled up, it will have a positive value.  If it was just scrolled down, it will have a negative value.  If it wasn't just scroll this frame, it will be 0.
		 */
		public var wheel:int;
		/**
		 * Current X position of the mouse pointer on the screen.
		 */
		public var screenX:int;
		/**
		 * Current Y position of the mouse pointer on the screen.
		 */
		public var screenY:int;
		
		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		protected var _current:int;
		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		protected var _last:int;
		/**
		 * A display container for the mouse cursor.
		 * This container is a child of FlxGame and sits at the right "height".
		 */
		protected var _cursorContainer:Sprite;
		/**
		 * This is just a reference to the current cursor image, if there is one.
		 */
		protected var _cursor:Bitmap;
		/**
		 * Helper variables for recording purposes.
		 */
		protected var _lastX:int;
		protected var _lastY:int;
		protected var _lastWheel:int;
		protected var _point:Point;
		protected var _globalScreenPosition:Point;
        
        private var m_Stage:Stage;
        
        public function NcMouse(stage:Stage, CursorContainer:Sprite, imgDefaultCursorClz:Class = null) 
        {
            super();
			_cursorContainer = CursorContainer;
			_lastX = screenX = 0;
			_lastY = screenY = 0;
			_lastWheel = wheel = NcMouse.MOUSE_NORMAL;
			_current = NcMouse.MOUSE_NORMAL;
			_last = NcMouse.MOUSE_NORMAL;
			_cursor = null;
			_point = new Point();
			_globalScreenPosition = new Point();
            m_clzImgDefaultCursor = (imgDefaultCursorClz == null) ? Bitmap : imgDefaultCursorClz;
            
            m_Stage = stage;
            //Add basic input event listeners and mouse container
			m_Stage.addEventListener(MouseEvent.MOUSE_DOWN, HandleMouseLeftDown);
			m_Stage.addEventListener(MouseEvent.MOUSE_UP, HandleMouseLeftUp);
			m_Stage.addEventListener(MouseEvent.MOUSE_WHEEL, HandleMouseWheel);
            
            /*Need FP1.2*/
            //Add for Middle.Right down and up
            m_Stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, HandleMouseMiddleDown);
            m_Stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, HandleMouseMiddleUp);
            m_Stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, HandleMouseRightDown);
            m_Stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, HandleMouseRightUp);
        }
        
        /**
		 * Clean up memory.
		 */
		public function Release():void
		{
			_cursorContainer = null;
			_cursor = null;
			_point = null;
			_globalScreenPosition = null;
		}
        
        /**
		 * Load a new mouse cursor graphic
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	Scale		Change the size of the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function Load(clzGraphic:Class = null, nScale:Number = 1, iXOffset:int = 0, iYOffset:int = 0) : void
		{
			if (_cursor != null)
            {
				_cursorContainer.removeChild(_cursor);
            }

			if (clzGraphic == null)
            {
				clzGraphic = m_clzImgDefaultCursor;
            }
            
			_cursor = new clzGraphic();
			_cursor.x = iXOffset;
			_cursor.y = iYOffset;
			_cursor.scaleX = nScale;
			_cursor.scaleY = nScale;
			
			_cursorContainer.addChild(_cursor);
		}
        
        /**
		 * Unload the current cursor graphic.  If the current cursor is visible,
		 * then the default system cursor is loaded up to replace the old one.
		 */
		public function Unload():void
		{
			if (_cursor == null)
			{
                return
            }
            
            if (_cursorContainer.visible)
            {
                this.Load();
            }
            else
            {
                _cursorContainer.removeChild(_cursor)
                _cursor = null;
            }
		}
        
        /**
		 * Either show an existing cursor or load a new one.
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	Scale		Change the size of the cursor.  Default = 1, or native size.  2 = 2x as big, 0.5 = half size, etc.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function Show(clzGraphic:Class = null, nScale:Number = 1, iXOffset:int = 0, iYOffset:int = 0) : void
		{
            Mouse.hide();
            
			_cursorContainer.visible = true;
			if (clzGraphic != null)
            {
				this.Load(clzGraphic, nScale, iXOffset, iYOffset);
            }
			else if (_cursor == null)
            {
				this.Load();
            }
		}
        
        /**
		 * Hides the mouse cursor
		 */
		public function Hide():void
		{
			_cursorContainer.visible = false;
		}
        
        /**
		 * Read only, check visibility of mouse cursor.
		 */
		public function get visible():Boolean
		{
			return _cursorContainer.visible;
		}
        
        /**
		 * Called by the internal game loop to update the mouse pointer's position in the game world.
		 * Also updates the just pressed/just released flags.
		 * 
		 * @param	XScroll		The amount the game world has scrolled horizontally.
		 * @param	YScroll		The amount the game world has scrolled vertically.
		 */
		public function Update():void
		{
			_globalScreenPosition.x = m_Stage.mouseX;
			_globalScreenPosition.y = m_Stage.mouseY;
            
			this.UpdateCursor();
            
            //_current and _last is UP => assign to NORMAL
			if (((_last == NcMouse.MOUSE_LEFT_UP) && (_current == NcMouse.MOUSE_LEFT_UP)) ||
                ((_last == NcMouse.MOUSE_MIDDLE_UP) && (_current == NcMouse.MOUSE_MIDDLE_UP)) ||
                ((_last == NcMouse.MOUSE_RIGHT_UP) && (_current == NcMouse.MOUSE_RIGHT_UP)))
            {
				_current = NcMouse.MOUSE_NORMAL;
            }
            //_current and _last is DOWN => assign to PRESS
			else if ((_last == NcMouse.MOUSE_LEFT_DOWN) && (_current == NcMouse.MOUSE_LEFT_DOWN))
            {
				_current = NcMouse.MOUSE_LEFT_PRESS;
            }
            else if ((_last == NcMouse.MOUSE_MIDDLE_DOWN) && (_current == NcMouse.MOUSE_MIDDLE_DOWN))
            {
				_current = NcMouse.MOUSE_MIDDLE_PRESS;
            }
            else if ((_last == NcMouse.MOUSE_RIGHT_DOWN) && (_current == NcMouse.MOUSE_RIGHT_DOWN))
            {
				_current = NcMouse.MOUSE_RIGHT_PRESS;
            }
            
			_last = _current;
		}
        
        /**
		 * Internal function for helping to update the mouse cursor and world coordinates.
		 */
		protected function UpdateCursor():void
		{
			//actually position the flixel mouse cursor graphic
			_cursorContainer.x = _globalScreenPosition.x;
			_cursorContainer.y = _globalScreenPosition.y;
			
			//update the x, y, screenX, and screenY variables based on the default camera.
			//This is basically a combination of getWorldPosition() and getScreenPosition()
			//var camera:FlxCamera = FlxG.camera;
			//screenX = (_globalScreenPosition.x - camera.x)/camera.zoom;
			//screenY = (_globalScreenPosition.y - camera.y)/camera.zoom;
			//x = screenX + camera.scroll.x;
			//y = screenY + camera.scroll.y;
            
            screenX = _globalScreenPosition.x;
            screenY = _globalScreenPosition.y;
            x = screenX;
            y = screenY;
		}
        
		public function GetScreenPosition():Point
		{
			return _globalScreenPosition;
		}
        
        		
		/**
		 * Resets the just pressed/just released flags and sets mouse to not pressed.
		 */
		public function Reset():void
		{
			_current = NcMouse.MOUSE_NORMAL;
			_last = NcMouse.MOUSE_NORMAL;
		}
        
        /**
		 * Check to see if the mouse is pressed.
		 * 
		 * @return	Whether the mouse is pressed.
		 */
		public function Pressed(sMouseID:String = NcMouse.LEFT):Boolean 
        { 
            switch (sMouseID)
            {
                case NcMouse.LEFT:
                    return _current == NcMouse.MOUSE_LEFT_PRESS;                
                    
                case NcMouse.MIDDLE:
                    return _current == NcMouse.MOUSE_MIDDLE_PRESS;                
                    
                case NcMouse.RIGHT:
                    return _current == NcMouse.MOUSE_RIGHT_PRESS;
                
                default:
                    throw "Wrong sMouseID, use this class' static";
                    break;
            }
            
            return false; 
        }
		
		/**
		 * Check to see if the mouse was just pressed.
		 * 
		 * @return Whether the mouse was just pressed.
		 */
		public function JustPressed(sMouseID:String = NcMouse.LEFT):Boolean
        { 
            switch (sMouseID)
            {
                case NcMouse.LEFT:
                    return _current == NcMouse.MOUSE_LEFT_DOWN;                
                    
                case NcMouse.MIDDLE:
                    return _current == NcMouse.MOUSE_MIDDLE_DOWN;                
                    
                case NcMouse.RIGHT:
                    return _current == NcMouse.MOUSE_RIGHT_DOWN;
                
                default:
                    throw "Wrong sMouseID, use this class' static";
                    break;
            }
            
            return false; 
        }
		
		/**
		 * Check to see if the mouse was just released.
		 * 
		 * @return	Whether the mouse was just released.
		 */
		public function JustReleased(sMouseID:String = NcMouse.LEFT):Boolean 
        { 
            switch (sMouseID)
            {
                case NcMouse.LEFT:
                    return _current == NcMouse.MOUSE_LEFT_UP;                
                    
                case NcMouse.MIDDLE:
                    return _current == NcMouse.MOUSE_MIDDLE_UP;                
                    
                case NcMouse.RIGHT:
                    return _current == NcMouse.MOUSE_RIGHT_UP;
                
                default:
                    throw "Wrong sMouseID, use this class' static";
                    break;
            }
            
            return false; 
        }
		
		/**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function HandleMouseLeftDown(e:MouseEvent):void
		{
			if (_current == NcMouse.MOUSE_LEFT_PRESS || _current == NcMouse.MOUSE_LEFT_DOWN) 
                _current = NcMouse.MOUSE_LEFT_PRESS;
			else _current = NcMouse.MOUSE_LEFT_DOWN;
		}
		
		/**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function HandleMouseLeftUp(e:MouseEvent):void
		{
			if (_current == NcMouse.MOUSE_LEFT_PRESS || _current == NcMouse.MOUSE_LEFT_DOWN) 
                _current = NcMouse.MOUSE_LEFT_UP;
			else _current = MOUSE_NORMAL;
		}
        
        /**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	e	A <code>MouseEvent</code> object.
		 */
        public function HandleMouseMiddleDown(e:MouseEvent):void 
        {
            if (_current == NcMouse.MOUSE_MIDDLE_PRESS || _current == NcMouse.MOUSE_MIDDLE_DOWN) 
                _current = NcMouse.MOUSE_MIDDLE_PRESS;
			else _current = NcMouse.MOUSE_MIDDLE_DOWN;
        }
        
        /**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	e	A <code>MouseEvent</code> object.
		 */
        public function HandleMouseMiddleUp(e:MouseEvent):void 
        {
            if (_current == NcMouse.MOUSE_MIDDLE_PRESS || _current == NcMouse.MOUSE_MIDDLE_DOWN) 
                _current = NcMouse.MOUSE_MIDDLE_UP;
			else _current = NcMouse.MOUSE_NORMAL;
        }
        
        /**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	e	A <code>MouseEvent</code> object.
		 */
        public function HandleMouseRightDown(e:MouseEvent):void 
        {
            if (_current == NcMouse.MOUSE_RIGHT_PRESS || _current == NcMouse.MOUSE_RIGHT_DOWN) 
                _current = NcMouse.MOUSE_RIGHT_PRESS;
			else _current = NcMouse.MOUSE_RIGHT_DOWN;
        }
        
        /**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	e	A <code>MouseEvent</code> object.
		 */
        public function HandleMouseRightUp(e:MouseEvent):void 
        {
            if (_current == NcMouse.MOUSE_RIGHT_PRESS || _current == NcMouse.MOUSE_RIGHT_DOWN) 
                _current = NcMouse.MOUSE_RIGHT_UP;
			else _current = NcMouse.MOUSE_NORMAL;
        }
		
		/**
		 * Event handler so FlxGame can update the mouse.
		 * 
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function HandleMouseWheel(e:MouseEvent):void
		{
			wheel = e.delta;
		}
    }
}


















