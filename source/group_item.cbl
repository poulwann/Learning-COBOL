       identification division.
       Program-Id. Group-Item.
       data division.
       working-storage section.
       01 item-data value "10 example item".
          05 item-number PIC 9(3).
          05 item-description PIC X(30).
    
       procedure division.

           display "Item Number : " item-number.
           display "item description : " ITEM-DESCRIPTION.

       