package nc.system 
{
    import nc.component.system.NcMessageOfficer;
    import nc.entity.NcEntityManager;
    import nc.virtual.INcEntity;
    
	/**
     * All The systems
     * @author Husky
     */
    public class NcSystems
    {
        private static var ms_Instance:INcEntity;
        
        public function NcSystems()
        {
        }
        
        public static function Get() : INcEntity
        {
            if (!ms_Instance)
            {
                //ms_Instance = new NcSystems(new CSSingletonProxy());
                ms_Instance = NcEntityManager.Get().CreateEntity();
            }
            
            return ms_Instance;
        }
    }
}

