import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class Altitude extends WatchUi.Drawable {

    function initialize(params as Object){
        Drawable.initialize(params);
    }

    function draw(dc){
        var altitude = $.DataValues.altitude;
        drawInfo(dc, altitude);
    }

    hidden function drawInfo(dc, altitude){
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);        

        //dc.drawText(90, 308, Settings.resource(Rez.Fonts.Icons), "i", Graphics.TEXT_JUSTIFY_CENTER);

        //dc.drawAngledText(105, 316, Graphics.getVectorFont({:face => ["RobotoCondensedRegular"] as Array<String>,:size => 32}), altitude+" m", Graphics.TEXT_JUSTIFY_LEFT, 50);
        dc.drawAngledText(90, 335, Graphics.getVectorFont({:face => ["RobotoCondensedRegular"] as Array<String>,:size => 38}), altitude+" m.", Graphics.TEXT_JUSTIFY_LEFT, 50);
    }
}