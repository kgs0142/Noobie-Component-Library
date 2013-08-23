package nc.state 
{
    import nc.component.NcStateMachine;
    import nc.event.NcStateMachineEvent;
    import nc.virtual.INcState;
	/**
     * ...
     * @author Husky
     */
    public class NcBaseState implements INcState
    {
        private var m_sName:String;
        private var m_FromStates:Vector.<String>;
        
        public function NcBaseState(sStateName:String, fromStates:Vector.<String> = null) 
        {
            m_sName = sStateName;
            
            m_FromStates = (fromStates == null) ? Vector.<String>(["*"]) : fromStates;
        }
        
        //function AllowTransitionFrom(stateName : String) : Boolean
        
        public function DoFirstRun(e:NcStateMachineEvent) : void
        {
            throw "subclass need to override";
        }

		public function DoRun() : void
        {
            
        }
        
		public function DoLastRun(e:NcStateMachineEvent) : void
        {
            throw "subclass need to override";
        }
        
        //public function toString() : String
        //{
            //return this.m_sName;
        //}
        
        //public function get objFrom() : Object
        //{
            //
        //}
        
        public function get from() : Vector.<String>
        {
            return m_FromStates;
        }
        
        public function get sName() : String
        {
            return this.m_sName;
        }
    }
}