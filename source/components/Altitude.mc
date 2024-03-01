import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class Altitude extends WatchUi.Drawable {

    function initialize(params as Object){
        Drawable.initialize(params);
    }

    function draw(dc){
        var altitude = DataValues.altitude;
        drawInfo(dc, altitude);
    }

    hidden function drawInfo(dc, altitude){
        
        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);        
        dc.drawText(135, 238, $.fonts.date, altitude+" m", Graphics.TEXT_JUSTIFY_RIGHT);
    }
}