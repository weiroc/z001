*&---------------------------------------------------------------------*
*& Report ZPPF003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPPF003.
TABLES:AFKO,AFPO,RESB,T001W,MARA,MCHB,MAKT,MARD,TJ02,MARC.
DATA: G_VRM_ID      TYPE VRM_ID VALUE 'P_BWART',  "绑定到一定的字段上
      LT_VRM_VALUES TYPE VRM_VALUES, "值列 表
      LS_VRM_VALUES LIKE LINE OF LT_VRM_VALUES.


TYPES: BEGIN OF ITAB1,
         PLNBEZ TYPE AFKO-PLNBEZ,  "物料
         DWERK  TYPE AFPO-DWERK,   "工厂
         AUFNR  TYPE AFKO-AUFNR,   "生产订单号
         DAUAT  TYPE AFPO-DAUAT,   "订单类型
         DISPO  TYPE AFKO-DISPO,   "MRP控制者
         LGORT  TYPE RESB-LGORT,   "库存地点
         KDAUF  TYPE AFPO-KDAUF,   "销售订单
         KDPOS  TYPE AFPO-KDPOS,   "销售订单行项目     　       "生产订单状态
         GLTRP  TYPE AFKO-GLTRP,   "基本完成日期
         GSTRP  TYPE AFKO-GSTRP,  "基本开始日期
         FTRMS  TYPE AFKO-FTRMS,   "计划下达日期
         GLTRS  TYPE AFKO-GLTRS,   "计划完成日期
       END OF ITAB1.

TYPES: BEGIN OF ITAB,
         DWERK   TYPE AFPO-DWERK,    "工厂
         NAME1   TYPE T001W-NAME1,   "工厂描述
         AUFNR   TYPE AFKO-AUFNR,    "生产订单号
         DAUAT   TYPE AFPO-DAUAT,   "订单类型
         ISTAT   TYPE BSVX-STTXT,   "生产订单状态
         PSMNG   TYPE AFPO-PSMNG,   "订单总数量
         DISPO   TYPE AFKO-DISPO,    "MRP控制者
         FEVOR   TYPE AFKO-FEVOR,    "生产管理员
         PLNBEZ  TYPE AFKO-PLNBEZ,   "产品编号
         MAKTX   TYPE MARA-ZZMAKTX,  "产品描述
         GLTRP   TYPE AFKO-GLTRP,    "基本完成日期
         GSTRP   TYPE AFKO-GSTRP,    "基本开始日期
         FTRMS   TYPE AFKO-FTRMS,    "计划开始日期
         GLTRS   TYPE AFKO-GLTRS,    "计划完成日期
         FTRMI   TYPE AFKO-FTRMI,    "实际下达日期
         GSTRI   TYPE AFKO-GSTRI,    "实际开始日期
         GETRI   TYPE AFKO-GETRI,    "实际结束日期
         PSOBS   TYPE AFPO-PSOBS,    "产品特殊库存标识
         PLNUM   TYPE AFPO-PLNUM,    "计划订单
         KDAUF   TYPE AFPO-KDAUF,    "销售订单
         KDPOS   TYPE AFPO-KDPOS,    "销售订单行项目
         WEMNG   TYPE AFPO-WEMNG,    "收货数量
         AMEIN   TYPE AFPO-AMEIN,    "订单单位
         MEINS   TYPE AFPO-MEINS,    "基本单位
         PAMNG   TYPE AFPO-PAMNG,    "报废数量
         PGMNG   TYPE AFPO-PGMNG,    "订货数量
         RSNUM   TYPE RESB-RSNUM,    "预留编号
         RSPOS   TYPE RESB-RSPOS,    "预定的项目编号
         XLOEK   TYPE RESB-XLOEK,    "项目被删除
         XWAOK   TYPE RESB-XWAOK,    "许可的移动
         KZEAR   TYPE RESB-KZEAR,    "最后发货
         POSTP   TYPE RESB-POSTP,    "生产订单行类别
         POSNR   TYPE RESB-POSNR,    "生产订单行项目号
         MATNR   TYPE RESB-MATNR,    "组件料号
         MAKTX02 TYPE MARA-ZZMAKTX,  "组件描述
         LGORT   TYPE RESB-LGORT,    "库存地点
         SOBKZ   TYPE RESB-SOBKZ,    "特殊库存
         BDTER   TYPE RESB-BDTER,    "需求日期
         BDMNG   TYPE RESB-BDMNG,    "需求量
         MEINS02 TYPE RESB-MEINS,    "单位
         CLABS   TYPE MCHB-CLABS,    "非限制库存数
         ENMNG   TYPE RESB-ENMNG,    "提货数（已领数）
         WLL     TYPE RESB-BDMNG,  "未领数
         RGEKZ   TYPE RESB-RGEKZ,    "反冲

         MTART   TYPE MARA-MTART,   "物料类型
         OBJNR   TYPE AUFK-OBJNR,           "对象号
         FLAG    TYPE C,
       END OF ITAB.

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
*长文本
DATA: GS_ITAB6 TYPE ITAB,
      GT_ITAB6 TYPE TABLE OF ITAB.
* 定义指针
FIELD-SYMBOLS <FS_ITAB> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB1> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB2> TYPE ITAB.
FIELD-SYMBOLS <FS_ITAB3> TYPE ITAB.


* 定义ALV 的变量
DATA:GT_FIELDCAT  TYPE LVC_T_FCAT,
     GS_FIELDCAT  TYPE LVC_S_FCAT,
     GS_LAYOUT    TYPE LVC_S_LAYO,
     GV_POS       TYPE I,
     GCL_ALV_GRID TYPE REF TO CL_GUI_ALV_GRID,
     GS_EVENTS    TYPE SLIS_ALV_EVENT,
     GT_EVENTS    TYPE SLIS_T_EVENT,
     GS_STBL      TYPE LVC_S_STBL.

*定义存放smartforms数据的工作区和内表
DATA:GT_RESULT TYPE TABLE OF ZPPS_003,
     GS_RESULT TYPE ZPPS_003,
     GS_FORM   TYPE ZPPS_003,
     GT_FORM   TYPE TABLE OF ZPPS_003,
     GS_SMART1 TYPE ZPPS_003,
     GT_SMART1 TYPE TABLE OF ZPPS_003,
     GS_SMART  TYPE ZPPS_003,
     GT_SMART  TYPE TABLE OF ZPPS_003.

*定义存放smartforms数据的工作区和内表
DATA:GT_CHECKBOX TYPE TABLE OF ZPPS_003,
     GS_CHECKBOX TYPE ZPPS_003.

*定义smartforms变量***********************************************************************************
DATA: SSF_NAME        TYPE TDSFNAME VALUE 'ZPPF_003',
      SSF_NAME02      TYPE TDSFNAME VALUE 'ZPPF_002',
      L_FM_NAME       TYPE RS38L_FNAM,
      CONTROL         TYPE SSFCTRLOP,
      OUTPUT_OPTIONS  TYPE SSFCOMPOP,
      JOB_OUTPUT_INFO TYPE SSFCRESCL.

*选择屏幕
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
S_AUFNR FOR AFKO-AUFNR,   "生产订单
S_PLNBEZ FOR AFKO-PLNBEZ, "物料
S_DISPO  FOR AFKO-DISPO,   "MRP控制者
S_LGORT  FOR RESB-LGORT,   "库存地点
S_KDAUF  FOR AFPO-KDAUF,   "销售订单
S_KDPOS  FOR AFPO-KDPOS,   "销售订单行项目
S_GLTRP  FOR AFKO-GLTRP,   "基本完成日期
S_GSTRP  FOR AFKO-GSTRP,   "基本开始日期
S_FTRMS  FOR AFKO-FTRMS,   "计划下达日期
S_GLTRS  FOR AFKO-GLTRS,   "计划完成日期
S_ISTAT  FOR TJ02-ISTAT.    "系统状态
  PARAMETERS:P_DWERK TYPE AFPO-DWERK OBLIGATORY,   "生产工厂
             P_DAUAT TYPE AFPO-DAUAT. "订单类型

  PARAMETERS: P_BWART TYPE C AS LISTBOX VISIBLE LENGTH 20 OBLIGATORY DEFAULT '1'.

SELECTION-SCREEN END OF BLOCK B1.


AT SELECTION-SCREEN OUTPUT.   "屏幕元素事件

  PERFORM GETDATA USING G_VRM_ID.   "将参数传入程序块中

FORM GETDATA USING  G_VRM_ID.

  REFRESH LT_VRM_VALUES .   "给下拉列表赋值

  LS_VRM_VALUES-KEY  = '1'.
  LS_VRM_VALUES-TEXT = '生产领料'.
  APPEND LS_VRM_VALUES TO LT_VRM_VALUES.
  CLEAR LS_VRM_VALUES.

  LS_VRM_VALUES-KEY  = '2'.
  LS_VRM_VALUES-TEXT = '生产退料'.
  APPEND LS_VRM_VALUES TO LT_VRM_VALUES.
  CLEAR LS_VRM_VALUES.

  LS_VRM_VALUES-KEY  = '3'.
  LS_VRM_VALUES-TEXT = '超领'.
  APPEND LS_VRM_VALUES TO LT_VRM_VALUES.
  CLEAR LS_VRM_VALUES.

  LS_VRM_VALUES-KEY  = '4'.
  LS_VRM_VALUES-TEXT = '超退'.
  APPEND LS_VRM_VALUES TO LT_VRM_VALUES.
  CLEAR LS_VRM_VALUES.
  CALL FUNCTION 'VRM_SET_VALUES'     "调用函数
    EXPORTING
      ID              = G_VRM_ID
      VALUES          = LT_VRM_VALUES
    EXCEPTIONS
      ID_ILLEGAL_NAME = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

START-OF-SELECTION.


*生产退料条件：
*RESB-RGEKZ<>'X'
*and RESB-DUMPS <> 'X'
*and RESB-POSTP = 'L'
*and RESB-XWAOK = 'X'
*and RESB-XLOEK <> 'X'
*and RESB-ENMNG <> 0


*生产领料条件：
*RESB.RGEKZ<>'X' 反冲字段
*and  RESB-DUMPS<>'X'虚拟件字段
*and RESB-POSTP =’L’
*and RESB-XWAOK ='X'"允许预订的货物移动
*and RESB-XLOEK<>'X'  "项目已删除
*and RESB-KZEAR <>'X'"最后发货字段
*
*此列隐藏，排除RESB.XLOEK='X'条目
*此列隐藏，排除RESB.XWAOK<>'X'条目
*此列隐藏，排除RESB.XWAOK<>'X'条目
*此列隐藏，排除RESB.POSTP<>'L'条目






*AND RESB~XLOEK = 'X'
*AND RESB~XWAOK <> 'X'
*AND RESB~XWAOK <> 'X'
*AND RESB~POSTP <> 'L'
*AND RESB~RGEKZ = 'X'.


IF P_BWART = 1.
*生产领料数据获取
  SELECT
AFPO~DWERK    "工厂
AFKO~AUFNR    "生产订单号
AFPO~DAUAT   "订单类型
AFPO~PSMNG   "订单总数量
AFKO~DISPO    "MRP控制者
AFKO~FEVOR    "生产管理员
AFKO~PLNBEZ   "产品编号
AFKO~GLTRP    "基本完成日期
AFKO~GSTRP    "基本开始日期
AFKO~FTRMS    "计划开始日期
AFKO~GLTRS    "计划完成日期
AFKO~FTRMI    "实际下达日期
AFKO~GSTRI    "实际开始日期
AFKO~GETRI    "实际结束日期
AFPO~PSOBS    "产品特殊库存标识
AFPO~PLNUM    "计划订单
AFPO~KDAUF    "销售订单
AFPO~KDPOS    "销售订单行项目
AFPO~WEMNG    "收货数量
AFPO~AMEIN    "订单单位
AFPO~MEINS    "基本单位
AFPO~PAMNG    "报废数量
AFPO~PGMNG    "订货数量
RESB~RSNUM    "预留编号
RESB~RSPOS    "预定的项目编号
RESB~XLOEK    "项目被删除
RESB~XWAOK    "许可的移动
RESB~KZEAR    "最后发货
RESB~POSTP    "生产订单行类别
RESB~POSNR    "生产订单行项目号
RESB~MATNR    "组件料号
RESB~LGORT    "库存地点
RESB~SOBKZ    "特殊库存
RESB~BDTER    "需求日期
RESB~BDMNG    "需求量
RESB~MEINS AS MEINS02     "单位
RESB~ENMNG    "提货数（已领数）   "未领数
RESB~RGEKZ    "反冲
     INTO CORRESPONDING FIELDS OF TABLE GT_ITAB
     FROM AFKO INNER JOIN AFPO ON AFPO~AUFNR = AFKO~AUFNR
             INNER  JOIN RESB ON RESB~RSNUM = AFKO~RSNUM
             INNER JOIN AUFK ON AUFK~AUFNR = AFKO~AUFNR
     WHERE EXISTS ( SELECT
                  OBJNR
                FROM JEST
                WHERE OBJNR = AUFK~OBJNR
                AND STAT IN S_ISTAT
                AND INACT = '' ).
*    AND AFPO~AUFNR IN S_AUFNR
*    WHERE AFPO~DWERK = P_DWERK.
*    AND AFKO~DISPO IN S_DISPO.
*生产领料条件：
*RESB.RGEKZ<>'X' 反冲字段
*and  RESB-DUMPS<>'X'虚拟件字段
*and RESB-POSTP =’L’
*and RESB-XWAOK ='X'"允许预订的货物移动
*and RESB-XLOEK<>'X'  "项目已删除
*and RESB-KZEAR <>'X'"最后发货字段
ELSEIF P_BWART = 2.
*生产退料数据获取
  SELECT
AFPO~DWERK    "工厂
AFKO~AUFNR    "生产订单号
AFPO~DAUAT   "订单类型
AFPO~PSMNG   "订单总数量
AFKO~DISPO    "MRP控制者
AFKO~FEVOR    "生产管理员
AFKO~PLNBEZ   "产品编号
AFKO~GLTRP    "基本完成日期
AFKO~GSTRP    "基本开始日期
AFKO~FTRMS    "计划开始日期
AFKO~GLTRS    "计划完成日期
AFKO~FTRMI    "实际下达日期
AFKO~GSTRI    "实际开始日期
AFKO~GETRI    "实际结束日期
AFPO~PSOBS    "产品特殊库存标识
AFPO~PLNUM    "计划订单
AFPO~KDAUF    "销售订单
AFPO~KDPOS    "销售订单行项目
AFPO~WEMNG    "收货数量
AFPO~AMEIN    "订单单位
AFPO~MEINS    "基本单位
AFPO~PAMNG    "报废数量
AFPO~PGMNG    "订货数量
RESB~RSNUM    "预留编号
RESB~RSPOS    "预定的项目编号
RESB~XLOEK    "项目被删除
RESB~XWAOK    "许可的移动
RESB~KZEAR    "最后发货
RESB~POSTP    "生产订单行类别
RESB~POSNR    "生产订单行项目号
RESB~MATNR    "组件料号
RESB~LGORT    "库存地点
RESB~SOBKZ    "特殊库存
RESB~BDTER    "需求日期
RESB~BDMNG    "需求量
RESB~MEINS AS MEINS02     "单位
RESB~ENMNG    "提货数（已领数）   "未领数
RESB~RGEKZ    "反冲
     INTO CORRESPONDING FIELDS OF TABLE GT_ITAB
     FROM AFKO INNER JOIN AFPO ON AFPO~AUFNR = AFKO~AUFNR
             INNER  JOIN RESB ON RESB~RSNUM = AFKO~RSNUM
             INNER JOIN AUFK ON AUFK~AUFNR = AFKO~AUFNR
     WHERE EXISTS ( SELECT
                  OBJNR
                FROM JEST
                WHERE OBJNR = AUFK~OBJNR
                AND STAT IN S_ISTAT
                AND INACT = '' ).
*    AND AFPO~AUFNR IN S_AUFNR
*    AND AFPO~DWERK = P_DWERK
*    AND AFKO~DISPO IN S_DISPO.
*生产退料条件：
*RESB-RGEKZ<>'X'
*and RESB-DUMPS <> 'X'
*and RESB-POSTP = 'L'
*and RESB-XWAOK = 'X'
*and RESB-XLOEK <> 'X'
*and RESB-ENMNG <> 0
  ELSEIF P_BWART = 3.
*数据获取
  SELECT
AFPO~DWERK    "工厂
AFKO~AUFNR    "生产订单号
AFPO~DAUAT   "订单类型
AFPO~PSMNG   "订单总数量
AFKO~DISPO    "MRP控制者
AFKO~FEVOR    "生产管理员
AFKO~PLNBEZ   "产品编号
AFKO~GLTRP    "基本完成日期
AFKO~GSTRP    "基本开始日期
AFKO~FTRMS    "计划开始日期
AFKO~GLTRS    "计划完成日期
AFKO~FTRMI    "实际下达日期
AFKO~GSTRI    "实际开始日期
AFKO~GETRI    "实际结束日期
AFPO~PSOBS    "产品特殊库存标识
AFPO~PLNUM    "计划订单
AFPO~KDAUF    "销售订单
AFPO~KDPOS    "销售订单行项目
AFPO~WEMNG    "收货数量
AFPO~AMEIN    "订单单位
AFPO~MEINS    "基本单位
AFPO~PAMNG    "报废数量
AFPO~PGMNG    "订货数量
RESB~RSNUM    "预留编号
RESB~RSPOS    "预定的项目编号
RESB~XLOEK    "项目被删除
RESB~XWAOK    "许可的移动
RESB~KZEAR    "最后发货
RESB~POSTP    "生产订单行类别
RESB~POSNR    "生产订单行项目号
RESB~MATNR    "组件料号
RESB~LGORT    "库存地点
RESB~SOBKZ    "特殊库存
RESB~BDTER    "需求日期
RESB~BDMNG    "需求量
RESB~MEINS AS MEINS02     "单位
RESB~ENMNG    "提货数（已领数）   "未领数
RESB~RGEKZ    "反冲
     INTO CORRESPONDING FIELDS OF TABLE GT_ITAB
     FROM AFKO INNER JOIN AFPO ON AFPO~AUFNR = AFKO~AUFNR
             INNER  JOIN RESB ON RESB~RSNUM = AFKO~RSNUM
             INNER JOIN AUFK ON AUFK~AUFNR = AFKO~AUFNR
     WHERE EXISTS ( SELECT
                  OBJNR
                FROM JEST
                WHERE OBJNR = AUFK~OBJNR
                AND STAT IN S_ISTAT
                AND INACT = '' ).
*    AND AFPO~AUFNR IN S_AUFNR
*    AND AFPO~DWERK = P_DWERK
*    AND AFKO~DISPO IN S_DISPO.
*AND RESB~XLOEK = 'X'
*AND RESB~XWAOK <> 'X'
*AND RESB~XWAOK <> 'X'
*AND RESB~POSTP <> 'L'
*AND RESB~RGEKZ = 'X'.
 ENDIF.


  IF GT_ITAB[] IS INITIAL.
    MESSAGE '没有数据，请重新选择！' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
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
           WHERE MAKT~MATNR = GT_ITAB-PLNBEZ.

    "组件物料描述
    SELECT MAKT~MAKTX AS MAKTX02
           MAKT~MATNR
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB3
           FROM MAKT
           FOR ALL ENTRIES IN GT_ITAB
           WHERE MAKT~MATNR = GT_ITAB-MATNR.


*    "产品描述
*    SELECT MARA~ZZMAKTX
*           MARA~MATNR
*           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB2
*           FROM MARA
*           FOR ALL ENTRIES IN GT_ITAB
*           WHERE MARA~MATNR = GT_ITAB-PLNBEZ.
*
*    "组件描述
*    SELECT MAkt~MAKTX AS MAKTX02
*           MAkt~MATNR
*           MARA~MTART  "物料类型
*           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB3
*           FROM MARA
*           FOR ALL ENTRIES IN GT_ITAB
*           WHERE MARA~MATNR = GT_ITAB-MATNR.

    "非限制库存数情况一
    SELECT MCHB~MATNR
           MCHB~WERKS AS DWERK
           MCHB~LGORT
           MCHB~CLABS
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB4
           FROM MCHB
           FOR ALL ENTRIES IN GT_ITAB
           WHERE MCHB~MATNR = GT_ITAB-MATNR
           AND MCHB~WERKS = GT_ITAB-DWERK
           AND MCHB~LGORT = GT_ITAB-LGORT.

    "非限制库存数情况二
    SELECT MARD~MATNR
           MARD~WERKS AS DWERK
           MARD~LGORT
           MARD~LABST AS CLABS
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB5
           FROM MARD
           FOR ALL ENTRIES IN GT_ITAB
           WHERE MARD~MATNR = GT_ITAB-MATNR
           AND MARD~WERKS = GT_ITAB-DWERK
           AND MARD~LGORT = GT_ITAB-LGORT.

    "查找对象号确定系统状态
    SELECT AUFK~AUFNR   "订单号
           AUFK~OBJNR
           INTO CORRESPONDING FIELDS OF TABLE GT_ITAB6
           FROM AUFK
           FOR ALL ENTRIES IN GT_ITAB
           WHERE AUFK~AUFNR = GT_ITAB-AUFNR.
  ENDIF.


*排序
  SORT GT_ITAB BY DWERK.

*将数据放入第一个内表中
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB>.
    "未领数
    <FS_ITAB>-WLL = <FS_ITAB>-BDMNG - <FS_ITAB>-ENMNG.

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
    WITH KEY MATNR = <FS_ITAB>-PLNBEZ.

    IF SY-SUBRC = 0.
      <FS_ITAB>-MAKTX = GS_ITAB2-MAKTX.
    ENDIF.

    "组件物料描述
    READ TABLE GT_ITAB3
    INTO GS_ITAB3
    WITH KEY MATNR = <FS_ITAB>-MATNR.
    IF SY-SUBRC = 0.
      <FS_ITAB>-MAKTX02 = GS_ITAB3-MAKTX02.
    ENDIF.
    "对象号确定系统状态
    READ TABLE GT_ITAB6
    INTO GS_ITAB6
    WITH KEY AUFNR = <FS_ITAB>-AUFNR.
    IF SY-SUBRC = 0.
      <FS_ITAB>-OBJNR = GS_ITAB6-OBJNR.
    ENDIF.

  ENDLOOP.


*将数据放入第一个内表中
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB2>.
    IF <FS_ITAB2>-MTART = 'FERT'.
      "非限制库存数情况一
      READ TABLE GT_ITAB4
      INTO GS_ITAB4
      WITH KEY MATNR = <FS_ITAB2>-MATNR
           DWERK = <FS_ITAB2>-DWERK
           LGORT = <FS_ITAB2>-LGORT.
      IF SY-SUBRC = 0.
        <FS_ITAB2>-CLABS = GS_ITAB4-CLABS.
      ENDIF.

    ELSEIF <FS_ITAB2>-MTART <> 'FERT'.
      "非限制库存数情况二
      READ TABLE GT_ITAB5
      INTO GS_ITAB5
      WITH KEY MATNR = <FS_ITAB2>-MATNR
            DWERK = <FS_ITAB2>-DWERK
            LGORT = <FS_ITAB2>-LGORT.
      IF SY-SUBRC = 0.
        <FS_ITAB2>-CLABS = GS_ITAB5-CLABS.
      ENDIF.
    ENDIF.
  ENDLOOP.

*获得生产订单状态
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB3>.

    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
*       CLIENT                  = SY-MANDT
*       FLG_USER_STAT           = ' '
        OBJNR = <FS_ITAB3>-OBJNR " 单据号码
*       ONLY_ACTIVE             = 'X'
        SPRAS = 'E'
*       BYPASS_BUFFER           = ' '
      IMPORTING
*       ANW_STAT_EXISTING       =
*       E_STSMA                 =
        LINE  = <FS_ITAB3>-ISTAT. " 返回状态
*   USER_LINE               =
*   STONR                   =
* EXCEPTIONS
*   OBJECT_NOT_FOUND        = 1
*   OTHERS                  = 2
    .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDLOOP.

  IF P_BWART = 1.
*ALV
    PERFORM  FRM_DISPLAY_DATA . "调用子程序
  ELSEIF P_BWART = 2.
    PERFORM  FRM_DISPLAY_DATA02 . "调用子程序
  ELSEIF P_BWART = 3.
    PERFORM  FRM_DISPLAY_DATA03. "调用子程序
  ELSEIF P_BWART = 4.
    PERFORM  FRM_DISPLAY_DATA04. "调用子程序
  ENDIF.
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

  PERFORM FRM_CREATE_FIELDS USING:
'DWERK' '工厂'  '' '',
'NAME1' '工厂描述' '' '',
'AUFNR' '生产订单号' '' '',
'DAUAT' '订单类型' '' '',
'ISTAT' '生产订单状态' '' '',
'PSMNG' '订单总数量' '' '',
'DISPO' 'MRP控制者' '' '',
'FEVOR' '生产管理员' '' '',
'PLNBEZ' '产品编号' '' '',
'MAKTX' '产品描述' '' '',
'GLTRP' '基本完成日期' '' '',
'GSTRP' '基本开始日期' '' '',
'FTRMS' '计划开始日期' '' '',
'GLTRS' '计划完成日期' '' '',
'FTRMI' '实际下达日期' '' '',
'GSTRI' '实际开始日期' '' '',
'GETRI' '实际结束日期' '' '',
'PSOBS' '产品特殊库存标识' '' '',
'PLNUM' '计划订单' '' '',
'KDAUF' '销售订单' '' '',
'KDPOS' '销售订单行项目' '' '',
'WEMNG' '收货数量' '' '',
'AMEIN' '订单单位' '' '',
'MEINS' '基本单位' '' '',
'PAMNG' '报废数量' '' '',
'PGMNG' '订货数量' '' '',
'RSNUM' '预留编号' '' '',
'RSPOS' '预定的项目编号' '' '',
*'XLOEK' '项目被删除' '' '',
*'XWAOK' '许可的移动' '' '',
*'KZEAR' '最后发货' '' '',
*'POSTP' '生产订单行类别' '' '',
'POSNR' '生产订单行项目号' '' '',
'MATNR' '组件料号' '' '',
'MAKTX' '组件描述' '' '',
'LGORT' '库存地点' '' '',
'SOBKZ' '特殊库存' '' '',
'BDTER' '需求日期' '' '',
'BDMNG' '需求量' '' '',
'MEINS' '单位' '' '',
'CLABS' '非限制库存数' '' '',
'ENMNG' '提货数（已领数）' '' '',
'WLL' '未领数' '' ''.
*'RGEKZ' '反冲' '' ''.
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
    WHEN '&SELALL'.
      PERFORM FRM_SEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN '&DELSAL'.
      PERFORM FRM_DEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FRM_SEL_ALLDATA
*&---------------------------------------------------------------------*
*& 自定义全选按钮
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SEL_ALLDATA .
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB>.
    <FS_ITAB>-FLAG = 'X'.
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
  LOOP AT GT_ITAB ASSIGNING <FS_ITAB>.
    <FS_ITAB>-FLAG = ' '.
  ENDLOOP.
ENDFORM.


*********************************************情况二生产退料
FORM FRM_DISPLAY_DATA02.
  PERFORM FRM_SET_LAYOUT02.
  PERFORM FRM_SET_FIELDCAT02.
  PERFORM FRM_DISPLAY_ALV02.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_LAYOUT02.
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
FORM FRM_SET_FIELDCAT02.

  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-FIELDNAME = 'FLAG'.
  GS_FIELDCAT-REPTEXT = '请选择'.
  GS_FIELDCAT-CHECKBOX  = 'X'.
  GS_FIELDCAT-EDIT      = 'X'.

*  gs_fieldcat-col_pos      = 1.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

  PERFORM FRM_CREATE_FIELDS02 USING:
'DWERK' '工厂'  '' '',
'NAME1' '工厂描述' '' '',
'AUFNR' '生产订单号' '' '',
'DAUAT' '订单类型' '' '',
'ISTAT' '生产订单状态' '' '',
'PSMNG' '订单总数量' '' '',
'DISPO' 'MRP控制者' '' '',
'FEVOR' '生产管理员' '' '',
'PLNBEZ' '产品编号' '' '',
'MAKTX' '产品描述' '' '',
'GLTRP' '基本完成日期' '' '',
'GSTRP' '基本开始日期' '' '',
'FTRMS' '计划开始日期' '' '',
'GLTRS' '计划完成日期' '' '',
'FTRMI' '实际下达日期' '' '',
'GSTRI' '实际开始日期' '' '',
'GETRI' '实际结束日期' '' '',
'PSOBS' '产品特殊库存标识' '' '',
'PLNUM' '计划订单' '' '',
'KDAUF' '销售订单' '' '',
'KDPOS' '销售订单行项目' '' '',
'WEMNG' '收货数量' '' '',
'AMEIN' '订单单位' '' '',
'MEINS' '基本单位' '' '',
'PAMNG' '报废数量' '' '',
'PGMNG' '订货数量' '' '',
'RSNUM' '预留编号' '' '',
'RSPOS' '预定的项目编号' '' '',
*'XLOEK' '项目被删除' '' '',
*'XWAOK' '许可的移动' '' '',
*'KZEAR' '最后发货' '' '',
*'POSTP' '生产订单行类别' '' '',
'POSNR' '生产订单行项目号' '' '',
'MATNR' '组件料号' '' '',
'MAKTX' '组件描述' '' '',
'LGORT' '库存地点' '' '',
'SOBKZ' '特殊库存' '' '',
'BDTER' '需求日期' '' '',
'BDMNG' '需求量' '' '',
'MEINS' '单位' '' '',
'CLABS' '非限制库存数' '' '',
'ENMNG' '提货数（已领数）' '' '',
'WLL' '未领数' '' ''.
*'RGEKZ' '反冲' '' ''.
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
FORM FRM_DISPLAY_ALV02.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      IS_LAYOUT_LVC            = GS_LAYOUT
      IT_FIELDCAT_LVC          = GT_FIELDCAT
      IT_EVENTS                = GT_EVENTS
      I_SAVE                   = 'A'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND02'
      I_CALLBACK_PF_STATUS_SET = 'SET_PF_STATUS02'
    TABLES
      T_OUTTAB                 = GT_ITAB.

  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.

FORM SET_PF_STATUS02 USING PT_EXCLUDE TYPE KKBLO_T_EXTAB.


  DATA:LT_EXCLUDE TYPE KKBLO_T_EXTAB WITH HEADER LINE.

  SET PF-STATUS 'STANDARD02' EXCLUDING LT_EXCLUDE[].

ENDFORM.
FORM FRM_CREATE_FIELDS02 USING PV_FIELDNAME PV_REPTEXT PV_ZERO PV_OUT.
  INSERT VALUE #(
  FIELDNAME = PV_FIELDNAME
  REPTEXT   = PV_REPTEXT
  NO_ZERO   = PV_ZERO
  NO_OUT    = PV_OUT
  )
  INTO TABLE GT_FIELDCAT.
ENDFORM.

*------自定义按钮
FORM USER_COMMAND02 USING R_UCOMM TYPE SY-UCOMM
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
    WHEN 'PRINT02'.
      PERFORM FRM_PRINTSAMRT.
    WHEN '&SELALL'.
      PERFORM FRM_SEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN '&DELSAL'.
      PERFORM FRM_DEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*********************************************情况三超领
FORM FRM_DISPLAY_DATA03.
  PERFORM FRM_SET_LAYOUT03.
  PERFORM FRM_SET_FIELDCAT03.
  PERFORM FRM_DISPLAY_ALV03.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_LAYOUT03.
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
FORM FRM_SET_FIELDCAT03.

  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-FIELDNAME = 'FLAG'.
  GS_FIELDCAT-REPTEXT = '请选择'.
  GS_FIELDCAT-CHECKBOX  = 'X'.
  GS_FIELDCAT-EDIT      = 'X'.

*  gs_fieldcat-col_pos      = 1.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

  PERFORM FRM_CREATE_FIELDS03 USING:
'DWERK' '工厂'  '' '',
'NAME1' '工厂描述' '' '',
'AUFNR' '生产订单号' '' '',
'DAUAT' '订单类型' '' '',
'ISTAT' '生产订单状态' '' '',
'PSMNG' '订单总数量' '' '',
'DISPO' 'MRP控制者' '' '',
'FEVOR' '生产管理员' '' '',
'PLNBEZ' '产品编号' '' '',
'MAKTX' '产品描述' '' '',
'GLTRP' '基本完成日期' '' '',
'GSTRP' '基本开始日期' '' '',
'FTRMS' '计划开始日期' '' '',
'GLTRS' '计划完成日期' '' '',
'FTRMI' '实际下达日期' '' '',
'GSTRI' '实际开始日期' '' '',
'GETRI' '实际结束日期' '' '',
'PSOBS' '产品特殊库存标识' '' '',
'PLNUM' '计划订单' '' '',
'KDAUF' '销售订单' '' '',
'KDPOS' '销售订单行项目' '' '',
'WEMNG' '收货数量' '' '',
'AMEIN' '订单单位' '' '',
'MEINS' '基本单位' '' '',
'PAMNG' '报废数量' '' '',
'PGMNG' '订货数量' '' '',
'RSNUM' '预留编号' '' '',
'RSPOS' '预定的项目编号' '' '',
*'XLOEK' '项目被删除' '' '',
*'XWAOK' '许可的移动' '' '',
*'KZEAR' '最后发货' '' '',
*'POSTP' '生产订单行类别' '' '',
'POSNR' '生产订单行项目号' '' '',
'MATNR' '组件料号' '' '',
'MAKTX' '组件描述' '' '',
'LGORT' '库存地点' '' '',
'SOBKZ' '特殊库存' '' '',
'BDTER' '需求日期' '' '',
'BDMNG' '需求量' '' '',
'MEINS' '单位' '' '',
'CLABS' '非限制库存数' '' '',
'ENMNG' '提货数（已领数）' '' '',
'WLL' '未领数' '' ''.
*'RGEKZ' '反冲' '' ''.
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
FORM FRM_DISPLAY_ALV03.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      IS_LAYOUT_LVC            = GS_LAYOUT
      IT_FIELDCAT_LVC          = GT_FIELDCAT
      IT_EVENTS                = GT_EVENTS
      I_SAVE                   = 'A'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND03'
      I_CALLBACK_PF_STATUS_SET = 'SET_PF_STATUS03'
    TABLES
      T_OUTTAB                 = GT_ITAB.

  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.

FORM SET_PF_STATUS03 USING PT_EXCLUDE TYPE KKBLO_T_EXTAB.


  DATA:LT_EXCLUDE TYPE KKBLO_T_EXTAB WITH HEADER LINE.

  SET PF-STATUS 'STANDARD03' EXCLUDING LT_EXCLUDE[].

ENDFORM.
FORM FRM_CREATE_FIELDS03 USING PV_FIELDNAME PV_REPTEXT PV_ZERO PV_OUT.
  INSERT VALUE #(
  FIELDNAME = PV_FIELDNAME
  REPTEXT   = PV_REPTEXT
  NO_ZERO   = PV_ZERO
  NO_OUT    = PV_OUT
  )
  INTO TABLE GT_FIELDCAT.
ENDFORM.

*------自定义按钮
FORM USER_COMMAND03 USING R_UCOMM TYPE SY-UCOMM
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
    WHEN 'PRINT03'.
      PERFORM FRM_PRINTSAMRT.
    WHEN '&SELALL'.
      PERFORM FRM_SEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN '&DELSAL'.
      PERFORM FRM_DEL_ALLDATA.
      RS_SELFIELD-REFRESH = 'X'.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.


********************************************情况四超退

FORM FRM_DISPLAY_DATA04.
  PERFORM FRM_SET_LAYOUT04.
  PERFORM FRM_SET_FIELDCAT04.
  PERFORM FRM_DISPLAY_ALV04.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FRM_SET_LAYOUT04.
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
FORM FRM_SET_FIELDCAT04.

  CLEAR GS_FIELDCAT.

  GS_FIELDCAT-FIELDNAME = 'FLAG'.
  GS_FIELDCAT-REPTEXT = '请选择'.
  GS_FIELDCAT-CHECKBOX  = 'X'.
  GS_FIELDCAT-EDIT      = 'X'.

*  gs_fieldcat-col_pos      = 1.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

  PERFORM FRM_CREATE_FIELDS04 USING:
'DWERK' '工厂'  '' '',
'NAME1' '工厂描述' '' '',
'AUFNR' '生产订单号' '' '',
'DAUAT' '订单类型' '' '',
'ISTAT' '生产订单状态' '' '',
'PSMNG' '订单总数量' '' '',
'DISPO' 'MRP控制者' '' '',
'FEVOR' '生产管理员' '' '',
'PLNBEZ' '产品编号' '' '',
'MAKTX' '产品描述' '' '',
'GLTRP' '基本完成日期' '' '',
'GSTRP' '基本开始日期' '' '',
'FTRMS' '计划开始日期' '' '',
'GLTRS' '计划完成日期' '' '',
'FTRMI' '实际下达日期' '' '',
'GSTRI' '实际开始日期' '' '',
'GETRI' '实际结束日期' '' '',
'PSOBS' '产品特殊库存标识' '' '',
'PLNUM' '计划订单' '' '',
'KDAUF' '销售订单' '' '',
'KDPOS' '销售订单行项目' '' '',
'WEMNG' '收货数量' '' '',
'AMEIN' '订单单位' '' '',
'MEINS' '基本单位' '' '',
'PAMNG' '报废数量' '' '',
'PGMNG' '订货数量' '' '',
'RSNUM' '预留编号' '' '',
'RSPOS' '预定的项目编号' '' '',
*'XLOEK' '项目被删除' '' '',
*'XWAOK' '许可的移动' '' '',
*'KZEAR' '最后发货' '' '',
*'POSTP' '生产订单行类别' '' '',
'POSNR' '生产订单行项目号' '' '',
'MATNR' '组件料号' '' '',
'MAKTX' '组件描述' '' '',
'LGORT' '库存地点' '' '',
'SOBKZ' '特殊库存' '' '',
'BDTER' '需求日期' '' '',
'BDMNG' '需求量' '' '',
'MEINS' '单位' '' '',
'CLABS' '非限制库存数' '' '',
'ENMNG' '提货数（已领数）' '' '',
'WLL' '未领数' '' ''.
*'RGEKZ' '反冲' '' ''.
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
FORM FRM_DISPLAY_ALV04.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      IS_LAYOUT_LVC            = GS_LAYOUT
      IT_FIELDCAT_LVC          = GT_FIELDCAT
      IT_EVENTS                = GT_EVENTS
      I_SAVE                   = 'A'
      I_CALLBACK_USER_COMMAND  = 'USER_COMMAND04'
      I_CALLBACK_PF_STATUS_SET = 'SET_PF_STATUS04'
    TABLES
      T_OUTTAB                 = GT_ITAB.

  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.

FORM SET_PF_STATUS04 USING PT_EXCLUDE TYPE KKBLO_T_EXTAB.


  DATA:LT_EXCLUDE TYPE KKBLO_T_EXTAB WITH HEADER LINE.

  SET PF-STATUS 'STANDARD04' EXCLUDING LT_EXCLUDE[].

ENDFORM.
FORM FRM_CREATE_FIELDS04 USING PV_FIELDNAME PV_REPTEXT PV_ZERO PV_OUT.
  INSERT VALUE #(
  FIELDNAME = PV_FIELDNAME
  REPTEXT   = PV_REPTEXT
  NO_ZERO   = PV_ZERO
  NO_OUT    = PV_OUT
  )
  INTO TABLE GT_FIELDCAT.
ENDFORM.

*------自定义按钮
FORM USER_COMMAND04 USING R_UCOMM TYPE SY-UCOMM
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
    WHEN 'PRINT04'.
      PERFORM FRM_PRINTSAMRT.
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
        WITH KEY AUFNR = GS_CHECKBOX-AUFNR
        LGORT = GS_CHECKBOX-LGORT.
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
   USING LS_SMART TYPE ZPPS_003.

*最终打印的所有行项目的合计
  DATA: LV_ITEMSUM TYPE I VALUE 0,
        LV_NO      TYPE I VALUE 0.

*获取alv上同一个生产订单号的所有行项目
  CLEAR: GS_FORM,GT_FORM.

  LOOP AT GT_ITAB INTO GS_ITAB WHERE AUFNR = LS_SMART-AUFNR AND LGORT = LS_SMART-LGORT.

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
  TABLES LT_RESULT STRUCTURE ZPPS_003
  USING LS_SMART TYPE ZPPS_003
        LV_SUM TYPE I.

*  LOOP AT LT_SMARTFORMS INTO LS_SMARTFORMS.
*    CLEAR LT_SMARTRESULT.
*    APPEND LS_SMARTFORMS TO LT_SMARTRESULT.
*    ENDLOOP.
**************************************
  ""计算总行数以便算出改补的行数
*      DESCRIBE TABLE LT_SMARTFORMS LINES COUNT.
*  DESCRIBE TABLE LT_RESULT LINES COUNT.
  "*
*根据勾选打印的情况来判断
  IF P_BWART = 1.
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
  ELSEIF P_BWART = 2.
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
