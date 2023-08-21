CLASS zcl_progress_bar DEFINITION PUBLIC CREATE PUBLIC .
  PUBLIC SECTION.
    CLASS-METHODS:
      "! @parameter current_record | If it's 0 or less, no percentage is displayed
      "! @parameter only_full_percent | When true, progressbar is updated only when current_record = 1 MOD (records_count/100)
      display_progress_bar  IMPORTING text TYPE string DEFAULT '' current_record TYPE i DEFAULT 0 records_count  TYPE i DEFAULT 0 only_full_percent TYPE abap_bool DEFAULT abap_true.
    METHODS:
      "! This method remembers last displayed text.
      "! @parameter text | If it's empty, previous text is displayed
      "! @parameter current_record | If it's 0 or less, no percentage is displayed
      "! @parameter records_count |
      "! @parameter only_full_percent | When true, progressbar is updated only when current_record = 1 MOD (records_count/100)
      set_progress_bar  IMPORTING text TYPE string DEFAULT '' current_record TYPE i DEFAULT 0 records_count  TYPE i DEFAULT 0 only_full_percent TYPE abap_bool DEFAULT abap_true.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
    progress_text  TYPE string.
ENDCLASS.



CLASS zcl_progress_bar IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_PROGRESS_BAR=>DISPLAY_PROGRESS_BAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING (default ='')
* | [--->] CURRENT_RECORD                 TYPE        I (default =0)
* | [--->] RECORDS_COUNT                  TYPE        I (default =0)
* | [--->] ONLY_FULL_PERCENT              TYPE        ABAP_BOOL (default =ABAP_TRUE)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display_progress_bar.
    IF records_count > 0.
      IF only_full_percent = abap_true AND records_count > 100.
        DATA(percent_count) = records_count / 100.
        IF current_record MOD percent_count = 1.
          cl_progress_indicator=>progress_indicate( i_text = text i_processed = current_record i_total = records_count i_output_immediately = 'X' ).
        ENDIF.
      ELSE.
        cl_progress_indicator=>progress_indicate( i_text = text i_processed = current_record i_total = records_count i_output_immediately = 'X' ).
      ENDIF.

    ELSE.
      cl_progress_indicator=>progress_indicate( i_text = text i_output_immediately = 'X').
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_PROGRESS_BAR->SET_PROGRESS_BAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING (default ='')
* | [--->] CURRENT_RECORD                 TYPE        I (default =0)
* | [--->] RECORDS_COUNT                  TYPE        I (default =0)
* | [--->] ONLY_FULL_PERCENT              TYPE        ABAP_BOOL (default =ABAP_TRUE)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_progress_bar.
    IF NOT text IS INITIAL.
      progress_text = text.
    ENDIF.

    IF records_count > 0.
      IF only_full_percent = abap_true AND records_count > 100.
        DATA(percent_count) = records_count / 100.
        IF current_record MOD percent_count = 1.
          cl_progress_indicator=>progress_indicate( i_text = progress_text i_processed = current_record i_total = records_count i_output_immediately = 'X' ).
        ENDIF.
      ELSE.
        cl_progress_indicator=>progress_indicate( i_text = progress_text i_processed = current_record i_total = records_count i_output_immediately = 'X' ).
      ENDIF.

    ELSE.
      cl_progress_indicator=>progress_indicate( i_text = progress_text i_output_immediately = 'X').
    ENDIF.
  ENDMETHOD.
ENDCLASS.