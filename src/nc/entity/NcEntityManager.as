package nc.entity 
{
    import nc.virtual.INcComponent;
    import nc.virtual.INcEntity;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
	/**
     * ...
     * @author Husky
     */
    public final class NcEntityManager extends EventDispatcher
    {
        private static var ms_Instance:NcEntityManager;
        
        ///Dictionary of entity ID mapping Component Vector.
        private var m_mapEntityComps:Dictionary;
        ///Dictionary of component type mapping entitys' IDs.
        //private var m_mapCompEntitys:Dictionary;
        
        private var m_uiAccuID:uint;

        //Component Methods--------------------------------------------------------------------------
        /**
         * Add component'S' in Entity
         * @param entity    Entity
         * @param vCompParam  Components
         */
        public function AddComponents(entity:INcEntity, vCompParam:Vector.<INcComponent>) : void
        {
            var vComp:Vector.<INcComponent> = this.GetComponents(entity.ID);
            
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
        
        public function RemoveComponent(sEntityID:String, clzComp:Class) : void
        {
            var vComp:Vector.<INcComponent> = this.GetComponents(sEntityID);
            
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (vComp[ui] is clzComp == false)
                {
                    continue;
                }
                
                vComp[ui].Release();
                vComp[ui] = null;
                vComp.splice(ui, 1);
                return;
            }
        }
        
        /**
         * Get clzComp Component of entity, auto cast as clz
         * @param sEntityID entity ID
         * @param clzComp component class    
         * @return
         */
        public function GetComponent(sEntityID:String, clzComp:Class) : *
        {
            var vComp:Vector.<INcComponent> = this.GetComponents(sEntityID);
            
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
         * @param sEntityID entity ID
         * @return
         */
        public function GetComponents(sEntityID:String) : Vector.<INcComponent>
        {
            return m_mapEntityComps[sEntityID];
        }
        
        /**
         * Check if the class type entity already had.
         * @param sEntityID
         * @param objComp
         * @return
         */
        private function HasThisComponent(sEntityID:String, objComp:Object) : Boolean
        {
            //Get the class of objComp
            var clzComp:Class = Class(getDefinitionByName(getQualifiedClassName(objComp)));
            var vComp:Vector.<INcComponent> = this.GetComponents(sEntityID);
            
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (vComp[ui] is clzComp == false)
                {
                    continue;
                }
                
                NC_LOG("Eid: " + sEntityID + ", duplicate component: " + vComp[ui]);
                
                return true;
            }
            
            return false;
        }
        
        //Entity Methods--------------------------------------------------------------------------
        
        public function CreateEntity() : INcEntity
        {
            var entity:NcEntity = new NcEntity(this.GetUniqueID());
            m_mapEntityComps[entity.ID] = Vector.<INcComponent>([]);
            
            return entity;
        }
        
        public function ReleaseEntity(entity:INcEntity) : void
        {
            entity.Release();
            delete m_mapEntityComps[entity.ID];
            entity = null;
        }
        
        //---------------------------------------------------------------------------------------
        ///FIXME **Need a safe method to do this.**
        private function GetUniqueID() : String
        {
            return "entity_" + m_uiAccuID++;
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
            for each (var vComp:Vector.<INcComponent> in m_mapEntityComps)
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
        
        public function NcEntityManager(proxy:CSingletonProxy)
        {
            if (proxy == null) 
            {
                throw new Error("Singleton create error.");
            }
        }
        
        public static function Get() : NcEntityManager
        {
            if (!ms_Instance)
            {
                ms_Instance = new NcEntityManager(new CSingletonProxy());
            }
            
            return ms_Instance;
        }
        
    }

}

class CSingletonProxy{}