import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;


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

        //Draw HR icon and current HR value
        drawCurrentHr(dc);

        //Draw HR chart        
        drawHrChart(dc, DataValues.height) as Array<Array>;        
    }

    hidden function drawHrChart(dc, height){    

        dc.setPenWidth(6);

        dc.setColor(Color.getColor("secondary"), Graphics.COLOR_TRANSPARENT);

        var samples = DataValues.hrSamples as Array<Number>;
        var hrMax = DataValues.hrMin;
        var hrMin = DataValues.hrMax;
        var innerCounter = DataValues.hrSamplesCounter;

        //Define line x length
        var xLength = (mWdiff + 10) / innerCounter;

        //Get firtst Y transformed point
        var sample = samples[0];
        var startYLine = transformYValue(sample, hrMax, hrMin, height);
        
        //Initialize coordinates
        var startPoint = [mWmin, startYLine];
        var endPoint = [(mWmin+xLength), null];
        
        //initialize arrays
        var polyPoints = new [(innerCounter*2)];

        //Loop samples
        for(var i = 0; i<innerCounter-1; i++){
            var currentSample = samples[i];
            var nextSample = samples[(i+1)];
            if(currentSample == null){
                startPoint[0] = endPoint[0];
                endPoint[0] = endPoint[0] + xLength;
                polyPoints[i*2] = [startPoint[0]-xLength, height];
                polyPoints[i*2+1] = [endPoint[0]-xLength, height];
                continue;           
            }
            endPoint[1] = transformYValue(nextSample, hrMax, hrMin, height);                     
            dc.drawLine(startPoint[0], startPoint[1], endPoint[0], endPoint[1]);         
            polyPoints[i*2] = [startPoint[0], startPoint[1]];
            polyPoints[i*2+1] = [endPoint[0], endPoint[1]];
            startPoint[0] = endPoint[0];
            startPoint[1] = endPoint[1];
            endPoint[0] = endPoint[0] + xLength;
        }

        //Finish polygon
        polyPoints[(innerCounter*2)-2] = [endPoint[0]-xLength, height];
        polyPoints[(innerCounter*2)-1] = [mWmin, height];

        dc.setColor(Color.getColor("primary"), Graphics.COLOR_TRANSPARENT);

        dc.fillPolygon(polyPoints);
    }

    hidden function transformYValue(sample, hrMin, hrMax, height){
        var hrDiff = hrMax - hrMin;
        var yLineConv;
        if(sample != null){
            var hrHrMinDiff = sample.toFloat() - hrMin.toFloat();
            yLineConv =  (hrHrMinDiff / hrDiff.toFloat() * mHdiff + mHmin).toFloat();
        }else{
            yLineConv = mHmax;
        } 
        yLineConv = height - yLineConv;
        return yLineConv;
    }

    hidden function drawCurrentHr(dc){
        dc.setColor(Color.getColor("text"), Graphics.COLOR_TRANSPARENT);

        var currentHr = DataValues.currentHr;

        if(currentHr == null){
            currentHr = "--";
        }else{
            currentHr = currentHr.format("%i");
        }

        dc.drawText(DataValues.centerX - 25, DataValues.centerY + DataValues.height/4 + 15, $.fonts.icons, "o", Graphics.TEXT_JUSTIFY_CENTER);

        var charArray = currentHr.toCharArray() as Array<Char>;
        var hrX = DataValues.centerX;
        var hrY = DataValues.centerY + 130;
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