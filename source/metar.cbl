       identification division.
       program-id. metar-parser.

       data division.
       working-storage section.
       01 metar-string PIC X(256).
       01 parsed-fields.
       05 observation-type pic x(5).
       05 station-id pic x(4).
           
           05 observation-time pic x(11).
           05 wind-direction pic x(7).
           05 visibility pic x(4).
           05 weather-condition pic x(3).
           05 cloud-cover-1 pic x(8).
           05 cloud-cover-2 pic x(8).
           05 temperature-dew-point pic x(9).
           05 altimeter pic x(6).
           05 tempo-indicator pic x(5).
           05 visibility-ground pic x(4).
           05 weather-condition2 pic x(2).
           05 cloud-cover pic x(7).

       procedure division.
           
           display "METAR Parsing example".
           display "Enter METAR string".
           accept metar-string
           unstring metar-string delimited by spaces
               into observation-type station-id observation-time
               wind-direction visibility weather-condition
               cloud-cover-1 cloud-cover-2 temperature-dew-point
               altimeter tempo-indicator visibility-ground 
               weather-condition2 cloud-cover
               end-unstring.
           display 'Observation type: ' OBSERVATION-TYPE.
           display 'Station ID: ' station-id.
           display 'Observation Time: ' observation-time.
           display 'Wind Direction: ' wind-direction.
           display 'Visibility: ' visibility.
           display 'Weather Condition: ' weather-condition.
           display 'Cloud Cover 1: ' cloud-cover-1.
           display 'Cloud Cover 2: ' cloud-cover-2.
           display 'Temperature/Dew Point: ' temperature-dew-point.
           display 'Altimeter: ' altimeter.
           display 'Tempo Indicator: ' tempo-indicator.
           display 'Visibility: ' visibility-ground.
           display 'Weather Condition: ' weather-condition2.
           display 'Cloud Cover: ' cloud-cover.

       end program metar-parser.
