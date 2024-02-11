import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Position;
import Toybox.Application;


class SunEvents extends WatchUi.Drawable {

    function initialize(params as Object){
        Drawable.initialize(params);
    }

    function draw(dc){
        var location = Activity.getActivityInfo().currentLocation;
        var sunset = null;
        var sunrise = null;
        if(location != null){
            Application.Storage.setValue("lastLocation", location.toDegrees()[0]+"#"+location.toDegrees()[1]);
        }
        if(location == null){
            var wcc = Weather.getCurrentConditions();
            if (wcc != null && wcc.observationLocationPosition != null) {
                location = wcc.observationLocationPosition;
                Application.Storage.setValue("lastLocation", location.toDegrees()[0]+"#"+location.toDegrees()[1]);
            }
        }
        location = null;
        if(location == null){
            var lastLocation = Application.Storage.getValue("lastLocation");
            if(lastLocation != null){
                var locationLat = lastLocation.substring(0,lastLocation.find("#"));
                var locationLon = lastLocation.substring(lastLocation.find("#")+1,lastLocation.length());
                location = new Position.Location({
                        :latitude => locationLat.toDouble(),
                        :longitude => locationLon.toDouble(),
                        :format => :degrees
                    });
            }
        }
        if(location != null){
            sunset = Weather.getSunset(location, Time.now());
            sunrise = Weather.getSunrise(location, Time.now());
            sunset = Time.Gregorian.info(sunset, Time.FORMAT_MEDIUM).hour + ":" + Time.Gregorian.info(sunset, Time.FORMAT_MEDIUM).min;
            sunrise = Time.Gregorian.info(sunrise, Time.FORMAT_MEDIUM).hour + ":" + Time.Gregorian.info(sunrise, Time.FORMAT_MEDIUM).min;
        }
        drawInfo(dc, sunrise, sunset);
    }

    hidden function drawInfo(dc, sunrise, sunset){

        if(sunrise == null){
            sunrise = "--:--";
        }

        if(sunset == null){
            sunset = "--:--";
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);        

        dc.drawText(151, 30, Settings.resource(Rez.Fonts.Icons), "l", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(150, 45, Settings.resource(Rez.Fonts.Test), sunrise, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(217, 30, Settings.resource(Rez.Fonts.Icons), "m", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(220, 45, Settings.resource(Rez.Fonts.Test), sunset, Graphics.TEXT_JUSTIFY_CENTER);

    }
}