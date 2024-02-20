import Toybox.System;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Position;
import Toybox.Application;

module DataRetriever {

    function getBattery(){
        $.mFaceValues.batteryInDays = System.getSystemStats().batteryInDays;
        $.mFaceValues.batteryInPercentage = System.getSystemStats().battery;
    }

    

    function getSunEvents(){
        var now = Time.now();
        if(
            ($.mFaceValues.lastSunEventsRetrieval == null
             || Time.Gregorian.info(now, Time.FORMAT_MEDIUM).day
             != Time.Gregorian.info($.mFaceValues.lastSunEventsRetrieval, Time.FORMAT_MEDIUM).day)
            || $.mFaceValues.updateSunEvents == true){
            var lastLocation = $.mFaceValues.lastLocation;
            if(lastLocation != null){
                var sunset = null;
                var sunrise = null;
                var location = new Position.Location({
                        :latitude => lastLocation[0],
                        :longitude => lastLocation[1],
                        :format => :degrees
                    }); 
                if(location != null){
                    sunset = Weather.getSunset(location, now);
                    sunrise = Weather.getSunrise(location, now);
                    sunset = Time.Gregorian.info(sunset, Time.FORMAT_MEDIUM).hour.format("%02d") + ":" + Time.Gregorian.info(sunset, Time.FORMAT_MEDIUM).min.format("%02d");
                    sunrise = Time.Gregorian.info(sunrise, Time.FORMAT_MEDIUM).hour.format("%02d") + ":" + Time.Gregorian.info(sunrise, Time.FORMAT_MEDIUM).min.format("%02d");
                        
                    $.mFaceValues.sunrise = sunrise;
                    $.mFaceValues.sunset = sunset;
                    $.mFaceValues.lastSunEventsRetrieval = now;
                    $.mFaceValues.updateSunEvents = false;
                }        
            }        
        }
    }

    function getLocation(){
        var location = Weather.getCurrentConditions().observationLocationPosition;
        var lastLocation = $.mFaceValues.lastLocation;
        if(location != null && lastLocation != null){
            location = location.toDegrees();
            if(location[0] != lastLocation[0] || location[1] != lastLocation[1]){
                $.mFaceValues.lastLocation =  location;
                $.mFaceValues.updateSunEvents =  true;
            }            
        }else{
            $.mFaceValues.lastLocation =  location.toDegrees();
            $.mFaceValues.updateSunEvents =  true;
        }
    }
}