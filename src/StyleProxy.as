package
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.utils.Proxy;
  import flash.utils.flash_proxy;
  
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  import mx.styles.IStyleClient;
  
  [Bindable("propertyChange")]
  public dynamic class StyleProxy extends Proxy implements IEventDispatcher
  {
    protected var dispatcher:EventDispatcher;
    
    public function StyleProxy()
    {
      _item = new Object();
      
      dispatcher = new EventDispatcher(this);
    }
    
    private var _item:Object;
    
    override flash_proxy function getProperty(name:*):* {
        return _item[name];
    }

    override flash_proxy function setProperty(name:*, value:*):void {   
      if (_item[name] != value)
      {
        _item[name] = value;
        
        var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
        event.kind = PropertyChangeEventKind.UPDATE;
        event.property = name;
        event.source = this;
        dispatchEvent(event);
      }
    }
    
    
    
    
    public function addEventListener(type:String, listener:Function,
                                     useCapture:Boolean = false,
                                     priority:int = 0,
                                     useWeakReference:Boolean = false):void
    {
        dispatcher.addEventListener(type, listener, useCapture,
                                    priority, useWeakReference);
    }
    
    public function removeEventListener(type:String, listener:Function,
                                        useCapture:Boolean = false):void
    {
        dispatcher.removeEventListener(type, listener, useCapture);
    }
    
    public function dispatchEvent(event:Event):Boolean
    {
        return dispatcher.dispatchEvent(event);
    }
    
    public function hasEventListener(type:String):Boolean
    {
        return dispatcher.hasEventListener(type);
    }
    
    public function willTrigger(type:String):Boolean
    {
        return dispatcher.willTrigger(type);
    }
    
    public function propertyChangeHandler(event:PropertyChangeEvent):void
    {
        dispatcher.dispatchEvent(event);
    }
    
    /*
    override flash_proxy function nextNameIndex(index:int):int {
        if (index > _item.length)
            return 0;
        return index + 1;
    }

    override flash_proxy function nextName(index:int):String {
        return String(index - 1);
    }

    override flash_proxy function nextValue(index:int):* {
        return _item[index - 1];
    }
    */


  }
}