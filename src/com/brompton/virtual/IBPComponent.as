package com.brompton.virtual 
{
    /**
     * Interface of Component class
     * @author Husky
     */
    public interface IBPComponent 
    {
        function Initial() : void;
        
		function Create() : void;
		
        function Update() : void;
        
        function Release() : void;
        
        //Shouldn't open the method?
        //FIXME Should restrict.
        function SetEntity(entity:IBPEntity) : void;
        function get Entity() : IBPEntity;
        
        ///FIXME really need this?
        function GetClzName() : String;
    }
}