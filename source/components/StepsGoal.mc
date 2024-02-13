import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


class StepsGoal extends WatchUi.Drawable {

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        var steps = ActivityMonitor.getInfo().steps;
        var stepsGoal = ActivityMonitor.getInfo().stepGoal;
        drawArcs(dc, steps, stepsGoal);
        drawInfo(dc, steps, stepsGoal);
    }

    hidden function drawInfo(dc, steps, stepsGoal){
        if(steps > stepsGoal){
            dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }

        dc.drawText(255, 128, Settings.resource(Rez.Fonts.Icons), "j", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawText(305, 123, Settings.resource(Rez.Fonts.Data), steps, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    hidden function drawArcs(dc, steps, stepsGoal){
        dc.setPenWidth(10);

        var startDegree = 25;
        var endDegree = 60;
        var sections = 4;
        var gap = 2;
        var diffDegree = endDegree - startDegree;

        var sectionsLength = (diffDegree - (gap * (sections-1))) / sections;

        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        var startSection = 25;
        var endSection = sectionsLength + startDegree;

        for(var i = 0; i<sections;i++){
            dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, dc.getWidth()/2-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, endSection);
            startSection = sectionsLength + gap + startSection;
            endSection = endSection + sectionsLength + gap;
        }      

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);        

        var goalPercentage = (100 * steps / stepsGoal).toFloat();

        var translatedPercentage = (goalPercentage/100).toFloat();

        var completionDegree = Math.floor(diffDegree * translatedPercentage);

        if(completionDegree > diffDegree){
            completionDegree = diffDegree;
        }

        completionDegree = startDegree + completionDegree;

        if(steps == 0 || stepsGoal == 0 || completionDegree == 25.0){
            return;
        }
        
        startSection = 25;
        endSection = sectionsLength + startSection;

        for(var i = 0; i<sections;i++){
            if(endSection < completionDegree){
                dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, dc.getWidth()/2-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, endSection);
            }else if(startSection - gap <= completionDegree && completionDegree <= startSection){
                continue;
            }else{
                dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, dc.getWidth()/2-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, completionDegree);
                break;
            }            
            startSection = sectionsLength + gap + startSection;
            endSection = endSection + sectionsLength + gap;
        }     
    }
}