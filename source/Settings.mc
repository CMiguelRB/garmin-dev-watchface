import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
import Toybox.WatchUi;

module Settings {

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
}