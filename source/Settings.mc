import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
import Toybox.WatchUi;

module Settings {

  var lowPowerMode = false;
  var isSleepTime = false;

  var _settings as Dictionary<String, Object> = {};
  var _resources as Dictionary<Symbol, Object> = {};

  function get(key) {
    return _settings[key];
  }

  function resource(resourceId) {
    if (_resources[resourceId] == null) {
      _resources[resourceId] = WatchUi.loadResource(resourceId);
    }
    return _resources[resourceId];
  }

  function initSettings() {
    var width = System.getDeviceSettings().screenWidth;
    var height = System.getDeviceSettings().screenHeight;
    
    _settings["width"] = width;
    _settings["height"] = height;
  
    determineSleepTime();
  }

  function setAsBoolean(settingsId, defaultValue as Lang.Boolean) {
    var value = Properties.getValue(settingsId);
    if (value == null || !(value instanceof Lang.Boolean)) {
      value = defaultValue;
    }
    _settings[settingsId] = value;
  }

  function setAsNumber(settingsId, defaultValue as Lang.Number) {
    var value = Properties.getValue(settingsId);
    if (value == null || !(value instanceof Lang.Number)) {
      value = defaultValue;
    }
    _settings[settingsId] = value;
  }

  function determineSleepTime() {
    var profile = UserProfile.getProfile();
    var current = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    current = new Time.Duration(current.hour * 3600 + current.min * 60);

    if (profile.wakeTime.lessThan(profile.sleepTime)) {
      Settings.isSleepTime = (get("sleepLayoutActive") && (current.greaterThan(profile.sleepTime) || current.lessThan(profile.wakeTime)));
    } else if (profile.wakeTime.greaterThan(profile.sleepTime)) {
      Settings.isSleepTime = get("sleepLayoutActive") && current.greaterThan(profile.sleepTime) && current.lessThan(profile.wakeTime);
    } else {
      Settings.isSleepTime = false;
    }
  }
}

var DataFieldRez as Array<Symbol> = [];