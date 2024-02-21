import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;


class FancyLines extends WatchUi.Drawable {

    var mRadius = 120;

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var y1End = 135;
        var endX1 = getX(dc, -50, $.DataValues.width/1.9, 105);
        var endY1 = getY(dc, -50, y1End + 1, 105);
        var endX2 = getX(dc, -50, endX1, 15);
        var endY2 = getY(dc, -50,  endY1, 15);
        var arrow = [
            [45, y1End],            
            [$.DataValues.width / 7, y1End + 1],
            [$.DataValues.width / 1.9, y1End + 1],

            [endX1, endY1 + 1],
            [endX2, endY2],
            [endX1, endY1 - 1],
            
            [$.DataValues.width / 1.9, y1End - 1],
            [$.DataValues.width / 7, y1End - 1]
            //End
        ];

        dc.fillPolygon(arrow);

        var y2End = 255;
        var endX3 = getX(dc, -230, $.DataValues.width - $.DataValues.width / 1.65, 105);
        var endY3 = getY(dc, -230, y2End + 1, 105);
        var endX4 = getX(dc, -230, endX3, 15);
        var endY4 = getY(dc, -230,  endY3, 15);
        var arrow2 = [
            [$.DataValues.width - 25, y2End],            
            [$.DataValues.width - 40, y2End + 1],
            [$.DataValues.width - $.DataValues.width / 1.65, y2End + 1],

            [endX3, endY3 + 1],
            [endX4, endY4],
            [endX3, endY3 - 1],
            
            [$.DataValues.width - $.DataValues.width / 1.65, y2End - 1],
            [$.DataValues.width - 40, y2End - 1]
            //End
        ];

        dc.fillPolygon(arrow2);

        dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

        var y3End = 88;
        var x3Start = 75;
        var x3End = 245;

        var arrow3 = [
            [x3Start, y3End],            
            [x3Start+15, y3End-1],
            [x3End-15, y3End-1],
            [x3End, y3End],
            [x3End-15, y3End+1],
            [x3Start+15, y3End+1]
        ];

        dc.fillPolygon(arrow3);

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