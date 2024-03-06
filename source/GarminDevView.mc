import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;

module fonts {
  var icons;
  var data;
  var time;
  var date;
}

class GarminDevView extends WatchUi.WatchFace {

  hidden var mLastLayout;

  hidden var mSettings;

  function initialize() {
    WatchFace.initialize();
  }

  // Load your resources here
  function onLayout(dc) {
    //General values
    DataValues.height = dc.getHeight();
    DataValues.centerY = dc.getHeight()/2;
    DataValues.width = dc.getWidth();
    DataValues.centerX = dc.getWidth()/2;
    //Battery
    DataValues.batteryArcRadius = DataValues.centerX - 6;
    DataValues.batteryArcGapDegree = 16;
    //Fonts
    $.fonts.icons = Settings.resource(Rez.Fonts.Icons);
    $.fonts.time = Settings.resource(Rez.Fonts.Time);
    $.fonts.data = Settings.resource(Rez.Fonts.Data);
    $.fonts.date = Settings.resource(Rez.Fonts.Date);
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
  }

  // Update the view
  function onUpdate(dc) {
    if(dc has :setAntiAlias) {
        dc.setAntiAlias(true);
    }
    View.onUpdate(dc);
    DataRetriever.retrieveData();
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {
  }

  hidden function _settings() {
    if (mSettings == null) {
      mSettings = System.getDeviceSettings();
    }
    return mSettings;
  }
}
