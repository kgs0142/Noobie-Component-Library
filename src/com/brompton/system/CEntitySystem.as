package com.brompton.system 
{
    import com.brompton.entity.BPEntityManager;
    import com.brompton.virtual.IBPEntity;
	/**
     * All The systems
     * @author Husky
     */
    public class CEntitySystem
    {
        private static var ms_Instance:IBPEntity;
        
        public function CEntitySystem()
        {
        }
        
        public static function Get() : IBPEntity
        {
            if (!ms_Instance)
            {
                //ms_Instance = new CEntitySystem(new CSSingletonProxy());
                ms_Instance = BPEntityManager.Get().CreateEntity();
            }
            
            return ms_Instance;
        }
    }
}

