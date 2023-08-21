CLASS zcl_xml_cleaning DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:
    "! Cleans xml of empty tags and/or attributes
    "! @parameter attributes | Decide, whether to remove empty ( attribute="" ) attributes or not
    "! @parameter nodes | Decide, whether to remove empty ( [node][/node] or [/node] ) nodes or not
    "! @parameter zero_times_and_dates | Decide, whether to remove attributes and nodes with empty date (0000-00-00) and/or time (00:00:00). Don't use if 00:00:00 is valid time.
    remove_empty IMPORTING xml_string TYPE string attributes TYPE abap_bool DEFAULT abap_true nodes TYPE abap_bool DEFAULT abap_true
                 zero_times_and_dates TYPE abap_bool DEFAULT abap_false  RETURNING VALUE(processed_xml_string) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_XML_CLEANING IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_XML_CLEANING=>REMOVE_EMPTY
* +-------------------------------------------------------------------------------------------------+
* | [--->] XML_STRING                     TYPE        STRING
* | [--->] ATTRIBUTES                     TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] NODES                          TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] ZERO_TIMES_AND_DATES           TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] PROCESSED_XML_STRING           TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD remove_empty.
    processed_xml_string = xml_string.

    IF zero_times_and_dates = abap_true.
      processed_xml_string = replace( val = processed_xml_string regex = '"00:00:00"|"0000-00-00"|"0000-00-00T00:00:00"' with = '""' occ = 0 ).
      processed_xml_string = replace( val = processed_xml_string regex = '>00:00:00<|>0000-00-00<|>0000-00-00T00:00:00<' with = '><' occ = 0 ).
    ENDIF.

    IF attributes = abap_true.
      processed_xml_string = replace( val = processed_xml_string regex = | [^<>\\\\\\/"=\\s]+=""| with = `` occ = 0  ).
    ENDIF.

    IF nodes = abap_true.
      DATA(empty_node_pattern) = |<[^<>="\\s\\/\\\\]+\\/>\|<[^<>="\\s\\/\\\\]+><\\/[^<>="\\s\\/\\\\]+>|.
      WHILE cl_abap_matcher=>contains( pattern = empty_node_pattern text = processed_xml_string ) = abap_true.
        processed_xml_string = replace( val = processed_xml_string regex = empty_node_pattern with = `` occ = 0  ).
      ENDWHILE.
    ENDIF.
  ENDMETHOD.
ENDCLASS.