package com.youbt.debug
{
	import com.youbt.core.RFSprite;
	import com.youbt.effects.effectClass.MoveEffect;
	import com.youbt.events.TweenEvent;
	import com.youbt.manager.RFSystemManager;
	import com.youbt.utils.Base64Decoder;
	import com.youbt.utils.Base64Encoder;
	import com.youbt.utils.DateUtils;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	[ExcludeClass]
	
	public class DebugConsole extends RFSprite
	{
		
		public var show:Boolean=false
		private var txt:TextField;
		private var txtformat:TextFormat
		private var txtinput:TextField;
		
		//private var gl:GlowFilter=new GlowFilter(0xffffff,1,2,2,1,1)
		
		
		
		public function DebugConsole(st:Stage)
		{
			
			if(_instance){
				return;
			}
			
			if(!st){
				throw (new Error("must specific stage"));
				return
			}
			
			this.graphics.beginFill(0x000000,0.5)
			this.graphics.drawRect(0,0,st.stageWidth,st.stageHeight/3)
			this.graphics.endFill()
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedHandler)
			st.addChild(this)
			txtformat=new TextFormat()
			txtformat.size=14
			txt=new TextField()
			txt.width=st.stageWidth
			txt.height=st.stageHeight/3-30
			txt.multiline=true;
			txt.wordWrap=true;
			txt.textColor=0xffffff
			
			txtinput=new TextField()
			txtinput.width=st.stageWidth
			txtinput.height=30;
			txtinput.backgroundColor=0x000000
			txtinput.textColor=0xffffff
			
			
			txtinput.y=st.stageHeight/3-30
			
			txtinput.defaultTextFormat=txtformat;
			txtinput.type=TextFieldType.INPUT;
			txtinput.addEventListener(FocusEvent.FOCUS_IN,focusInHandler)
			txtinput.text="";
			txtinput.setSelection(txtinput.text.length,txtinput.text.length)
			txtinput.restrict="A-Z a-z 0-9 \\. \\( \\) \\- \\_ \\' \\: \\, \\/ \\=";
			this.addChild(txt)
			this.addChild(txtinput)
			
			super.visible=false;
			
			
		}
		
		private function focusInHandler(e:FocusEvent):void
		{
			this.stage.focus=this.txtinput;
		}
		
		
		private function addedHandler(e:Event):void{
			
			this.stage.addEventListener(Event.RESIZE,resizeHandler)
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler)
			
		}
		
		private function keyHandler(e:KeyboardEvent):void
		{
			if(e.keyCode==_showcutkey){
				if(this.show){
					DebugConsole.hide()
				}else{
					DebugConsole.show()
				}
			}else if(e.keyCode==13){
				if(!this.show){
					return
				}
				if(stage){
					if(stage.focus==this.txtinput){
						runcommand(this.txtinput.text)
						if(inputs.length>max){
								inputs.shift()
						}
						inputs.push(this.txtinput.text)
						this.txtinput.text="";
						this.txtinput.setSelection(this.txtinput.text.length,this.txtinput.text.length)
					}
				}
				
			}else if(e.keyCode==38){
				if(!this.show){
					return
				}
				if(cursor>=0 && inputs.length>0){
					e.stopImmediatePropagation()
					if(cursor>0){
						cursor--;
					}
					this.txtinput.text=inputs[cursor]
					
					this.txtinput.setSelection(this.txtinput.text.length,this.txtinput.text.length)
				}
				
			}else if(e.keyCode==40){
				if(!this.show){
					return
				}
				if(cursor<inputs.length-1){
					e.stopImmediatePropagation()
					cursor++
					this.txtinput.text=inputs[cursor];
				//	trace('111'+this.txtinput.text.length+"/"+cursor)
					
					this.txtinput.setSelection(this.txtinput.text.length,this.txtinput.text.length)
				}
			}
		}
		private var cursor:int=0;
		private var inputs:Array=[]
		private var max:int=15;
		/**
		 * running command
		 * support registered command 
		 * support running time command 
		 * @param str
		 * 
		 */		
		private function runcommand(str:String):void
		{
			if(str.length==0){
				return;
			}
			
			
			trace(">>"+str)
			var cmds:Array=str.split(" ")
			var cmdstr:String=cmds[0];
			
			var margs:Array
			if(cmds.length>1){
				margs=cmds[1].split(",")
			}
			var cmd:Cmd=list[cmdstr]
			if(cmd){
					cmd.apply(margs)		
			}else{
				
				
				var oa:Array=str.split("::")
				
				if(oa.length<2){
					trace("Unkonwn command,/help for help");
					return;
				}
				var str1:String=oa[1]
				
				
				var oa2:Array=str1.split(".");
				
				var classname:String
				
				try{
					
				
				
				if(oa2.length==1){
					classname=oa[0]+"::"+oa2[0];
					trace(getDefinitionByName((classname)).toString())
				}else{
					classname=oa[0]+"::"+oa2[0];
					var i:int=1
					var lastobj:Object;
					var lastfunc:Boolean=false;
					var j:int=oa2[oa2.length-1].lastIndexOf("=")
					var equal:Boolean=false
					var value:Object
					if(j!=-1){
						equal=true
						value=oa2[oa2.length-1].slice(j+1)
						oa2[oa2.length-1]=oa2[oa2.length-1].slice(0,j)
					}
					
					while(i<oa2.length){
						var stl:String=oa2[i]
						var t0:int=stl.lastIndexOf(")")
						var t1:int=stl.lastIndexOf("(")
						
						if(t0>-1 || t1>-1){
							var args:Array
							if(t0-t1>1){
								args=stl.slice(t1+1,t0).split(",")
							}
							stl=stl.slice(0,t1)
						}
						var func:Function
						var robj:Object;
							
						if(!lastobj){
							robj=getDefinitionByName(classname)[stl]
						}else{
							robj=lastobj[stl]
						}
						if(robj){
							if(robj is Function){
								func=robj as Function
								lastobj=func.apply(this,args)
								lastfunc=true
							}else{
								lastfunc=false
							}
						}
						i++
					}
					if(robj){
						if(equal){
							lastobj[stl]=value;
							DebugConsole.trace("old val:"+robj.toString()+" new val:"+lastobj[stl])
						}else{
							DebugConsole.trace(robj.toString())
						}
						
					}else{
						if(lastfunc){
							
						}else{
							trace("Unknown command or No return value");
						}
						
					}
				
				}
				}catch(e:Error)
				{
					trace("Unknown command or Exception"+e.toString()+"\r , /help for help ")
				}
				
			}
			

		}
		private function resizeHandler(e:Event):void
		{
			
			this.graphics.clear()	
			this.graphics.beginFill(0x000000,0.5)
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight/3)
			this.graphics.endFill()	
			txt.width=stage.stageWidth
			txt.height=stage.stageHeight/3-30
			
			txtinput.y=stage.stageHeight/3-30
			txtinput.width=stage.stageWidth
			refresh(null)
		}
		/**
		 * refresh console 
		 * 
		 */		
		public function refresh(str:String):void
		{
			if(stage){
				stage.setChildIndex(this,stage.numChildren-1)
			}
			if(!str){
				if(debug_info.length>0){
					str=debug_info;
					_instance.txt.htmlText+=debug_info
					debug_info="";
				}
			}else{
				_instance.txt.htmlText+=str;	
			}
			
			
			
			txt.scrollV=txt.bottomScrollV
			txtinput.setSelection(txtinput.text.length,txtinput.text.length)
		}
		private var savedmessage:String;
		
		
		private static var debug_info:String="RF Debug Console,/help for help";
		
		private static var _instance:DebugConsole
		
		private static var _showcutkey:int=192
		
		private static function set showcutkey(vl:int):void
		{
			_showcutkey=vl
		} 
		public static function trace(obj:Object,show:Boolean=false):void
		{
			var str:String=debug_info
			if(_instance){
				if(_instance.show || show){
					_instance.refresh(obj.toString()+"<BR>")
					return;
				}	
			}
			debug_info+=obj.toString()+"<BR>";
			str=debug_info
		}
		public static function init(stage:Stage,show:Boolean=false,expired:Object=null):void
		{
			if(!_instance){
				_instance=new DebugConsole(stage)
				if(show){
					_instance.visible=show
				}
				
				registerCommand("/help",_instance.help,"","help")
				registerCommand("/set",_instance.showEviro,"","view runtime evniroment of the console")
				registerCommand("/list",_instance.showCmd,"","view all registered commands")
				registerCommand("/cls",_instance.clear,"","clear all outputs")
				registerCommand("/dump",null,"","to do ")
				registerCommand("/screenshot",null,"","to do")
				
				var b:Boolean=false;
				
				if(expired){
					flash.net.registerClassAlias("exp",Cmd0)
					try{
						var de:Base64Decoder=new Base64Decoder()
						de.decode(String(expired))
						var ba:ByteArray=de.flush()
						if(de){
							ba.uncompress()
							var cmd0:Cmd0=ba.readObject()
							if(cmd0){
								var date:Date=new Date()
								if(DateUtils.compareDates(date,cmd0.end)!=1){
									b=true
								}else{
									var so:SharedObject=SharedObject.getLocal("ba")
									if(so.data.ba==null){
										so.data.ba=date;
										so.data.la=date;
										so.flush()
									}else{
										var la:Date=so.data.la as Date
										var dt:Date=so.data.ba as Date
										if(!la || DateUtils.compareDates(date,la)!=-1){
											b=true
										}else{
											var xdt:Date=new Date()
											xdt.time=dt.time+3600000*24*cmd0.p
											if(DateUtils.compareDates(date,xdt)==1){
											}else{
												b=true
											}
											so.data.la=date
											so.flush()
										}
									}
								}
							}else{
								b=true
							}
						}else{
							b=true
						}
					}catch(e:Error){
						DebugConsole.trace(e)
							b=true
					}
				}
				if(b){
					RFSystemManager.getInstance().dispatchEvent(new Event("ba"))
				}
				
			}
		}
		
		public static function getDate(y:int,m:int,d:int,p:int,s:String):String{
			flash.net.registerClassAlias("exp",Cmd0)
			var cmd0:Cmd0=new Cmd0()
			cmd0.end=new Date(y,m,d)
			cmd0.p=p
			cmd0.hash=Math.random().toString()
			cmd0.s=s
			var ba:ByteArray=new ByteArray()
			ba.writeObject(cmd0)
			ba.compress()
			var en:Base64Encoder=new Base64Encoder()
			en.encodeBytes(ba)
			return en.flush()
		}
		
		private static var _exp:Boolean;
		
		
		/**
		 * clean screen 
		 * 
		 */		
		public function clear():void{
			
			
			if(_instance){
				savedmessage=_instance.txt.htmlText
				_instance.txt.htmlText="";
				if(_instance.show){
					_instance.refresh(null)			
				}	
			}
		}
		
		/**
		 *  
		 * 
		 */		
		public function showEviro():void{
			trace("TotalCommand"+this.inputs.length+" Limit"+this.max)
		}
		
		/**
		 * show all command 
		 * 
		 */		
		public function showCmd():void{
			
			for each(var vo:Cmd in list){
				trace(vo.toString())
			}
			
		}
		/**
		 * help 
		 * 
		 */		
		public function help():void{
			
			var msg:String="<FONT COLOR='#00ee00'>This is help content<BR>"+
					"/set to view runtime evniroment of the console<BR>"+
					"/list to view all registered commands<BR>"+
					"/cls to clear all outputs<BR>"+
					"running time excution syntex:<BR>"+
		 			"**note:must specify the entire path,must use :: before class name<BR>"+
					"com.musicxx.legou.rpc::Provider.getInstance().publicvar<BR>"+
					"com.musicxx.legou.rpc::Provider.getInstance().publicfunction(arg1,arg2)<BR>"+
					"com.musicxx.legou.rpc::Provider.getInstance()<BR>"+
					"com.musicxx.legou.rpc::Provider.staticvar</FONT>";
					
			trace(msg)
		}
		public var list:Dictionary=new Dictionary(true)
		public static function registerCommand(cmd:String,vl:Object,args:String=null,desc:String='No description'):void
		{
			if(_instance){
				var vo:Cmd=new Cmd()
				vo.cmd=cmd;
				vo.vl=vl
				vo.args=args
				vo.desc=desc
				_instance.list[cmd]=vo
			}
			
		}
		public static function show():void
		{
			if(_instance){
				_instance.visible=true
				_instance.refresh(null)		
			}
		}
		public static function hide():void
		{
			if(_instance){
				_instance.visible=false
			}
		}
		private var mv:MoveEffect
		override public function set visible(value:Boolean):void{
			
			if(!mv){
				mv=new MoveEffect(this)
			}
			
			super.visible=value;
			show=value;
			mv.target=this
			
			
			if(mv.isPlaying){
				mv.removeEventListener(TweenEvent.TWEEN_END,tweenend)
				mv.end()
			} 
			if(show){
				super.visible=value;
				mv.yFrom=-this.height/2
				mv.yTo=0
				if(this.stage){
					this.stage.focus=this.txtinput;
				}
				
			}else{
				mv.yFrom=0
				mv.yTo=-this.height
			}
			mv.duration=200
			
			mv.addEventListener(TweenEvent.TWEEN_END,tweenend)
			mv.play()
		}
		private function tweenend(e:TweenEvent):void
		{
			super.visible=show
		}
	}
}
	import com.youbt.debug.DebugConsole;
	
class Cmd{
	public var cmd:String;
	public var vl:Object
	public var args:String;
	public var desc:String
	public function Cmd(){
		
	}
	public function apply(args:Array=null):void{
		if(vl is Function){
			try{
				(vl as Function).apply(this,args)
			}catch (e:Error){
				DebugConsole.trace(e.toString())
			}
		}
	}
	public function toString():String{
		return cmd+","+args+","+desc
	}
}
class Cmd0{
	public var end:Date
	public var p:Number
	public var s:String
	public var hash:String
	public function Cmd0(){
		
	}
}