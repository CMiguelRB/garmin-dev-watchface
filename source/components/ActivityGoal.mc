import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


class ActivityGoal extends WatchUi.Drawable {

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
        var activity = ActivityMonitor.getInfo().activeMinutesWeek;
        var activityGoal = ActivityMonitor.getInfo().activeMinutesWeekGoal;
        //drawArcs(dc, activity, activityGoal);
        drawInfo(dc, activity, activityGoal);
        drawBars(dc, activity, activityGoal);
    }

    hidden function drawInfo(dc, activity, activityGoal){
        if(activity.total > activityGoal){
            dc.setColor(themeColor(Color.SECONDARY_1), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }

        //dc.drawText(190, 290, Settings.resource(Rez.Fonts.Icons), "a", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawText(175, 272, Settings.resource(Rez.Fonts.Icons), "a", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);


        /* dc.drawText(65, 250, Settings.resource(Rez.Fonts.Icons), "b", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(75, 250, Settings.resource(Rez.Fonts.Test), activity.total+"/"+activityGoal, Graphics.TEXT_JUSTIFY_LEFT); */
    }

    hidden function drawArcs(dc, activity, activityGoal){
        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        dc.setPenWidth(8);

        dc.drawArc(190, 290, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360);

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);

        var diffDegree = 360 - 0;

        var goalPercentage = (100 * activity.total / activityGoal).toFloat();

        var translatedPercentage = (goalPercentage/100).toFloat();

        var completionDegree = Math.floor(diffDegree * translatedPercentage);

        if(completionDegree > diffDegree){
            completionDegree = diffDegree;
        }
        if(activity.total == 0 || activityGoal == 0){
            return;
        }

        dc.drawArc(190, 290, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, completionDegree);
    }

    /*hidden function drawBars(dc, activity, activityGoal){
        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        dc.setPenWidth(8);

        dc.fillPolygon([[195,280], [205,265], [380,265], [370,280]]);

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);

        var goalPercentage = (100 * activity.total / activityGoal).toFloat();

        var translatedPercentage = (goalPercentage/100).toFloat();

        var diffX = 175;

        var completionX = Math.floor(diffX * translatedPercentage);

        if(completionX > diffX){
            completionX = diffX;
        }
        if(activity.total == 0 || activityGoal == 0){
            return;
        }        

        dc.fillPolygon([[195,280], [205,265], [205+completionX,265], [195+completionX,280]]);

    }*/

    hidden function drawBars(dc, activity, activityGoal){
        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        dc.setPenWidth(8);

        var startX = 195;
        var endX = 370;
        var y1 = 280;
        var y2 = 265;
        var diffX = endX - startX;
        var gap = 5;
        var steps = 5;
        var stepsLength = (diffX - (gap * (steps-1))) / steps;
        var x = startX;

        for(var i = 0; i< steps; i++){
            dc.fillPolygon([[x,y1], [x+10,y2], [x+stepsLength+10,y2], [x+stepsLength,y1]]);
            x = x + stepsLength + gap;
        }   

        if(activity.total == 0 || activityGoal == 0){
            return;
        }  

        dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);

        var goalPercentage = (100 * activity.total / activityGoal).toFloat();

        var translatedPercentage = (goalPercentage/100).toFloat();

        var completionX = Math.floor(diffX * translatedPercentage);

        if(completionX > diffX){
            completionX = diffX;
        }

        x = startX;

        for(var i = 0; i< steps; i++){
            if(x + stepsLength < startX + completionX){
                dc.fillPolygon([[x,y1], [x+10,y2], [x+stepsLength+10,y2], [x+stepsLength,y1]]);
            }else{
                dc.fillPolygon([[x,y1], [x+10,y2], [startX + completionX+10,y2], [startX + completionX,y1]]);
                break;
            }
            x = x + stepsLength + gap;
        } 
                
    }
}