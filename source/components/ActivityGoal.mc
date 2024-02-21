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
        var activity = $.DataValues.activity;
        var activityGoal = $.DataValues.activityGoal;
        drawInfo(dc, activity, activityGoal);
        drawBars(dc, activity, activityGoal);
    }

    hidden function drawInfo(dc, activity, activityGoal){
        if(activity == null || activityGoal == null){
            dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);
        }else if(activity.total > activityGoal){
            dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }


        dc.drawText(175, 276, Settings.resource(Rez.Fonts.Icons), "p", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

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

       if(activity == null || activityGoal == null || activity.total == 0 || activityGoal == 0){
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
            }else if(x - gap <= completionX + startX && completionX + startX <= x){
                continue;
            }else{
                dc.fillPolygon([[x,y1], [x+10,y2], [startX + completionX+10,y2], [startX + completionX,y1]]);
                break;
            }
            x = x + stepsLength + gap;
        } 
                
    }
}