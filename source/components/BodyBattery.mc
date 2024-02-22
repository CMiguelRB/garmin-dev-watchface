import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;


class BodyBattery extends WatchUi.Drawable {

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        
        var bodyBattery = $.DataValues.bodyBattery;
        drawInfo(dc, bodyBattery);
        drawBars(dc, bodyBattery);
    }

    hidden function drawInfo(dc, bodyBattery){
        if(bodyBattery == null){
            dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT);
        }else if(bodyBattery == 100){
            dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);
        }

        dc.drawText(160, 305, Settings.resource(Rez.Fonts.Icons), "n", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    hidden function drawBars(dc, bodyBattery){
        dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT);

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

        if(bodyBattery == null || bodyBattery == 0){
            return;
        }

        dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);

        var translatedPercentage = (bodyBattery/100).toFloat();

        var completionX = Math.floor(diffX * translatedPercentage);

        if(completionX > diffX){
            completionX = diffX;
        }

        x = startX;

        for(var i = 0; i< steps; i++){
            if(x + stepsLength < startX + completionX){
                dc.fillPolygon([[x,310], [x+10,295], [x+stepsLength+10,295], [x+stepsLength,310]]);
            }else if(x - gap <= completionX + startX && completionX + startX <= x){
                continue;
            }else{
                dc.fillPolygon([[x,310], [x+10,295], [startX + completionX+10,295], [startX + completionX,310]]);
                break;
            }
            x = x + stepsLength + gap;
        } 
                
    }
}