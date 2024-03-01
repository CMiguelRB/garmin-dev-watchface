import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;


class FancyLines extends WatchUi.Drawable {

    var mRadius = 120;

    function initialize(params as Object) {
        Drawable.initialize(params);
    }

    function draw(dc){
        /*dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);

        var y2End = 255;
        var endX3 = getX(dc, -230, DataValues.width - DataValues.width / 1.65, 105);
        var endY3 = getY(dc, -230, y2End + 1, 105);
        var endX4 = getX(dc, -230, endX3, 15);
        var endY4 = getY(dc, -230,  endY3, 15);
        var arrow2 = [
            [DataValues.width - 25, y2End],            
            [DataValues.width - 40, y2End + 1],
            [DataValues.width - DataValues.width / 1.65, y2End + 1],

            [endX3, endY3 + 1],
            [endX4, endY4],
            [endX3, endY3 - 1],
            
            [DataValues.width - DataValues.width / 1.65, y2End - 1],
            [DataValues.width - 40, y2End - 1]
            //End
        ];

        dc.fillPolygon(arrow2);*/

        dc.setColor(Color.getColor("lines"), Graphics.COLOR_TRANSPARENT);


        /*var y3End = 88;
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

        dc.fillPolygon(arrow3);*/

        dc.setPenWidth(2);
        dc.drawLine(45, 118, 245, 118);
        dc.drawLine(245, 118, 275, 150);
        dc.drawLine(275, 150, 385, 150);

        dc.drawLine(45, 285, 135, 285);
        dc.drawLine(135, 285, 165, 253);
        dc.drawLine(165, 253, 385, 253);

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