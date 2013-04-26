package com.brompton.component 
{
	/**
     * ...
     * @author Husky
     */
    public class BPHpComp extends BPBaseComponent 
    {
        
        public function BPHpComp() 
        {
            
        }
        
        public override function Create() : void
        {
            trace("HP comp create");
        }
        
        public override function Update() : void
        {
            trace("HP comp Update");
        }
        
        public override function Release() : void
        {
            
        }
    }
}