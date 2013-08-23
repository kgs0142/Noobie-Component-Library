package test.states 
{
    import flash.events.KeyboardEvent;
    import nc.component.NcStateMachine;
    import nc.event.NcStateMachineEvent;
	import nc.state.NcBaseState;
    import nc.virtual.INcEntity;
	
	/**
     * ...
     * @author Husky
     */
    public class IdleState extends NcBaseState 
    {
        
        public function IdleState() 
        {
            super("Idle");
        }
        
        private var entity:INcEntity;
        
        private var debugCounter:uint = 0;
        
        public override function DoFirstRun(e:NcStateMachineEvent) : void
        {
            NC_LOG("Idle State Do first Run");
            
            entity = e.entity;
        }

		public override function DoRun() : void
        {
            debugCounter++;
            
            if (debugCounter > 1000)
            {
                var statemachine:NcStateMachine = entity.GetComponent(NcStateMachine);
                statemachine.ChangeState("Walk");
            }
        }
        
		public override function DoLastRun(e:NcStateMachineEvent) : void
        {
            NC_LOG("Idle State Do Last Run");
        }
    }
}