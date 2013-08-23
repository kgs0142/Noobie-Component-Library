package nc.util
{
	/**
	 * 以 AS3 實作類似 NcEnum 功能的 class
	 * 
	 * @example 以下程式示範如何在一個 class 中定義一組 NcEnum
	 * <listing version="3.0">
	 * 	public class Character {
	 * 	
	 * 		private static var TYPES:NcEnum = new NcEnum();
	 * 
	 * 		public static const TYPE_KNIGHT:int = TYPES.nextIndex(); 
	 * 
	 * 		public static const TYPE_WIZARD:int = TYPES.nextIndex(); 
	 * 
	 * 		public static const TYPE_PRIEST:int = TYPES.nextIndex(); 
	 * 	}
	 * </listing>
	 */	
	public class NcEnum
	{
		private var pNumEnums:int;
		
		public function NcEnum(base:int=0)
		{
			pNumEnums = base;
		} 
		
		/**
		 * 取得下一個 NcEnum 號碼
		 *  
		 * @return 下一個 NcEnum 號碼
		 * 
		 */		
		public function nextIndex():int
		{
			return pNumEnums++;
		}
		
		/**
		 * 取得目前給出的 NcEnum 號碼數量
		 *  
		 * @return 目前給出的 NcEnum 號碼數量
		 * 
		 */		
		public function get NUM_NcEnumS():int
		{
			return pNumEnums;
		}
	}
}