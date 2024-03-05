import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


class DailyDistance extends WatchUi.Drawable {

    var mRadius;
    var mStartDegree;
    var mEndDegree;

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        var activities = DataValues.activities;
        var distance = DataValues.distance;
        drawBars(dc, activities, distance);
        drawInfo(dc, distance);
    }

    hidden function drawInfo(dc, distance){

        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);

        dc.drawText(315, 170, $.fonts.icons, "g", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        if(distance != null){
            var distanceKm = (distance.toFloat() / 100000).format("%.1f");

            dc.drawText(345, 173, $.fonts.data, distanceKm, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    hidden function drawBars(dc, activities, distance){

        dc.setPenWidth(10);

        dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);

        if(activities != null && distance != null){
            var x = 285;
            var base = 240;
            var hDiff = 45;
            var width = 12;
            var gap = 3;
            var dMax = 0;
            var dMin = 99999999;
            activities = activities.reverse() as Array<ActivityMonitor.History>;
            var dist = new ActivityMonitor.History();
            dist.distance = distance;
            activities.add(dist);
            activities = activities.slice(1,null);

            for(var i = 0; i<activities.size(); i++){
                if(activities[i] != null){
                    if(activities[i].distance > dMax){
                        dMax = activities[i].distance;
                    }
                    if(activities[i].distance < dMin){
                        dMin = activities[i].distance;
                    }                
                }
            }

            for(var i = 0; i < activities.size(); i++){
                var d = activities[i].distance;
                if(i == activities.size()-1){
                    dc.setColor(Color.getColor("secondary"), Graphics.COLOR_TRANSPARENT);
                }
                if(d != null){
                    var y = getY(d, dMax, dMin, hDiff, base);
                    var pts = [[x, base],[x, y],[x+width, y],[x+width, base]];
                    dc.fillPolygon(pts);
                }
                x = x + width + gap;
            }
        }
    }

    hidden function getY(distance, dMax, dMin, hDiff, base){
        var dDiff = dMax - dMin;
        var yLineConv;
        var disDminDiff = distance.toFloat() - dMin.toFloat();
        if(disDminDiff == 0.0 && dDiff == 0){
            return base;
        }
        yLineConv =  (disDminDiff / dDiff.toFloat() * hDiff + base).toFloat();
        return base - (yLineConv - base);
    }
}