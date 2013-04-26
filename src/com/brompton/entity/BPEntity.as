package com.brompton.entity 
{
    import com.brompton.virtual.IBPComponent;
    import com.brompton.virtual.IBPEntity;
    import com.brompton.virtual.IBPComponent;
    import flash.utils.getQualifiedClassName;
	
    
	/**
     * Entity operating by it's ID, a entity don't have dupicate component.
     * @author Husky
     */
    public final class BPEntity implements IBPEntity 
    {
        //private var m_sTag:String;
        
        ///the unique ID of entity
        private var m_uiID:uint;
        
        public function BPEntity(uiID:uint) 
        {
            m_uiID = uiID;
        }
        
        /**
         * Add component'S' in Entity
         * @param params ComponentA, ComponentB, ...
         */
        public function AddComponents(...params) : void
        {
            var vComp:Vector.<IBPComponent> = Vector.<IBPComponent>([]);
            var uiLength:uint = params.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                vComp.push(params[ui]);
            }
            
            BPEntityManager.Get().AddComponents(this, vComp);
        }
        
        public function RemoveComponent(clz:Class) : void
        {
            
        }
        
        public function GetComponent(clz:Class) : IBPComponent
        {
            //var sClzName:String = getQualifiedClassName(CHpComp);
            
            return BPEntityManager.Get().GetComponent(this.ID, clz);
        }
        
        public function Release() : void
        {
            var entityMgr:BPEntityManager = BPEntityManager.Get();
            var vComp:Vector.<IBPComponent> = entityMgr.GetComponents(this.ID);
            
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                vComp[ui].Release();
                vComp[ui] = null;
            }
            vComp.splice(0, uiLength);
            vComp = null;
        }
        
        public function get ID() : uint
        {
            return m_uiID;
        }
    }
}







