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
        var sunrise = DataValues.sunrise;
        var sunset = DataValues.sunset;
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

        dc.drawText(101, 60, $.fonts.icons, "l", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(100, 76, $.fonts.data, sunrise, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(215, 60, $.fonts.icons, "m", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(218, 76, $.fonts.data, sunset, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(157, 82, $.fonts.icons, "q", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT); 

        var per = DataValues.dayPercentage;

        var startDegree = 165;
        var endDegree = 15;
        var totalDegree = startDegree - endDegree;
        var gap = 5;
        var sections = 5;
        var sectionsLength = (totalDegree - (gap * (sections-1))) / sections;

        var startSection = startDegree;
        var endSection = startDegree - sectionsLength;

        for(var i = 0; i<sections;i++){
            dc.drawArc(157, 83, 30, Graphics.ARC_CLOCKWISE, startSection, endSection);
            startSection = startSection - gap - sectionsLength;
            endSection = endSection - sectionsLength - gap;
        }  

        dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);

        var completionDegree;

        if(per < 1){
            return;
        }else if(per > 100){
            completionDegree = endDegree;
        }else{
            completionDegree = startDegree - ((totalDegree * per) / 100);
        }

        startSection = startDegree;
        endSection = startDegree - sectionsLength;

        for(var i = 0; i<sections;i++){
            if(endSection > completionDegree){
                dc.drawArc(157, 83, 30, Graphics.ARC_CLOCKWISE, startSection, endSection);
            }else if(startSection  <= completionDegree && completionDegree <= startSection + gap){
                continue;
            }else{
                dc.drawArc(157, 83, 30, Graphics.ARC_CLOCKWISE, startSection, completionDegree);
                break;
            }            
            startSection = startSection - gap - sectionsLength;
            endSection = endSection - sectionsLength - gap;
        }
    }
}