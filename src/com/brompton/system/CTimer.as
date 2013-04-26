package com.brompton.system
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    ///負責所有的ENTER_FRAME、Timer UPDATE 需求，
    public final class CTimer
    {
        //把物件本身拿來當註冊的ID
        //private var m_csID:Object;
        private var m_arrRegister:Vector.<Object>;
        
        //這個Frame的MS - 前個Frame的MS = 更新的間隔時間
        private var m_uiPrevFrameMS:uint;
        private var m_uiCurFrameMS:uint;
        private var m_uiLatencyMS:uint;
        
        private var m_csDispatcher:Sprite;
        
        //是否運作中
        private var m_bStart:Boolean;
        
        private static var ms_Instance:CTimer;
        
        //開始Timer
        public function start() : void
        {
            m_bStart = true;
            if (m_csDispatcher.hasEventListener(Event.ENTER_FRAME) == true)
            {
                return;
            }
            
            m_csDispatcher.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
        }
        
        //停止Timer
        public function stop() : void
        {
            m_bStart = false;
            m_csDispatcher.removeEventListener(Event.ENTER_FRAME, update);
        }
        
        //更新所有的Update
        public function update(e:Event = null) : void
        {
            m_uiCurFrameMS = getTimer();
            m_uiLatencyMS = m_uiCurFrameMS - m_uiPrevFrameMS;
            
            //FIXME 這邊留意，如果物件在自己註冊的Update中移除了監聽，也許會發生問題
            //之後看情況是否修改成"要求被移除，再統一移除"
            
            //m_arrRegister.length隨時會因為有人反註冊變動，這邊不能取常數接
            //var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < m_arrRegister.length; ui++)
            {
                m_arrRegister[ui].m_uiAccuPeriod += m_uiLatencyMS;
                //會不斷累積的Counter，LifeTime的判斷用
                m_arrRegister[ui].m_uiConstAccuPeriod += m_uiLatencyMS;
                
                //如果有生命週期
                //if (m_arrRegister[ui].m_uiLifeTime != 0 && 
                    //m_arrRegister[ui].m_uiConstAccuPeriod >= m_arrRegister[ui].m_uiLifeTime)
                //{
                    //m_arrRegister[ui]["m_fooComplete"]();
                    //
                    //this.unRegister(m_arrRegister[ui].m_objID);
                    //continue;
                //}
                
                //Timer的Period Time判斷
                if (m_arrRegister[ui].m_uiAccuPeriod < m_arrRegister[ui].m_uiPeriod)
                {
                    continue;
                }
                
                m_arrRegister[ui].m_uiAccuRepeat++;
                m_arrRegister[ui].m_uiAccuPeriod = 0;
                var fooUpdate:Function = m_arrRegister[ui].m_fooUpdate;
                
                //重複次數判斷
                //if (m_arrRegister[ui].m_uiRepeat != 0 && 
                    //m_arrRegister[ui].m_uiAccuRepeat > m_arrRegister[ui].m_uiRepeat)
                //{
                    //m_arrRegister[ui]["m_fooComplete"]();
                    //
                    //this.unRegister(m_arrRegister[ui].m_objID);
                    //continue;
                //}
                
                //Call update function
                fooUpdate();
            }
            
            var objRegister:Object;
            //需要移除註冊的Register
            var arrUnRegister:Vector.<Object> = Vector.<Object>([]);
            
            //更新完後，判斷哪些register需要移除
            for each (objRegister in m_arrRegister)
            {
                //如果有生命週期
                if (objRegister["m_uiLifeTime"] != 0 && 
                    objRegister["m_uiConstAccuPeriod"] >= objRegister["m_uiLifeTime"])
                {
                    objRegister["m_fooComplete"]();
                    
                    arrUnRegister.push(objRegister);
                    //this.unRegister(objRegister["m_objID"]);
                    continue;
                }
                
                //重複次數判斷
                if (objRegister["m_uiRepeat"] != 0 && 
                    objRegister["m_uiAccuRepeat"] >= objRegister["m_uiRepeat"])
                {
                    objRegister["m_fooComplete"]();
                    
                    arrUnRegister.push(objRegister);
                    //this.unRegister(objRegister["m_objID"]);
                    continue;
                }
            }
            
            //然後移除
            for each (objRegister in arrUnRegister)
            {
                this.unRegister(objRegister["m_objID"]);
            }
            
            m_uiPrevFrameMS = m_uiCurFrameMS;
        }
        
        /**
         * Get Remaining Repeat Update Times
         * @param	objID
         * @return  0 -> no assign repeat
         */
        public function getRRTimes(objID:Object) : int
        {
            var iResult:int = -1;
            var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_arrRegister[ui]["m_objID"] != objID)
                {
                    continue;
                }
                
                iResult = (m_arrRegister[ui]["m_uiRepeat"] == 0) ? -1 :
                           m_arrRegister[ui]["m_uiRepeat"] - m_arrRegister[ui]["m_uiAccuRepeat"]
                
                return iResult;
            }
            
            return iResult;
        }
        
        ///跳過多少時間->所有註冊者的倒數時間都被縮減(只有指定repeat 次數的會有效）
        public function speedUp(uiSkipMS:uint) : void
        {
            var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_arrRegister[ui]["m_uiRepeat"] == 0)
                {
                    continue;
                }
                
                m_arrRegister[ui]["m_uiAccuRepeat"] += int(uiSkipMS/m_arrRegister[ui]["m_uiPeriod"]);
            }
        }
        
        /**
         * 註冊ENTER_FRAME structure
         * @param	objID 把要監聽Enter_Frame事件的物件拿來當ID
         * @param	fooUpdate ENTER_FRAME的update function
         * @param   uiPeriod 更新的時間間隔，單位是MS
         * @param   uiRepeat 重複次數, 0 代表重複
         * @param   uiLifeTime 生命週期，時間到就一定釋放該資源
         * @param   fooComplete Timer結束時會呼叫的function
         * @param	uiPriority 優先權，目前沒做
         */
        public function register(objID:Object, fooUpdate:Function, uiPeriod:uint = 0, uiRepeat:uint = 0, 
                                 uiLifeTime:uint = 0, fooComplete:Function = null, uiPriority:uint = 0) : void
        {
            var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_arrRegister[ui].m_objID == objID)
                {
                    return;
                }
            }
            
            var fooComplete:Function = (fooComplete == null) ? function () : void {} : fooComplete;
            
            //m_uiAccuPeriod 是用來累積更新間隔時間的
            var obj:Object = {"m_objID": objID, "m_fooUpdate": fooUpdate, 
                              "m_uiPeriod": uiPeriod, "m_uiAccuPeriod": 0,
                              "m_uiConstAccuPeriod": 0, "m_uiRepeat": uiRepeat, 
                              "m_uiLifeTime": uiLifeTime, "m_uiAccuRepeat": 0,
                              "m_fooComplete": fooComplete};
            m_arrRegister.push(obj);
        }
        
        /**
         * 反註冊
         * @param	objID 把要監聽Enter_Frame事件的物件拿來當ID
         */
        public function unRegister(objID:Object) : void
        {
            var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_arrRegister[ui].m_objID != objID)
                {
                    continue;
                }
                
                m_arrRegister.splice(ui, 1);
                return;
            }
        }
        
        public function hasRegister(objID:Object) : Boolean
        {
            var uiLength:uint = m_arrRegister.length;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                if (m_arrRegister[ui].m_objID != objID)
                {
                    continue;
                }
                
                return true;
            }
            return false;
        }
        
        public function CTimer(proxy:CSSingletonProxy) 
		{
			if (proxy == null) 
			{
				throw new Error("Singleton create error.");
			}
            
            m_uiCurFrameMS = getTimer();
            m_uiPrevFrameMS = m_uiCurFrameMS;
            m_arrRegister = new Vector.<Object>();
            m_csDispatcher = new Sprite();
        }
        
        public static function Get() : CTimer
		{
			if (!ms_Instance)
			{
				ms_Instance = new CTimer(new CSSingletonProxy());
			}
			
			return ms_Instance;
		}
        
        ///return MS
        public function getUpdateLatency() : uint { return m_uiLatencyMS; }
        
        public function get bStart() : Boolean { return m_bStart; }
    }   
}

/**Just for create a singleton class*/
class CSSingletonProxy{}