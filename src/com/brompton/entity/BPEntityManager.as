package com.brompton.entity 
{
    import com.brompton.virtual.IBPComponent;
    import com.brompton.virtual.IBPEntity;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
	/**
     * ...
     * @author Husky
     */
    public final class BPEntityManager extends EventDispatcher
    {
        private static var ms_Instance:BPEntityManager;
        
        ///Dictionary of entitys ID mapping Component Vector.
        private var m_mapEntityComps:Dictionary;
        
        private var m_uiAccuID:uint;

        //Component Methods--------------------------------------------------------------------------
        /**
         * Add component'S' in Entity
         * @param entity    Entity
         * @param vCompParam  Components
         */
        public function AddComponents(entity:IBPEntity, vCompParam:Vector.<IBPComponent>) : void
        {
            var vComp:Vector.<IBPComponent> = this.GetComponents(entity.ID);
            
            var uiLength:uint = vCompParam.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (this.HasThisComponent(entity.ID, vCompParam[ui]) == true)
                {
                    continue;
                }
                
                //Create, set entity and push
                vCompParam[ui].Create();
                
                vCompParam[ui].SetEntity(entity);
                vComp.push(vCompParam[ui]);
            }
        }
        
        /**
         * Get clzComp Component of entity
         * @param uiEntityID entity ID
         * @param clzComp component class    
         * @return
         */
        public function GetComponent(uiEntityID:uint, clzComp:Class) : IBPComponent
        {
            var vComp:Vector.<IBPComponent> = this.GetComponents(uiEntityID);
            
            //cause comps of entity can't be dupicate, if find return.
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (vComp[ui] is clzComp == false)
                {
                    continue;
                }
                
                return vComp[ui];
            }
            
            return null;
        }
        
        /**
         * Get all components of entity
         * @param uiEntityID entity ID
         * @return
         */
        public function GetComponents(uiEntityID:uint) : Vector.<IBPComponent>
        {
            return m_mapEntityComps[uiEntityID];
        }
        
        /**
         * Check if the class type entity already had.
         * @param uiEntityID
         * @param objComp
         * @return
         */
        private function HasThisComponent(uiEntityID:uint, objComp:Object) : Boolean
        {
            //Get the class of objComp
            var clzComp:Class = Class(getDefinitionByName(getQualifiedClassName(objComp)));
            var vComp:Vector.<IBPComponent> = this.GetComponents(uiEntityID);
            
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (vComp[ui] is clzComp == false)
                {
                    continue;
                }
                
                return true;
            }
            
            return false;
        }
        
        //Entity Methods--------------------------------------------------------------------------
        
        public function CreateEntity() : IBPEntity
        {
            var entity:BPEntity = new BPEntity(this.GetUniqueID());
            m_mapEntityComps[entity.ID] = Vector.<IBPComponent>([]);
            
            return entity;
        }
        
        public function ReleaseEntity(entity:IBPEntity) : void
        {
            entity.Release();
            delete m_mapEntityComps[entity.ID];
            entity = null;
        }
        
        //---------------------------------------------------------------------------------------
        ///FIXME **Need a safe method to do this.**
        private function GetUniqueID() : uint
        {
            return m_uiAccuID++;
        }
        
        //public function Initial() : void
        //{
            //
        //}
        
        public function Create() : void
        {
            m_uiAccuID = 0;
            m_mapEntityComps = new Dictionary();
        }
        
        public function Update() : void
        {
            ///XXX need priority of Components?
            for each (var vComp:Vector.<IBPComponent> in m_mapEntityComps)
            {
                var uiLength:uint = vComp.length;
                for (var ui:uint = 0; ui < uiLength; ui++)
                {
                    vComp[ui].Update();
                }
            }
        }
        
        //public function Release() : void
        //{
            //
        //}
        
        public function BPEntityManager(proxy:CSingletonProxy)
        {
            if (proxy == null) 
            {
                throw new Error("Singleton create error.");
            }
        }
        
        public static function Get() : BPEntityManager
        {
            if (!ms_Instance)
            {
                ms_Instance = new BPEntityManager(new CSingletonProxy());
            }
            
            return ms_Instance;
        }
        
    }

}

class CSingletonProxy{}