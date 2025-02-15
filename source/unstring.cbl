       identification division.
       Program-Id. Unstring-group.
       data division.
       working-storage section.
       01 example-data value "METAR EKCH 151320Z".
          05 report-type pic x(5).
          05 report-station pic x(4).
          05 report-weather pic x(10).
    
       procedure division.

           display "Unstring example".
           unstring example-data delimited by spaces
           into report-type report-station report-weather
           end-unstring.
           display "type: "report-type.
           display "station: "report-station.
           display "weather: "report-weather.
