package nc.component 
{
	import nc.component.NcBaseComponent;
    import nc.event.NcStateMachineEvent;
    import nc.virtual.INcState;
    import flash.utils.Dictionary;
	
	/**
     * Creating and revising by cassiozen / AS3-State-Machine
     * @author Husky
     */
    public class NcStateMachine extends NcBaseComponent 
    {
        ///current state
        private var m_sCurState:String;
        ///store all states
        private var m_mapStates:Dictionary;
        ///the state to other state's path
        //private var m_vPaths:Vector.<int>;
        
        ///The NcEventDispatcher component of entity
        //private var m_cEventDispatcher:NcEventDispatcher;
        
        /**
		 * Creates a generic StateMachine. Available states can be set with addState and initial state can
		 * be set using initialState setter.
		 * @example This sample creates a state machine for a player model with 3 states (Playing, paused and stopped)
		 * <pre>
		 *	playerSM = new NcStateMachine();
		 *
		 *	playerSM.AddState("playing",{ enter: onPlayingEnter, exit: onPlayingExit, from:["paused","stopped"] });
		 *	playerSM.AddState("paused",{ enter: onPausedEnter, from:"playing"});
		 *	playerSM.AddState("stopped",{ enter: onStoppedEnter, from:"*"});
		 *	
		 *	NcDispatcher.addEventListener(NcStateMachineEvent.TRANSITION_DENIED,transitionDeniedFunction);
		 *	NcDispatcher.addEventListener(NcStateMachineEvent.TRANSITION_COMPLETE,transitionCompleteFunction);
		 *	
		 *	playerSM.initialState = "stopped";
		 *	</pre>
		 */
        public function NcStateMachine() 
        {
            
        }
    
        public override function Initial() : void 
        {
            //m_cEventDispatcher = m_Entity.GetComponent(NcEventDispatcher);
            //if (m_cEventDispatcher == null)
            //{
                //throw ("NcStateMachine component of " + this.m_Entity.ID + " didn't has a NcEventDispatcher Component!");
            //}
        }

        public override function Update() : void
        {
            m_mapStates[m_sCurState]["DoRun"]();
        }

        public override function Release() : void
        {
            NC_LOG("Eid: " + this.Entity.ID + ", " + this.GetClzName() + " start to release.");
            
            //throw "Release have to be overrided";
            var e:NcStateMachineEvent = new NcStateMachineEvent(NcStateMachineEvent.EXIT_CALLBACK);
            e.entity = this.Entity;
            e.fromState = m_sCurState;
            e.currentState = m_sCurState;
            m_mapStates[m_sCurState]["DoLastRun"](e);
            
            for (var sState:String in m_mapStates)
            {
                m_mapStates[sState] = null;
                delete m_mapStates[sState];
            }
            
            m_mapStates = null;
            
            //m_vPaths.splice(0, m_vPaths.length);
            //m_vPaths = null;
        }
        
        /**
		 * Adds a new state
		 * @param newState	The new state want to be added (cannot be duplicate)
		 * The "from" property can be a string or and array with the state names or * to allow any transition
		 **/
		public function AddState(newState:INcState) : void
		{
			if (newState.sName in m_mapStates)
            {
                NC_LOG("[StateMachine]:" + m_sID + ", Overriding existing state " + newState.sName);
            }
			
			m_mapStates[newState.sName] = newState;
			//newState.Initial();
		}
        
        /**
		 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
		 * These will only occour if no state is defined
		 * @param sStateName The name of the State
		 **/
		public function SetInitState(sStateName:String) : void
		{
			if (m_sCurState != null || sStateName in m_mapStates == false)
			{
                return;
            }
            
            m_sCurState = sStateName;

            var e:NcStateMachineEvent = new NcStateMachineEvent(NcStateMachineEvent.ENTER_CALLBACK);
            e.entity = this.Entity;
            e.toState = sStateName;
            e.currentState = m_sCurState;
            m_mapStates[m_sCurState]["DoFirstRun"](e);
            
            //Transition Complete
            //e = new NcStateMachineEvent(NcStateMachineEvent.TRANSITION_COMPLETE);
            //e.toState = sStateName;
            //
            //m_cEventDispatcher.DispatchEvent(e);
		}
        
        /**
		 * Verifies if a transition can be made from the current state to the state passed as param
		 * @param stateName	The name of the State
		 **/
        public function CanChangeStateTo(sStateName:String) : Boolean
        {
            //不能自己的State切到自己的State
			//return (stateName != _state && 
            return  (m_mapStates[sStateName]["from"].indexOf(m_sCurState) != -1 || 
                     m_mapStates[sStateName]["from"] == "*");
        }
               
        /**
		 * Changes the current state
		 * This will only be done if the intended state allows the transition from the current state
		 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
		 * @param stateTo	The name of the state to transition to
		 **/
		public function ChangeState(sStateTo:String) : void
		{
			// If there is no state that maches stateTo
			if (sStateTo in m_mapStates == false)
			{
				NC_LOG("[StateMachine]" + m_sID +"Cannot make transition: State " + sStateTo + " is not defined");
				return;
			}

            var e:NcStateMachineEvent;
            
			// If current state is not allowed to make this transition
			if (this.CanChangeStateTo(sStateTo) == false)
			{
				NC_LOG("[StateMachine]" + m_sID + "Transition to " + sStateTo + " denied");
				//e = new NcStateMachineEvent(NcStateMachineEvent.TRANSITION_DENIED);
				//e.fromState = m_sCurState;
				//e.toState = sStateTo;
				//e.allowedStates = m_mapStates[sStateTo].from;
				//m_cEventDispatcher.DispatchEvent(e);
				return;
			}

			//call exit and enter callbacks------------------------------
            e = new NcStateMachineEvent(NcStateMachineEvent.EXIT_CALLBACK);
            e.toState = sStateTo;
            e.entity = this.Entity;
            e.fromState = m_sCurState;
            e.currentState = m_sCurState;
            m_mapStates[m_sCurState]["DoLastRun"](e);
            //-------------------------------------------------------------------------------
            
			var sOldState:String = m_sCurState;
			m_sCurState = sStateTo;
            
            //call enter of new state------------------------------------------
            e = new NcStateMachineEvent(NcStateMachineEvent.ENTER_CALLBACK);
            e.toState = sStateTo;
            e.fromState = sOldState;
            e.entity = this.Entity;
            e.currentState = m_sCurState;
            m_mapStates[m_sCurState]["DoFirstRun"](e);
            
			// Transition is complete. dispatch TRANSITION_COMPLETE
			//e = new NcStateMachineEvent(NcStateMachineEvent.TRANSITION_COMPLETE);
			//e.fromState = sOldState;
			//e.toState = sStateTo;
			//m_cEventDispatcher.DispatchEvent(e);
		}
        
        public override function Create() : void
        {
            m_mapStates = new Dictionary();
        }
        
        /**
		 *	Getters and Setters
		 */
		//public function get state() : String
		//{
			////return m_mapStates[m_sCurState];
            //return m_sCurState;
		//}

		//public function get states() : Dictionary
		//{
			//return m_mapStates;
		//}

		//public function getStateByName(sName:String) : IState
		//{
            //if (sName in m_mapStates == true)
            //{
                //return m_mapStates[sName]
            //}
            //
			//return null;
		//}
    }
}