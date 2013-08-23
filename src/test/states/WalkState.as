package test.states 
{
    import nc.event.NcStateMachineEvent;
    import nc.state.NcBaseState;
	/**
     * ...
     * @author Husky
     */
    public class WalkState extends NcBaseState 
    {
        
        public function WalkState() 
        {
            super("Walk");
        }
        
        public override function DoFirstRun(e:NcStateMachineEvent) : void
        {
            NC_LOG("Walk State Do first Run");
        }

		public override function DoRun() : void
        {
            
        }
        
		public override function DoLastRun(e:NcStateMachineEvent) : void
        {
            NC_LOG("Walk State Do Last Run");
        }
    }
}