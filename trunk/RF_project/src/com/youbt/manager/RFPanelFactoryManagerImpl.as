package com.youbt.manager
{
	import flash.utils.getQualifiedClassName;
	import com.youbt.manager.IPanelFactory;
	import com.youbt.controls.AbstractPanel;
	import flash.display.DisplayObjectContainer;
	import com.youbt.utils.HashMap;
	
	public class RFPanelFactoryManagerImpl implements IPanelFactory
	{
		
		private var factoryMap:HashMap;
		protected var isListenning:Boolean=false;
		public function RFPanelFactoryManagerImpl()
		{
		}
		
		private function getMap():HashMap{
			if(this.factoryMap==null){
				this.factoryMap=new HashMap();
			}
			return this.factoryMap;
		}
		
		public function addFactory(factory:IPanelFactory):void{
			var key:String=getQualifiedClassName(factory);
			if(this.getMap().getValue(key) !=null)return;
			
			this.getMap().put(key,factory);
			
			if(isListenning){
				factory.startListener();
			}
		}
		
		public function removeFactory(factory:IPanelFactory):IPanelFactory{
			var key:String=getQualifiedClassName(factory);
			if(this.getMap().getValue(key) ==null)return null;
			
			factory.clearListener();
			return this.getMap().remove(key) as IPanelFactory;
		}
		
		public function startListener():void{
			var list:Array=this.getMap().values();
			for each(var factory:IPanelFactory in list){
				factory.startListener();
			}
			
			isListenning=true;
		}
		
		public function clearListener():void{
			var list:Array=this.getMap().values();
			for each(var factory:IPanelFactory in list){
				factory.clearListener();
			}
			
			isListenning=false;
		}
		public function dispose():void{
			this.clearListener();
			this.factoryMap=null;
		}
		
		public function newInstance():AbstractPanel{
			return null;
		}
		
		public function setContainer(container:DisplayObjectContainer):void{
			
		}

	}
}