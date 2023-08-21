CLASS zcl_csv_converter DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_string TYPE TABLE OF string.

    "! @parameter fields_to_skip | Table of fields to skip, names must be full path
    "!                             (e.g. SUBSTRUCT-FIELD, if row has structure field named SUBSTRUCT, which in turn has field named FIELD
    "! @parameter headers_from_ddic | Get headers names from ABAP dictionary description. Otherwise use technical names returned by RTTS.
    "! @parameter user_format | Format output using user settings and edit masks, if applicable ( Unit of measure, date, numbers etc.).
    "!                          Otherwise write as-is, e.g. '19700101' for 1.01.1970 date.
    "! @parameter all_in_double_quotes | Enclose every value in double-quotes, even if not necessary
    METHODS convert_it_to_csv
      IMPORTING
        !data_table           TYPE ANY TABLE
        !column_delimiter     TYPE string DEFAULT ';'
        !fields_to_skip       TYPE tt_string OPTIONAL
        !write_headers        TYPE abap_bool DEFAULT abap_true
        !headers_from_ddic    TYPE abap_bool DEFAULT abap_true
        !user_format          TYPE abap_bool DEFAULT abap_true
        !all_in_double_quotes TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(csv)            TYPE string
      RAISING
        zcx_exception .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF t_field,
        path           TYPE string,
        type           TYPE abap_typecategory,
        type_reference TYPE REF TO cl_abap_datadescr,
      END OF t_field .
    TYPES:
      tt_field TYPE STANDARD TABLE OF t_field WITH DEFAULT KEY .

    DATA column_delimiter TYPE string .
    DATA fields_to_skip TYPE tt_string .
    DATA write_headers TYPE abap_bool .
    DATA headers_from_ddic TYPE abap_bool .
    DATA user_format TYPE abap_bool .
    DATA all_in_double_quotes TYPE abap_bool .
    DATA characters_to_escape TYPE tt_string .

    METHODS determine_characters_to_escape .
    METHODS get_fields
      IMPORTING
        !struct_descr TYPE REF TO cl_abap_structdescr
        !prefix       TYPE string DEFAULT ''
        !suffix       TYPE string DEFAULT ''
      RETURNING
        VALUE(fields) TYPE tt_field
      RAISING
        zcx_exception .
    METHODS filter_fields
      CHANGING
        !fields TYPE tt_field .
    METHODS get_headers_line
      IMPORTING
        !fields     TYPE tt_field
      RETURNING
        VALUE(line) TYPE string .
    METHODS get_row_as_string
      IMPORTING
        !row_ref    TYPE REF TO data
        !fields     TYPE tt_field
      RETURNING
        VALUE(line) TYPE string .
    METHODS get_escaped_value
      IMPORTING
        !value         TYPE string
      RETURNING
        VALUE(escaped) TYPE string .
    METHODS get_value_as_string
      IMPORTING
        !value                 TYPE any
        !el_descr              TYPE REF TO cl_abap_elemdescr
      RETURNING
        VALUE(formatted_value) TYPE string .
    METHODS get_formatted_value
      IMPORTING
        !value                 TYPE any
        !el_descr              TYPE REF TO cl_abap_elemdescr
      RETURNING
        VALUE(formatted_value) TYPE string .
ENDCLASS.



CLASS zcl_csv_converter IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CSV_CONVERTER->CONVERT_IT_TO_CSV
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA_TABLE                     TYPE        ANY TABLE
* | [--->] COLUMN_DELIMITER               TYPE        STRING (default =';')
* | [--->] FIELDS_TO_SKIP                 TYPE        TT_STRING(optional)
* | [--->] WRITE_HEADERS                  TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] HEADERS_FROM_DDIC              TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] USER_FORMAT                    TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] ALL_IN_DOUBLE_QUOTES           TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] CSV                            TYPE        STRING
* | [!CX!] ZCX_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert_it_to_csv.
    "Assign parameters to internal variables.
    me->column_delimiter = column_delimiter.
    me->fields_to_skip = fields_to_skip.
    me->write_headers = write_headers.
    me->headers_from_ddic = headers_from_ddic.
    me->user_format  = user_format.
    me->all_in_double_quotes = all_in_double_quotes.
    determine_characters_to_escape( ).

    DATA row TYPE REF TO data.
    DATA(table_descr) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( data_table ) ).
    DATA(tab_line_descr) = table_descr->get_table_line_type(  ).

    "Table of structures
    IF tab_line_descr IS INSTANCE OF cl_abap_structdescr.
      DATA(fields) = get_fields( struct_descr = CAST cl_abap_structdescr( tab_line_descr ) ).

      IF NOT fields_to_skip IS INITIAL.
        filter_fields( CHANGING fields = fields ).
      ENDIF.

      IF write_headers = abap_true.
        csv = |{ get_headers_line( fields = fields ) }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      LOOP AT data_table REFERENCE INTO row.
        DATA(line) = get_row_as_string( row_ref = row fields = fields ).
        csv = |{ csv }{ line }{ cl_abap_char_utilities=>newline }|.
      ENDLOOP.

      "Table of single elements
    ELSEIF tab_line_descr IS INSTANCE OF cl_abap_elemdescr.
      DATA(element_descr) = CAST cl_abap_elemdescr( tab_line_descr ).

      IF write_headers = abap_true.
        csv = |{ get_escaped_value( COND string(  WHEN headers_from_ddic = abap_true AND element_descr->is_ddic_type( )
                                    THEN element_descr->get_ddic_field( )-reptext ELSE element_descr->absolute_name
                ) ) }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      LOOP AT data_table REFERENCE INTO row.
        ASSIGN row->* TO FIELD-SYMBOL(<value>).
        DATA(line_val) = get_value_as_string( value = <value> el_descr = element_descr ).
        csv = |{ csv }{ line_val }{ cl_abap_char_utilities=>newline }|.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->DETERMINE_CHARACTERS_TO_ESCAPE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD determine_characters_to_escape.
    CLEAR characters_to_escape.
    APPEND cl_abap_char_utilities=>newline TO characters_to_escape.
    APPEND column_delimiter TO characters_to_escape.
    APPEND |"| TO characters_to_escape.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->FILTER_FIELDS
* +-------------------------------------------------------------------------------------------------+
* | [<-->] FIELDS                         TYPE        TT_FIELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD filter_fields.
    LOOP AT fields_to_skip REFERENCE INTO DATA(field_to_skip).
      DELETE fields WHERE path = to_upper( field_to_skip->* ).
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_ESCAPED_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        STRING
* | [<-()] ESCAPED                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_escaped_value.
    escaped = value.
    DATA(enclose_in_double_quotes) = all_in_double_quotes.

    LOOP AT characters_to_escape REFERENCE INTO DATA(char_to_escape).
      IF escaped CS char_to_escape->*.
        enclose_in_double_quotes = abap_true.
        IF char_to_escape->* = |"|.
          escaped = replace( val = escaped sub = char_to_escape->* with = |""| occ = 0 ).
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF enclose_in_double_quotes = abap_true.
      escaped = |"{ escaped }"|.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_FIELDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] STRUCT_DESCR                   TYPE REF TO CL_ABAP_STRUCTDESCR
* | [--->] PREFIX                         TYPE        STRING (default ='')
* | [--->] SUFFIX                         TYPE        STRING (default ='')
* | [<-()] FIELDS                         TYPE        TT_FIELD
* | [!CX!] ZCX_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fields.
    LOOP AT struct_descr->get_components( ) INTO DATA(comp).
      IF comp-type->kind = comp-type->kind_struct. "Add subcomponents with correct path
        APPEND LINES OF get_fields( struct_descr = CAST cl_abap_structdescr( comp-type )
          prefix = |{ prefix }{ COND #( WHEN comp-as_include = abap_true THEN || ELSE |{ comp-name }-| ) }|
          suffix = comp-suffix ) TO fields.

      ELSEIF comp-type->kind = comp-type->kind_elem OR comp-type->kind = comp-type->kind_table.   "Add
        APPEND VALUE #( path = |{ prefix }{ comp-name }{ suffix }| type = comp-type->kind type_reference = comp-type ) TO fields.

      ELSE. "Throw error
        RAISE EXCEPTION TYPE zcx_exception  EXPORTING custom_message = |Type '{ comp-type->kind }' not supported. Must Structure, Element or Table|.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_FORMATTED_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        ANY
* | [--->] EL_DESCR                       TYPE REF TO CL_ABAP_ELEMDESCR
* | [<-()] FORMATTED_VALUE                TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_formatted_value.
    IF NOT el_descr->edit_mask IS INITIAL.
      DATA masked(255) TYPE c.
      WRITE value USING EDIT MASK el_descr->edit_mask TO masked.
      CONDENSE masked.
      formatted_value = |{ masked }|.

    ELSE.
      CASE el_descr->type_kind.
        WHEN el_descr->typekind_date.
          FIELD-SYMBOLS <date> TYPE d.
          ASSIGN value TO <date>.
          formatted_value = |{ <date> DATE = USER }|.

        WHEN el_descr->typekind_time.
          FIELD-SYMBOLS <time> TYPE t.
          ASSIGN value TO <time>.
          formatted_value = |{ <time> TIME = USER }|.

        WHEN el_descr->typekind_decfloat OR el_descr->typekind_decfloat16 OR el_descr->typekind_decfloat34
        OR el_descr->typekind_float OR el_descr->typekind_packed
        OR el_descr->typekind_int OR el_descr->typekind_int1 OR el_descr->typekind_int2 OR el_descr->typekind_int8.
          FIELD-SYMBOLS <numeric> TYPE numeric.
          ASSIGN value TO <numeric>.
          formatted_value = |{ <numeric> NUMBER = USER }|.

        WHEN OTHERS.
          formatted_value = |{ value }|.

      ENDCASE.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_HEADERS_LINE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FIELDS                         TYPE        TT_FIELD
* | [<-()] LINE                           TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_headers_line.
    DATA header TYPE string.

    LOOP AT fields REFERENCE INTO DATA(field).
      "      BREAK mkaszuba. "TODO check when table what happens
      IF headers_from_ddic = abap_true AND field->type_reference->is_ddic_type( ) = abap_true AND field->type_reference IS INSTANCE OF cl_abap_elemdescr.
        DATA(elem_descr) = CAST cl_abap_elemdescr( field->type_reference ).
        header = get_escaped_value( value = elem_descr->get_ddic_field( )-reptext ).
        line = |{ line }{ header }{ column_delimiter }|.

      ELSE.
        header = get_escaped_value( field->path ).
        line = |{ line }{ header }{ column_delimiter }|.

      ENDIF.
    ENDLOOP.

    line = substring( val = line len = strlen( line ) - 1 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_ROW_AS_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] ROW_REF                        TYPE REF TO DATA
* | [--->] FIELDS                         TYPE        TT_FIELD
* | [<-()] LINE                           TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_row_as_string.
    LOOP AT fields REFERENCE INTO DATA(field).
      ASSIGN row_ref->(field->path) TO FIELD-SYMBOL(<field>).

      IF field->type = 'E'.
        DATA(text) = get_value_as_string( el_descr = CAST #( field->type_reference ) value = <field> ).
        line = |{ line }{ text }{ column_delimiter }|.

      ELSEIF field->type = 'T'.
        DATA(csv_converter) = NEW zcl_csv_converter( ).
        DATA(table_as_text) = get_escaped_value( csv_converter->convert_it_to_csv( data_table = <field> column_delimiter = column_delimiter
                            all_in_double_quotes = all_in_double_quotes write_headers = write_headers
                            headers_from_ddic = headers_from_ddic user_format = user_format ) ).
        line = |{ line }{ table_as_text }{ column_delimiter }|.

      ENDIF.
    ENDLOOP.

    line = substring( val = line len = strlen( line ) - 1 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CSV_CONVERTER->GET_VALUE_AS_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] VALUE                          TYPE        ANY
* | [--->] EL_DESCR                       TYPE REF TO CL_ABAP_ELEMDESCR
* | [<-()] FORMATTED_VALUE                TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_value_as_string.
    IF user_format = abap_true.
      formatted_value = get_escaped_value( get_formatted_value( value = value el_descr = el_descr  ) ).
    ELSE.
      formatted_value = get_escaped_value( value = CONV #( value ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.