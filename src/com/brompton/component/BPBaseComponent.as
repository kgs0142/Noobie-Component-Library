package com.brompton.component 
{
    import com.brompton.virtual.IBPComponent;
    import com.brompton.virtual.IBPEntity;
    import flash.utils.getQualifiedClassName;
    import com.brompton.util.bplib;
	/**
     * ...
     * @author Husky
     */
    public class BPBaseComponent implements IBPComponent 
    {
        ///the owner of components.
        protected var m_Entity:IBPEntity;
        
        private var m_sClzName:String;
        
        private var m_bSetEntityLock:Boolean;
        
        public function BPBaseComponent() 
        {
            m_Entity = null;
            m_sClzName = getQualifiedClassName(this);
        }
        
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
        
        public final function SetEntity(entity:IBPEntity) : void
        {
            if (m_bSetEntityLock == true)
            {
                //return;
                throw "Can't Set entity more than once."
            }
            
            m_Entity = entity;
            m_bSetEntityLock = true;
        }
        
        public final function get Entity() : IBPEntity
        {
            return m_Entity;
        }
    }
}












