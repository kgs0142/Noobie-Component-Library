package nc.component 
{
    import flash.utils.Dictionary;
    import nc.component.system.NcMessageOfficer;
    import nc.entity.NcEntityManager;
    import nc.struct.NcMessage;
    import nc.system.NcSystems;
	/**
     * The receiver part of message (NcSystems need add NcMessageOfficer first)
     * @author Husky
     */
    public class NcMessenger extends NcBaseComponent 
    {
        ///Key: msgType, Value:Vector.<Callback>
        private var m_SubscriberMap:Dictionary;
        
        private var m_ncMessageOfficer:NcMessageOfficer;
        
        public function NcMessenger() 
        {
            
        }
        
        public override function Create() : void
        {
            m_SubscriberMap = new Dictionary();
        }
        
        public override function Initial() : void 
        {
            m_ncMessageOfficer = NcSystems.Get().GetComponent(NcMessageOfficer);
            if (m_ncMessageOfficer == null)
            {
                NC_LOG("Don't have the NcMessageOfficer component.");
            }
        }
        
        public override function Update() : void
        {
            if (m_ncMessageOfficer == null)
            {
                return;
            }
            
            //Receiver msgs
            var vMsgs:Vector.<NcMessage> = m_ncMessageOfficer.GetMessages(this.Entity.ID);
            
            //notify all entity who has subscribe the matched msg type.
            for each (var ncMsg:NcMessage in vMsgs)
            {
                if (m_SubscriberMap.hasOwnProperty(ncMsg.iType) == false)
                {
                    continue;
                }
                
                var vSubscribeCallback:Vector.<Function> = m_SubscriberMap[ncMsg.iType];
                for each(var callback:Function in vSubscribeCallback)
                {
                    callback(ncMsg.data.GetString("sSenderID"), ncMsg);
                }
            } 
            
        }
        
        public function SendMessage(ncMessage:NcMessage) : void
        {
            if (m_ncMessageOfficer == null)
            {
                NC_LOG("Don't have the NcMessageOfficer component.");
                return;
            }
            
            //Add senderID (this entity's ID)
            ncMessage.SetKeyValue("sSenderID", this.Entity.ID);
            
            m_ncMessageOfficer.SendMessage(ncMessage);
        }
        
        /**
         * Subscribe message, will call fnCallBack when receive the message type.
         * @param sMsgType Message type
         * @param fnCallBack the id of subscriber, function(senderID:String, msg:NcMessage)
         */
        public function Subscribe(iMsgType:int, fnCallBack:Function) : void
        {
            if (m_SubscriberMap.hasOwnProperty(iMsgType) == false)
            {
                m_SubscriberMap[iMsgType] = Vector.<Function>([]);
            }
            
            //Callback must be unique, same as ID
            if (m_SubscriberMap[iMsgType].indexOf(fnCallBack) != -1)
            {
                return;
            }
            
            m_SubscriberMap[iMsgType].push(fnCallBack);
        }
        
        public function UnSubscribe(fnCallBack:Function) : void
        {
            for each (var vCallback:Vector.<Function> in m_SubscriberMap)
            {
                //fnCallBack is ID
                var index:int = vCallback.indexOf(fnCallBack);
                if (index == -1)
                {
                    continue;
                }
                
                vCallback.splice(index, 1);
            } 
        }
        
        public override function Release() : void
        {
            m_ncMessageOfficer = null;
            
            for (var key:Object in m_SubscriberMap)
            {
                delete m_SubscriberMap[key];
            }
            
            m_SubscriberMap = null;
        }
    }
}