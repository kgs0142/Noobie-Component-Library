package  
{
    import com.brompton.component.system.BPLoader;
    import com.brompton.component.system.script.BPLuaManager;
    import com.brompton.entity.BPEntityManager;
    import com.brompton.system.CEntitySystem;
    import com.brompton.virtual.IBPEntity;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.Sound;
    import flash.net.URLLoader;
    import flash.system.ApplicationDomain;
    import flash.text.TextField;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import nochump.util.zip.ZipEntry;
    import nochump.util.zip.ZipFile;
    import nochump.util.zip.ZipOutput;
    
	/**
     * Will remove Main.as when the lib is almost done.
     * @author ...
     */
    public class Main extends Sprite
    {
        [Embed(source="assets.zip", mimeType="application/octet-stream")]
        private static const m_clzAssetTest:Class;
        
        public function Main()
        {
            //How to use EntityManager
            //1. give a Update callback to CEntityManager.Get().Update()
            //2. CEntityManager.Get().Create()
            //3. Create entity and components
            
            //TEST nochumo.zip
            var zipFile:ZipFile = new ZipFile(new m_clzAssetTest());
            var zipEntry:ZipEntry = zipFile.getEntry("assets/Untitled-1.swf");
            
            var byte:ByteArray = zipFile.getInput(zipEntry);
            
            //var sFileContent:String;
            //sFileContent= byte.readMultiByte(byte.length, "utf-8");
            //sFileContent = byte.readUTFBytes(byte.length);
            //trace(sFileContent);
            
            //var sound:Sound = new Sound();
            //sound.loadCompressedDataFromByteArray(byte, byte.length);
            //sound.play();
            
            var loader:Loader = new Loader();
            loader.name = "Test";
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadComplete);
            loader.loadBytes(byte);
            this.addChild(loader);
            
            this.addEventListener(Event.ENTER_FRAME, this.EnterFrameHD); 
            
            BPEntityManager.Get().Create();
            
            //All the system is add on it. It's better in a Class.
            CEntitySystem.Get().AddComponents
            (
                new BPLoader(),
                new BPLuaManager()
            );
            
            var loaderCompo:BPLoader = CEntitySystem.Get().GetComponent(BPLoader) as BPLoader;
            
            //loaderComponent.sPrefix = "./"
            
            //loaderComponent.SetEmbedZipClassToLoad(m_clzAssetTest);
            
            loaderCompo.PushAssetToLoad("assets/lua/Monster.lua");
            loaderCompo.PushAssetToLoad("assets/1021-cat-3.jpg");
            loaderCompo.PushAssetToLoad("assets/8b327e81bcc17d3c38e0239a69c8626a.jpg");
            
            loaderCompo.PushAssetToLoad("assets/scene/Level_Entrance.xml");
            loaderCompo.PushAssetToLoad("assets/scene/mapCSV_Entrance_bg.csv");
            loaderCompo.PushAssetToLoad("assets/scene/mapCSV_Entrance_Main.csv");
            loaderCompo.PushAssetToLoad("assets/TileTest002.png");
            loaderCompo.PushAssetToLoad("assets/TileSet003.png");
            
            loaderCompo.StartLoad(this.LoadAllAssetComplete);
            
            //SAFE_RELEASE()
        }
        
        private function LoadComplete(e:Event) : void
        {
            trace(e);
            var loader:Loader = (e.currentTarget as LoaderInfo).loader;

            //var cls:Class = loader.contentLoaderInfo.applicationDomain as Class;
            
            var dic:Dictionary = new Dictionary();
            dic["aaa"] = loader.contentLoaderInfo.applicationDomain;
            
            var a:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
            var vString:Vector.<String> = a.getQualifiedDefinitionNames();
            //var bmp:Bitmap = loader.content as Bitmap;
            //bmp.x = stage.stageWidth/2;
            //bmp.y = stage.stageHeight/2;
            //this.addChild(bmp);
            
            loader.unload();
            loader.unloadAndStop();
            loader = null;
            
            vString = dic["aaa"].getQualifiedDefinitionNames();
            
        }
        
        private function LoadAllAssetComplete() : void
        {
            var loaderCompo:BPLoader = CEntitySystem.Get().GetComponent(BPLoader) as BPLoader;
            var a:ApplicationDomain = loaderCompo.GetAsset("Untitled-1") as ApplicationDomain;
            
            var clz:Class;
            var bmp:Bitmap;
            
            //clz = a.getDefinition("bmpMario") as Class;
            //bmp = new Bitmap(new clz());
            //this.addChild(bmp);
            
            bmp = loaderCompo.GetAsset("8b327e81bcc17d3c38e0239a69c8626a") as Bitmap;
            bmp.x = 100;
            this.addChild(bmp);
            
            bmp = loaderCompo.GetAsset("1021-cat-3") as Bitmap;
            bmp.x = 100;
            bmp.y = 50;
            this.addChild(bmp);
            
            var luaMgr:BPLuaManager = CEntitySystem.Get().GetComponent(BPLuaManager) as BPLuaManager;
            var sScript:String = loaderCompo.GetAsset("Monster") as String;
            
            //var lua:BPLuaAlchemy = new BPLuaAlchemy();
            //lua.doString(sScript);
            luaMgr.DoString(sScript);
            luaMgr.CallGlobal("LuaFn_Test");
            
            var sXml:String = loaderCompo.GetAsset("Level_Entrance") as String;
            var xml:XML = new XML(sXml);
            trace(xml);
        }
        
        private function EnterFrameHD(e:Event) : void
        {
            BPEntityManager.Get().Update();
        }
    }
}




