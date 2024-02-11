import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class Altitude extends WatchUi.Drawable {

    function initialize(params as Object){
        Drawable.initialize(params);
    }

    function draw(dc){
        var altitude = SensorHistory.getElevationHistory({:period => 1}).next();
        if(altitude == null){
            var iterator = SensorHistory.getElevationHistory({:period => 100, :order => SensorHistory.ORDER_NEWEST_FIRST});
            altitude = iterator.next();
            if(altitude == null){
                while(altitude == null){
                    altitude = iterator.next();
                }
            }
        }
        altitude = altitude.data;
        altitude = Math.round(altitude).toNumber();
        drawInfo(dc, altitude);
    }

    hidden function drawInfo(dc, altitude){
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);        

        //dc.drawText(90, 308, Settings.resource(Rez.Fonts.Icons), "i", Graphics.TEXT_JUSTIFY_CENTER);

        //dc.drawAngledText(105, 316, Graphics.getVectorFont({:face => ["RobotoCondensedRegular"] as Array<String>,:size => 32}), altitude+" m", Graphics.TEXT_JUSTIFY_LEFT, 50);
        dc.drawAngledText(90, 335, Graphics.getVectorFont({:face => ["RobotoCondensedRegular"] as Array<String>,:size => 38}), altitude+" m.", Graphics.TEXT_JUSTIFY_LEFT, 50);
    }
}