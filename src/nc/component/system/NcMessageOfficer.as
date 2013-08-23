package nc.component.system 
{
	import nc.component.NcBaseComponent;
    import nc.struct.NcMessage;
	
	/**
     * The MessageOffice System
     * @author Husky
     */
    public class NcMessageOfficer extends NcBaseComponent 
    {
        //Msgbox use double buffer
        private var m_vMsgsA:Vector.<NcMessage>;
        private var m_vMsgsB:Vector.<NcMessage>;
        private var m_vCurMsgs:Vector.<NcMessage>;
        
        public function NcMessageOfficer() 
        {

        }
        
        public override function Create() : void
        {
            m_vMsgsA = Vector.<NcMessage>([]);
            m_vMsgsB = Vector.<NcMessage>([]);
            m_vCurMsgs = Vector.<NcMessage>([]);
        }
        
        public override function Initial() : void 
        {
        }
        
        public override function Update() : void
        {
            //Switch buffer, clean msgBox
            if (m_vCurMsgs == m_vMsgsA)
            {
                m_vCurMsgs = m_vMsgsB;
                m_vMsgsA.splice(0, m_vMsgsA.length);
                return;
            }
            
            m_vCurMsgs = m_vMsgsA;
            m_vMsgsB.splice(0, m_vMsgsB.length);
        }
        
        public function GetMessages(sEntityID:String) : Vector.<NcMessage>
        {
            var vMsgs:Vector.<NcMessage> = Vector.<NcMessage>([]);
            for each (var ncMsg:NcMessage in m_vCurMsgs)
            {
                if (ncMsg.data.GetString("sSenderID") == sEntityID)
                {
                    vMsgs.push(ncMsg);
                }
            }
            
            return vMsgs;
        }
        
        public function SendMessage(ncMessage:NcMessage) : void
        {
            if (m_vCurMsgs == m_vMsgsA)
            {
                m_vMsgsB.push(ncMessage);
                return;
            }
            
            m_vMsgsA.push(ncMessage);
        }
    }
}