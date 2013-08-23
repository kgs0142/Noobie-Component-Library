package nc.component 
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
	/**
     * ...
     * @author Husky
     */
    public class NcEventDispatcher extends NcBaseComponent 
    {
        private var m_Dispatcher:EventDispatcher;
        
        //key = Event Type; value = vector of callbacks
        ///map of listeners and their event callbacks
        private var m_mapListener:Dictionary;
        
        public function NcEventDispatcher() {}
        
        public function DispatchEvent(e:Event) : Boolean
        {
            return m_Dispatcher.dispatchEvent(e);
        }
        
        public function AddEventListener(sType:String, fnCallback:Function, bUseCapture:Boolean = false, 
                                         iPriority:int = 0, bUseWeakReference:Boolean = false) : void 
        {
            if (this.HasEventListener(sType) == true)
            {
                return;
            }
            
            var vCallbacks:Vector.<Function> = m_mapListener[sType];
            vCallbacks = (vCallbacks == null) ? vCallbacks = Vector.<Function>([]) : vCallbacks;
            
            vCallbacks.push(fnCallback);
            
            m_Dispatcher.addEventListener(sType, fnCallback, bUseCapture, iPriority, bUseWeakReference);
        }
        
        public function RemoveEventListener(sType:String, fnCallback:Function, bUseCapture:Boolean = false) : void
        {
            m_Dispatcher.removeEventListener(sType, fnCallback, bUseCapture);
            
            var vCallbacks:Vector.<Function> = m_mapListener[sType];
            vCallbacks = (vCallbacks == null) ? vCallbacks = Vector.<Function>([]) : vCallbacks;
            
            var index:int = vCallbacks.indexOf(fnCallback);
            
            if (index == -1)
            {
                return;
            }
            
            vCallbacks.splice(index, 1);
        }
        
        public function HasEventListener(sType:String) : Boolean
        {
            return m_Dispatcher.hasEventListener(sType);
        }
        
        public function WillTrigger(sType:String) : Boolean
        {
            return m_Dispatcher.willTrigger(sType);
        }
        
        public override function Create() : void
        {
            m_mapListener = new Dictionary();
            m_Dispatcher = new EventDispatcher();
        }
        
        public override function Initial() : void 
        {
        }

        public override function Update() : void
        {
        }

        public override function Release() : void
        {
            for (var sKey:String in m_mapListener)
            {
                var vCallbacks:Vector.<Function> = m_mapListener[sKey];
                
                var uiLength:uint = vCallbacks.length;
                for (var ui:uint = 0; ui < uiLength; ui++)
                {
                    this.RemoveEventListener(sKey, vCallbacks[ui]);
                }
                
                vCallbacks.splice(0, uiLength);
                m_mapListener[sKey] = null;
                delete m_mapListener[sKey];
            }
            
            m_mapListener = null;
        }
    }
}




















