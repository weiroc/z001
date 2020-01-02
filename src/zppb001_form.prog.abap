*&---------------------------------------------------------------------*
*& Include ZPPB001_FORM
*&---------------------------------------------------------------------*


form frm_modify_screen.

  loop at screen.
    if rb_in = 'X'.
      if screen-group1 = 'G1'.
        screen-active = 1.
      endif.
      if screen-group1 = 'G2'." OR SCREEN-GROUP1 = 'G3'.
        screen-active = 0.
      endif.
    else.
      if screen-group1 = 'G1'.
        screen-active = 0.
      endif.
      if screen-group1 = 'G2'.
        screen-active = 1.
      endif.
      if screen-group1 = 'G3'.
        screen-active = 0.
      endif.

    endif.

    modify screen.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_DOWNLOAD_TEMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_download_template .

  data:lo_objdata     like wwwdatatab,
       lo_mime        like w3mime,
       lc_filename    type string value'BOM导入.XLSX',
       lc_fullpath    type string value'C:\',
       lc_path        type string value'C:\',
       ls_destination like rlgrap-filename,
       ls_objnam      type string,
       l_rc           like sy-subrc,
       ls_errtxt      type string,
       l_objid        type wwwdatatab-objid,
       l_dest         like sapb-sappfad.

* 对象名
  l_objid = 'ZPP_BOMIMPORT'.
* 模板下载路径名
  call method cl_gui_frontend_services=>file_save_dialog
    exporting
      window_title         = '模板下载'
      default_extension    = 'XLSX'
      default_file_name    = lc_filename
    changing
      filename             = lc_filename
      path                 = lc_path
      fullpath             = lc_fullpath
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
*     INVALID_DEFAULT_FILE_NAME = 4
      others               = 5.
* 没有选择路径
  if lc_fullpath = ''.
    message  '请选择正确的路径！' type 'E'.
  else.
*-  路径名
    l_dest = lc_fullpath.
    select single
           relid     "IMPORT/EXPORT 记录中的区域
           objid     "SAP WWW 网关对象名
      from wwwdata
      into corresponding fields of lo_objdata
     where srtf2 = 0
      and relid = 'MI'
      and objid = l_objid.

    if sy-subrc <> 0 or lo_objdata-objid is initial.
      message '没有获得模板数据' type 'E'.
    endif.

    ls_destination = l_dest.
    call function 'DOWNLOAD_WEB_OBJECT'
      exporting
        key         = lo_objdata
        destination = ls_destination
      importing
        rc          = l_rc.
    if l_rc <> 0.
      message '模板下载失败' type 'E'.
    endif.
  endif.

endform.



form frm_download_template2 .

  data:lo_objdata     like wwwdatatab,
       lo_mime        like w3mime,
       lc_filename    type string value'BOM删除.XLSX',
       lc_fullpath    type string value'C:\',
       lc_path        type string value'C:\',
       ls_destination like rlgrap-filename,
       ls_objnam      type string,
       l_rc           like sy-subrc,
       ls_errtxt      type string,
       l_objid        type wwwdatatab-objid,
       l_dest         like sapb-sappfad.


* 对象名
  l_objid = 'ZPP_BOMDELETE'.
* 模板下载路径名
  call method cl_gui_frontend_services=>file_save_dialog
    exporting
      window_title         = '模板下载'
      default_extension    = 'XLSX'
      default_file_name    = lc_filename
    changing
      filename             = lc_filename
      path                 = lc_path
      fullpath             = lc_fullpath
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
*     INVALID_DEFAULT_FILE_NAME = 4
      others               = 5.
* 没有选择路径
  if lc_fullpath = ''.
    message  '请选择正确的路径！' type 'E'.
  else.
*-  路径名
    l_dest = lc_fullpath.
    select single
           relid     "IMPORT/EXPORT 记录中的区域
           objid     "SAP WWW 网关对象名
      from wwwdata
      into corresponding fields of lo_objdata
     where srtf2 = 0
      and relid = 'MI'
      and objid = l_objid.

    if sy-subrc <> 0 or lo_objdata-objid is initial.
      message '没有获得模板数据' type 'E'.
    endif.

    ls_destination = l_dest.
    call function 'DOWNLOAD_WEB_OBJECT'
      exporting
        key         = lo_objdata
        destination = ls_destination
      importing
        rc          = l_rc.
    if l_rc <> 0.
      message '模板下载失败' type 'E'.
    endif.
  endif.

endform.

*&---------------------------------------------------------------------*
*& Form FRM_DOWNLOAD_TEMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_download_template3 .

  data:lo_objdata     like wwwdatatab,
       lo_mime        like w3mime,
       lc_filename    type string value'BOM修改.XLSX',
       lc_fullpath    type string value'C:\',
       lc_path        type string value'C:\',
       ls_destination like rlgrap-filename,
       ls_objnam      type string,
       l_rc           like sy-subrc,
       ls_errtxt      type string,
       l_objid        type wwwdatatab-objid,
       l_dest         like sapb-sappfad.

* 对象名
  l_objid = 'ZPP_BOMMODIFY'.
* 模板下载路径名
  call method cl_gui_frontend_services=>file_save_dialog
    exporting
      window_title         = '模板下载'
      default_extension    = 'XLSX'
      default_file_name    = lc_filename
    changing
      filename             = lc_filename
      path                 = lc_path
      fullpath             = lc_fullpath
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
*     INVALID_DEFAULT_FILE_NAME = 4
      others               = 5.
* 没有选择路径
  if lc_fullpath = ''.
    message  '请选择正确的路径！' type 'E'.
  else.
*-  路径名
    l_dest = lc_fullpath.
    select single
           relid     "IMPORT/EXPORT 记录中的区域
           objid     "SAP WWW 网关对象名
      from wwwdata
      into corresponding fields of lo_objdata
     where srtf2 = 0
      and relid = 'MI'
      and objid = l_objid.

    if sy-subrc <> 0 or lo_objdata-objid is initial.
      message '没有获得模板数据' type 'E'.
    endif.

    ls_destination = l_dest.
    call function 'DOWNLOAD_WEB_OBJECT'
      exporting
        key         = lo_objdata
        destination = ls_destination
      importing
        rc          = l_rc.
    if l_rc <> 0.
      message '模板下载失败' type 'E'.
    endif.
  endif.

endform.
*&---------------------------------------------------------------------*
*& Form GET_FILEPATH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_UFILE
*&---------------------------------------------------------------------*
form get_filepath  changing    i_file.

* Data for open dialog
  data: l_filetab type filetable,
        l_rc      type i.
  clear l_filetab.
  refresh l_filetab.
* Open dialog
  call method cl_gui_frontend_services=>file_open_dialog
    exporting
*     WINDOW_TITLE         = 'SAP Custom - Open File'
*     DEFAULT_EXTENSION    =
*     DEFAULT_FILENAME     = CL_GUI_FRONTEND_SERVICES=>FILETYPE_EXCEL
      file_filter          = cl_gui_frontend_services=>filetype_excel
      initial_directory    = 'C:\'
      multiselection       = ''
    changing
      file_table           = l_filetab
      rc                   = l_rc
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      others               = 4.
* Get file path
  check l_rc eq 1.
  read table l_filetab index 1 into i_file.

endform.



*--------------------------------------------------------------------*

*--luzy TXT格式搜索帮助
form frm_f4_file  using    pv_file
                           pv_filetype.

  data: lv_file_filter   type string,
        lv_init_dir      type string,
        ls_file          type file_table,
        lt_file          type filetable,
        lv_rc            type i,
        lv_user_action   type i,
        lv_file_encoding type abap_encoding.

  lv_file_filter = pv_filetype.

  call method cl_gui_frontend_services=>get_desktop_directory
    changing
      desktop_directory    = lv_init_dir
    exceptions
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      others               = 4.
  if sy-subrc <> 0.
*   Implement suitable error handling here
  endif.

  cl_gui_cfw=>flush( ).

  call method cl_gui_frontend_services=>file_open_dialog
    exporting
*     WINDOW_TITLE            = LV_WINDOW_TITLE
*     DEFAULT_EXTENSION       = LV_EXTENSION
*     DEFAULT_FILENAME        =
      file_filter             = lv_file_filter
*     WITH_ENCODING           =
      initial_directory       = lv_init_dir
*     MULTISELECTION          =
    changing
      file_table              = lt_file
      rc                      = lv_rc
      user_action             = lv_user_action
      file_encoding           = lv_file_encoding
    exceptions
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      others                  = 5.
  if sy-subrc <> 0.
*    IMPLEMENT SUITABLE ERROR HANDLING HERE
  endif.

  read table lt_file into ls_file index 1.
  if sy-subrc = 0.
    pv_file = ls_file-filename.
  endif.

endform.





*&---------------------------------------------------------------------*
*& Form FRM_GET_DATA_IN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

****************************************************************************************************
form frm_get_data_in .


  if rb_txt = 'X'.

*LUZY 从TXT中得到数据
    perform frm_txt_to_sap.
  else.
* 从excel中得到数据
    perform frm_xls_to_sap.
  endif.






* 导入数据的编辑检查
  perform frm_edit_file.

endform.
***************************************************************************************************

*&---------------------------------------------------------------------*
*& Form FRM_XLS_TO_SAP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_xls_to_sap .

  data:
  lt_raw_data    type truxs_t_text_data.

  call function 'TEXT_CONVERT_XLS_TO_SAP'
    exporting
      i_tab_raw_data       = lt_raw_data
      i_filename           = p_ufile
    tables
      i_tab_converted_data = gt_file
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
    message id sy-msgid type 'S' number sy-msgno
    with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 display like 'E'.

    leave list-processing.
  endif.

endform.

*--------------------------------------------------------------------*
*--LUZY 从TXT中得到数据
*--------------------------------------------------------------------*
form frm_txt_to_sap.


  data: lv_file    type string,
        lv_header  type xstring,
        lv_filelen type i.

  .
  lv_file = p_ufile.


  call function 'GUI_UPLOAD'
    exporting
      filename                = lv_file
      filetype                = 'ASC'
      has_field_separator     = 'X'
      header_length           = 0
      read_by_line            = 'X'
      dat_mode                = ' '
      codepage                = ' '
      ignore_cerr             = abap_true
      replacement             = '#'
      check_bom               = ' '
*     VIRUS_SCAN_PROFILE      =
      no_auth_check           = 'X'
    importing
      filelength              = lv_filelen
      header                  = lv_header
    tables
      data_tab                = gt_file
*   CHANGING
*     ISSCANPERFORMED         = ' '
    exceptions
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      others                  = 17.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.






*&---------------------------------------------------------------------*
*& Form FRM_EDIT_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*





*****************************************************************************************************
form frm_edit_file .

  data:
    ls_file     like line of gt_file,
    ls_data     like line of gt_data_in,
    ls_data_bak like line of gt_data_in,
    l_line      type i,
    l_message   type char255.                  "ALV信息

*--LUZY TXT导入时从第一行开始
* 创建时从第二行
  if rb_ins = 'X'.

    if rb_txt = 'X'.
      l_line = 1.
    else.
      l_line = 3.

    endif.

* 修改删除时从第二行
  else.
    if rb_txt = 'X'.
      l_line = 1.
    else.
      l_line = 3.

    endif.
  endif.


  loop at gt_file into ls_file from l_line.
    clear:
    ls_data.
    if rb_upd = 'X'.
      ls_data-flg_del = ls_file-col01. "删除标识
      ls_data-werks = ls_file-col02. "工厂
      ls_data-matnr = ls_file-col03."主物料

      select single maktx into ls_data-maktx from makt
            where makt~matnr = ls_data-matnr and makt~spras = '1'. "主物料描述

      ls_data-stlan = p1_stlan .    "BOM用途
      ls_data-stlal = ls_file-col06 .    "可选的 BOM
      ls_data-bmeng = ls_file-col07 .    "基本数量

      select single meins into ls_data-bmein from mara
         where mara~matnr = ls_data-matnr.

      ls_data-posnr = ls_file-col08 .    "组件物料序号
      call function 'CONVERSION_EXIT_NUMCV_INPUT'
        exporting
          input  = ls_data-posnr
        importing
          output = ls_data-posnr.

      ls_data-postp = ls_file-col09 .    "项目类别
      ls_data-idnrk = ls_file-col10 .    "组件物料料号

      select single maktx into ls_data-maktx2 from makt
        where makt~matnr = ls_data-idnrk and makt~spras = '1'.


      ls_data-menge = ls_file-col12 .    "组件物料料号
      ls_data-meins = ls_file-col13 .    "组件物料单位
      call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
        exporting
          input          = ls_data-meins
        importing
          output         = ls_data-meins
        exceptions
          unit_not_found = 1
          others         = 2.
      if sy-subrc <> 0.
*   Implement suitable error handling here
      endif.


      ls_data-ausch = ls_file-col14 .    "损耗率
      ls_data-lgort = ls_file-col15 .    "返冲仓库

      ls_data-bom_status       = '1'.          "BOM状态

      ls_data-sanka            = 'X'.              "与成本核算相关项目
    elseif rb_del = 'X'.
      ls_data-werks = ls_file-col01. "工厂
      ls_data-matnr = ls_file-col02."主物料
      select single maktx into ls_data-maktx from makt
           where makt~matnr = ls_data-matnr and makt~spras = '1'. "主物料描述

      ls_data-stlan = p1_stlan .    "BOM用途
      ls_data-stlal = ls_file-col04 .    "可选的 BOM
    else.
      ls_data-werks = ls_file-col01. "工厂
      ls_data-matnr = ls_file-col02."主物料

      select single maktx into ls_data-maktx from makt
            where makt~matnr = ls_data-matnr and makt~spras = '1'. "主物料描述

      ls_data-stlan = p1_stlan .    "BOM用途
      ls_data-stlal = ls_file-col05 .    "可选的 BOM
      ls_data-bmeng = ls_file-col06 .    "基本数量

      select single meins into ls_data-bmein from mara
         where mara~matnr = ls_data-matnr.

      ls_data-posnr = ls_file-col07 .    "组件物料序号
      ls_data-postp = ls_file-col08 .    "项目类别
      ls_data-idnrk = ls_file-col09 .    "组件物料料号

      select single maktx into ls_data-maktx2 from makt
        where makt~matnr = ls_data-idnrk and makt~spras = '1'.


      ls_data-menge = ls_file-col11 .    "组件物料料号
      ls_data-meins = ls_file-col12 .    "组件物料单位
      call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
        exporting
          input          = ls_data-meins
        importing
          output         = ls_data-meins
        exceptions
          unit_not_found = 1
          others         = 2.
      if sy-subrc <> 0.
*   Implement suitable error handling here
      endif.


      ls_data-ausch = ls_file-col13 .    "损耗率
      ls_data-lgort = ls_file-col14 .    "返冲仓库

      ls_data-bom_status       = '1'.          "BOM状态

      ls_data-sanka            = 'X'.              "与成本核算相关项目
    endif.

    append ls_data to gt_data_in.
  endloop.

  sort gt_data_in by werks matnr stlan stlal posnr.
  sort gt_alv by werks ascending.
  delete adjacent duplicates from gt_alv comparing werks.

  loop at gt_data_in into ls_data.

    if sy-tabix <> 1.

      if ls_data-werks   = ls_data_bak-werks and
         ls_data-matnr   = ls_data_bak-matnr and
         ls_data-stlan   = ls_data_bak-stlan and
         ls_data-stlal   = ls_data_bak-stlal and
         ls_data-posnr   = ls_data_bak-posnr.

        l_message = 'BOM项目号重复'.
*         alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_cancel.

        delete gt_data_in where werks = ls_data-werks
                           and  matnr = ls_data-matnr
                           and  stlan = ls_data-stlan
                           and  stlal = ls_data-stlal.
      endif.

    endif.

    ls_data_bak = ls_data.

  endloop.
endform.
***********************************************************************************************************
*&---------------------------------------------------------------------*
*& Form FRM_EDIT_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_DATA_WERKS
*&      --> LS_DATA_MATNR
*&      --> LS_DATA_STLAN
*&      --> LS_DATA_STLAL
*&      --> L_MESSAGE
*&      --> ICON_CANCEL
*&---------------------------------------------------------------------*
form frm_edit_alv  using    i_werks   type csap_mbom-werks
                            i_matnr   type csap_mbom-matnr
                            i_stlan   type csap_mbom-stlan
                            i_stlal   type csap_mbom-stlal
                            i_message type char255
                            i_icon_id type icon-id.

  data:
  ls_alv        type typ_alv.

  call function 'CONVERSION_EXIT_MATN2_OUTPUT'
    exporting
      input  = i_matnr
    importing
      output = ls_alv-matnr.

  ls_alv-werks    = i_werks.
  ls_alv-matnr    = i_matnr.
  ls_alv-stlan    = i_stlan.
  ls_alv-stlal    = i_stlal.
  ls_alv-message  = i_message.
  ls_alv-icon_id  = i_icon_id.
  append ls_alv to gt_alv.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


form frm_bapi_bom .

  clear zline_in.

  case 'X'.
    when rb_ins.   "创建BOM
      perform frm_bapi_bom_ins.
    when rb_upd.   "修改BOM
      perform frm_bapi_bom_upd.
    when rb_del.   "删除BOM
      perform frm_bapi_bom_del.
    when others.
  endcase.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_INS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


form frm_bapi_bom_ins .

  perform frm_bapi_bom_ins_bapi.

* PERFORM frm_bapi_bom_upd_item.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_INS_BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*****************************************************************************************************************************
*FORM frm_bapi_bom_ins_bapi .
*
*  DATA:
*    ls_tmp       LIKE LINE OF gt_data_in,
*    ls_data      LIKE LINE OF gt_data_in,
*    lt_stpo      TYPE TABLE OF stpo_api01,      "BOM 项目的 API 结构：能被修改的字段
*    ls_stpo      LIKE LINE OF  lt_stpo,
*    lt_dep_data  TYPE TABLE OF csdep_dat,       "BOMs：相关性的基本数据
*    ls_dep_data  LIKE LINE OF  lt_dep_data,
*    l_valid_from TYPE csap_mbom-datuv,          "有效日期自 (BTCI)
*    l_message    TYPE char255,                  "ALV信息
*    l_originno   TYPE i,
*    ls_stko      TYPE stko_api01.               "API BOM 表头结构：可以被更改的字段
*
*
*  LOOP AT gt_data_in INTO ls_tmp.
*
*    CLEAR:
*   ls_data,
*   ls_stpo,
*   ls_dep_data.
*
* LS_DATA = LS_TMP.
*
* L_ORIGINNO = L_ORIGINNO + 1.
*
**   BOM 项目的 API 结构：能被修改的字段
*    LS_STPO-ITEM_CATEG = LS_DATA-postp  .   "项目类别（物料单）
*    LS_STPO-ITEM_NO    = LS_DATA-posnr  .      "BOM 项目号
*    LS_STPO-COMPONENT  = LS_DATA-idnrk.      "BOM 组件
*    LS_STPO-COMP_QTY   = LS_DATA-menge.       "组件数量 (BTCI)
*    LS_STPO-COMP_UNIT  = LS_DATA-meins.      "组件计量单位
*    LS_STPO-COMP_SCRAP = LS_DATA-ausch.     "损耗率
*    LS_STPO-REL_COST   = LS_DATA-sanka.       "标识：与成本核算相关的项目
*    LS_STPO-ISSUE_LOC  = LS_DATA-lgort.      "生产订单的发货地点
*    LS_STPO-IDENTIFIER = L_ORIGINNO.             "特定客户的 APIs 对象标识符
*      APPEND LS_STPO TO LT_STPO.
*
**  API BOM 表头结构：可以被更改的字段
*      LS_STKO-BOM_STATUS = LS_DATA-BOM_STATUS.   "BOM 状态
*      LS_STKO-BASE_QUAN  = LS_DATA-bmein.    "基准数量(BTCI)
*
**     日期:转换
*      CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
*        EXPORTING
*          DATE_INTERNAL            = SY-DATUM
*        IMPORTING
*          DATE_EXTERNAL            = L_VALID_FROM
*        EXCEPTIONS
*          DATE_INTERNAL_IS_INVALID = 1
*          OTHERS                   = 2.
*      IF SY-SUBRC <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*
**   创建BOM
*
*     CALL FUNCTION 'CSAP_MAT_BOM_CREATE'
*        EXPORTING
*          MATERIAL           = LS_DATA-MATNR     "sap料号
*          PLANT              = LS_DATA-WERKS     "工厂
*          BOM_USAGE          = LS_DATA-STLAN     "BOM用途
*          VALID_FROM         = L_VALID_FROM      "有效起
*          I_STKO             = LS_STKO
*          FL_COMMIT_AND_WAIT = 'X'
**         FL_DEFAULT_VALUES  = ' '
*        TABLES
*          T_STPO             = LT_STPO
*          T_DEP_DATA         = LT_DEP_DATA
*        EXCEPTIONS
*          ERROR              = 1
*          OTHERS             = 2.
*
*      IF SY-SUBRC = 0.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            WAIT = 'X'.
*
*        L_MESSAGE = '创建BOM成功'.
*
*        ZLINE_IN = ZLINE_IN + 1.
*
**       alv数据的编辑
*        PERFORM FRM_EDIT_ALV USING LS_DATA-WERKS
*                                   LS_DATA-MATNR
*                                   LS_DATA-STLAN
*                                   LS_DATA-STLAL
*                                   L_MESSAGE
*                                   ICON_OKAY.
*      ELSE.
*        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
*          INTO L_MESSAGE.
**       alv数据的编辑
*        PERFORM FRM_EDIT_ALV USING LS_DATA-WERKS
*                                   LS_DATA-MATNR
*                                   LS_DATA-STLAN
*                                   LS_DATA-STLAL
*                                   L_MESSAGE
*                                   ICON_CANCEL.
*      ENDIF.
*
*
*
*
*  ENDLOOP.
*
*ENDFORM.
*******************************************************************************************************************************************
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_INS_BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_bapi_bom_ins_bapi .

  data:
    ls_tmp    like line of gt_data_in,
    ls_data   like line of gt_data_in,
    l_message type char255.                  "ALV信息

  data:
    ls_bom_header type bicsk,          "BOM 表头数据的批输入结构
    ls_group_data type bgr00,
    l_msgid       type t100-arbgb,
    l_msgno       type t100-msgnr,
    l_msgty       type sy-msgty,
    l_msgv1       type sy-msgv1,
    l_msgv2       type sy-msgv2,
    l_msgv3       type sy-msgv3,
    l_msgv4       type sy-msgv4,
    lt_bom_item   like bicsp occurs 0 with header line, "BOM项数据的批输入结构
    lt_sub_item   like bicsu occurs 0 with header line.

  loop at gt_data_in into ls_tmp.

    clear:
      ls_data.

    ls_data = ls_tmp.

    at new stlal.
      clear:
        ls_bom_header,
        ls_group_data,
        l_msgid      ,
        l_msgno      ,
        l_msgty      ,
        l_msgv1      ,
        l_msgv2      ,
        l_msgv3      ,
        l_msgv4      ,
        lt_bom_item  ,
        lt_sub_item  .
    endat.

    at end of stlal.
      ls_bom_header-tcode = 'CS01'.
      ls_bom_header-werks = ls_data-werks.
      ls_bom_header-matnr = ls_data-matnr.
      ls_bom_header-stktx = ls_data-maktx.
      ls_bom_header-bmeng = ls_data-bmeng.
*      LS_BOM_HEADER-BMEin = LS_DATA-bmein.
      ls_bom_header-stlal = ls_data-stlal.
      ls_bom_header-stlan = ls_data-stlan.
      ls_bom_header-stlst = ls_data-bom_status.
*      ls_bom_header-datuv = sy-datum.
*     日期:转换
      call function 'CONVERT_DATE_TO_EXTERNAL'
        exporting
          date_internal            = sy-datum
        importing
          date_external            = ls_bom_header-datuv
        exceptions
          date_internal_is_invalid = 1
          others                   = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.

      call function 'CS_BI_BOM_CREATE_BATCH_INPUT1'
        exporting
*         BDC_FLAG     = ' '
          bom_header   = ls_bom_header
*         CLOSE_GROUP  = ' '
          commit_work  = 'X'
          group_data   = ls_group_data
*         NEW_GROUP    = ' '
          tcode_mode   = 'N'
          tcode_update = 'S'
        importing
          msgid        = l_msgid
          msgno        = l_msgno
          msgty        = l_msgty
          msgv1        = l_msgv1
          msgv2        = l_msgv2
          msgv3        = l_msgv3
          msgv4        = l_msgv4
        tables
          bom_item     = lt_bom_item
          bom_sub_item = lt_sub_item.

      if l_msgty = 'E' or l_msgty = 'A'.
        call function 'BAPI_TRANSACTION_ROLLBACK'.
        message id l_msgid type l_msgty number l_msgno
          with l_msgv1 l_msgv2 l_msgv3 l_msgv4
          into l_message.
*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_cancel.
      else.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.

        l_message = '创建BOM成功'.

*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_okay.

        perform frm_bapi_bom_upd_item using ls_data.
      endif.

    endat.


  endloop.


endform.
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_UPD_ITEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

form frm_bapi_bom_upd_item using in_data like line of gt_data_in.

  data:
    ls_tmp      like line of gt_data_in,
    ls_data     like line of gt_data_in,
    lt_stpo     type table of stpo_api03,      "BOM 项目的 API 结构：ALL ＋标识的字段
    ls_stpo     like line of  lt_stpo,
    lt_dep_data type table of csdep_dat,       "BOMs：相关性的基本数据
    ls_dep_data like line of  lt_dep_data,
    l_message   type char255,                  "ALV信息
    l_originno  type i,
    datuv_bi    type datuv_bi,
    ls_stko     type stko_api01.               "API BOM 表头结构：可以被更改的字段

  field-symbols:
  <ls_fs_alv>    like line of gt_alv.

  loop at gt_data_in into ls_tmp where werks = in_data-werks and matnr = in_data-matnr
                                   and stlal = in_data-stlal and stlan = in_data-stlan.

    clear:
   ls_data,
   ls_stpo,
   ls_dep_data.

    ls_data = ls_tmp.

    at new stlal.
      refresh:
        lt_stpo,
        lt_dep_data.
      clear:
        l_message,
        l_originno,
        ls_stko.
    endat.

    ls_stpo-item_categ = ls_data-postp  .   "项目类别（物料单）
    ls_stpo-item_no    = ls_data-posnr  .      "BOM 项目号
    ls_stpo-component  = ls_data-idnrk.      "BOM 组件
    ls_stpo-comp_qty   = ls_data-menge.       "组件数量 (BTCI)
    ls_stpo-comp_unit  = ls_data-meins.      "组件计量单位
    ls_stpo-comp_scrap = ls_data-ausch.     "损耗率
    if p1_stlan = '5'.
      ls_stpo-rel_sales   = 'X'.
    else.
      ls_stpo-rel_cost   = ls_data-sanka.       "标识：与成本核算相关的项目
    endif.

    ls_stpo-issue_loc  = ls_data-lgort.      "生产订单的发货地点
    ls_stpo-identifier = l_originno.             "特定客户的 APIs 对象标识符
    call function 'CONVERT_DATE_TO_EXTERNAL'
      exporting
        date_internal            = sy-datum
      importing
        date_external            = ls_stpo-valid_from
      exceptions
        date_internal_is_invalid = 1
        others                   = 2.
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.

    append ls_stpo to lt_stpo.


    at end of stlal.
*     API BOM 表头结构：可以被更改的字段
      ls_stko-bom_status = ls_data-bom_status.   "BOM 状态
*      LS_STKO-BOM_TEXT   = LS_DATA-BOM_TEXT.     "BOM 文本
      ls_stko-base_quan  = ls_data-bmeng.    "基准数量(BTCI)
      ls_stko-base_quan  = ls_data-bmeng.    "基准数量(BTCI)

*     修改BOM
      call function 'CONVERT_DATE_TO_EXTERNAL'
        exporting
          date_internal            = sy-datum
        importing
          date_external            = datuv_bi
        exceptions
          date_internal_is_invalid = 1
          others                   = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.


      call function 'CSAP_MAT_BOM_MAINTAIN'
        exporting
          material           = ls_data-matnr     "主件物料(母件）
          plant              = ls_data-werks     "工厂
          bom_usage          = ls_data-stlan     "BOM用途
          alternative        = ls_data-stlal     "可选的 BOM
          valid_from         = datuv_bi
*         CHANGE_NO          =
*         REVISION_LEVEL     =
          i_stko             = ls_stko
          fl_commit_and_wait = 'X'
          fl_bom_create      = 'X'
          fl_new_item        = 'X'
*         FL_DEFAULT_VALUES  = ' '
          fl_complete        = 'X'
        tables
          t_stpo             = lt_stpo
*         T_DEP_DATA         = LT_DEP_DATA
        exceptions
          error              = 1
          others             = 2.
      if sy-subrc = 0.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.
        zline_in = zline_in + 1.
      else.
        call function 'BAPI_TRANSACTION_ROLLBACK'.


        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          into l_message.
        if rb_ins = 'X'. "如果是新建bom,删除已经创建的bom头部
          call function 'CSAP_MAT_BOM_DELETE'
            exporting
              material           = ls_data-matnr     "主件物料(母件）
              plant              = ls_data-werks     "工厂
              bom_usage          = ls_data-stlan     "BOM用途
              alternative        = ls_data-stlal     "可选的 BOM
*             VALID_FROM         =
*             CHANGE_NO          =
*             REVISION_LEVEL     =
*             FL_NO_CHANGE_DOC   = ' '
              fl_commit_and_wait = 'X'
*       IMPORTING
*             FL_WARNING         =
            exceptions
              error              = 1
              others             = 2.
        endif.
        loop at gt_alv assigning <ls_fs_alv>.

          call function 'CONVERSION_EXIT_MATN1_OUTPUT'
            exporting
              input  = ls_data-matnr
            importing
              output = ls_data-matnr.

          if  ls_data-matnr = <ls_fs_alv>-matnr   and
              ls_data-werks = <ls_fs_alv>-werks   and
              ls_data-stlan = <ls_fs_alv>-stlan   and
              ls_data-stlal = <ls_fs_alv>-stlal.
            <ls_fs_alv>-message = l_message.
            <ls_fs_alv>-icon_id = icon_cancel.
          endif.
        endloop.
      endif.
      clear:ls_stko.
      refresh:lt_stpo.
    endat.
  endloop.
endform.
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_UPD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


form frm_bapi_bom_upd .

  data:
    ls_tmp      like line of gt_data_in,
    ls_data     like line of gt_data_in,
    lt_stpo     type table of stpo_api03,      "BOM 项目的 API 结构：ALL ＋标识的字段
    ls_stpo     like line of  lt_stpo,
    lt_dep_data type table of csdep_dat,       "BOMs：相关性的基本数据
    ls_dep_data like line of  lt_dep_data,
    l_message   type char255,                  "ALV信息
    l_originno  type i,
    ls_stko     type stko_api01.               "API BOM 表头结构：可以被更改的字段

  data:
    l_valid_from    type csap_mbom-datuv,
    lt_stpo_sel     like stpo_api02 occurs 0 with header line, "BOM 项目的 API 结构：能被修改的字段
    lt_dep_data_sel like csdep_dat  occurs 0 with header line. "BOMs：相关性的基本数据

  loop at gt_data_in into ls_tmp.

    clear:
      ls_data,
      ls_stpo,
      ls_dep_data.

    ls_data = ls_tmp.

    at new stlal.
      refresh:
        lt_stpo,
        lt_dep_data,
        lt_stpo_sel.
      clear:
        l_message,
        l_valid_from,
        l_originno,
        ls_stko.

*     日期:转换
      call function 'CONVERT_DATE_TO_EXTERNAL'
        exporting
          date_internal            = sy-datum
        importing
          date_external            = l_valid_from
        exceptions
          date_internal_is_invalid = 1
          others                   = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.

*     得到最新的BOM 行项目
      call function 'CSAP_MAT_BOM_OPEN'
        exporting
          material    = ls_data-matnr     "主件物料(母件）
          plant       = ls_data-werks     "工厂
          bom_usage   = ls_data-stlan     "BOM用途
          alternative = ls_data-stlal     "可选的 BOM
          valid_from  = l_valid_from
*         CHANGE_NO   =
*         REVISION_LEVEL         =
*         FL_NO_CHANGE_DOC       = ' '
*        IMPORTING
*         O_STKO      =
*         FL_WARNING  =
        tables
          t_stpo      = lt_stpo_sel
          t_dep_data  = lt_dep_data_sel
*         T_DEP_DESCR =
*         T_DEP_ORDER =
*         T_DEP_SOURCE           =
*         T_DEP_DOC   =
        exceptions
          error       = 1
          others      = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.

      loop at lt_stpo_sel.
        call function 'CONVERSION_EXIT_MATN2_INPUT'
          exporting
            input  = lt_stpo_sel-component
          importing
            output = lt_stpo_sel-component.
        modify lt_stpo_sel transporting component.
      endloop.
    endat.

    l_originno = l_originno + 1.

    read table lt_stpo_sel with key item_no   = ls_data-posnr.


    if sy-subrc = 0.

*  删除标记是X
      if ls_data-flg_del is not  initial.
*       BOM 项目的 API 结构：能被修改的字段
        ls_stpo-fldelete   = 'X'.                    "删除标识
        ls_stpo-bom_no     = lt_stpo_sel-bom_no.     "物料单
        ls_stpo-item_node  = lt_stpo_sel-item_node.  "BOM 项目节点号
        ls_stpo-item_count = lt_stpo_sel-item_count. "内部计数器
        ls_stpo-item_categ = ls_data-postp  .       "项目类别（物料单）
        ls_stpo-item_no    = ls_data-posnr  .        "BOM 项目号
        ls_stpo-component  = ls_data-idnrk.         "BOM 组件
        append ls_stpo to lt_stpo.
      else.
*  BOM 项目的 API 结构：能被修改的字段
        ls_stpo-fldelete   = ' '.                    "删除标识
        ls_stpo-bom_no     = lt_stpo_sel-bom_no.     "物料单
        ls_stpo-item_node  = lt_stpo_sel-item_node.  "BOM 项目节点号
        ls_stpo-item_count = lt_stpo_sel-item_count. "内部计数器

        ls_stpo-item_categ = ls_data-postp  .   "项目类别（物料单）
        ls_stpo-item_no    = ls_data-posnr  .      "BOM 项目号
        ls_stpo-component  = ls_data-idnrk.      "BOM 组件
        ls_stpo-comp_qty   = ls_data-menge.       "组件数量 (BTCI)
        ls_stpo-comp_unit  = ls_data-meins.      "组件计量单位
        ls_stpo-comp_scrap = ls_data-ausch.     "损耗率
        ls_stpo-rel_cost   = ls_data-sanka.       "标识：与成本核算相关的项目
        ls_stpo-issue_loc  = ls_data-lgort.      "生产订单的发货地点
        ls_stpo-identifier = l_originno.             "特定客户的 APIs 对象标识符

        append ls_stpo to lt_stpo.

      endif.



    else.

* BOM 项目的 API 结构：能被修改的字段

      if ls_data-flg_del is initial.
        ls_stpo-fldelete   = ' '.                    "删除标识

        ls_stpo-item_categ = ls_data-postp  .   "项目类别（物料单）
        ls_stpo-item_no    = ls_data-posnr  .      "BOM 项目号
        ls_stpo-component  = ls_data-idnrk.      "BOM 组件
        ls_stpo-comp_qty   = ls_data-menge.       "组件数量 (BTCI)
        ls_stpo-comp_unit  = ls_data-meins.      "组件计量单位
        ls_stpo-comp_scrap = ls_data-ausch.     "损耗率
        ls_stpo-rel_cost   = ls_data-sanka.       "标识：与成本核算相关的项目
        ls_stpo-issue_loc  = ls_data-lgort.      "生产订单的发货地点
        ls_stpo-identifier = l_originno.             "特定客户的 APIs 对象标识符

        append ls_stpo to lt_stpo.
      endif.
    endif.

    at end of stlal.

*API BOM 表头结构：可以被更改的字段
      ls_stko-bom_status = ls_data-bom_status.   "BOM 状态
*      LS_STKO-BOM_TEXT   = LS_DATA-BOM_TEXT.     "BOM 文本
      ls_stko-base_quan  = ls_data-bmeng.    "基准数量(BTCI)

*修改BOM
      call function 'CSAP_MAT_BOM_MAINTAIN'
        exporting
          material           = ls_data-matnr     "主件物料(母件）
          plant              = ls_data-werks     "工厂
          bom_usage          = ls_data-stlan     "BOM用途
          alternative        = ls_data-stlal     "可选的 BOM
*         VALID_FROM         =
*         CHANGE_NO          =
*         REVISION_LEVEL     =
          i_stko             = ls_stko
          fl_commit_and_wait = 'X'
          fl_bom_create      = 'X'
          fl_new_item        = 'X'
          fl_default_values  = ' '
          fl_complete        = 'X'
        tables
          t_stpo             = lt_stpo
*         T_DEP_DATA         = LT_DEP_DATA
        exceptions
          error              = 1
          others             = 2.

      if sy-subrc = 0.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.

        l_message = '修改BOM成功'.

        zline_in = zline_in + 1.

*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_okay.
      else.
        call function 'BAPI_TRANSACTION_ROLLBACK'.

        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          into l_message.
*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_cancel.
      endif.


      call function 'CSAP_MAT_BOM_CLOSE'
*        EXPORTING
*          FL_COMMIT_AND_WAIT       = 'X'
*        IMPORTING
*          FL_WARNING               =
        exceptions
          error  = 1
          others = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.

    endat.

  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_ALV_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*




form frm_alv_output .

  data:
    lt_fieldcat type slis_t_fieldcat_alv,
    ls_filedcat type slis_fieldcat_alv,
    ls_layout   type slis_layout_alv.

  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.

  define d_filedcat.
    ls_filedcat-fieldname = &1.
    ls_filedcat-seltext_l = &2.

    IF &1 = 'ICON_ID'.
      ls_filedcat-icon = 'X'.
    ENDIF.

    APPEND ls_filedcat TO lt_fieldcat.
    CLEAR ls_filedcat.
  end-of-definition.

  d_filedcat: 'WERKS'     '工厂' ,
              'MATNR'     '主件物料(母件）' ,
              'STLAN'     'BOM 用途'  ,
              'STLAL'     '可选的 BOM'  ,
              'MESSAGE'   '信息'      ,
              'ICON_ID'   '提示'  .

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program          = sy-repid
*     I_CALLBACK_PF_STATUS_SET    = 'FRM_PF_STATUS_SET'
*     I_CALLBACK_USER_COMMAND     = 'FRM_USER_COMMAND'
*************** BEGIN PIGLET 20170309
      i_callback_html_top_of_page = 'FRM_TOP_OF_PAGE'
*************** END
      is_layout                   = ls_layout
      it_fieldcat                 = lt_fieldcat
      i_save                      = 'A'
    tables
      t_outtab                    = gt_alv
    exceptions
      program_error               = 1
      others                      = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.
*&---------------------------------------------------------------------*
*& Form FRM_GET_DATA_OUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_get_data_out .


  clear itab.
  clear itab[].

  if rb_dan = 'X'.
    pm_mehrs = space.
  elseif rb_duo = 'X'.
    pm_mehrs = 'X'.
  endif.

  select
          mara~matnr
          mara~matkl
          marc~prctr
          marc~werks
          mast~stlal
          mast~stlan
         into corresponding fields of table itab
         from mara
         inner join marc
         on mara~matnr = marc~matnr
         inner join mast
         on marc~werks = mast~werks and marc~matnr = mast~matnr
         where mara~matnr in s_matnr
         and marc~werks in r_werks
         and mast~stlan = p_stlan
         and mast~stlal in s_stlal.
  if itab[] is initial.
    message s888(sabapdocu) with '此物料在该工厂里没有此可选号的BOM，请检查！'.
    leave list-processing.
  endif.



  select *
      into table it_makt
      from makt
      where makt~spras = sy-langu.

*POSTP 项目类别
  data: l_tabix like sy-tabix.
  data: l_histu type histu.


  loop at itab.

    if p_stlan is not initial.
      itab-stlan = p_stlan.
    endif.

    refresh:stb[],matcat[].
    call function 'CS_BOM_EXPL_MAT_V2'
      exporting
        aufsw                 = ' '
        capid                 = 'PP01'
        datuv                 = p_andat
        ehndl                 = pm_ehndl
        mbwls                 = ''
        mtnrv                 = itab-matnr
        mehrs                 = pm_mehrs
        stlal                 = itab-stlal
        stlan                 = itab-stlan
        werks                 = itab-werks
        aumgb                 = 'X'
        emeng                 = '1'
      importing
        topmat                = topmat
      tables
        stb                   = stb
        matcat                = matcat
      exceptions
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        others                = 9.
    if sy-subrc <> 0.
      refresh: stb[].
    endif.

    clear stb1[].
    stb1[] = stb[].
    loop at stb.
      l_tabix = sy-tabix.
      itab1-matnr = itab-matnr.
      itab1-werks = stb-werks.
      itab1-ojtxb = stb-ojtxb.

      if pm_mehrs = space.
        itab1-emmbm = topmat-bmeng.
      else.
        itab1-emmbm = topmat-emmbm.
      endif.
      itab1-bmein = topmat-bmein.


      clear p_matnr.
      if stb-stufe = 1.

        itab1-tmatnr = itab-matnr.

      else.

        l_histu = stb-stufe - 1.
        perform get_matnr2
                    using
                       l_histu
                       l_tabix
                    changing
                       p_matnr.
        itab1-tmatnr = p_matnr.
      endif.
      itab1-stufe =   stb-stufe.

      itab1-stlal =   stb-stlal.
      itab1-stlan =   topmat-stlan.

      itab1-itsob  = stb-itsob.
      itab1-sanka = stb-sanka.
      itab1-rgekz = stb-rgekz.

      itab1-posnr =   stb-posnr.
      itab1-idnrk =   stb-idnrk.
      itab1-ojtxp =   stb-ojtxp.
      if pm_mehrs = space.
        itab1-menge = stb-menge.
      else.
        itab1-menge =   stb-mngko.
      endif.
      itab1-mmein =   stb-meins.
*        itab1-matkl =   stb-matkl.
      matnr1 = stb-idnrk. " 组件   topmat

      itab1-andat = stb-andat.
      itab1-annam = stb-annam.

      itab1-lgort = stb-lgort. " 生产仓储地点
      itab1-potx1 = stb-potx1.


      itab1-postp = stb-postp.     "项目类别
      clear marc.
      select single * from marc
                   where matnr = matnr1
                     and werks = itab1-werks.
      if sy-subrc = 0.
        itab1-beskz = marc-beskz. " 采购类型
      endif.

      select single verpr peinh
        into ( itab1-cost ,itab1-peinh )
        from mbew
        where matnr = itab1-matnr
        and   bwkey = p_bwkey
        and   vprsv = 'V'.

      if sy-subrc ne 0.

        select single stprs peinh
        into ( itab1-cost ,itab1-peinh )
        from mbew
        where matnr = itab1-matnr
        and   bwkey = p_bwkey
        and   vprsv = 'S'.

      endif.

      i_matnr = itab1-matnr.


*      CALL FUNCTION 'ZBAPI_MATERIAL_PR00'
*        EXPORTING
**         I_VKORG            =
**         I_VTWEG            =
*          I_KONDA            = 'JA'
*          I_MATNR            = I_MATNR
**         I_VKBUR            =
**         I_KUNNR            =
**         I_KUNRG            =
*        IMPORTING
*          E_PR00              = E_PR00
**         E_KONWA            =
**         RETURN             =
**         E_TABLE_NAME       =
*                .

*      ITAB1-PR00 = E_PR00.


      "-- 去掉前导零 --

      call function 'CONVERSION_EXIT_MATN1_OUTPUT'
        exporting
          input  = itab1-matnr
        importing
          output = itab1-matnr.

      call function 'CONVERSION_EXIT_MATN1_OUTPUT'
        exporting
          input  = itab1-tmatnr
        importing
          output = itab1-tmatnr.

      call function 'CONVERSION_EXIT_MATN1_OUTPUT'
        exporting
          input  = itab1-idnrk
        importing
          output = itab1-idnrk.

      append itab1.
      clear itab1.
    endloop.

  endloop.


endform.


form get_matnr2 using p_histu type histu p_index like sy-tabix changing
p_matnr like makt-matnr .
  clear p_matnr.
  loop at stb1 from 0 to p_index where stufe = p_histu.
    p_matnr = stb1-idnrk.
  endloop.
endform. "GET_MATNRDES
*&---------------------------------------------------------------------*
*& Form FRM_EXCEL_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_excel_output .

  alv_layout-colwidth_optimize = 'X'.
  alv_layout-zebra             = 'X'.
  perform init_grid using alv_fieldcat.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = alv_layout
      it_fieldcat             = alv_fieldcat
      i_save                  = 'A'
    tables
      t_outtab                = itab1
    exceptions
      program_error           = 1
      others                  = 2.

endform.





form user_command using ucomm like sy-ucomm

 selfield type slis_selfield.
  read table itab1 index selfield-tabindex.
  check sy-subrc = 0.
  case ucomm.
    when '&IC1'.

      case selfield-fieldname.
        when 'MATNR'.
          set parameter id 'MAT' field itab1-matnr.
          call transaction  'MM03' and  skip  first  screen.
        when 'TMATNR'.
          set parameter id 'MAT' field itab1-tmatnr.
          call transaction  'MM03' and  skip  first  screen.
        when 'IDNRK'.
          set parameter id 'MAT' field itab1-idnrk.
          call transaction  'MM03' and  skip  first  screen.
      endcase.

  endcase.

endform. "USER_COMMAND




form init_grid using p_fieldcat type slis_t_fieldcat_alv.

  data: ls_fieldcat type slis_fieldcat_alv.
  data: col_pos type i.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'WERKS'.
  ls_fieldcat-seltext_l = '工厂'.
  ls_fieldcat-seltext_s = '工厂'.
  ls_fieldcat-seltext_m = '工厂'.
  append ls_fieldcat to p_fieldcat.

*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-seltext_l = '物料编码'.
*  ls_fieldcat-seltext_s = '物料编码'.
*  ls_fieldcat-seltext_m = '物料编码'.
*  APPEND ls_fieldcat TO p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'STUFE'.
  ls_fieldcat-seltext_l = '展开层'.
  ls_fieldcat-seltext_s = '展开层'.
  ls_fieldcat-seltext_m = '展开层'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'TMATNR'.
  ls_fieldcat-seltext_l = '父层物料编码'.
  ls_fieldcat-seltext_s = '父层物料编码'.
  ls_fieldcat-seltext_m = '父层物料编码'.
  append ls_fieldcat to p_fieldcat.
  clear ls_fieldcat.

  ls_fieldcat-fieldname = 'OJTXB'.
  ls_fieldcat-seltext_l = '父层物料描述'.
  ls_fieldcat-seltext_s = '父层物料描述'.
  ls_fieldcat-seltext_m = '父层物料描述'.
  append ls_fieldcat to p_fieldcat.

  ls_fieldcat-fieldname = 'EMMBM'.
  ls_fieldcat-seltext_l = 'BOM基本数量'.
  ls_fieldcat-seltext_s = 'BOM基本数量'.
  ls_fieldcat-seltext_m = 'BOM基本数量'.
  append ls_fieldcat to p_fieldcat.

  ls_fieldcat-fieldname = 'BMEIN'.
  ls_fieldcat-seltext_l = 'BOM 基本单位'.
  ls_fieldcat-seltext_s = 'BOM 基本单位'.
  ls_fieldcat-seltext_m = 'BOM 基本单位'.
  append ls_fieldcat to p_fieldcat.

  ls_fieldcat-fieldname = 'STLAL'.
  ls_fieldcat-seltext_l = '可选的BOM'.
  ls_fieldcat-seltext_s = '可选的BOM'.
  ls_fieldcat-seltext_m = '可选的BOM'.
  append ls_fieldcat to p_fieldcat.

  ls_fieldcat-fieldname = 'STLAN'.
  ls_fieldcat-seltext_l = 'BOM用途'.
  ls_fieldcat-seltext_s = 'BOM用途'.
  ls_fieldcat-seltext_m = 'BOM用途'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'POSNR'.
  ls_fieldcat-seltext_l = 'BOM项目号'.
  ls_fieldcat-seltext_s = 'BOM项目号'.
  ls_fieldcat-seltext_m = 'BOM项目号'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'POSTP'.
  ls_fieldcat-seltext_l = '项目组件类别'.
  ls_fieldcat-seltext_s = '项目组件类别'.
  ls_fieldcat-seltext_m = '项目组件类别'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'IDNRK'.
  ls_fieldcat-seltext_l = '组件代码'.
  ls_fieldcat-seltext_s = '组件代码'.
  ls_fieldcat-seltext_m = '组件代码'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'OJTXP'.
  ls_fieldcat-seltext_l = '组件描述'.
  ls_fieldcat-seltext_s = '组件描述'.
  ls_fieldcat-seltext_m = '组件描述'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'MENGE'.
  ls_fieldcat-seltext_l = '组件数量'.
  ls_fieldcat-seltext_s = '组件数量'.
  ls_fieldcat-seltext_m = '组件数量'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'MMEIN'.
  ls_fieldcat-seltext_l = '单位'.
  ls_fieldcat-seltext_s = '单位'.
  ls_fieldcat-seltext_m = '单位'.
  ls_fieldcat-edit_mask = '==CUNIT'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'BESKZ'.
  ls_fieldcat-seltext_l = '采购类型'.
  ls_fieldcat-seltext_s = '采购类型'.
  ls_fieldcat-seltext_m = '采购类型'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'POTX1'.
  ls_fieldcat-seltext_l = 'BOM文本描述'.
  ls_fieldcat-seltext_s = 'BOM文本描述'.
  ls_fieldcat-seltext_m = 'BOM文本描述'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'LGORT'.
  ls_fieldcat-seltext_l = '生产仓储地点'.
  ls_fieldcat-seltext_s = '生产仓储地点'.
  ls_fieldcat-seltext_m = '生产仓储地点'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'ITSOB'.
  ls_fieldcat-seltext_l = '特殊获取'.
  ls_fieldcat-seltext_s = '特殊获取'.
  ls_fieldcat-seltext_m = '特殊获取'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'SANKA'.
  ls_fieldcat-seltext_l = '成本核算标识相关'.
  ls_fieldcat-seltext_s = '成本核算标识相关'.
  ls_fieldcat-seltext_m = '成本核算标识相关'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'RGEKZ'.
  ls_fieldcat-seltext_l = '返冲'.
  ls_fieldcat-seltext_s = '返冲'.
  ls_fieldcat-seltext_m = '返冲'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'COST'.
  ls_fieldcat-seltext_l = '成本价'.
  ls_fieldcat-seltext_s = '成本价'.
  ls_fieldcat-seltext_m = '成本价'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'PEINH'.
  ls_fieldcat-seltext_l = '成本价价格单位'.
  ls_fieldcat-seltext_s = '成本价价格单位'.
  ls_fieldcat-seltext_m = '成本价价格单位'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'PR00'.
  ls_fieldcat-seltext_l = '代理价'.
  ls_fieldcat-seltext_s = '代理价'.
  ls_fieldcat-seltext_m = '代理价'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'ANDAT'.
  ls_fieldcat-seltext_l = '创建日期'.
  ls_fieldcat-seltext_s = '创建日期'.
  ls_fieldcat-seltext_m = '创建日期'.
  append ls_fieldcat to p_fieldcat.

  clear ls_fieldcat.
  ls_fieldcat-fieldname = 'ANNAM'.
  ls_fieldcat-seltext_l = '创建者'.
  ls_fieldcat-seltext_s = '创建者'.
  ls_fieldcat-seltext_m = '创建者'.
  append ls_fieldcat to p_fieldcat.

endform. "INIT_GRID
*&---------------------------------------------------------------------*
*& Form FRM_BAPI_BOM_DEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form frm_bapi_bom_del .

  data:
    ls_data   like line of  gt_data_in,
    l_message type char255.                  "ALV信息

  loop at gt_data_in into ls_data.

    at end of stlal.
*     删除BOM
      call function 'CSAP_MAT_BOM_DELETE'
        exporting
          material           = ls_data-matnr     "主件物料(母件）
          plant              = ls_data-werks     "工厂
          bom_usage          = ls_data-stlan     "BOM用途
          alternative        = ls_data-stlal     "可选的 BOM
*         VALID_FROM         =
*         CHANGE_NO          =
*         REVISION_LEVEL     =
*         FL_NO_CHANGE_DOC   = ' '
          fl_commit_and_wait = 'X'
*       IMPORTING
*         FL_WARNING         =
        exceptions
          error              = 1
          others             = 2.

      if sy-subrc = 0.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.

        l_message = '删除BOM成功'.

        zline_in = zline_in + 1.

*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_okay.
      else.
        call function 'BAPI_TRANSACTION_ROLLBACK'.

        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          into l_message.
*       alv数据的编辑
        perform frm_edit_alv using ls_data-werks
                                   ls_data-matnr
                                   ls_data-stlan
                                   ls_data-stlal
                                   l_message
                                   icon_cancel.
      endif.
    endat.

  endloop.


endform.
