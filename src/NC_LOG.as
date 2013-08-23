package  
{
    import nc.entity.NcEntityManager;
	/**
     * NC_LOG
     * @author Husky
     */
    public function NC_LOG(sMessage:String) :void
    {
        //CONFIG::NO_LOGGER
        //{
            //return;
        //}
        
        //CONFIG::DEBUGGER
        //{
            //var debugger:BPDebugger = NcEntityManager.Get().GetComponent(BPDebugger) as BPDebugger;
            //debugger.NC_LOG(sMessage);
        //}
        
        var sLoc:String = new Error().getStackTrace().match( /(?<=\/|\\)\w+?.as:\d+?(?=])/g )[1].replace( ":" , ", line " );
        trace(">" + sLoc + ":");
        trace(sMessage);
    }
}