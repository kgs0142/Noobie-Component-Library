package nc.util
{
    /**
     * Bit flag for many boolean using need
     * @author Husky
     */
    public class NcBitFlag
    {
        protected var m_arrBits:Vector.<uint> = Vector.<uint>([]);
       
        /**
         * Bit flag的建構式
         * @param    uiLength 會推入幾個uint到陣列中(as3一個uint 4 bytes = 32個可以用的boolean)
         */
        public function NcBitFlag(uiLength:uint)
        {
            for (var ui:uint; ui < uiLength; ui++)
            {
                m_arrBits.push(uint);
            }
        }
       
        ///用現成的Vecotr.<uint>來create
        //public function loadVector(arrUint:Vector.<uint>) : void
        //{
            //if (arrUint == null)
            //{
                //return;
            //}
            //
            //m_arrBits.splice(0, m_arrBits.length);
            //for (var ui:uint; ui < arrUint.length; ui++)
            //{
                //m_arrBits.push(arrUint[ui]);
            //}
        //}
        
        ///index of uint array
        public function check(uiPos:uint) : Boolean
        {
            var uiArrIndex:uint = Math.floor(uiPos/32);
            var uiBitIndex:uint = uiPos%32;
           
            return (m_arrBits[uiArrIndex] & (1 << uiBitIndex)) > 0 ? true : false;
        }
       
        ///set bit on
        public function bitOn(uiPos:uint) : void
        {
            var uiArrIndex:uint = Math.floor(uiPos/32);
            var uiBitIndex:uint = uiPos%32;
           
            m_arrBits[uiArrIndex] = m_arrBits[uiArrIndex] | 1 << uiBitIndex;
        }
        
        //set bit off
        public function bitOff(uiPos:uint) : void
        {
            var uiArrIndex:uint = Math.floor(uiPos/32);
            var uiBitIndex:uint = uiPos%32;
           
			m_arrBits[uiArrIndex] = m_arrBits[uiArrIndex] & ~(1 << uiBitIndex);
        }
        
        public function get arrBits():Vector.<uint> { return m_arrBits; }
        public function set arrBits(value:Vector.<uint>) : void { m_arrBits = value; }
    }
}