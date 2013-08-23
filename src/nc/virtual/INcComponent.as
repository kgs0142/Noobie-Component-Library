package nc.virtual 
{
    /**
     * Interface of Component class
     * @author Husky
     */
    public interface INcComponent 
    {
        function Initial() : void;
        
        ///Will called when you entity.AddComponent(this)
		function Create() : void;
		
        function Update() : void;
        
        function Release() : void;
        
        //Shouldn't open the method?
        //FIXME Should restrict.
        function SetEntity(entity:INcEntity) : void;
        function get Entity() : INcEntity;
        
        ///FIXME really need this?
        function GetClzName() : String;
        
        function get sID() : String;
    }
}