import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


class StepsGoal extends WatchUi.Drawable {

    var mRadius;
    var mStartDegree;
    var mEndDegree;

    function initialize(params as Object) {
        Drawable.initialize(params);
        mStartDegree = params[:startDegree];
        mEndDegree = params[:endDegree];
        mRadius = params[:radius];
    }

    function draw(dc){
        var steps = ActivityMonitor.getInfo().steps;
        var stepsGoal = ActivityMonitor.getInfo().stepGoal;
        drawArcs(dc, steps, stepsGoal);
        drawInfo(dc, steps, stepsGoal);
    }

    hidden function drawInfo(dc, steps, stepsGoal){
        if(steps > stepsGoal){
            dc.setColor(themeColor(Color.SECONDARY_1), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }

        dc.drawText(310, 105, Settings.resource(Rez.Fonts.Icons), "j", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawText(310, 140, Settings.resource(Rez.Fonts.Test), steps, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);


        /* dc.drawText(65, 250, Settings.resource(Rez.Fonts.Icons), "b", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(75, 250, Settings.resource(Rez.Fonts.Test), activity.total+"/"+activityGoal, Graphics.TEXT_JUSTIFY_LEFT); */
    }

    hidden function drawArcs(dc, steps, stepsGoal){
        dc.setPenWidth(8);

        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);


        dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, dc.getWidth()/2-32, Graphics.ARC_COUNTER_CLOCKWISE, 20, 55);

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);

        var diffDegree = 55 - 20;

        var goalPercentage = (100 * steps / stepsGoal).toFloat();

        var translatedPercentage = (goalPercentage/100).toFloat();

        var completionDegree = Math.floor(diffDegree * translatedPercentage);

        if(completionDegree > diffDegree){
            completionDegree = diffDegree;
        }

        completionDegree = 20 + completionDegree;

        if(steps == 0 || stepsGoal == 0 || completionDegree == 20.0){
            return;
        }

        dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, dc.getWidth()/2-32, Graphics.ARC_COUNTER_CLOCKWISE, 20, completionDegree);

        //dc.drawArc(dc.getWidth()/2-43, dc.getWidth()/2-43, 30, Graphics.ARC_COUNTER_CLOCKWISE, 135, 315);
        //dc.drawArc(dc.getWidth()/2, dc.getWidth()/2, 30, Graphics.ARC_COUNTER_CLOCKWISE, 315, 135);
    }

    hidden function getX(dc, degree, x, radius) {
        degree = Math.toRadians(degree);
        return x.toFloat() + radius.toFloat() * Math.cos(degree);
    }

    hidden function getY(dc, degree, y, radius) {
        degree = Math.toRadians(degree);
        return  (y.toFloat() + radius.toFloat() * Math.sin(degree));
    }
}