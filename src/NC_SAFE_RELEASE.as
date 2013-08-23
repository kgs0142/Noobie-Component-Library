package 
{
	/**
     * Safe release obj. if obj != null, try call obj.Release(), set obj = null;
     * Cause as3 has no pointer, still need to set obj = null out of the function.
     * @author Husky
     */
    public function NC_SAFE_RELEASE(obj:Object) : void
    {
        if (obj == null)
        {
            return;
        }
        
        //try call obj.Release
        if (obj.hasOwnProperty("Release"))
        {
            obj["Release"]();
        }
        
        obj = null;
    }
}