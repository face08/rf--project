package test
{
    import com.youbt.events.RFDownloadListEvent;
    import com.youbt.net.ParallelDownloader;

    import flash.events.IEventDispatcher;


    /**
     * RFLOADER 基本用法
     * RFLOADER 的GC
     * DOWNLOADLIST 的基本用法
     * DOWNLOADLIST 的GC
     *
     * @author Administrator
     *
     */	
    [ExcludeClass]
    public class LoaderTest
    {
        public function LoaderTest()
        {


            var pl:ParallelDownloader=new ParallelDownloader()
            pl.maxRunningTask=1;

            pl.addEventListener(RFDownloadListEvent.LISTCOMPLETE,listcompleteHandler)
            pl.addEventListener(RFDownloadListEvent.TASKCOMPLETE,taskcompleteHandler)
            pl.addEventListener(RFDownloadListEvent.TASKPROGRESS,taskprogressHandler)


            pl.addTask('http://192.168.1.202/flashdata/getAssemblyOne.xx?c_thing_code=F50',0)
            pl.addTask('http://192.168.1.202/flashdata/getAssemblyOne.xx?c_thing_code=F10',0)
            pl.addTask('http://192.168.1.202/flashdata/getAssemblyOne.xx?c_thing_code=F30',0)
        }

        private function listcompleteHandler(e:RFDownloadListEvent):void
        {
            var pl:IEventDispatcher=e.currentTarget as IEventDispatcher


            pl.removeEventListener(RFDownloadListEvent.LISTCOMPLETE,listcompleteHandler)
            pl.removeEventListener(RFDownloadListEvent.TASKCOMPLETE,taskcompleteHandler)
            pl.removeEventListener(RFDownloadListEvent.TASKPROGRESS,taskprogressHandler)

            // REFERECEN COUNT =0 GC SUCCESSED

        }
        private function taskcompleteHandler(e:RFDownloadListEvent):void
        {
            trace(e.content)

        }

        private function taskprogressHandler(e:RFDownloadListEvent):void
        {

        }

    }
}

