CLASS zcl_it_excel DEFINITION PUBLIC CREATE PUBLIC .

    PUBLIC SECTION.
      TYPES:
        tt_string TYPE ANY TABLE OF string,
        BEGIN OF t_wks_data,
          name           TYPE string,
          internal_table TYPE REF TO data,
        END OF t_wks_data,
        tt_wks_data TYPE STANDARD TABLE OF t_wks_data WITH DEFAULT KEY.
  
      CLASS-METHODS:
        "! Each sheet is converted to table, where each line is structure with components A, B, C etc. (column names in Excel).
        "! <br/> Dates are formatted as YYYY-MM-DD.
        "! <br/> Numbers are without spaces, and decimal point is dot.
        "! @parameter filename | Can be xlsx or xlsm.
        import_excel_to_tables IMPORTING filename TYPE string RETURNING VALUE(tables) TYPE tt_wks_data,
        "! DEPRECATED. Use export_to_xlsx_v2.
        "! <br/>Uses cl_fdt_xl_spreadsheet class.
        "! @parameter data_table | Table line must be structure, and cannot have substructures other than include.
        "! @parameter headers_from_ddic | Get headers names from ABAP dictionary description
        export_to_xlsx IMPORTING filename TYPE string data_table TYPE ANY TABLE
                       headers_from_ddic TYPE abap_bool DEFAULT abap_true RAISING zcx_exception,
        "! Uses standard salv container for export. Formats date etc. Flattens substructures. Recommended.
        "! @parameter filename | Must have 'XLSX' extension.
        "! @parameter data_table | Accepts table lines with substructures. Subtables are skipped.
        export_to_xlsx_v2 IMPORTING filename TYPE string headers_from_ddic TYPE abap_bool DEFAULT abap_true
                          fields_to_skip TYPE tt_string OPTIONAL CHANGING data_table TYPE ANY TABLE.
  
    PROTECTED SECTION.
    PRIVATE SECTION.
      CLASS-METHODS:
        build_columns_table IMPORTING components TYPE abap_component_tab headers_from_ddic TYPE abap_bool
                            EXPORTING columns TYPE if_fdt_doc_spreadsheet=>t_column,
        get_components IMPORTING struct_descr TYPE REF TO cl_abap_structdescr
                       RETURNING VALUE(components) TYPE abap_component_tab RAISING zcx_exception.
  ENDCLASS.
  
  
  
  CLASS ZCL_IT_EXCEL IMPLEMENTATION.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Static Private Method ZCL_IT_EXCEL=>BUILD_COLUMNS_TABLE
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] COMPONENTS                     TYPE        ABAP_COMPONENT_TAB
  * | [--->] HEADERS_FROM_DDIC              TYPE        ABAP_BOOL
  * | [<---] COLUMNS                        TYPE        IF_FDT_DOC_SPREADSHEET=>T_COLUMN
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD build_columns_table.
      LOOP AT components REFERENCE INTO DATA(comp).
        DATA(display_name) = comp->name.
        IF headers_from_ddic = abap_true AND comp->type->is_ddic_type( ) AND comp->type IS INSTANCE OF cl_abap_elemdescr.
          DATA(elem_descr) = CAST cl_abap_elemdescr( comp->type ).
          display_name =  elem_descr->get_ddic_field( )-reptext .
        ENDIF.
  
        APPEND VALUE #( name = comp->name display_name = display_name type = comp->type ) TO columns.
      ENDLOOP.
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Static Public Method ZCL_IT_EXCEL=>EXPORT_TO_XLSX
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] FILENAME                       TYPE        STRING
  * | [--->] DATA_TABLE                     TYPE        ANY TABLE
  * | [--->] HEADERS_FROM_DDIC              TYPE        ABAP_BOOL (default =ABAP_TRUE)
  * | [!CX!] ZCX_EXCEPTION
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD export_to_xlsx.
      "Type check
      DATA(table_descr) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( data_table ) ).
      DATA(tab_line_descr) = table_descr->get_table_line_type(  ).
      IF NOT tab_line_descr IS INSTANCE OF cl_abap_structdescr.
        RAISE EXCEPTION TYPE zcx_exception EXPORTING custom_message = |Table row must be a structure.|.
      ENDIF.
  
      "Build column information - need it for .include structures, are skipped without it
      DATA(struct_descr)  = CAST cl_abap_structdescr( tab_line_descr ).
      build_columns_table( EXPORTING components =  get_components( struct_descr = struct_descr  )
                          headers_from_ddic = headers_from_ddic IMPORTING columns = DATA(columns) ).
  
      "Export to file
      DATA(bin_data) = cl_fdt_xl_spreadsheet=>if_fdt_doc_spreadsheet~create_document(  columns = columns itab = REF #( data_table )
                                              iv_call_type = if_fdt_doc_spreadsheet=>gc_call_dec_table ).
      DATA(it_raw_data) = cl_bcs_convert=>xstring_to_solix( iv_xstring = bin_data ).
      cl_gui_frontend_services=>gui_download( EXPORTING filename = filename filetype = 'BIN' bin_filesize = xstrlen( bin_data )
                                              CHANGING data_tab = it_raw_data ).
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Static Public Method ZCL_IT_EXCEL=>EXPORT_TO_XLSX_V2
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] FILENAME                       TYPE        STRING
  * | [--->] HEADERS_FROM_DDIC              TYPE        ABAP_BOOL (default =ABAP_TRUE)
  * | [--->] FIELDS_TO_SKIP                 TYPE        TT_STRING(optional)
  * | [<-->] DATA_TABLE                     TYPE        ANY TABLE
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD export_to_xlsx_v2.
      cl_salv_table=>factory( IMPORTING r_salv_table = DATA(o_salv) CHANGING t_table = data_table ).
  
      "Update columns if needed, medium text is visible after export.
      LOOP AT o_salv->get_columns( )->get( ) REFERENCE INTO DATA(col).
        IF strlen(  col->r_column->get_medium_text( ) ) = 0 OR headers_from_ddic = abap_false.
          col->r_column->set_medium_text( CONV #( col->columnname ) ).
        ENDIF.
  
        IF NOT fields_to_skip IS INITIAL.
          col->r_column->set_visible( xsdbool( NOT line_exists( fields_to_skip[ table_line = col->columnname ] ) ) ).
        ENDIF.
      ENDLOOP.
  
      "Export
      DATA(lv_xml_bytes) = o_salv->to_xml( xml_type = if_salv_bs_xml=>c_type_xlsx ).
      cl_scp_change_db=>xstr_to_xtab( EXPORTING im_xstring = lv_xml_bytes IMPORTING ex_size = DATA(lv_size) ex_xtab = DATA(it_raw_data) ).
      cl_gui_frontend_services=>gui_download( EXPORTING filename = filename filetype = 'BIN' bin_filesize = lv_size CHANGING data_tab = it_raw_data ).
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Static Private Method ZCL_IT_EXCEL=>GET_COMPONENTS
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] STRUCT_DESCR                   TYPE REF TO CL_ABAP_STRUCTDESCR
  * | [<-()] COMPONENTS                     TYPE        ABAP_COMPONENT_TAB
  * | [!CX!] ZCX_EXCEPTION
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD get_components.
      LOOP AT struct_descr->get_components( ) INTO DATA(comp).
        IF comp-type->kind = comp-type->kind_elem.
          APPEND comp TO components.
  
        ELSEIF comp-type->kind = comp-type->kind_struct AND comp-as_include = abap_true.
          DATA(comp_struct_descr) = CAST cl_abap_structdescr( comp-type ).
          APPEND LINES OF get_components( struct_descr = CAST cl_abap_structdescr( comp-type )  ) TO components.
  
        ELSE.
          RAISE EXCEPTION TYPE zcx_exception EXPORTING custom_message = |Component { comp-name } type { comp-type->kind } is neither Element nor Include Structure|.
  
        ENDIF.
      ENDLOOP.
  
    ENDMETHOD.
  
  
  * <SIGNATURE>---------------------------------------------------------------------------------------+
  * | Static Public Method ZCL_IT_EXCEL=>IMPORT_EXCEL_TO_TABLES
  * +-------------------------------------------------------------------------------------------------+
  * | [--->] FILENAME                       TYPE        STRING
  * | [<-()] TABLES                         TYPE        TT_WKS_DATA
  * +--------------------------------------------------------------------------------------</SIGNATURE>
    METHOD import_excel_to_tables.
      "Upload and parse excel file
      DATA it_bin_data TYPE w3mimetabtype.
      cl_gui_frontend_services=>gui_upload( EXPORTING filename = filename filetype = 'BIN' CHANGING data_tab = it_bin_data ).
      DATA(file_as_xstring) = cl_bcs_convert=>solix_to_xstring( it_bin_data ).
      DATA(excel) =  NEW cl_fdt_xl_spreadsheet( document_name = filename  xdocument = file_as_xstring ).
  
      "Read first worksheet to table
      excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names  =  DATA(worksheets) ).
      LOOP AT worksheets REFERENCE INTO DATA(wks).
        APPEND VALUE #( name = wks->* internal_table = excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( wks->* ) ) TO tables.
      ENDLOOP.
    ENDMETHOD.
  ENDCLASS.