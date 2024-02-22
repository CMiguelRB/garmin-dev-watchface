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