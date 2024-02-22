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
        var sunrise = $.DataValues.sunrise;
        var sunset = $.DataValues.sunset;
        drawInfo(dc, sunrise, sunset);
    }

    hidden function drawInfo(dc, sunrise, sunset){

        if(sunrise == null){
            sunrise = "00:00";
        }

        if(sunset == null){
            sunset = "00:00";
        }
        
        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);        

        dc.drawText(151, 30, $.fonts.icons, "l", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(150, 45, $.fonts.data, sunrise, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(217, 30, $.fonts.icons, "m", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(220, 45, $.fonts.data, sunset, Graphics.TEXT_JUSTIFY_CENTER);

    }
}