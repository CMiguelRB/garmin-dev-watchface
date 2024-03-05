import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class Temps extends WatchUi.Drawable {

    function initialize(params as Object){
        Drawable.initialize(params);
    }

    function draw(dc){

        var low = DataValues.lowTemp;
        var high = DataValues.highTemp;

        if(low == null){
            low = ".";
        }
        if(high == null){
            high = ".";
        }
        
        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);   
        dc.drawText(80, 310, $.fonts.icons,  "r", Graphics.TEXT_JUSTIFY_RIGHT);     
        dc.drawText(107, 290, $.fonts.data,  high, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(130, 290, $.fonts.data,  "ºC", Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(107, 315, $.fonts.data,  low, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(130, 315, $.fonts.data,  "ºC", Graphics.TEXT_JUSTIFY_RIGHT);
    }
}