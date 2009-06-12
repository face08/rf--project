package test.effect
{
    import com.youbt.effects.effectClass.MoveEffect;
    import com.youbt.effects.effectClass.TweenEffectInstance;
    import com.youbt.events.TweenEvent;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    [ExcludeClass]
    public class EffectTest extends Sprite
    {
        public function EffectTest()
        {

            drawButton(start)
            drawButton(stop)
            drawButton(end)
            drawButton(ball)


            this.addChild(start).x=0
            this.addChild(stop).x=180
            this.addChild(end).x=360

            this.addChild(ball).y=200

            start.addEventListener(MouseEvent.CLICK,startHandler)
            stop.addEventListener(MouseEvent.CLICK,stopHandler)
            end.addEventListener(MouseEvent.CLICK,endHandler)

            mt=new MoveEffect(ball)

        }
        private var mt:MoveEffect;

        private function startHandler(e:MouseEvent):void
        {
            mt.startDelay=100
            mt.target=ball
            mt.xFrom=0
            mt.xTo=500
            mt.duration=2000
            mt.yFrom=200
            mt.yTo=200
            mt.addEventListener(TweenEvent.TWEEN_END,endHandler1)
            mt.startEffect()

        }

        private function endHandler1(e:TweenEvent):void
        {
            var ti:TweenEffectInstance=e.currentTarget as TweenEffectInstance
            ti.reverse()
            ti.play()
        }
        private function stopHandler(e:MouseEvent):void
        {
            mt.stop()			
        }
        private function endHandler(e:MouseEvent):void
        {
            mt.end()

        }

        private var start:Sprite=new Sprite()
        private var stop:Sprite=new Sprite()
        private var end:Sprite=new Sprite()

        private var ball:Sprite=new Sprite()

        private function drawButton(target:Sprite):void
        {
            target.graphics.clear()
            target.graphics.beginFill(0xff00ff)
            target.graphics.drawRect(0,0,150,50)
            target.graphics.endFill()

        }


    }
}

