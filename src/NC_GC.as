package  
{
    import flash.net.LocalConnection;
	/**
     * Immediate do garbage collection
     * @author Husky
     */
    public function NC_GC() : void
    {
        try
        {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
        } 
        catch (e:Error) {}
    }
}