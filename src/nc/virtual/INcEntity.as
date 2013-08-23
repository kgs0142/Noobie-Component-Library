package nc.virtual 
{
    
    /**
     * Interface of Entity class
     * @author Husky
     */
    public interface INcEntity 
    {
        function Release() : void;
        
        ///Initial all the components
        function InitialComponents() : void;
        
        ///Add Components (compA, compB, ...)
        function AddComponents(...params) : void;
        
        function RemoveComponent(clz:Class) : void;
        
        function GetComponent(clz:Class) : *;
        
        function get ID() : String;
    }
}