import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class BodyBattery extends WatchUi.Drawable {

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        var bodyBattery = SensorHistory.getBodyBatteryHistory({:period => 1}).next().data;
        drawInfo(dc, bodyBattery);
        drawBars(dc, bodyBattery);
    }

    hidden function drawInfo(dc, bodyBattery){
        if(bodyBattery == 100){
            dc.setColor(themeColor(Color.SECONDARY_1), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }

        dc.drawText(160, 305, Settings.resource(Rez.Fonts.Icons), "d", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    hidden function drawBars(dc, bodyBattery){
        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        dc.setPenWidth(8);

        var startX = 180;
        var endX = 355;
        var diffX = endX - startX;
        var gap = 5;
        var steps = 5;
        var stepsLength = (diffX - (gap * (steps-1))) / steps;
        var x = startX;

        for(var i = 0; i< steps; i++){
            dc.fillPolygon([[x,310], [x+10,295], [x+stepsLength+10,295], [x+stepsLength,310]]);
            x = x + stepsLength + gap;
        }   

        if(bodyBattery == 0){
            return;
        }

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);

        var translatedPercentage = (bodyBattery/100).toFloat();

        var completionX = Math.floor(diffX * translatedPercentage);

        if(completionX > diffX){
            completionX = diffX;
        }

        x = startX;

        for(var i = 0; i< steps; i++){
            if(x + stepsLength < startX + completionX){
                dc.fillPolygon([[x,310], [x+10,295], [x+stepsLength+10,295], [x+stepsLength,310]]);
            }else{
                dc.fillPolygon([[x,310], [x+10,295], [startX + completionX+10,295], [startX + completionX,310]]);
                break;
            }
            x = x + stepsLength + gap;
        } 
                
    }
}