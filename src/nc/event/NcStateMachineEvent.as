package nc.event 
{
	import flash.events.Event;
    import nc.entity.NcEntity;
    import nc.virtual.INcEntity;
	
	/**
     * ...
     * @author Husky
     */
    public class NcStateMachineEvent extends Event 
    {
        public static const EXIT_CALLBACK:String = "exit";
		public static const ENTER_CALLBACK:String = "enter";
		public static const TRANSITION_COMPLETE:String = "transition complete";
		public static const TRANSITION_DENIED:String = "transition denied";
		
        public var entity:INcEntity;
		public var fromState:String;
		public var toState:String;
		public var currentState:String;
		public var allowedStates:Object;

        ///State要操作的對象，AI Agent
        //public var agent:Object;
        
		public function NcStateMachineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
    }
}