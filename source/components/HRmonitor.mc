import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;


class HRmonitor extends WatchUi.Drawable {

    hidden var mWmin;
    hidden var mWdiff;
    hidden var mHmax;
    hidden var mHmin;
    hidden var mHdiff;

    function initialize(params as Object) {
        Drawable.initialize(params);

        mWmin = 85;
        mWdiff = DataValues.width - (mWmin * 2);
        mHmax = 55;
        mHmin = 35;
        mHdiff = mHmax - mHmin;
    }

    function draw(dc){

        var showHrChart = Properties.getValue("showHrChart");

        //Draw HR icon and current HR value
        drawCurrentHr(dc, showHrChart);

        //Draw HR chart       
        if(showHrChart == true && DataValues.hrSamples != null && DataValues.hrSamplesCounter > 0){
            drawHrChart(dc);
        }     
    }

    hidden function drawHrChart(dc){    

        var chartColorValue = Properties.getValue("chartColor");

        if(chartColorValue == 0){
            dc.setColor(Color.getColor("secondary"), Graphics.COLOR_TRANSPARENT);
        }else{
            dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);
        }

        var samples = DataValues.hrSamples as Array<Number>;
        var hrMax = DataValues.hrMin;
        var hrMin = DataValues.hrMax;
        var samplesCounter = DataValues.hrSamplesCounter;

        var startX = mWmin;
        var xLength = (mWdiff) / samplesCounter;
        var gap = 1;
        var endY = DataValues.height;

        for(var i = 0; i<samplesCounter; i++){
            if(samples[i] != null){
                var startY = transformYValue(samples[i], hrMin, hrMax);
                dc.fillRectangle(startX, startY, xLength, endY);
            }
            startX += xLength + gap;
        }
    }

    hidden function transformYValue(sample, hrMin, hrMax){
        var hrDiff = hrMax - hrMin;
        var yLineConv;
        if(sample != null){
            var hrHrMinDiff = sample.toFloat() - hrMin.toFloat();
            yLineConv =  (hrHrMinDiff / hrDiff.toFloat() * mHdiff + mHmin).toFloat();
        }else{
            yLineConv = mHmax;
        } 
        yLineConv = DataValues.height - yLineConv;
        return yLineConv;
    }

    hidden function drawCurrentHr(dc, showHrChart){
        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);

        var currentHr = DataValues.currentHr;

        if(currentHr == null){
            currentHr = "--";
        }else{
            currentHr = currentHr.format("%i");
        }

        var variableY = 130;

        if(showHrChart == false){
            variableY = 160;
        }


        dc.drawText(DataValues.centerX - 30, DataValues.centerY + variableY - 14, $.fonts.icons, "o", Graphics.TEXT_JUSTIFY_CENTER);

        var charArray = currentHr.toCharArray() as Array<Char>;
        var hrX = DataValues.centerX - 5;
        var hrY = DataValues.centerY + variableY;
        var offset = 0;

        for(var i = 0; i < charArray.size(); i++ ){
            dc.drawText(
                hrX + offset,
                hrY,
                $.fonts.date,
                charArray[i],
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );  
            offset += 15; 
        } 
    }
}