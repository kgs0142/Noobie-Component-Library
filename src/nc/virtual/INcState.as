package nc.virtual 
{
    import nc.component.NcBaseComponent;
    import nc.component.NcStateMachine;
    import nc.event.NcStateMachineEvent;
    
    /**
     * ...
     * @author Husky
     */
    public interface INcState 
    {
        //function AllowTransitionFrom(stateName : String) : Boolean
        
        //function Initial(stateMachine:NcStateMachine) : void;
        
        function DoFirstRun(e:NcStateMachineEvent) : void;

		function DoRun() : void;
        
		function DoLastRun(e:NcStateMachineEvent) : void;
        
        //function toString() : String;
        
        //function get objFrom() : Object;
        
        function get sName() : String;
        
        function get from() : Vector.<String>;
    }
}