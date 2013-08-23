package nc.entity 
{
    import nc.virtual.INcComponent;
    import nc.virtual.INcEntity;
    import nc.virtual.INcComponent;
    import flash.utils.getQualifiedClassName;
	
    
	/**
     * Entity operating by it's ID, a entity don't have dupicate component.
     * @author Husky
     */
    public final class NcEntity implements INcEntity 
    {
        //private var m_sTag:String;
        
        ///the unique ID of entity
        private var m_sID:String;
        
        public function NcEntity(sID:String) 
        {
            m_sID = sID;
        }
        
        /**
         * Add component'S' in Entity
         * @param params ComponentA, ComponentB, ...
         */
        public function AddComponents(...params) : void
        {
            var vComp:Vector.<INcComponent> = Vector.<INcComponent>([]);
            var uiLength:uint = params.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                vComp.push(params[ui]);
            }
            
            NcEntityManager.Get().AddComponents(this, vComp);
        }
        
        public function RemoveComponent(clzComp:Class) : void
        {
            NcEntityManager.Get().RemoveComponent(this.ID, clzComp);
        }
        
        ///Auto cast as clz
        public function GetComponent(clz:Class) : *
        {
            //var sClzName:String = getQualifiedClassName(CHpComp);
            
            return NcEntityManager.Get().GetComponent(this.ID, clz);
        }
        
        public function InitialComponents() : void
        {
            var vComp:Vector.<INcComponent> = NcEntityManager.Get().GetComponents(this.ID);
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                vComp[ui].Initial();
            }
        }
        
        public function Release() : void
        {
            var entityMgr:NcEntityManager = NcEntityManager.Get();
            var vComp:Vector.<INcComponent> = entityMgr.GetComponents(this.ID);
            
            var uiLength:uint = vComp.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                vComp[ui].Release();
                vComp[ui] = null;
            }
            vComp.splice(0, uiLength);
            vComp = null;
        }
        
        public function get ID() : String
        {
            return m_sID;
        }
    }
}







