package
{
  import flash.display.DisplayObjectContainer;
  import flash.utils.Dictionary;
  import flash.utils.Proxy;
  
  import mx.core.IStateClient;
  import mx.core.mx_internal;
  import mx.styles.IStyleClient;
  import mx.utils.DescribeTypeCache;
  import mx.utils.DescribeTypeCacheRecord;
  
  import spark.skins.SparkSkin;
  
  use namespace mx_internal;
  
  public class StyledSparkSkin extends SparkSkin
  {
    [Bindable]
    public var styles:StyleProxy;
    
    private var stylesToSet:Dictionary;
    
    public function StyledSparkSkin()
    {
      super();
      styles = new StyleProxy();

      stylesToSet = new Dictionary();
      
      var tc:DescribeTypeCacheRecord = DescribeTypeCache.describeType(this);
      
      for each (var x:XML in tc.typeDescription.metadata.(@name=='Style'))
      {
        stylesToSet[x.arg.(@key=="name").@value.toString()] = x.arg.(@key=="defaultValue").@value.toString();
      }
    }
    
    override public function set owner(value:DisplayObjectContainer):void
    {
        _owner = value;
        
        for (var s:Object in stylesToSet)
        {
          var v:Object = stylesToSet[s];
          
          var ss:Object = (_owner as IStyleClient).getStyle(s as String);
          
          if (ss != null)
          {
            v = ss;
          }
          
          styles[s] = v;
        }
        
        updateStylesFromStyleString();
    }
    
    public function updateStylesFromStyleString():void
    {
      if (owner["style"] != undefined)
      {
        var stylesArray:Array = owner["style"].split(";");
        
        for each (var s:String in stylesArray)
        {
          if (s.length > 0)
          {
            s = s.replace(/\s/,"");
            var a:Array = s.split(":");
            
            styles[a[0]] = a[1];
          }
        }
      }
    }

  }
}