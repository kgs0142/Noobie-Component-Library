package nc.struct 
{
	/**
     * ...
     * @author Husky
     */
    public class NcMessage 
    {
        protected var m_iMessageType:int;

        protected var m_cMapData:NcMapData;
        
        public function NcMessage(iMsgType:int) 
        {
            m_iMessageType = iMsgType;
            m_cMapData = new NcMapData();
        }
        
        public function SetKeyValue(key:String, value:Object):NcMessage
        {
            m_cMapData.SetValue(key, value);
            return this;
        }
        
        public function get data():NcMapData
        {
            return m_cMapData;
        }
        
        public function get iType():int
        {
            return m_iMessageType;
        }
    }
}