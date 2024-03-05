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

  var mBurnInProtectionMode = false;
  var mLastUpdateBIPMode = false;
  var mLastUpdateSleepTime = false; 
  hidden var mLastLayout;

  hidden var mSettings;

  function initialize() {
    WatchFace.initialize();
  }

  function chooseLayout(dc, onLayoutCall) {
    // onLayout
    if (onLayoutCall) {
      if (requiresBurnInProtection() && mBurnInProtectionMode) {
        return Rez.Layouts.SimpleWatchFace(dc);
      } else if (Settings.isSleepTime) {
        return Rez.Layouts.WatchFaceSleep(dc);
      } else {
        return defaultLayout(dc);
      }
    }
    // enter / exit low power mode triggered
    if (requiresBurnInProtection() && mLastUpdateBIPMode != mBurnInProtectionMode) {
      return burnInProtectionLayout(dc);
    }
    // sleep / wake time event triggered
    if (!mBurnInProtectionMode && mLastUpdateSleepTime != Settings.isSleepTime) {
      return sleepTimeLayout(dc);
    }
    
    return defaultLayout(dc);
  }

  hidden function defaultLayout(dc) {
    mLastLayout = Settings.get("layout");
    return Rez.Layouts.WatchFace(dc);
  }

  hidden function sleepTimeLayout(dc) {
    mLastUpdateSleepTime = Settings.isSleepTime;
    if (mLastUpdateSleepTime) {
      return Rez.Layouts.WatchFaceSleep(dc);
    } else {
      return defaultLayout(dc);
    }
  }

  hidden function burnInProtectionLayout(dc) {
    mLastUpdateBIPMode = mBurnInProtectionMode;
    if (mBurnInProtectionMode) {
      return Rez.Layouts.SimpleWatchFace(dc);
    }
    if (Settings.isSleepTime) {
      return sleepTimeLayout(dc);
    }
    return defaultLayout(dc);
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
    setLayout(chooseLayout(dc, true));
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

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() {
    if (requiresBurnInProtection()) {
      mBurnInProtectionMode = false;
      WatchUi.requestUpdate();
    }
    Settings.lowPowerMode = false;
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() {
    if (requiresBurnInProtection()) {
      mBurnInProtectionMode = true;
      WatchUi.requestUpdate();
    }
    Settings.lowPowerMode = true;
  }

  hidden function _settings() {
    if (mSettings == null) {
      mSettings = System.getDeviceSettings();
    }
    return mSettings;
  }

  hidden function requiresBurnInProtection() {
    return _settings() has :requiresBurnInProtection && _settings().requiresBurnInProtection;
  }
}
