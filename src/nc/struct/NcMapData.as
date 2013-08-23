package nc.struct 
{
	/**
     * ...
     * @author Husky
     */
    public class NcMapData 
    {
        private var m_objData:Object;
        
        public function NcMapData() 
        {
            m_objData = {};
        }
        
        public function HasKey(sKey:String):Boolean
		{
			return m_objData.hasOwnProperty(sKey);
		}
        
		public function RemoveKey(sKey:String):void
		{
			delete m_objData[sKey];
		}

		public function Clear():void
		{
			m_objData = {};
		}
		
		public function SetValue(sKey:String, value:Object):void
		{
			m_objData[sKey] = value;
		} 

		public function GetValue(sKey:String):Object
		{
			if(m_objData.hasOwnProperty(sKey))
				return m_objData[sKey];
			return null;
		}

		public function GetBoolean(sKey:String):Boolean
		{
			return Boolean(GetValue(sKey));
		}

		public function GetInt(sKey:String):int
		{
			return int(GetValue(sKey));
		}

        public function GetUInt(sKey:String):uint
		{
			return uint(GetValue(sKey));
		}
        
		public function GetNumber(sKey:String):Number
		{
			return Number(GetValue(sKey));
		}

		public function GetString(sKey:String):String
		{
			var value:Object = GetValue(sKey);
			if(value != null)
				return String(value);
			return null;
		}
    }

}