CLASS zcl_date DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    DATA:
      intervals.
    CLASS-METHODS:
      day IMPORTING date TYPE d RETURNING VALUE(day) TYPE i,
      "! based on ISO 8601 - 1st week in year is the one with first Thursday (in other words, the one  with 4th January).
      week IMPORTING date TYPE d RETURNING VALUE(week) TYPE kweek,
      month IMPORTING date TYPE d RETURNING VALUE(month) TYPE i,
      year IMPORTING date TYPE d RETURNING VALUE(year) TYPE i,
      "! @parameter day | 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
      weekday IMPORTING date TYPE d RETURNING VALUE(day) TYPE i,
      first_day_in_month IMPORTING date TYPE d RETURNING VALUE(first_day_in_month) TYPE d,
      last_day_in_month IMPORTING date TYPE d RETURNING VALUE(last_day_in_month) TYPE d,
      days_in_month IMPORTING date TYPE d RETURNING VALUE(days) TYPE i,
      days_in_year IMPORTING date TYPE d RETURNING VALUE(days) TYPE i,
      "! Overflow will be converted (e.g. 33.01 = 02.02).
      create IMPORTING year TYPE i month TYPE i day TYPE i RETURNING VALUE(date) TYPE d,
      "! @parameter interval | Y,R - year; M - month; W - week; D - day;
      add_to_date IMPORTING  interval TYPE c value TYPE i date TYPE d RETURNING VALUE(result_date) TYPE d,
      "! @parameter interval | Y,R - year; M - month; W - week; D - day;
      difference IMPORTING interval TYPE c date_from TYPE d date_to TYPE d RETURNING VALUE(difference) TYPE i,
      "! Tries to pars given string to date object using given mask and regular expressions. Overflow will be converted (e.g. 33.01 = 02.02).
      "! @parameter date_string | String to find mask in.
      "! @parameter mask | Mask to look for in string. Will be used as regular expression mask (so special character must be escaped).
      "! Must contain DD or D for days, MM or M for months and YYYY or RRRR for years.
      "! @raising zcx_exception | Raise exception if no date found in string or if mask is invalid.
      parse_string IMPORTING date_string TYPE string mask TYPE string RETURNING VALUE(date) TYPE d RAISING zcx_exception.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS:
     known_thursday TYPE d VALUE '19700101'.
    CLASS-METHODS:
      replace_pattern IMPORTING pattern TYPE string with TYPE string EXPORTING index TYPE i CHANGING text TYPE string RAISING zcx_exception.

ENDCLASS.



CLASS zcl_date IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>ADD_TO_DATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] INTERVAL                       TYPE        C
* | [--->] VALUE                          TYPE        I
* | [--->] DATE                           TYPE        D
* | [<-()] RESULT_DATE                    TYPE        D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_to_date.
    DATA(interval_ucase) = to_upper( interval ) .
    CONDENSE interval_ucase.
    result_date = date.

    CASE interval_ucase.
      WHEN 'Y' OR 'R'. "YEAR
        result_date(4) = CONV i( date(4) ) + value.
        IF result_date+4(4) = '0229'. "Check for leap year
          result_date+6(2) = COND #( WHEN result_date+2(2) MOD 4 = 0 THEN 29 ELSE 28 ).
        ENDIF.

      WHEN 'M'. "MONTH
        "Instead of adding months to given date (problematic when e.g. add 1 month to December,
        "because it rolls over to next year), consider adding corrected number of months to January
        DATA(months_to_add) = value + CONV i( result_date+4(2) ) - 1.
        result_date+4(2)  = '01'.
        "First add all years in months, so it leaves < 12 months
        DATA(years_to_add) = CONV i( trunc( CONV f( months_to_add ) / 12 ) ).
        result_date(4) = CONV i( date(4) ) + years_to_add.
        "Add remaining months
        IF months_to_add - 12 * years_to_add >= 0.
          result_date+4(2) = |{ 1 + months_to_add - 12 * years_to_add ALIGN = RIGHT PAD = '0' WIDTH = 2 }| .
        ELSE.
          result_date(4) = CONV i( result_date(4) ) - 1.
          result_date+4(2) = |{ 12 + 1 + months_to_add - 12 * years_to_add ALIGN = RIGHT PAD = '0' WIDTH = 2 }| .
        ENDIF.

        "Check for correct number of days in month
        IF day( result_date ) >= day( last_day_in_month( result_date ) ).
          result_date = last_day_in_month( result_date ).
        ENDIF.

      WHEN 'W'. "WEEK
        result_date =  result_date + 7 * value.

      WHEN 'D'. "DAY
        result_date =  result_date + value.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] YEAR                           TYPE        I
* | [--->] MONTH                          TYPE        I
* | [--->] DAY                            TYPE        I
* | [<-()] DATE                           TYPE        D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create.
    date(4) = year.
    date+4(4) = '0101'.
    date = add_to_date( interval = 'M' value = ( month - 1 ) date = date ).
    date = add_to_date( interval = 'D' value = ( day - 1 ) date = date ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>DAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] DAY                            TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD day.
    day = date+6(2).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>DAYS_IN_MONTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] DAYS                           TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD days_in_month.
    CASE date+4(2).
      WHEN '01' OR '03' OR '05' OR '07' OR '08' OR '10' OR '12'.
        days = 31.
      WHEN '02'.
        days = COND #( WHEN year( date ) MOD 4 = 0 THEN 29 ELSE 28 ).
      WHEN '04' OR '06' OR '09' OR '11'.
        days = 30.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>DAYS_IN_YEAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] DAYS                           TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD days_in_year.
    days = COND #( WHEN year( date ) MOD 4 = 0 THEN 366 ELSE 365 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>DIFFERENCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] INTERVAL                       TYPE        C
* | [--->] DATE_FROM                      TYPE        D
* | [--->] DATE_TO                        TYPE        D
* | [<-()] DIFFERENCE                     TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD difference.
    DATA(interval_ucase) = to_upper( interval ) .
    CONDENSE interval_ucase.

    CASE interval_ucase.
      WHEN 'Y' OR 'R'. "YEAR
        difference = year( date_to ) - year( date_from ).

      WHEN 'M'. "MONTH
        difference = 12 * ( year( date_to ) - year( date_from ) ) + month( date_to ) - month( date_from ).

      WHEN 'W'. "WEEK
        difference =  trunc(  ( CONV f( date_to  - date_from ) ) / 7 ). "Apparently 12 / 7 = 2, because SAP rounds it ¯\_(ツ)_/¯
        DATA(weekday_diff) = ( abs( date_to - date_from ) )  MOD 7.
        IF  date_from <= date_to AND weekday_diff >= weekday( date_to ) .
          difference = difference + 1.
        ELSEIF date_from > date_to AND weekday_diff > 7 - weekday( date_to ) .
          difference = difference - 1.
        ENDIF.

      WHEN 'D'. "DAY
        difference = date_to - date_from.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>FIRST_DAY_IN_MONTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] FIRST_DAY_IN_MONTH             TYPE        D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD first_day_in_month.
    first_day_in_month = date.
    first_day_in_month+6(2) = '01'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>LAST_DAY_IN_MONTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] LAST_DAY_IN_MONTH              TYPE        D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD last_day_in_month.
    last_day_in_month = date.
    last_day_in_month+6(2) = days_in_month( date ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>MONTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] MONTH                          TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD month.
    month = date+4(2).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>PARSE_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE_STRING                    TYPE        STRING
* | [--->] MASK                           TYPE        STRING
* | [<-()] DATE                           TYPE        D
* | [!CX!] ZCX_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD parse_string.
    TYPES:
      BEGIN OF t_inteval_index,
        interval(1) TYPE c,
        index       TYPE i,
      END OF t_inteval_index.
    DATA:
         intervals TYPE SORTED TABLE OF t_inteval_index WITH UNIQUE KEY index.

    DATA index TYPE i.
    DATA(updated_mask) = mask.

    "Prepare mask to be a pattern
    IF cl_abap_matcher=>contains( pattern = 'DD' text = updated_mask ) = abap_true.
      replace_pattern( EXPORTING pattern = '(DD)' with = '([0-9][0-9])' IMPORTING index = index  CHANGING text = updated_mask ).
    ELSE.
      replace_pattern( EXPORTING pattern = '(D)' with = '([0-9][0-9]|[0-9])' IMPORTING index = index  CHANGING text = updated_mask ).
    ENDIF.
    INSERT VALUE #( interval = 'D' index = index ) INTO TABLE intervals.

    IF cl_abap_matcher=>contains( pattern = 'MM' text = updated_mask ) = abap_true.
      replace_pattern( EXPORTING pattern = '(MM)' with = '([0-9][0-9])' IMPORTING index = index  CHANGING text = updated_mask ).
    ELSE.
      replace_pattern( EXPORTING pattern = '(M)' with = '([0-9][0-9]|[0-9])' IMPORTING index = index  CHANGING text = updated_mask ).
    ENDIF.
    INSERT VALUE #( interval = 'M' index = index ) INTO TABLE intervals.

    replace_pattern( EXPORTING pattern = '(YYYY|RRRR)' with = '([0-9][0-9][0-9][0-9])' IMPORTING index = index  CHANGING text = updated_mask ).
    INSERT VALUE #( interval = 'Y' index = index ) INTO TABLE intervals.

    "Try to find pattern
    DATA(date_matcher) = cl_abap_matcher=>create( pattern = updated_mask text = date_string ignore_case = abap_true ).
    IF date_matcher->find_next( ) = abap_false.
      RAISE EXCEPTION TYPE zcx_exception EXPORTING  custom_message = |No match found in '{ date_string }'. Used pattern '{ updated_mask }'|.
    ENDIF.

    "Read pattern and convert to date
    DATA(as)  = date_matcher->get_match( ).
    DATA(day) = CONV i( date_matcher->get_submatch( line_index( intervals[  interval = 'D' ] ) ) ).
    DATA(month) = CONV i( date_matcher->get_submatch( line_index( intervals[ interval = 'M' ] ) ) ).
    DATA(year) = CONV i( date_matcher->get_submatch( line_index( intervals[  interval = 'Y' ] ) ) ).

    date = create( day = day  month = month year = year ).
  ENDMETHOD .


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_DATE=>REPLACE_PATTERN
* +-------------------------------------------------------------------------------------------------+
* | [--->] PATTERN                        TYPE        STRING
* | [--->] WITH                           TYPE        STRING
* | [<---] INDEX                          TYPE        I
* | [<-->] TEXT                           TYPE        STRING
* | [!CX!] ZCX_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD replace_pattern.
    DATA(day_matcher) = cl_abap_matcher=>create( pattern = pattern text = text ignore_case = abap_true ).

    IF day_matcher->find_next( ) = abap_false.
      RAISE EXCEPTION TYPE zcx_exception EXPORTING custom_message = |Pattern '{ pattern }' doesn't exists in '{ text }'.|.
    ENDIF.

    index = day_matcher->get_match( )-offset.
    day_matcher->replace_found( with ).
    text = day_matcher->text.

    IF day_matcher->find_next( ) = abap_true.
      RAISE EXCEPTION TYPE zcx_exception EXPORTING custom_message = |Pattern '{ pattern }' exists more than once in '{ text }'.|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>WEEK
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] WEEK                           TYPE        KWEEK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD week.
    DATA(fourth_january) = create( year = year( date ) month = 1 day = 4 ).
    DATA(week_diff_to_first_week) = difference( date_from = fourth_january date_to = date interval = 'W' ).

    IF week_diff_to_first_week >= 0.
      week = |{ date(4) }{ week_diff_to_first_week + 1 ALIGN = RIGHT PAD = '0' WIDTH = 2 }| .
    ELSE.
      DATA(fourth_january_prev_year) = create( year = year( date ) - 1 month = 1 day = 4 ).
      week_diff_to_first_week = difference( date_from = fourth_january_prev_year date_to = date interval = 'W' ).
      week = |{  year( fourth_january_prev_year ) ALIGN = RIGHT PAD = '0' WIDTH = 4  }{
          week_diff_to_first_week + 1 ALIGN = RIGHT PAD = '0' WIDTH = 2 }| .
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>WEEKDAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] DAY                            TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD weekday.
    "+3, because it's 0 on thursdays, so to assign 3 to thursday
    "+1 after, to move 0-6 range to 1-7
    day = ( date + 3 - known_thursday ) MOD 7 + 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DATE=>YEAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATE                           TYPE        D
* | [<-()] YEAR                           TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD year.
    year = date(4).
  ENDMETHOD.
ENDCLASS.