CLASS zcl_file_explorer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF file_types,
        txt   TYPE i VALUE 0,
        csv   TYPE i VALUE 1,
        xlsx  TYPE i VALUE 2,
        excel TYPE i VALUE 3,
        all   TYPE i VALUE 4,
        xml   TYPE i VALUE 5,
      END OF file_types .

    "! @parameter file_type | Check FILE_TYPES constant for available file types
    CLASS-METHODS pick_file_dialog
      IMPORTING
        !file_type       TYPE i
        !title           TYPE string OPTIONAL
      RETURNING
        VALUE(file_path) TYPE string
      RAISING
        zcx_gui_error .
    "! @parameter file_type | Check FILE_TYPES constant for available file types
    CLASS-METHODS save_file_dialog
      IMPORTING
        !file_type       TYPE i
        !title           TYPE string OPTIONAL
        !default_name    TYPE string OPTIONAL
      RETURNING
        VALUE(file_path) TYPE string
      RAISING
        zcx_gui_error .
    CLASS-METHODS file_exists
      IMPORTING
        !file              TYPE string
      RETURNING
        VALUE(file_exists) TYPE abap_bool
      RAISING
        zcx_gui_error .
    CLASS-METHODS get_desktop_folder
      RETURNING
        VALUE(desktop_folder) TYPE string.
    CLASS-METHODS save_text_file
      IMPORTING
        !filename TYPE string
        text      TYPE string
      RAISING
        zcx_exception.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      get_file_filter IMPORTING file_type TYPE i RETURNING VALUE(file_filter) TYPE string,
      "! @parameter extensions | semicolon delimited in case of more than one
      get_file_extensions IMPORTING file_type TYPE i RETURNING VALUE(extensions) TYPE string.

ENDCLASS.



CLASS zcl_file_explorer IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_FILE_EXPLORER=>FILE_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE                           TYPE        STRING
* | [<-()] FILE_EXISTS                    TYPE        ABAP_BOOL
* | [!CX!] ZCX_GUI_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD file_exists.
    file_exists = cl_gui_frontend_services=>file_exist( file ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_gui_error.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_FILE_EXPLORER=>GET_DESKTOP_FOLDER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] DESKTOP_FOLDER                 TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_desktop_folder.
    cl_gui_frontend_services=>get_desktop_directory( CHANGING desktop_directory = desktop_folder ).
    cl_gui_cfw=>update_view( ). "Magic line to actually fill desktop value ¯\_(ツ)_/¯
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_FILE_EXPLORER=>GET_FILE_EXTENSIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE_TYPE                      TYPE        I
* | [<-()] EXTENSIONS                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_file_extensions.
    CASE file_type.
      WHEN file_types-txt. extensions = |TXT|.
      WHEN file_types-csv. extensions = |CSV|.
      WHEN file_types-xlsx. extensions = |XLSX|.
      WHEN file_types-excel. extensions = |XLSX;XLSM|.
      WHEN file_types-all. extensions = ||.
      WHEN file_types-xml. extensions = |XML|.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_FILE_EXPLORER=>GET_FILE_FILTER
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE_TYPE                      TYPE        I
* | [<-()] FILE_FILTER                    TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_file_filter.
    CASE file_type..
      WHEN file_types-txt. file_filter = 'Plik tekstowy (*.txt)|*.txt|'.
      WHEN file_types-csv. file_filter = 'Plik CSV (*.csv)|*.csv|'.
      WHEN file_types-xlsx. file_filter = 'Plik Excela XLSX (*.xlsx)|*.xlsx|'.
      WHEN file_types-excel. file_filter = 'Plik Excela (*.xlsx, *.xlsm)|*.xlsx;*.xlsm|'.
      WHEN file_types-all. file_filter = 'Wszystko (*.*)|*.*|'.
      WHEN file_types-xml. file_filter = 'Plik XML (*.xml)|*.xml|'.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_FILE_EXPLORER=>PICK_FILE_DIALOG
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE_TYPE                      TYPE        I
* | [--->] TITLE                          TYPE        STRING(optional)
* | [<-()] FILE_PATH                      TYPE        STRING
* | [!CX!] ZCX_GUI_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD pick_file_dialog.
    DATA:
      files       TYPE filetable,
      files_count TYPE i,
      user_action TYPE i.

    cl_gui_frontend_services=>file_open_dialog(
       EXPORTING
         window_title            = COND #( WHEN title IS INITIAL THEN '' ELSE  title )
         file_filter             = get_file_filter( file_type )
         initial_directory       = get_desktop_folder( )
       CHANGING
         file_table              = files
         rc                      = files_count
         user_action             = user_action ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_gui_error.
    ENDIF.

    IF user_action = cl_gui_frontend_services=>action_ok AND files_count = 1 .
      file_path = files[ 1 ]-filename.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_FILE_EXPLORER=>SAVE_FILE_DIALOG
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE_TYPE                      TYPE        I
* | [--->] TITLE                          TYPE        STRING(optional)
* | [--->] DEFAULT_NAME                   TYPE        STRING(optional)
* | [<-()] FILE_PATH                      TYPE        STRING
* | [!CX!] ZCX_GUI_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_file_dialog.
    DATA:
      filename    TYPE string,
      path        TYPE string,
      user_action TYPE i.

    cl_gui_frontend_services=>file_save_dialog(
      EXPORTING
        window_title              = COND #( WHEN title IS INITIAL THEN '' ELSE  title )
        default_extension         = get_file_extensions( file_type )
        default_file_name         = COND #( WHEN default_name IS INITIAL THEN '' ELSE  default_name )
        file_filter               = get_file_filter( file_type )
        initial_directory         = get_desktop_folder( )
        prompt_on_overwrite       = abap_true
      CHANGING
        filename                  = filename
        path                      = path
        fullpath                  = file_path
        user_action               = user_action
      EXCEPTIONS
        cntl_error                = 1                " Control error
        error_no_gui              = 2                " No GUI available
        not_supported_by_gui      = 3                " GUI does not support this
        invalid_default_file_name = 4                " Invalid default file name
        OTHERS                    = 5
    ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_gui_error .
    ENDIF.

    IF user_action <> cl_gui_frontend_services=>action_ok.
      CLEAR file_path.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_FILE_EXPLORER=>SAVE_TEXT_FILE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILENAME                       TYPE        STRING
* | [--->] TEXT                           TYPE        STRING
* | [!CX!] ZCX_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_text_file.
    DATA it TYPE TABLE OF string.
    APPEND text  TO it.
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                  = filename
        write_bom                 = abap_true   "Excel doesn't recognize polish letter otherwise
      CHANGING
        data_tab                  = it
      EXCEPTIONS
        file_write_error          = 1                    " Cannot write to file
        no_batch                  = 2                    " Cannot execute front-end function in background
        gui_refuse_filetransfer   = 3                    " Incorrect Front End
        invalid_type              = 4                    " Invalid value for parameter FILETYPE
        no_authority              = 5                    " No Download Authorization
        unknown_error             = 6                    " Unknown error
        header_not_allowed        = 7                    " Invalid header
        separator_not_allowed     = 8                    " Invalid separator
        filesize_not_allowed      = 9                    " Invalid file size
        header_too_long           = 10                   " Header information currently restricted to 1023 bytes
        dp_error_create           = 11                   " Cannot create DataProvider
        dp_error_send             = 12                   " Error Sending Data with DataProvider
        dp_error_write            = 13                   " Error Writing Data with DataProvider
        unknown_dp_error          = 14                   " Error when calling data provider
        access_denied             = 15                   " Access to File Denied
        dp_out_of_memory          = 16                   " Not enough memory in data provider
        disk_full                 = 17                   " Storage medium is full.
        dp_timeout                = 18                   " Data provider timeout
        file_not_found            = 19                   " Could not find file
        dataprovider_exception    = 20                   " General Exception Error in DataProvider
        control_flush_error       = 21                   " Error in Control Framework
        not_supported_by_gui      = 22                   " GUI does not support this
        error_no_gui              = 23                   " GUI not available
        OTHERS                    = 24
    ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_exception EXPORTING custom_message = |Gui export exception { sy-subrc }|.
    ENDIF.
  ENDMETHOD.
ENDCLASS.