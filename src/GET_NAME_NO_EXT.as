package  
{
	/**
     * return the name without extention and path
     * @author Husky
     */
    public function GET_NAME_NO_EXT(sFullString:String) : String
    {
        var iLastDash:int = sFullString.lastIndexOf("/");
        var iLastDot:int = sFullString.lastIndexOf(".");
        
        //Get the file name without extension
        return sFullString.slice(iLastDash + 1, iLastDot);
    }
}