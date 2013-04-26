package com.brompton.component.system 
{
    import com.brompton.component.BPBaseComponent;
    import com.brompton.entity.BPEntityManager;
    import com.brompton.global.BPDefine;
    import flash.display.Bitmap;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import nochump.util.zip.ZipEntry;
    import nochump.util.zip.ZipFile;
	
	/**
     * You can load assets(loading_asset) and embed one Zip asset(zip_asset). 
     * TXT -> String; BMP -> Bitmap; SND -> bytearray; SWF -> domain (Dont load sound)
     * @author Husky
     */
    public class BPLoader extends BPBaseComponent
    {
        //TODO The define assign here first, check if should move to other class
        //asset type------------------------------
        public static const TEXT_TYPE:String = "ASSET_TEXT_TYPE";
        public static const IMG_TYPE:String = "ASSET_IMG_TYPE";
        public static const SWF_TYPE:String = "ASSET_SWF_TYPE";
        public static const SND_TYPE:String = "ASSET_SOUND_TYPE";
        
        //Asset.Event (BPEvent?)
        public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
        public static const LOAD_NEXT_FROM_QUEUE:String = "LOAD_NEXT_FROM_QUEUE";
        public static const LOADING_ZIP_QUEUE_COMPLETE:String = "LOADING_ZIP_QUEUE_COMPLETE";
        public static const LOADING_ASSET_QUEUE_COMPLETE:String =  "LOADING_ASSET_QUEUE_COMPLETE";
        
        private static const ZIP_ASSET_TAG:String = "ZIP_ASSET_TAG";
        private static const LOADING_ASSET_TAG:String = "LOADING_ASSET_TAG";
        
        ///the encoding loader for Text used
        private static const ENCODING:String = "utf-8";
        
        //----------------------------------------
        ///the prefix path of loading path
        private var m_sPrefix:String;
        ///the Complete Callback will only exectue once.
        private var m_fnComplete:Function;
        
        //-------------------------------------------------------------------------
        ///The loading queue
        private var m_vLoadingQueue:Vector.<CLoadingData>;
        ///The zip queue
        private var m_vZipQueue:Vector.<CLoadingData>;
        
        //Where Asset Store---------------------------------------------------------
        ///Use file name mapping loading Asset
        private var m_mapNameLoadingAsset:Dictionary;
        ///Use file name mapping embed zip Asset
        private var m_mapNameZipAsset:Dictionary;
        ///the embed zip File
        private var m_zipEmbedFile:ZipFile;
        //--------------------------------------------------------------------------
        
        public function BPLoader() 
        {
            m_sPrefix = "../";
            m_zipEmbedFile = null;
            m_fnComplete = BPDefine.FN_EMPTY;
            m_mapNameZipAsset = new Dictionary();
            m_mapNameLoadingAsset = new Dictionary();
            m_vZipQueue = Vector.<CLoadingData>([]); 
            m_vLoadingQueue = Vector.<CLoadingData>([]);
            
            //Get DebuggerComponent, and use logger
            trace("Create Loader Component");
        }
        
        //1. Prepare to load----------------------------------------------------------
        ///Set EmbedZip and create m_vZipQueue
        public function SetEmbedZipClassToLoad(clzEmbedZip:Class) : void
        {
            m_vZipQueue.splice(0, m_vZipQueue.length);
            
            m_zipEmbedFile = new ZipFile(new clzEmbedZip());
            
            var cLoadingData:CLoadingData;
            var zipEntry:ZipEntry;
            var uiLength:uint = m_zipEmbedFile.size;
            for (var ui:uint = 0; ui < uiLength; ui++)
            {
                zipEntry = m_zipEmbedFile.entries[ui];
                
                cLoadingData = new CLoadingData(zipEntry.name);
                m_vZipQueue.push(cLoadingData);
            }
        }
        
        /**
         * will create Name and Type by path
         * @param sPath Loading path
         */
        public function PushAssetToLoad(sPath:String) : void
        {
            var cLoadingData:CLoadingData = new CLoadingData(m_sPrefix + sPath);
            
            m_vLoadingQueue.push(cLoadingData);
        }
        //------------------------------------------------------------------------
                
        //3. Loading Complete---------------------------------------------------
        private function LoadingComplete() : void
        {
            m_zipEmbedFile = null;
            
            ///Maybe want reload again?
            m_vLoadingQueue.splice(0, m_vLoadingQueue.length);
            m_vZipQueue.splice(0, m_vZipQueue.length);
            
            trace("Load all asset complete");
            
            m_fnComplete();
            
            BPEntityManager.Get().dispatchEvent(new Event(BPLoader.LOAD_COMPLETE));
        }
        //------------------------------------------------------------------------
        
        /**
         * Get asset by file name
         * @param sName   file name without extension
         * @return Object
         */
        public function GetAsset(sName:String) : Object
        {
            var objAsset:Object = m_mapNameLoadingAsset[sName];
            objAsset = (objAsset == null) ? m_mapNameZipAsset[sName] : objAsset;
            
            return objAsset;
        }
        
        //------------------------------------------------------
        
        //2. Start Loading---------------------------------------------------------
        ///Start Loading, when load complete, will cause a AssetEvent.LOAD_COMPLETE
        public function StartLoad(fnComplete:Function = null) : void
        {
            m_fnComplete = (fnComplete == null) ? BPDefine.FN_EMPTY : fnComplete;
            
            //TODO start load all asset in m_vLoadingQueue, 
            //or load embedZip (need transform)
            
            //Load together? how to separate the different file to dictionary?
            var ui:uint = 0;
            var uiLength:uint = m_vLoadingQueue.length;
            for (ui = 0; ui < uiLength; ui++)
            {
                this.LoadLoadingAsset(m_vLoadingQueue[ui]);
            }
            
            uiLength = m_vZipQueue.length;
            for (ui = 0; ui < uiLength; ui++)
            {
                this.LoadZipAsset(m_vZipQueue[ui]);
            }
        }
        
        private function LoadLoadingAsset(cLoadingData:CLoadingData) : void
        {
            var cSound:CSound;
            var cLoader:CLoader;
            var cURLLoader:CURLLoader;
            switch (cLoadingData.sType)
            {
                case IMG_TYPE:
                    cLoader = new CLoader();
                    cLoader.m_cLoadingData = cLoadingData;
                    cLoader.m_sTag = LOADING_ASSET_TAG;
                    cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.ImgLoadComplete);
                    cLoader.load(new URLRequest(cLoadingData.sPath));
                    break;
                    
                case TEXT_TYPE:
                    cURLLoader = new CURLLoader();
                    cURLLoader.m_cLoadingData = cLoadingData;
                    cURLLoader.m_sTag = LOADING_ASSET_TAG;
                    cURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
                    cURLLoader.addEventListener(Event.COMPLETE, this.TextLoadComplete);
                    cURLLoader.load(new URLRequest(cLoadingData.sPath));
                    break;
                 
                case SND_TYPE:
                    cSound = new CSound();
                    cSound.m_cLoadingData = cLoadingData;
                    cSound.m_sTag = LOADING_ASSET_TAG;
                    cSound.addEventListener(Event.COMPLETE, this.SndLoadComplete);
                    cSound.load(new URLRequest(cLoadingData.sPath));
                    break;
                    
                case SWF_TYPE:
                    cLoader = new CLoader();
                    cLoader.m_cLoadingData = cLoadingData;
                    cLoader.m_sTag = LOADING_ASSET_TAG;
                    cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.SwfLoadComplete);
                    cLoader.load(new URLRequest(cLoadingData.sPath));
                    break;
                    
                default:
                    break;
            }
        }
        
        private function LoadZipAsset(cLoadingData:CLoadingData) : void
        {
            var zipEntry:ZipEntry = m_zipEmbedFile.getEntry(cLoadingData.sPath);
            var byte:ByteArray = m_zipEmbedFile.getInput(zipEntry);
            
            var cLoader:CLoader;
            var cURLLoader:CURLLoader;
            switch (cLoadingData.sType)
            {
                case IMG_TYPE:
                    cLoader = new CLoader();
                    cLoader.m_cLoadingData = cLoadingData;
                    cLoader.m_sTag = ZIP_ASSET_TAG;
                    cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.ImgLoadComplete);
                    cLoader.loadBytes(byte);
                    break;
                    
                case TEXT_TYPE:
                    //var sFileContent:String = byte.readMultiByte(byte.length, ENCODING);
                    var sFileContent:String = byte.readUTFBytes(byte.length);
                    m_mapNameZipAsset[cLoadingData.sName] = sFileContent;
                    
                    cLoadingData.bLoadingComplete = true;
                    this.CheckLoadCompleteAndDispatch();
                    break;
                 
                case SND_TYPE:
                    m_mapNameZipAsset[cLoadingData.sName] = byte;
                    
                    cLoadingData.bLoadingComplete = true;
                    this.CheckLoadCompleteAndDispatch();
                    break;
                    
                case SWF_TYPE:
                    cLoader = new CLoader();
                    cLoader.m_cLoadingData = cLoadingData;
                    cLoader.m_sTag = ZIP_ASSET_TAG;
                    cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.SwfLoadComplete);
                    cLoader.loadBytes(byte);
                    break;
                    
                default:
                    break;
            }
        }
        
        private function SwfLoadComplete(e:Event) : void
        {
            var cLoader:CLoader = (e.currentTarget as LoaderInfo).loader as CLoader;
            
            cLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.SwfLoadComplete);
            
            var map:Dictionary = (cLoader.m_sTag == LOADING_ASSET_TAG) ? 
                                  m_mapNameLoadingAsset : m_mapNameZipAsset;
            
            map[cLoader.m_cLoadingData.sName] = cLoader.contentLoaderInfo.applicationDomain;
            
            cLoader.m_cLoadingData.bLoadingComplete = true;
            
            cLoader.unload();
            cLoader.unloadAndStop();
            cLoader = null;
            
            this.CheckLoadCompleteAndDispatch();
        }
        
        private function ImgLoadComplete(e:Event) : void
        {
            var cLoader:CLoader = (e.currentTarget as LoaderInfo).loader as CLoader;
            
            cLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.ImgLoadComplete);
            
            var map:Dictionary = (cLoader.m_sTag == LOADING_ASSET_TAG) ? 
                                  m_mapNameLoadingAsset : m_mapNameZipAsset;
            
            map[cLoader.m_cLoadingData.sName] = cLoader.content as Bitmap;
            
            cLoader.m_cLoadingData.bLoadingComplete = true;
            
            cLoader.unload();
            cLoader.unloadAndStop();
            cLoader = null;
            
            this.CheckLoadCompleteAndDispatch();
        }
        
        private function TextLoadComplete(e:Event) : void
        {
            var cURLLoader:CURLLoader = (e.currentTarget as CURLLoader);
            cURLLoader.removeEventListener(Event.COMPLETE, this.TextLoadComplete);
            
            var byte:ByteArray = ByteArray(cURLLoader.data);
            //var sFileContent:String = byte.readMultiByte(byte.length, ENCODING);
            var sFileContent:String = byte.readUTFBytes(byte.length);
            
            var map:Dictionary = (cURLLoader.m_sTag == LOADING_ASSET_TAG) ? 
                                  m_mapNameLoadingAsset : m_mapNameZipAsset;
            
            map[cURLLoader.m_cLoadingData.sName] = sFileContent;
            
            cURLLoader.m_cLoadingData.bLoadingComplete = true;
            
            cURLLoader.close();
            cURLLoader = null;
            
            this.CheckLoadCompleteAndDispatch();
        }
        
        private function SndLoadComplete(e:Event) : void
        {
            var cSound:CSound = e.currentTarget as CSound;
            cSound.removeEventListener(Event.COMPLETE, this.SndLoadComplete);
            
            var map:Dictionary = (cSound.m_sTag == LOADING_ASSET_TAG) ? 
                                  m_mapNameLoadingAsset : m_mapNameZipAsset;
            
            cSound.m_cLoadingData.bLoadingComplete = true;
            
            map[cSound.m_cLoadingData.sName] = cSound;
            
            this.CheckLoadCompleteAndDispatch();
        }
        
        private function CheckLoadCompleteAndDispatch() : void
        {
            var ui:uint = 0;
            var uiLength:uint = m_vLoadingQueue.length;
            for (ui = 0; ui < uiLength; ui++)
            {
                if (m_vLoadingQueue[ui].bLoadingComplete == false)
                {
                    return;
                }
            }
            
            uiLength = m_vZipQueue.length;
            for (ui = 0; ui < uiLength; ui++)
            {
                if (m_vZipQueue[ui].bLoadingComplete == false)
                {
                    return;
                }
            }
            
            //return true;
            this.LoadingComplete();
        }
        
        //------------------------------------------------------------------------
        
        public override function Initial() : void 
        {
        }

		public override function Create() : void
        {
        }

        public override function Update() : void
        {
        }

        public override function Release() : void
        {
        }
        
        public function get sPrefix():String { return m_sPrefix; }
        public function set sPrefix(value:String):void { m_sPrefix = value; }
    }
}


import com.brompton.component.system.BPLoader;
import flash.display.Loader;
import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.net.URLLoader;
import flash.net.URLRequest;
///The original loading data of asset (Type, Path)
internal class CLoadingData
{
    public var sName:String;
    public var sType:String;
    public var sPath:String;
    public var bLoadingComplete:Boolean;
    
    //TODO check if this is need
    //Check if data is correct to be load (ZipFile will load file has only path. eg. "/asset/")
    //public var bValid:Boolean;
    
    public function CLoadingData(path:String) : void
    {
        //bValid = true;
        sPath = path;
        bLoadingComplete = false;
        
        var sTemp:String = path;
        var iLastDash:int = sTemp.lastIndexOf("/");
        var iLastDot:int = sTemp.lastIndexOf(".");
        
        //Get the file name without extension
        sName = sTemp.slice(iLastDash + 1, iLastDot);
        //Make the asset type
        sType = this.MakeAssetType(sTemp.slice(iLastDot + 1));
        
        //if (iLastDash == -1 || iLastDot == -1)
        //{
            //bValid = false;
        //}
    }
    
    /**
     * 
     * @param sExtension
     * @return
     */
    private function MakeAssetType(sExtension:String) : String
    {
        switch (sExtension.toLowerCase())
        {
            case "txt":
            case "xml":
            case "lua":
                return BPLoader.TEXT_TYPE;
            
            case "jpg":
            case "jpeg":
            case "gif":
            case "png":
            case "bmp":
                return BPLoader.IMG_TYPE;
                
            case "wav":
            case "mp3":
                return BPLoader.SND_TYPE;
            
            case "swf":
                return BPLoader.SWF_TYPE;
                
            default:
                return BPLoader.TEXT_TYPE;
        }
    }
}

internal class CSound extends Sound
{
    public var m_cLoadingData:CLoadingData;
    public var m_sTag:String;
    
    public function CSound(stream:URLRequest = null, context:SoundLoaderContext = null) : void
    {
        super(stream, context);
    }
}

internal class CLoader extends Loader
{
    public var m_cLoadingData:CLoadingData;
    public var m_sTag:String;
    
    public function CLoader()
    {
        super();
        
        m_sTag = "";
        m_cLoadingData = null;
    }
}

internal class CURLLoader extends URLLoader
{
    public var m_cLoadingData:CLoadingData;
    public var m_sTag:String;
    
    public function CURLLoader(request:URLRequest = null)
    {
        super(request);
        
        m_sTag = "";
        m_cLoadingData = null;
    }
}























