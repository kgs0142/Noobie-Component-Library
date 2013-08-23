package nc.component 
{
    import nc.virtual.INcComponent;
    import nc.virtual.INcEntity;
    import flash.utils.getQualifiedClassName;
    import nc.util.bplib;
	/**
     * ...
     * @author Husky
     */
    public class NcBaseComponent implements INcComponent 
    {
        private static var ACCU_COMP_ID:uint = 0;
        
        private var m_sClzName:String;
        
        private var m_bSetEntityLock:Boolean;

        ///the owner of components.
        protected var m_Entity:INcEntity;
        
        ///ID, it's good than don't have it huh?
        protected var m_sID:String;
        
        public function NcBaseComponent() 
        {
            m_Entity = null;
            m_sClzName = getQualifiedClassName(this);
            m_sID = "comp_" + m_sClzName + "_" + (ACCU_COMP_ID++).toString();
        }
        
        ///Will called when you entity.AddComponent(this)
        public function Create() : void
        {
            throw "Create have to be overrided";
        }
        
        public function Initial() : void 
        {
            throw "Initial have to be overrided";
        }

        public function Update() : void
        {
            throw "Update have to be overrided";
        }

        public function Release() : void
        {
            throw "Release have to be overrided";
        }
        
        //Final-----------------------------------------------------------------------
        ///return component的實體class package::name
        public final function GetClzName() : String
        {
            return m_sClzName;
        }
        
        public final function SetEntity(entity:INcEntity) : void
        {
            if (m_bSetEntityLock == true)
            {
                //return;
                throw "Can't Set entity more than once."
            }
            
            m_Entity = entity;
            m_bSetEntityLock = true;
        }
        
        public final function get Entity() : INcEntity
        {
            return m_Entity;
        }
        
        public function get sID() : String { return m_sID; }
    }
}












