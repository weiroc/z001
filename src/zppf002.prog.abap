*----------------------------------------------------------------------------------------------------------------------*
* 程序名称：ZPPF002
* 程序名：  生产工单打印
* 开发日期：24.12.2019
* 创建者：
*----------------------------------------------------------------------------------------------------------------------*
* 概要说明
*----------------------------------------------------------------------------------------------------------------------*
*  生产工单打印
*----------------------------------------------------------------------------------------------------------------------*
* 变更记录
*
*    日期       修改者       传输请求号     修改内容及原因
*----------------------------------------------------------------------------------------------------------------------*
*
*----------------------------------------------------------------------------------------------------------------------*
REPORT ZPPF002.

TABLES:AFPO,AFKO,MAKT,RESB,T001W,STXL,KNA1,TJ02,AUFK,JEST,STXH.
*定义结构
TYPES:BEGIN OF ITAB,
        DWERK     TYPE  AFPO-DWERK,            "生产工厂
        NAME1     TYPE  T001W-NAME1,           "工厂名称
        AUFNR     TYPE  AFPO-AUFNR,            "生产订单
        DAUAT     TYPE  AFPO-DAUAT,            "订单类型
        PSMNG     TYPE  AFPO-PSMNG,            "订单数量
        VERID     TYPE  AFPO-VERID,            "生产版本
        DISPO     TYPE  AFKO-DISPO,            "MRP控制者
        MATNR     TYPE  AFPO-MATNR,            "物料编号
        MAKTX     TYPE  MAKT-MAKTX,            "物料描述
        KDAUF     TYPE  AFPO-KDAUF,            "销售订单
        KDPOS     TYPE  AFPO-KDPOS,            "销售订单项
        XSDDX(16) TYPE  C,                     "销售订单/销售订单项
        GSTRP     TYPE  AFKO-GSTRP,            "订单开始日期
        GLTRP     TYPE  AFKO-GLTRP,            "基本完成日期
        POSNR     TYPE  RESB-POSNR,            "项目序号
        MATNR02   TYPE  RESB-MATNR,            "组件料号
        MAKTX02   TYPE  MAKT-MAKTX,            "组件描述
        ERFME     TYPE  RESB-ERFME,            "单位
        CHARG     TYPE  RESB-CHARG,            "组件批次
        BDMNG     TYPE  RESB-BDMNG,            "应领数量
        VORNR     TYPE  RESB-VORNR,            "工序
        RSNUM     TYPE  AFKO-RSNUM,            "预留
        RSNUM02   TYPE  RESB-RSNUM,            "预留
        RGEKZ     TYPE  RESB-RGEKZ,            "反冲
        SCGD      TYPE  C,                     "加工要求
        NAME02    TYPE  KNA1-NAME1,            "客户单位
        KUNNR     TYPE  VBAK-KUNNR,            "售达方
        VBELN     TYPE  VBAK-VBELN,            "销售凭证
        FLAG      TYPE C,
        OBJNR     TYPE  AUFK-OBJNR,           "对象号
        ISTAT     TYPE BSVX-STTXT,          "系统状态
        TDNAME    TYPE   STXH-TDNAME,    "名称
        TDSPRAS   TYPE   STXH-TDSPRAS,   "语言代码
        TDOBJECT  TYPE  STXH-TDOBJECT,
        TDID      TYPE   STXH-TDID,
      END OF ITAB.


**定义ALV结构，用来存放Excel导出的数据
*TYPES:BEGIN OF ITAB02,
*        DWERK     TYPE  AFPO-DWERK,            "生产工厂
*        NAME1     TYPE  T001W-NAME1,           "工厂名称
*        AUFNR     TYPE  AFPO-AUFNR,            "生产订单
*        DAUAT     TYPE  AFPO-DAUAT,            "订单类型
*        PSMNG     TYPE  AFPO-PSMNG,            "订单数量
*        VERID     TYPE  AFPO-VERID,            "生产版本
*        DISPO     TYPE  AFKO-DISPO,            "MRP控制者
*        MATNR     TYPE  AFPO-MATNR,            "物料编号
*        MAKTX     TYPE  MAKT-MAKTX,            "物料描述
*        XSDDX(16) TYPE  C,                     "销售订单/销售订单项
*        GSTRP     TYPE  AFKO-GSTRP,            "订单开始日期
*        GLTRP     TYPE  AFKO-GLTRP,            "基本完成日期
*        POSNR     TYPE  RESB-POSNR,            "项目序号
*        MATNR02   TYPE  RESB-MATNR,            "组件料号
*        MAKTX02   TYPE  MAKT-MAKTX,            "组件描述
*        ERFME     TYPE  RESB-ERFME,            "单位
*        CHARG     TYPE  RESB-CHARG,            "组件批次
*        BDMNG     TYPE  RESB-BDMNG,            "应领数量
*        VORNR     TYPE  RESB-VORNR,            "工序
*        RGEKZ     TYPE  RESB-RGEKZ,            "反冲
*        SCGD      TYPE  C,                     "加工要求
*      END OF ITAB02.


*定义工作区和内表
DATA: GS_ITAB0 TYPE ITAB,
      GT_ITAB0 TYPE TABLE OF ITAB.

*主要的内表
DATA: GS_ITAB TYPE ITAB,
      GT_ITAB TYPE TABLE OF ITAB.
*放公司名称
DATA: GS_ITAB1 TYPE ITAB,
      GT_ITAB1 TYPE TABLE OF ITAB.
*物料描述
DATA: GS_ITAB2 TYPE ITAB,
      GT_ITAB2 TYPE TABLE OF ITAB.
*售达方
DATA: GS_ITAB3 TYPE ITAB,
      GT_ITAB3 TYPE TABLE OF ITAB.
*组件物料描述
DATA: GS_ITAB4 TYPE ITAB,
      GT_ITAB4 TYPE TABLE OF ITAB.
*长文本
DATA: GS_ITAB5 TYPE ITAB,
      GT_ITAB5 TYPE TABLE OF ITAB.

*定义存放smartforms数据的工作区和内表
DATA:GT_RESULT TYPE TABLE OF ZPPS_002,
     GS_RESULT TYPE ZPPS_002,
     GS_FORM   TYPE ZPPS_002,
     GT_FORM   TYPE TABLE OF ZPPS_002,
     GS_SMART1 TYPE ZPPS_002,
     GT_SMART1 TYPE TABLE OF ZPPS_002,
     GS_SMART  TYPE ZPPS_002,
     GT_SMART  TYPE TABLE OF ZPPS_002.

*定义存放smartforms数据的工作区和内表
DATA:GT_CHECKBOX TYPE TABLE OF ZPPS_002,
     GS_CHECKBOX TYPE ZPPS_002.


**定义存放导出EXCEL的数据的工作区和内表
*DATA: LS_EXCEL TYPE ITAB02,
*      LT_EXCEL TYPE TABLE OF ITAB02.

*定义SMARTFORM行数
DATA: COUNT  TYPE I,
      L_LINE TYPE I.
* 定义指针
FIELD-SYMBOLS <FS_ITAB> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB1> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB2> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB3> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB4> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB5> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB6> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB7> TYPE ITAB.
* 定义ALV 的变量
DATA:GT_FIELDCAT  TYPE LVC_T_FCAT,
     GS_FIELDCAT  TYPE LVC_S_FCAT,
     GS_LAYOUT    TYPE LVC_S_LAYO,
     GV_POS       TYPE I,
     GCL_ALV_GRID TYPE REF TO CL_GUI_ALV_GRID,
     GS_EVENTS    TYPE SLIS_ALV_EVENT,
     GT_EVENTS    TYPE SLIS_T_EVENT,
     GS_STBL      TYPE LVC_S_STBL.

*定义smartforms变量***********************************************************************************
DATA: SSF_NAME        TYPE TDSFNAME VALUE 'ZPPF_001',
      SSF_NAME02      TYPE TDSFNAME VALUE 'ZPPF_002',
      L_FM_NAME       TYPE RS38L_FNAM,
      CONTROL         TYPE SSFCTRLOP,
      OUTPUT_OPTIONS  TYPE SSFCOMPOP,
      JOB_OUTPUT_INFO TYPE SSFCRESCL.

*选择屏幕
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_AUFNR FOR AFKO-AUFNR.          "生产订单
  PARAMETERS:P_DWERK TYPE AFPO-DWERK OBLIGATORY.   "生产工厂


  SELECT-OPTIONS: S_DISPO FOR AFKO-DISPO NO INTERVALS NO-EXTENSION,              "MRP控制者
  S_ISTAT FOR TJ02-ISTAT.          "系统状态

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
  PARAMETERS:P_A4 RADIOBUTTON GROUP GRP1 DEFAULT 'X',
             P_A5 RADIOBUTTON GROUP GRP1.
SELECTION-SCREEN END OF BLOCK B2.


**检查权限
*AT SELECTION-SCREEN.
*  AUTHORITY-CHECK OBJECT 'F_SKA1_BUK'
*              ID 'TCD' FIELD SY-TCODE     "ABAP 系统字段：当前事务代码'
*              ID 'DWERK' FIELD P_DWERK.
*  IF SY-SUBRC <> 0.
*    MESSAGE E001(00) WITH '没有事物代码' SY-TCODE '的创建权限'.
*  ENDIF.


START-OF-SELECTION.

*数据获取部分
**  在SQL之中提供了一个EXISTS结构用于判断子查询是否有数据返回。如果子查询中有数据返回，则EXISTS结构返回TRUE，反之返回FALSE。
  SELECT
     AFPO~DWERK"生产工厂
     AFPO~DAUAT"订单类型
     AFPO~AUFNR"生产订单
     AFPO~PSMNG"订单数量
     AFPO~VERID"生产版本
     AFKO~DISPO"MRP控制者
     AFPO~MATNR"物料编号
     AFPO~KDAUF"销售订单
     AFPO~KDPOS"销售项
     AFKO~GSTRP"订单开始日期
     AFKO~GLTRP"基本完成日期
     RESB~POSNR"项目序号
     RESB~MATNR AS MATNR02"组件料号
     RESB~ERFME"单位
     RESB~BDMNG"需求量
     RESB~VORNR"工序
     RESB~RGEKZ"反冲标记
     RESB~CHARG "批号
     AFKO~RSNUM"预留
     RESB~RSNUM AS RSNUM02"预留
     INTO CORRESPONDING FIELDS OF TABLE GT_ITAB
     FROM AFKO INNER JOIN AFPO ON AFPO~AUFNR = AFKO~AUFNR
             INNER  JOIN RESB ON RESB~RSNUM = AFKO~RSNUM
             INNER JOIN AUFK ON AUFK~AUFNR = AFKO~AUFNR
     WHERE EXISTS ( SELECT
                  OBJNR
                FROM JEST
                WHERE OBJNR = AUFK~OBJNR
                AND STAT IN S_ISTAT
                AND INACT = '' )
    AND AFPO~AUFNR IN S_AUFNR
    AND AFPO~DWERK = P_DWERK
    AND AFKO~DISPO IN S_DISPO.
*  AND RESB~XLOEK <> 'X' .
*     DELETE GT_ALV WHERE XLOEK = 'X'.

  IF GT_ITAB[] IS INITIAL.
    MESSAGE '没有数据，请重新选择！' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
*    STOP.
  ENDIF.

  IF GT_ITAB[] IS NOT INITIAL.
    "工厂名称
    SELECT T001W~WERKS AS DWERK
           T001W~NAME1
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB1
           FROM T001W
           FOR ALL ENTRIES IN GT_ITAB
           WHERE T001W~WERKS = GT_ITAB-DWERK.

    "物料描述
    SELECT MAKT~MAKTX
           MAKT~MATNR
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB2
           FROM MAKT
           FOR ALL ENTRIES IN GT_ITAB
           WHERE MAKT~MATNR = GT_ITAB-MATNR.

    "组件物料描述
    SELECT MAKT~MAKTX AS MAKTX02
           MAKT~MATNR
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB4
           FROM MAKT
           FOR ALL ENTRIES IN GT_ITAB
           WHERE MAKT~MATNR = GT_ITAB-MATNR02.

    "售达方
*afpo-KDAUF = vbak-vbeln    vbak-kunnr = kan1-kunnr    kna1-name1
    SELECT VBAK~VBELN
           VBAK~KUNNR
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB3
           FROM VBAK
           FOR ALL ENTRIES IN GT_ITAB
           WHERE VBAK~VBELN = GT_ITAB-KDAUF.

*"查找对象号确定系统状态
*SELECT
*  AUFK~AUFNR   "订单号
*  AUFK~OBJNR
*  INTO CORRESPONDING FIELDS OF TABLE GT_ITAB0
*  FROM AUFK
*  FOR ALL ENTRIES IN GT_ITAB
*  WHERE AUFK~AUFNR = GT_ITAB-AUFNR.

  ENDIF.

*排序
  SORT GT_ITAB BY DWERK.

*将数据放入第一个内表中
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB>.
    "工厂名称
    READ TABLE GT_ITAB1
    INTO GS_ITAB1
    WITH KEY DWERK = <FS_ITAB>-DWERK.
    IF SY-SUBRC = 0.
      <FS_ITAB>-NAME1 = GS_ITAB1-NAME1.
    ENDIF.

    "物料描述
    READ TABLE GT_ITAB2
    INTO GS_ITAB2
    WITH KEY MATNR = <FS_ITAB>-MATNR.
    IF SY-SUBRC = 0.
      <FS_ITAB>-MAKTX = GS_ITAB2-MAKTX.
    ENDIF.

    "组件物料描述
    READ TABLE GT_ITAB4
    INTO GS_ITAB4
    WITH KEY MATNR = <FS_ITAB>-MATNR02.
    IF SY-SUBRC = 0.
      <FS_ITAB>-MAKTX02 = GS_ITAB4-MAKTX02.
    ENDIF.

    "售达方
    READ TABLE GT_ITAB3
    INTO GS_ITAB3
    WITH KEY VBELN = <FS_ITAB>-KDAUF.
    IF SY-SUBRC = 0.
      <FS_ITAB>-KUNNR = GS_ITAB3-KUNNR.
    ENDIF.

*    "对象号确定系统状态
*  READ TABLE GT_ITAB0
*  INTO GS_ITAB0
*  WITH KEY AUFNR = <FS_ITAB>-AUFNR.
*  IF SY-SUBRC = 0.
*    <FS_ITAB>-OBJNR = GS_ITAB0-OBJNR.
*  ENDIF.

  ENDLOOP.

*kan1-kunnr    kna1-name1
  IF GT_ITAB[] IS NOT INITIAL.
    "客户单位
    SELECT KNA1~KUNNR
           KNA1~NAME1 AS NAME02
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB4
           FROM KNA1
           FOR ALL ENTRIES IN GT_ITAB
           WHERE KNA1~KUNNR = GT_ITAB-KUNNR.
  ENDIF.

*排序
  SORT GT_ITAB BY KUNNR.

*将数据放入第一个内表中
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB1>.
    "客户单位
    READ TABLE GT_ITAB4
    INTO GS_ITAB4
    WITH KEY KUNNR = <FS_ITAB>-KUNNR.
    IF SY-SUBRC = 0.
      <FS_ITAB>-NAME02 = GS_ITAB1-NAME02.
    ENDIF.
  ENDLOOP.

*LOOP AT GT_ITAB ASSIGNING <FS_ITAB4>.
*
*  CALL FUNCTION 'STATUS_TEXT_EDIT'
*    EXPORTING
**     CLIENT                  = SY-MANDT
**     FLG_USER_STAT           = ' '
*      OBJNR = <FS_ITAB4>-OBJNR " 单据号码
**     ONLY_ACTIVE             = 'X'
*      SPRAS = 'E'
**     BYPASS_BUFFER           = ' '
*    IMPORTING
**     ANW_STAT_EXISTING       =
**     E_STSMA                 =
*      LINE  = <FS_ITAB4>-ISTAT. " 返回状态
**   USER_LINE               =
**   STONR                   =
** EXCEPTIONS
**   OBJECT_NOT_FOUND        = 1
**   OTHERS                  = 2
*  .
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*
*ENDLOOP.


*DATA GV_TDNAME TYPE THEAD-TDNAME.
*DATA GV_AUFNR TYPE AFKO-AUFNR VALUE '000300000000'.

*合并字符串
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB2>.
    CONCATENATE '%' <FS_ITAB2>-AUFNR '%' INTO <FS_ITAB2>-TDNAME.
  ENDLOOP.


  IF GT_ITAB[] IS NOT INITIAL.
    LOOP AT GT_ITAB INTO GS_ITAB.
      SELECT TDNAME,         "名称
             TDSPRAS       "语言代码
        FROM STXH
        INTO TABLE @GT_ITAB5
        WHERE TDOBJECT = 'AUFK'
        AND TDNAME LIKE @GS_ITAB5-TDNAME
        AND TDID = 'KOPF'.
    ENDLOOP.
  ENDIF.

  LOOP AT GT_ITAB5 INTO GS_ITAB5.
    PERFORM FRM_GET_TEXT USING 'KOPF'  GS_ITAB5-TDSPRAS GS_ITAB5-TDNAME 'AUFK' CHANGING GS_ITAB5-SCGD.
    APPEND GS_ITAB5 TO GT_ITAB.
  ENDLOOP.


*合并字符串  订单和订单项
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB5>.
    CONCATENATE <FS_ITAB2>-KDAUF <FS_ITAB5>-KDPOS INTO <FS_ITAB5>-XSDDX.
  ENDLOOP.


*ALV
  PERFORM  FRM_DISPLAY_DATA . "调用子程序
*&---------------------------------------------------------------------*
*& Form frm_get_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> SY_LANGU
*&      --> P_
*&      --> P_
*&      <-- GV_STRING
*&---------------------------------------------------------------------*
FORM FRM_GET_TEXT  USING    UV_ID
                            UV_SPRAS
                            UV_NAME
                            UV_OBJECT
                   CHANGING CV_TEXT.

  DATA: LV_ID     TYPE THEAD-TDID,
        LV_SPRAS  TYPE THEAD-TDSPRAS,
        LV_NAME   TYPE THEAD-TDNAME,
        LV_OBJECT TYPE THEAD-TDOBJECT.

  DATA LT_LINES TYPE TABLE OF TLINE WITH HEADER LINE.

  LV_ID = UV_ID.
  LV_SPRAS = UV_SPRAS.
  LV_NAME = UV_NAME.
  LV_OBJECT =  UV_OBJECT.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      ID                      = LV_ID
      LANGUAGE                = LV_SPRAS
      NAME                    = LV_NAME
      OBJECT                  = LV_OBJECT
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
*     OLD_LINE_COUNTER        =
    TABLES
      LINES                   = LT_LINES
    EXCEPTIONS
      ID                      = 1
      LANGUAGE                = 2
      NAME                    = 3
      NOT_FOUND               = 4
      OBJECT                  = 5
      REFERENCE_CHECK         = 6
      WRONG_ACCESS_TO_ARCHIVE = 7
      OTHERS                  = 8.
  IF SY-SUBRC <> 0.
    CV_TEXT = 'E'.
    EXIT.
  ENDIF.

  LOOP AT LT_LINES.
    CONCATENATE CV_TEXT LT_LINES-TDLINE INTO CV_TEXT SEPARATED BY SPACE.
  ENDLOOP.

ENDFORM.


FORM FRM_DISPLAY_DATA .
  PERFORM FRM_SET_LAYOUT.
  PERFORM FRM_SET_FIELDCAT.
  PERFORM FRM_DISPLAY_ALV.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_LAYOUT .
  GS_LAYOUT-ZEBRA = 'X'.
  GS_LAYOUT-SEL_MODE = 'A'.
  GS_LAYOUT-CWIDTH_OPT = 'X'. "edit可编辑
  GS_LAYOUT-NO_ROWMARK = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_FIELDCAT .

  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-FIELDNAME = 'FLAG'.
  GS_FIELDCAT-REPTEXT = '请选择'.
  GS_FIELDCAT-CHECKBOX  = 'X'.
  GS_FIELDCAT-EDIT      = 'X'.

*  gs_fieldcat-col_pos      = 1.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

  PERFORM FRM_CREATE_FIELDS USING:'DWERK'  '生产工厂' '' '',
'NAME1' '工厂名称' '' '',
'AUFNR' '生产订单' '' '',
'DAUAT' '订单类型' '' '',
'PSMNG' '订单数量' '' '',
'VERID' '生产版本' '' '',
'DISPO' 'MRP控制者' '' '',
'MATNR' '物料编号' '' '',
'MAKTX' '物料描述' '' '',
"'KDAUF' '销售订单' '' '',
"'KDPOS' '销售订单项' '' '',
'XSDDX' '销售订单/项' '' '',
'GSTRP' '订单开始日期' '' '',
'GLTRP' '基本完成日期' '' '',
'POSNR' '项目序号' '' '',
'MATNR02' '组件料号' '' '',
'MAKTX02' '组件描述' '' '',
'ERFME' '单位' '' '',
'CHARG' '组件批次' '' '',
'BDMNG' '应领数量' '' '',
'VORNR' '工序' '' '',
"'RSNUM' '预留' '' '',
"'RSNUM02' '预留' '' '',
'RGEKZ' '反冲' '' '',
'SCGD' '加工要求' '' ''.


*  PERFORM create_fieldcatalog USING gt_out CHANGING gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_DISPLAY_ALV .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      IS_LAYOUT_LVC            = GS_LAYOUT
      IT_FIELDCAT_LVC          = GT_FIELDCAT
      IT_EVENTS                = GT_EVENTS
      I_SAVE                   = 'A'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND'
      I_CALLBACK_PF_STATUS_SET = 'SET_PF_STATUS'
*     i_callback_html_top_of_page = 'F_HTML_TOP_OF_PAGE' 页眉
*     i_html_height_top        = 12  "指定页眉宽度
    TABLES
      T_OUTTAB                 = GT_ITAB.

  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.

FORM SET_PF_STATUS USING PT_EXCLUDE TYPE KKBLO_T_EXTAB.


  DATA:LT_EXCLUDE TYPE KKBLO_T_EXTAB WITH HEADER LINE.

  SET PF-STATUS 'STANDARD' EXCLUDING LT_EXCLUDE[].

ENDFORM.
FORM FRM_CREATE_FIELDS USING PV_FIELDNAME PV_REPTEXT PV_ZERO PV_OUT.
  INSERT VALUE #(
  FIELDNAME = PV_FIELDNAME
  REPTEXT   = PV_REPTEXT
  NO_ZERO   = PV_ZERO
  NO_OUT    = PV_OUT
  )
  INTO TABLE GT_FIELDCAT.
ENDFORM.

*------自定义按钮
FORM USER_COMMAND USING R_UCOMM TYPE SY-UCOMM
      RS_SELFIELD TYPE SLIS_SELFIELD.
*CheckBox 勾选情况
  DATA: LR_GRID TYPE REF TO CL_GUI_ALV_GRID.  "选中checkbox立马触发事件
  DATA : LV_INDEX TYPE I.
  DATA : ET_FILTERED    TYPE LVC_T_FIDX.
  DATA:LV_TABIX           TYPE SY-TABIX.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      E_GRID = LR_GRID.
  CALL METHOD LR_GRID->CHECK_CHANGED_DATA.


*按钮事件
  CASE R_UCOMM.
    WHEN 'PRINT'.
      PERFORM FRM_PRINTSAMRT.
*    WHEN 'EXCEL'.
*      PERFORM SUB_DOWNLOAD_FILE USING 'EXCEL'.
    WHEN '&SELALL'.
      PERFORM FRM_SEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN '&DELSAL'.
      PERFORM FRM_DEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*打印数据A4
FORM FRM_PRINTSAMRT.
  CONTROL-PREVIEW   = 'X'.  "而是直接显示预览结果
  CONTROL-NO_DIALOG = ''.    "打印前显示打印设置对话框
  CONTROL-NO_OPEN   = 'X'.
  CONTROL-NO_CLOSE  = 'X'.

  OUTPUT_OPTIONS-TDIMMED = 'X'.
  OUTPUT_OPTIONS-TDDEST = 'LP01'. "打印设备
  OUTPUT_OPTIONS-TDARMOD = 1.

  CLEAR GT_CHECKBOX."清空内表数据
*获取勾选的数据
  IF GT_ITAB[] IS NOT INITIAL.
    LOOP AT GT_ITAB INTO GS_ITAB.
      CLEAR GS_CHECKBOX.
      IF GS_ITAB-FLAG = 'X'.
        MOVE-CORRESPONDING GS_ITAB TO GS_CHECKBOX.
        APPEND GS_CHECKBOX TO GT_CHECKBOX.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF GT_CHECKBOX IS INITIAL.
    MESSAGE:'请选择至少一条数据进行打印！' TYPE 'E'.
  ELSE.

    SORT GT_CHECKBOX BY AUFNR.
*获取抬头数据，可能有相同或不同的生产订单号，则不同抬头，放在内表中，后面使用此内表作循环打印
    LOOP AT GT_CHECKBOX INTO GS_CHECKBOX.
*抬头内表数据为空，则直接将数据存放进抬头内表
*抬头内表不为空，则判断抬头内表中是否有该生产订单的数据，如果没有，将数据存放进抬头内表
      IF GT_SMART IS NOT INITIAL.
        READ TABLE GT_SMART INTO GS_SMART
        WITH KEY AUFNR = GS_CHECKBOX-AUFNR.
        IF SY-SUBRC <> 0 .
          GS_SMART = GS_CHECKBOX.
          APPEND GS_SMART TO GT_SMART.
        ENDIF.
      ELSE.
        GS_SMART = GS_CHECKBOX.
        APPEND GS_SMART TO GT_SMART.
      ENDIF.
    ENDLOOP.

    PERFORM OPEN_SSF.
*开启打印对话框
    SORT GT_SMART BY AUFNR.
*根据抬头生产订单获取相应的行项目数据
    LOOP AT GT_SMART INTO GS_SMART.

      PERFORM FRM_ITEMDATA USING GS_SMART.
    ENDLOOP.

    PERFORM FRM_CLOSE_SSF.
  ENDIF.
ENDFORM.


*--------------------------------------------------------------------------------*
*	Form frm_itemdata          *
*---------------------------------------------------------------------------------*
*   获取smartforms行项目数据
*   参数: ls_smart：当此打印页的抬头
*---------------------------------------------------------------------------------*

FORM FRM_ITEMDATA
   USING LS_SMART TYPE ZPPS_002.

*最终打印的所有行项目的合计
  DATA: LV_ITEMSUM TYPE I VALUE 0,
        LV_NO      TYPE I VALUE 0.

*获取alv上同一个生产订单号的所有行项目
  CLEAR: GS_FORM,GT_FORM.

  LOOP AT GT_ITAB INTO GS_ITAB WHERE AUFNR = LS_SMART-AUFNR.

    MOVE-CORRESPONDING GS_ITAB TO GS_FORM.
    LV_NO = LV_NO + 1.
    GS_FORM-NUM = LV_NO.
    APPEND GS_FORM TO GT_FORM.

    CLEAR GS_FORM.
  ENDLOOP.

  PERFORM FRM_PRINT TABLES GT_FORM USING LS_SMART LV_ITEMSUM.

ENDFORM.



*--------------------------------------------------------------------------------*
*	Form  frm_print         *
*---------------------------------------------------------------------------------*
*   调用打印smartforms函数
*   参数： lt_result,要打印的行项目数据
*          ls_smart，要打印的抬头数据
*          lv_sum，行项目合计后的数量
*---------------------------------------------------------------------------------*
FORM FRM_PRINT
  TABLES LT_RESULT STRUCTURE ZPPS_002
  USING LS_SMART TYPE ZPPS_002
        LV_SUM TYPE I.

*  LOOP AT LT_SMARTFORMS INTO LS_SMARTFORMS.
*    CLEAR LT_SMARTRESULT.
*    APPEND LS_SMARTFORMS TO LT_SMARTRESULT.
*    ENDLOOP.
**************************************
  ""计算总行数以便算出改补的行数
*      DESCRIBE TABLE LT_SMARTFORMS LINES COUNT.
  DESCRIBE TABLE LT_RESULT LINES COUNT.
  "*
*根据勾选打印的情况来判断
  IF P_A4 = 'X'.
*    L_LINE =  COUNT MOD 22.
*    IF L_LINE <> 0.
*      L_LINE = 22 - L_LINE.                                                                            "*
*      DO L_LINE TIMES.                                                                                 "*
*        APPEND GS_SMART1 TO LT_RESULT.                                                                       "*
*      ENDDO.
*    ENDIF.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        FORMNAME           = SSF_NAME
      IMPORTING
        FM_NAME            = L_FM_NAME
      EXCEPTIONS
        NO_FORM            = 1
        NO_FUNCTION_MODULE = 2
        OTHERS             = 3.
    IF SY-SUBRC <> 0.
*   Implement suitable error handling here
    ENDIF.

    CALL FUNCTION L_FM_NAME "'/1BCDWB/SF00000016'
      EXPORTING
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        CONTROL_PARAMETERS = CONTROL
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        OUTPUT_OPTIONS     = OUTPUT_OPTIONS
*       USER_SETTINGS      = 'X'
        LT_STRUCT          = LS_SMART
* IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO    =
*       JOB_OUTPUT_OPTIONS =
      TABLES
        ITAB1              = LT_RESULT[]
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.


*根据勾选打印的情况来判断
  ELSEIF P_A4 = ''.
*    L_LINE =  COUNT MOD 22.
*    IF L_LINE <> 0.
*      L_LINE = 7 - L_LINE.                                                                            "*
*      DO L_LINE TIMES.                                                                                 "*
*        APPEND GS_SMART1 TO LT_RESULT.                                                                       "*
*      ENDDO.
*    ENDIF.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        FORMNAME           = SSF_NAME02
      IMPORTING
        FM_NAME            = L_FM_NAME
      EXCEPTIONS
        NO_FORM            = 1
        NO_FUNCTION_MODULE = 2
        OTHERS             = 3.
    IF SY-SUBRC <> 0.
*   Implement suitable error handling here
    ENDIF.

    CALL FUNCTION L_FM_NAME "'/1BCDWB/SF00000016'
      EXPORTING
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        CONTROL_PARAMETERS = CONTROL
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        OUTPUT_OPTIONS     = OUTPUT_OPTIONS
*       USER_SETTINGS      = 'X'
        LT_STRUCT          = LS_SMART
* IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO    =
*       JOB_OUTPUT_OPTIONS =
      TABLES
        ITAB1              = LT_RESULT
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDIF.

ENDFORM.

*调用SSF_OPEN函数设置打印机,打开输出请求,使用用户打印设置必须调用 SSF OPEN。
FORM OPEN_SSF .
  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      USER_SETTINGS      = 'X'
      CONTROL_PARAMETERS = CONTROL
      OUTPUT_OPTIONS     = OUTPUT_OPTIONS
    EXCEPTIONS
      FORMATTING_ERROR   = 1
      INTERNAL_ERROR     = 2
      SEND_ERROR         = 3
      USER_CANCELED      = 4
      OTHERS             = 5.

ENDFORM. " OPEN_SSF

*关闭打印机
FORM FRM_CLOSE_SSF.

  CALL FUNCTION 'SSF_CLOSE'
    IMPORTING
      JOB_OUTPUT_INFO  = JOB_OUTPUT_INFO
    EXCEPTIONS
      FORMATTING_ERROR = 1
      INTERNAL_ERROR   = 2
      SEND_ERROR       = 3
      OTHERS           = 4.

ENDFORM. " CLOSE_SSF\


**数据导出Excel
*FORM SUB_DOWNLOAD_FILE USING VALUE(I_TYPE) TYPE CHAR6.
*
*  DATA : LV_FILENAME TYPE STRING.
*
*  CLEAR LT_EXCEL."清空内表数据
*
*  LOOP AT GT_ITAB INTO GS_ITAB.
*    IF GS_ITAB-FLAG = 'X'.
*      MOVE-CORRESPONDING GS_ITAB TO LS_EXCEL.
*      APPEND LS_EXCEL TO LT_EXCEL.
*
*    ENDIF.
*  ENDLOOP.
*
*
*  IF I_TYPE = 'EXCEL'.
*    LV_FILENAME = 'D:\生产订单.xls'.
*  ENDIF.
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      FILENAME = LV_FILENAME
*      FILETYPE = 'DAT'
*      CODEPAGE = '8404'
*    TABLES
*      DATA_TAB = LT_EXCEL.
*ENDFORM.




*&---------------------------------------------------------------------*
*& Form FRM_SEL_ALLDATA
*&---------------------------------------------------------------------*
*& 自定义全选按钮
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SEL_ALLDATA .
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB7>.
    <FS_ITAB7>-FLAG = 'X'.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_DEL_ALLDATA
*&---------------------------------------------------------------------*
*& 取消全选
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_DEL_ALLDATA .
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB7>.
    <FS_ITAB7>-FLAG = ' '.
  ENDLOOP.
ENDFORM.
