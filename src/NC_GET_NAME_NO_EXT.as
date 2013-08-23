package  
{
	/**
     * return the asset name without extention and path
     * @author Husky
     */
    public function NC_GET_NAME_NO_EXT(sFullString:String) : String
    {
        var iLastDash:int = sFullString.lastIndexOf("/");
        var iLastDot:int = sFullString.lastIndexOf(".");
        
        //Get the file name without extension
        return sFullString.slice(iLastDash + 1, iLastDot);
    }
}