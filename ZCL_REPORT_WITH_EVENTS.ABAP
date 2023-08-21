CLASS zcl_report_with_events DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA alv_table TYPE REF TO cl_salv_table READ-ONLY .

    METHODS constructor
      IMPORTING
        !report_id TYPE sy-repid
      RAISING
        cx_salv_msg .
    METHODS set_progress_bar
      IMPORTING
        !text           TYPE string DEFAULT ''
        !current_record TYPE i DEFAULT 0
        !records_count  TYPE i DEFAULT 0 .
    METHODS set_data
      IMPORTING
        !create_table_copy TYPE abap_bool DEFAULT 'X'
      CHANGING
        !data_table        TYPE STANDARD TABLE
      RAISING
        cx_salv_no_new_data_allowed .
    METHODS display_data
      IMPORTING
        !layout_name TYPE slis_vari OPTIONAL .
    METHODS get_layout_from_f4_selection
      RETURNING
        VALUE(retval) TYPE slis_vari .
    METHODS set_fixed_column_text IMPORTING column TYPE lvc_fname text TYPE scrtext_l output_length TYPE lvc_outlen OPTIONAL.
    METHODS set_column_ddic_ref IMPORTING column TYPE lvc_fname table TYPE lvc_tname  field TYPE lvc_fname .
    METHODS hide_column IMPORTING column TYPE lvc_fname.
    METHODS set_column_icon IMPORTING column TYPE lvc_fname.
  PROTECTED SECTION.

    DATA data_table_ref TYPE REF TO data .

    METHODS get_ref_to_cell_value
      IMPORTING
        !row          TYPE salv_de_row
        !column       TYPE salv_de_column
      RETURNING
        VALUE(retval) TYPE REF TO data
      RAISING
        cx_sy_tab_range_out_of_bounds .

    "EVENT HANDLERS
    METHODS on_before_salv_function
        FOR EVENT before_salv_function OF cl_salv_events_table
      IMPORTING
        !e_salv_function .
    METHODS on_after_salv_function
        FOR EVENT before_salv_function OF cl_salv_events_table
      IMPORTING
        !e_salv_function .
    METHODS on_added_function
        FOR EVENT added_function OF cl_salv_events_table
      IMPORTING
        !e_salv_function .
    METHODS on_top_of_page
        FOR EVENT top_of_page OF cl_salv_events_table
      IMPORTING
        !r_top_of_page
        !page
        !table_index .
    METHODS on_end_of_page
        FOR EVENT end_of_page OF cl_salv_events_table
      IMPORTING
        !r_end_of_page
        !page .
    METHODS on_double_click
        FOR EVENT double_click OF cl_salv_events_table
      IMPORTING
        !row
        !column .
    METHODS on_link_click
        FOR EVENT link_click OF cl_salv_events_table
      IMPORTING
        !row
        !column .
    "EVENTS HANDLERS END

  PRIVATE SECTION.

    DATA layout_key TYPE salv_s_layout_key .
    DATA progress_text TYPE string.
    METHODS initialise_alv
      RAISING
        cx_salv_msg .
    METHODS enable_layouts .
    METHODS set_handlers .

    METHODS format_alv_table
      IMPORTING
        !layout_name TYPE slis_vari OPTIONAL .
ENDCLASS.



CLASS ZCL_REPORT_WITH_EVENTS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] REPORT_ID                      TYPE        SY-REPID
* | [!CX!] CX_SALV_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    me->layout_key     = VALUE salv_s_layout_key( report = report_id ).
    initialise_alv( ).
    enable_layouts( ).
    set_handlers( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->DISPLAY_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] LAYOUT_NAME                    TYPE        SLIS_VARI(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display_data.
    format_alv_table(  layout_name ).
    alv_table->display( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_REPORT_WITH_EVENTS->ENABLE_LAYOUTS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD enable_layouts.
    alv_table->get_layout( )->set_key( layout_key ).
    alv_table->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    alv_table->get_layout( )->set_default( abap_true ). "Enables to save layout as default
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_REPORT_WITH_EVENTS->FORMAT_ALV_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] LAYOUT_NAME                    TYPE        SLIS_VARI(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD format_alv_table.
    IF NOT layout_name IS INITIAL.
      alv_table->get_layout( )->set_initial_layout( layout_name ).
    ENDIF.
    "Kills performance with large data
    "alv_table->get_columns( )->set_optimize( ).
    alv_table->get_functions( )->set_all( ).
    alv_table->get_display_settings( )->set_striped_pattern( abap_true ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->GET_LAYOUT_FROM_F4_SELECTION
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RETVAL                         TYPE        SLIS_VARI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_layout_from_f4_selection.
    retval = cl_salv_layout_service=>f4_layouts(
              s_key    = layout_key
              restrict = if_salv_c_layout=>restrict_none  )-layout.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->GET_REF_TO_CELL_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] ROW                            TYPE        SALV_DE_ROW
* | [--->] COLUMN                         TYPE        SALV_DE_COLUMN
* | [<-()] RETVAL                         TYPE REF TO DATA
* | [!CX!] CX_SY_TAB_RANGE_OUT_OF_BOUNDS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ref_to_cell_value.
    FIELD-SYMBOLS: <data_table> TYPE STANDARD TABLE.
    ASSIGN  me->data_table_ref->* TO <data_table>.

    IF row < 0 OR row > lines( <data_table> ).
      RAISE EXCEPTION TYPE cx_sy_tab_range_out_of_bounds .
    ENDIF.

    READ TABLE <data_table> ASSIGNING FIELD-SYMBOL(<table_row>) INDEX row.
    ASSIGN COMPONENT column OF STRUCTURE <table_row> TO FIELD-SYMBOL(<cell_value>).

    GET REFERENCE OF  <cell_value> INTO retval.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->HIDE_COLUMN
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLUMN                         TYPE        LVC_FNAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD hide_column.
    me->alv_table->get_columns( )->get_column( column )->set_technical( abap_true ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_REPORT_WITH_EVENTS->INITIALISE_ALV
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] CX_SALV_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD initialise_alv.
    "Need empty table for cl_salv_table factory, must be of structured type, throws error otherwise
    TYPES: BEGIN  OF t_dummy, dummy TYPE i, END OF t_dummy.
    CREATE DATA data_table_ref TYPE TABLE OF t_dummy.
    FIELD-SYMBOLS: <data_table> TYPE STANDARD TABLE.
    ASSIGN  data_table_ref->* TO <data_table>.
    cl_salv_table=>factory( IMPORTING r_salv_table = alv_table CHANGING t_table = <data_table> ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_ADDED_FUNCTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] E_SALV_FUNCTION                LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_added_function.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_AFTER_SALV_FUNCTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] E_SALV_FUNCTION                LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_after_salv_function.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_BEFORE_SALV_FUNCTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] E_SALV_FUNCTION                LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_before_salv_function.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_DOUBLE_CLICK
* +-------------------------------------------------------------------------------------------------+
* | [--->] ROW                            LIKE
* | [--->] COLUMN                         LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_double_click.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_END_OF_PAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] R_END_OF_PAGE                  LIKE
* | [--->] PAGE                           LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_end_of_page.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_LINK_CLICK
* +-------------------------------------------------------------------------------------------------+
* | [--->] ROW                            LIKE
* | [--->] COLUMN                         LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_link_click.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_REPORT_WITH_EVENTS->ON_TOP_OF_PAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] R_TOP_OF_PAGE                  LIKE
* | [--->] PAGE                           LIKE
* | [--->] TABLE_INDEX                    LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_top_of_page.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->SET_COLUMN_DDIC_REF
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLUMN                         TYPE        LVC_FNAME
* | [--->] TABLE                          TYPE        LVC_TNAME
* | [--->] FIELD                          TYPE        LVC_FNAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_column_ddic_ref.
    me->alv_table->get_columns( )->get_column( column )->set_ddic_reference( VALUE salv_s_ddic_reference( table = table field = field ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->SET_COLUMN_ICON
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLUMN                         TYPE        LVC_FNAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_column_icon.
    DATA(col) = CAST cl_salv_column_table(  me->alv_table->get_columns( )->get_column( column ) ).
    col->set_icon( if_salv_c_bool_sap=>true ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->SET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] CREATE_TABLE_COPY              TYPE        ABAP_BOOL (default ='X')
* | [<-->] DATA_TABLE                     TYPE        STANDARD TABLE
* | [!CX!] CX_SALV_NO_NEW_DATA_ALLOWED
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_data.
    IF create_table_copy = abap_true.
      "COPY DATA TO LOCAL REFERENCE, NEEDED IF IT'S FREED AFTER METHOD FINISHES PROGRAM WILL SHORT DUMP.
      CREATE DATA me->data_table_ref LIKE data_table.
      FIELD-SYMBOLS <data_table> LIKE data_table.
      ASSIGN data_table_ref->* TO <data_table> .
      APPEND LINES OF data_table TO <data_table>.

      alv_table->set_data( CHANGING t_table =  <data_table> ).
    ELSE.
      me->data_table_ref = REF #(  data_table ).
      alv_table->set_data( CHANGING t_table =  data_table ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->SET_FIXED_COLUMN_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] COLUMN                         TYPE        LVC_FNAME
* | [--->] TEXT                           TYPE        SCRTEXT_L
* | [--->] OUTPUT_LENGTH                  TYPE        LVC_OUTLEN(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_fixed_column_text.
    DATA(col) = me->alv_table->get_columns( )->get_column( column ).
    IF strlen( text ) > 20.
      col->set_long_text( text ).
      col->set_fixed_header_text( 'L' ).
    ELSEIF strlen( text ) > 10.
      col->set_long_text( text ).
      col->set_medium_text( CONV #( text ) ).
      col->set_fixed_header_text( 'M' ).
    ELSE.
      col->set_long_text( text ).
      col->set_medium_text( CONV #( text ) ).
      col->set_short_text( CONV #( text ) ).
      col->set_fixed_header_text( 'S' ).
    ENDIF.

    IF NOT output_length IS  INITIAL.
      col->set_output_length( output_length ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_REPORT_WITH_EVENTS->SET_HANDLERS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_handlers.
    DATA(event) = alv_table->get_event( ).
    SET HANDLER me->on_before_salv_function FOR event.
    SET HANDLER me->on_after_salv_function FOR event.
    SET HANDLER me->on_added_function FOR event.
    SET HANDLER me->on_top_of_page FOR event.
    SET HANDLER me->on_end_of_page FOR event.
    SET HANDLER me->on_double_click FOR event.
    SET HANDLER me->on_link_click FOR event.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_REPORT_WITH_EVENTS->SET_PROGRESS_BAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] TEXT                           TYPE        STRING (default ='')
* | [--->] CURRENT_RECORD                 TYPE        I (default =0)
* | [--->] RECORDS_COUNT                  TYPE        I (default =0)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_progress_bar.
    IF NOT text IS INITIAL.
      progress_text = text.
    ENDIF.

    IF records_count > 0.
      cl_progress_indicator=>progress_indicate( i_text = progress_text i_processed = current_record i_total = records_count i_output_immediately = 'X' ).
    ELSE.
      cl_progress_indicator=>progress_indicate( i_text = progress_text i_output_immediately = 'X').
    ENDIF.
  ENDMETHOD.
ENDCLASS.