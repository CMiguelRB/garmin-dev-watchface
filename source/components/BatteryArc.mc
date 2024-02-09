import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Lang;

class BatteryArc extends DataFieldDrawable {

  hidden var mStartDegree;
  hidden var mEndDegree;
  hidden var mTotalDegree;
  hidden var mRadius;

  function initialize(params as Object) {
    DataFieldDrawable.initialize(params);

    mStartDegree = 90 - params[:gapDegree];
    mEndDegree = 90 + params[:gapDegree];
    mTotalDegree = 360 - params[:gapDegree] * 2;
    mRadius = params[:radius];
  }

  function draw(dc) {
    DataFieldDrawable.draw(dc);
    if (mLastInfo != null) {
      update(dc);
    }
  }

  function update(dc) {
    setAntiAlias(dc, true);
    if (mLastInfo.progress > 1.0) {
      mLastInfo.progress = 1.0;
    }
    // draw remaining arc first so it wont overdraw our endpoint
    drawMargin(dc);
    dc.setPenWidth(12);
    drawRemainingArc(dc, mLastInfo.progress);
    drawProgressArc(dc, mLastInfo.progress);
    drawIcon(dc);

    setAntiAlias(dc, false);
  }

  function partialUpdate(dc) {
    drawPartialUpdate(dc, method(:update));
  }

  hidden function drawMargin(dc){
    dc.setPenWidth(20);
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(
        Settings.get("centerXPos"),
        Settings.get("centerYPos"),
        mRadius+8,
        Graphics.ARC_CLOCKWISE,
        0,
        360
      );
  }

  hidden function drawProgressArc(dc, fillLevel) {
    dc.setColor(themeColor(Color.PRIMARY), Graphics.COLOR_TRANSPARENT);
    if (fillLevel > 0.0) {
      var startDegree = mStartDegree;
      var endDegree = mStartDegree - getFillDegree(fillLevel);

      drawEndpoint(dc, startDegree, 0, 0);
      drawEndpoint(dc, endDegree, 0, 0);

      dc.drawArc(
        Settings.get("centerXPos"),
        Settings.get("centerYPos"),
        mRadius,
        Graphics.ARC_CLOCKWISE,
        mStartDegree,
        endDegree
      );
    }
  }

  hidden function drawRemainingArc(dc, fillLevel) {    
    dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);

    drawEndpoint(dc, mStartDegree, 0, 0);
    drawEndpoint(dc, mEndDegree, 0, 0);

    dc.drawArc(
      Settings.get("centerXPos"),
      Settings.get("centerYPos"),
      mRadius,
      Graphics.ARC_CLOCKWISE,
      mStartDegree,
      mEndDegree
    );    
  }

  hidden function drawEndpoint(dc, degree, offX, offY) {
    var x = Math.round(getX(dc, degree));
    var y = Math.round(getY(dc, degree));
    
    
    dc.fillCircle(x+offX, y+offY, 5);
  }

  hidden function drawIcon(dc) {
    if (mLastInfo.progress == 0) {
      dc.setColor(themeColor(Color.TEXT_INACTIVE), Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    }

    var  x = Settings.get("centerXPos");
    var  y = Settings.get("topYPos") + 15; 
    

    if(mLastInfo.text.equals("  ")){
      mLastInfo.text = "0";
    }

    mLastInfo.text = mLastInfo.text + "d";

    dc.drawText(
        x-17,
        y-2,
        Settings.resource(Rez.Fonts.Icons),
        "h",
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );  

    var charArray = mLastInfo.text.toCharArray() as Array<String>;
    var offset = - 5;

    for(var i = 0; i < charArray.size() as Number; i++ ){
      dc.drawText(
        x + offset,
        y,
        Settings.resource(Rez.Fonts.Test),
        charArray[i],
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );  
      offset += 12; 
    } 
  }

  hidden function getX(dc, degree) {
    degree = Math.toRadians(degree);
    return (dc.getHeight()/2).toFloat() + mRadius.toFloat() * Math.cos(degree);
  }

  hidden function getY(dc, degree) {
    degree = Math.toRadians(degree);
    return dc.getHeight().toFloat() - ((dc.getHeight()/2).toFloat() + mRadius.toFloat() * Math.sin(degree));
  }

  hidden function getFillDegree(fillLevel) {
    return mTotalDegree * fillLevel;
  }
} 