
CLASS zcl_mat_converter DEFINITION PUBLIC CREATE PUBLIC .

    PUBLIC SECTION.
      TYPES:
        tt_matnr_range TYPE RANGE OF matnr,
        tt_unit_range  TYPE RANGE OF meins.
      INTERFACES:
        if_amdp_marker_hdb.
      METHODS:
        clear_data,
        "! Data must be loaded before using this method.
        "! @parameter converted_amount | If conversion can't be carried (e.g. unit doesn't exists or data not loaded), returns 0.
        "! @parameter unit_from | Must be in internal SAP format (e.g. 'ST' for Sztuka, 'KAR' for Karton etc.)
        "! @parameter unit_to |  Must be in internal SAP format (e.g. 'ST' for Sztuka, 'KAR' for Karton etc.)
        convert IMPORTING matnr TYPE matnr unit_from TYPE meinh unit_to TYPE meinh amount TYPE decfloat34 RETURNING VALUE(converted_amount) TYPE decfloat34,
        "! Use this method if most likely whole marm is needed
        load_all_data,
        load_data_from_ranges IMPORTING matnr_range TYPE tt_matnr_range unit_range TYPE tt_unit_range,
        "! Use this method if data can be reasonably restricted
        "! @parameter matnr_table | Any table with matnr data. Leave empty to get all materials.
        "! @parameter matnr_col_name | Name of matnr column in matnr_table. Leave empty if matnr_table is table of matnr.
        "! @parameter unit_table | Any table with unit data. Leave empty to get all units.
        "! @parameter unit_col_name | Name of unit column in unit_table. Leave empty if unit_table is table of unit.
        load_data IMPORTING matnr_table TYPE table OPTIONAL matnr_col_name TYPE string OPTIONAL
                            unit_table TYPE table OPTIONAL unit_col_name TYPE string OPTIONAL,
        "! @parameter unit_to | If not supplied, base unit is assumed, meaning value returned is unit_from-nominator / unit_from-denominator
        get_multiplier IMPORTING matnr TYPE matnr unit_from TYPE meinh unit_to TYPE meinh OPTIONAL RETURNING VALUE(multiplier) TYPE decfloat34.
  
    PROTECTED SECTION.
  
    PRIVATE SECTION.
      TYPES:
        BEGIN OF t_conversion_data,
          matnr       TYPE matnr,
          unit        TYPE meins,
          numerator   TYPE i,
          denominator TYPE i,
        END OF t_conversion_data,
        tt_conversion_data TYPE HASHED TABLE OF t_conversion_data WITH UNIQUE KEY matnr unit,
  
        BEGIN OF t_matnr,
          matnr TYPE matnr,
        END OF t_matnr,
        tt_matnr TYPE TABLE OF t_matnr,
        BEGIN OF t_unit,
          unit TYPE meins,
        END OF t_unit,
        tt_unit TYPE TABLE OF t_unit.
  
      DATA:
        conversion_data TYPE tt_conversion_data.
  
      METHODS:
        updata_data IMPORTING new_data TYPE tt_conversion_data,
        load_data_amdp  IMPORTING VALUE(matnr_table) TYPE tt_matnr VALUE(unit_table) TYPE tt_unit EXPORTING VALUE(conversion_data) TYPE tt_conversion_data.
  ENDCLASS.
  
  
  
  CLASS zcl_mat_converter IMPLEMENTATION.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->CLEAR_DATA
  * +-------------------------------------------------------------------------------------------------+
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD clear_data.
      FREE conversion_data.
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->CONVERT
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] MATNR                          TYPE        MATNR
  * | [--->] UNIT_FROM                      TYPE        MEINH
  * | [--->] UNIT_TO                        TYPE        MEINH
  * | [--->] AMOUNT                         TYPE        DECFLOAT34
  * | [<-()] CONVERTED_AMOUNT               TYPE        DECFLOAT34
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD convert.
      DATA(conv_from) = REF #( conversion_data[ matnr = matnr unit = unit_from ] OPTIONAL ).
      DATA(conv_to) = REF #( conversion_data[ matnr = matnr unit = unit_to ] OPTIONAL ).
  
      IF ( NOT conv_from IS BOUND ) OR ( NOT conv_to IS BOUND ).
        RETURN.
      ENDIF.
  
      converted_amount = amount *  conv_from->numerator / conv_from->denominator * conv_to->denominator / conv_to->numerator.
  
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->GET_MULTIPLIER
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] MATNR                          TYPE        MATNR
  * | [--->] UNIT_FROM                      TYPE        MEINH
  * | [--->] UNIT_TO                        TYPE        MEINH(optional)
  * | [<-()] MULTIPLIER                     TYPE        DECFLOAT34
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD get_multiplier.
      IF unit_to IS SUPPLIED.
        multiplier = me->convert(  matnr = matnr unit_from = unit_from unit_to = unit_to amount = 1 ).
      ELSE.
  
        DATA(conv_from) = REF #( conversion_data[ matnr = matnr unit = unit_from ] OPTIONAL ).
        IF ( NOT conv_from IS BOUND ).
          RETURN.
        ENDIF.
        multiplier = conv_from->numerator / conv_from->denominator .
      ENDIF.
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->LOAD_ALL_DATA
  * +-------------------------------------------------------------------------------------------------+
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD load_all_data.
      SELECT DISTINCT matnr, meinh AS unit, umrez AS numerator, umren AS denominator FROM marm INTO TABLE @conversion_data.
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->LOAD_DATA
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] MATNR_TABLE                    TYPE        TABLE(optional)
  * | [--->] MATNR_COL_NAME                 TYPE        STRING(optional)
  * | [--->] UNIT_TABLE                     TYPE        TABLE(optional)
  * | [--->] UNIT_COL_NAME                  TYPE        STRING(optional)
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD load_data.
      "Hash tables are actually slower in this case.
      DATA matnr_range TYPE tt_matnr.
      DATA unit_range TYPE tt_unit.
  
      "Build ranges table
      LOOP AT matnr_table ASSIGNING FIELD-SYMBOL(<matnr_row>).
        IF matnr_col_name IS SUPPLIED.
          ASSIGN COMPONENT matnr_col_name OF STRUCTURE <matnr_row> TO FIELD-SYMBOL(<matnr>).
          APPEND <matnr> TO matnr_range.
        ELSE.
          APPEND <matnr_row> TO matnr_range.
        ENDIF.
      ENDLOOP.
      SORT matnr_range BY matnr.
      DELETE ADJACENT DUPLICATES FROM matnr_range.
  
      "Build units table
      LOOP AT unit_table ASSIGNING FIELD-SYMBOL(<unit_row>).
        IF unit_col_name IS SUPPLIED.
          ASSIGN COMPONENT unit_col_name OF STRUCTURE <matnr_row> TO FIELD-SYMBOL(<unit>).
          APPEND <unit> TO unit_range.
        ELSE.
          APPEND <unit_row> TO unit_range.
        ENDIF.
      ENDLOOP.
      SORT unit_range BY unit.
      DELETE ADJACENT DUPLICATES FROM unit_range.
  
      "Load actual data
      load_data_amdp( EXPORTING matnr_table = matnr_range unit_table = unit_range IMPORTING conversion_data =  DATA(new_conversion_data) ).
      updata_data( new_conversion_data ).
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Private Method ZCL_MAT_CONVERTER->LOAD_DATA_AMDP
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] MATNR_TABLE                    TYPE        TT_MATNR
  * | [--->] UNIT_TABLE                     TYPE        TT_UNIT
  * | [<---] CONVERSION_DATA                TYPE        TT_CONVERSION_DATA
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD load_data_amdp BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT USING marm.
      declare is_matnr_empty int = IS_EMPTY(:matnr_table);
      declare is_unit_empty int = IS_EMPTY(:unit_table);
  
    conversion_data = select distinct marm.matnr, meinh as unit, umrez as numerator, umren as denominator from marm
                      where mandt = SESSION_CONTEXT('CLIENT')
                      and ( is_matnr_empty = 1 OR matnr in ( select * from :matnr_table ))
                      and ( is_unit_empty = 1 OR meinh in ( select * from :unit_table ));
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Public Method ZCL_MAT_CONVERTER->LOAD_DATA_FROM_RANGES
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] MATNR_RANGE                    TYPE        TT_MATNR_RANGE
  * | [--->] UNIT_RANGE                     TYPE        TT_UNIT_RANGE
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD load_data_from_ranges.
      DATA new_conversion_data TYPE tt_conversion_data.
  
      SELECT DISTINCT matnr, meinh AS unit, umrez AS numerator, umren AS denominator
      FROM marm
      WHERE matnr IN @matnr_range AND meinh IN @unit_range
      INTO TABLE @new_conversion_data.
  
      updata_data( new_conversion_data ).
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Instance Private Method ZCL_MAT_CONVERTER->UPDATA_DATA
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] NEW_DATA                       TYPE        TT_CONVERSION_DATA
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD updata_data.
      IF lines( me->conversion_data ) = 0.
        me->conversion_data = new_data.
      ELSE.
        LOOP AT new_data REFERENCE INTO DATA(new_entry).
          IF NOT line_exists( me->conversion_data[ matnr = new_entry->matnr unit = new_entry->unit ] ).
            INSERT new_entry->* INTO TABLE me->conversion_data.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDMETHOD.
  ENDCLASS.