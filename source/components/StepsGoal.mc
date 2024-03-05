import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


class StepsGoal extends WatchUi.Drawable {

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        var steps = DataValues.steps;
        var stepsGoal = DataValues.stepsGoal;
        drawArcs(dc, steps, stepsGoal);
        if(steps != null){
            drawInfo(dc, steps, stepsGoal);
        }
    }

    hidden function drawInfo(dc, steps, stepsGoal){
        if(steps >= stepsGoal){
            dc.setColor(Color.getColor("secondary"), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);
        }

        dc.drawText(270, 43, $.fonts.icons, "j", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawText(340, 125, $.fonts.data, steps, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    hidden function drawArcs(dc, steps, stepsGoal){
        dc.setPenWidth(10);

        var startDegree = 25;
        var endDegree = 65;
        var sections = 4;
        var gap = 2;
        var diffDegree = endDegree - startDegree;

        var sectionsLength = (diffDegree - (gap * (sections-1))) / sections;

        dc.setColor(Color.getColor("inactive"), Graphics.COLOR_TRANSPARENT);

        var startSection = 25;
        var endSection = sectionsLength + startDegree;

        for(var i = 0; i<sections;i++){
            dc.drawArc(DataValues.centerX, DataValues.centerX, DataValues.centerX-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, endSection);
            startSection = sectionsLength + gap + startSection;
            endSection = endSection + sectionsLength + gap;
        }      

        if(steps != null && stepsGoal != null){
            dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);

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
                    dc.drawArc(DataValues.centerX, DataValues.centerX, DataValues.centerX-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, endSection);
                }else if(startSection - gap <= completionDegree && completionDegree <= startSection){
                    continue;
                }else{
                    dc.drawArc(DataValues.centerX, DataValues.centerX, DataValues.centerX-30, Graphics.ARC_COUNTER_CLOCKWISE, startSection, completionDegree);
                    break;
                }            
                startSection = sectionsLength + gap + startSection;
                endSection = endSection + sectionsLength + gap;
            }     
        }
    }
}