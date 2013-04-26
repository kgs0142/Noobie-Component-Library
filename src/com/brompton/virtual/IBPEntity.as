package com.brompton.virtual 
{
    
    /**
     * Interface of Entity class
     * @author Husky
     */
    public interface IBPEntity 
    {
        function Release() : void
        
        function AddComponents(...params) : void;
        
        function RemoveComponent(clz:Class) : void;
        
        function GetComponent(clz:Class) : IBPComponent;
        
        function get ID() : uint;
    }
}