import Toybox.System;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Position;
import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Math;

module DataRetriever {

    function retrieveData(){
        var currentMoment = Time.now().value();
        if(DataValues.lastRetrievalMoment == null || currentMoment - DataValues.lastRetrievalMoment > 5){

            getBattery();  
            getLocation();
            getSunEvents();
            getHeartRate();

            getSteps();
            getBodyBattery();
            getActivityGoal();
            getAltitude();
            getDistance();
            getTemps();

            DataValues.lastRetrievalMoment = Time.now().value();
        }
    }

    function getBattery(){
        DataValues.batteryInDays = System.getSystemStats().batteryInDays;
        DataValues.batteryInPercentage = System.getSystemStats().battery;
    }    

    function getSunEvents(){
        var now = Time.now();
        if(
            (DataValues.lastSunEventsRetrieval == null
             || Time.Gregorian.info(now, Time.FORMAT_MEDIUM).day
             != Time.Gregorian.info(DataValues.lastSunEventsRetrieval, Time.FORMAT_MEDIUM).day)
            || DataValues.updateSunEvents == true){
            var lastLocation = DataValues.lastLocation;
            if(lastLocation != null){
                var sunset = null;
                var sunrise = null;
                var location = new Position.Location({
                        :latitude => lastLocation[0],
                        :longitude => lastLocation[1],
                        :format => :degrees
                    }); 
                if(location != null){
                    var sunsetMoment = Weather.getSunset(location, now);
                    var sunriseMoment = Weather.getSunrise(location, now);
                    sunset = Time.Gregorian.info(sunsetMoment, Time.FORMAT_MEDIUM).hour.format("%02d") + ":" + Time.Gregorian.info(sunsetMoment, Time.FORMAT_MEDIUM).min.format("%02d");
                    sunrise = Time.Gregorian.info(sunriseMoment, Time.FORMAT_MEDIUM).hour.format("%02d") + ":" + Time.Gregorian.info(sunriseMoment, Time.FORMAT_MEDIUM).min.format("%02d");
                        
                    DataValues.sunrise = sunrise;
                    DataValues.sunset = sunset;
                    DataValues.sunriseMoment = sunriseMoment;
                    DataValues.sunsetMoment = sunsetMoment;
                    DataValues.lastSunEventsRetrieval = now;
                    DataValues.updateSunEvents = false;
                }        
            }   
        }
        if(DataValues.sunriseMoment != null && DataValues.sunsetMoment != null){
            var total = DataValues.sunsetMoment.compare(DataValues.sunriseMoment);
            var passed = now.compare(DataValues.sunriseMoment);
            DataValues.dayPercentage = (passed * 100) / total;
        }
    }

    function getLocation(){
        var location = Weather.getCurrentConditions().observationLocationPosition;
        var lastLocation = DataValues.lastLocation;
        if(location != null && lastLocation != null){
            location = location.toDegrees();
            if(location[0] != lastLocation[0] || location[1] != lastLocation[1]){
                DataValues.lastLocation =  location;
                DataValues.updateSunEvents =  true;
            }            
        }else{
            DataValues.lastLocation =  location.toDegrees();
            DataValues.updateSunEvents =  true;
        }
    }

    function getHeartRate(){
        DataValues.currentHr = Activity.getActivityInfo().currentHeartRate;
        var hrIterator = ActivityMonitor.getHeartRateHistory(new Time.Duration(3600), false);
        DataValues.hrMax = hrIterator.getMax();
        DataValues.hrMin = hrIterator.getMin();
        var samples = {};
        var counter = 0;
        var innerCounter = 0;
        var sample = hrIterator.next();
        while (sample != null){
            if(counter % 3 == 0){
                if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                        samples[innerCounter] = sample.heartRate;
                }else{
                    samples[innerCounter] = null;
                }    
                innerCounter++;
            }   
            sample = hrIterator.next();  
            counter++;              
        }
        DataValues.hrSamples = samples;
        DataValues.hrSamplesCounter = innerCounter;
    }

    function getSteps(){
        DataValues.steps = ActivityMonitor.getInfo().steps;
        DataValues.stepsGoal = ActivityMonitor.getInfo().stepGoal;
    }

    function getBodyBattery(){
        var bodyBattery = SensorHistory.getBodyBatteryHistory({:period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST}).next();
        if(bodyBattery == null){
            var iterator = SensorHistory.getBodyBatteryHistory({:period => 100, :order => SensorHistory.ORDER_NEWEST_FIRST});
            bodyBattery = iterator.next();
            if(bodyBattery == null){
                while(bodyBattery == null){
                    bodyBattery = iterator.next();
                }
            }
        }
        DataValues.bodyBattery = bodyBattery.data;
    }

    function getActivityGoal(){
        DataValues.activity = ActivityMonitor.getInfo().activeMinutesWeek;
        DataValues.activityGoal = ActivityMonitor.getInfo().activeMinutesWeekGoal;
    }

    function getAltitude(){
        var altitude = SensorHistory.getElevationHistory({:period => 1}).next();
        if(altitude == null){
            var iterator = SensorHistory.getElevationHistory({:period => 100, :order => SensorHistory.ORDER_NEWEST_FIRST});
            altitude = iterator.next();
            if(altitude == null){
                while(altitude == null){
                    altitude = iterator.next();
                }
            }
        }
        DataValues.altitude = Math.round(altitude.data).toNumber();
    }

    function getDistance(){
        DataValues.activities = ActivityMonitor.getHistory();
        DataValues.distance = ActivityMonitor.getInfo().distance;
    }

    function getTemps(){
        DataValues.lowTemp = Weather.getCurrentConditions().lowTemperature;
        DataValues.highTemp = Weather.getCurrentConditions().highTemperature;
    }
}