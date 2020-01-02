*&---------------------------------------------------------------------*
*& Include ZPPB001_TOP1
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF typ_file,
    COL01 TYPE CHAR200,       "删除标识
    col02 TYPE char200,          "工厂
    col03 TYPE char200,          "SAP料号
    col04 TYPE char200,          "物料描述
    col05 TYPE char200,          "单位
    col06 TYPE char200,          "可选的BOM
    col07 TYPE char200,          "基本数量
    col08 TYPE char200,          "组件物料序号
    col09 TYPE char200,          "项目类别
    col10 TYPE char200,          "组件物料料号
    col11 TYPE char200,          "组件物料描述
    col12 TYPE char200,          "组件物料用量
    col13 TYPE char200,          "组件物料单位
    col14 TYPE char200,          "损耗率
    col15 TYPE char200,          "返冲仓库
  END OF typ_file,

*导入数据

  BEGIN OF typ_data_in,
    werks      TYPE mast-werks,               "工厂
    matnr      TYPE mast-matnr,               "SAP料号
    maktx      TYPE makt-maktx,               "描述
    stlan      TYPE mast-stlan,               "BOM用途
    stlal      TYPE mast-stlal,               "可选的bom
    bmeng      TYPE stko-bmeng,               "基本数量
    bmein      TYPE stko-bmein,               "基本数量单位
    bom_status TYPE stko_api01-bom_status,    "BOM状态
    posnr      TYPE stpo-posnr,               "组件物料序号
    postp      TYPE stpo-postp,               "项目类别
    idnrk      TYPE stpo-idnrk,               "组件物料料号
    maktx2     TYPE makt-maktx,               "组件物料描述
    menge      TYPE stpo-menge,               "组件物料用量
    meins      TYPE stpo-meins,               "组件物料单位
    ausch      TYPE stpo-ausch,               "损耗率
    lgort      TYPE stpo-lgort,               "返冲仓库
    sanka      TYPE stpo-sanka,               "与成本核算相关项目
    flg_del    TYPE char1,                        "删除标记
  END OF typ_data_in,



* alv显示

  BEGIN OF typ_alv,
    werks   TYPE csap_mbom-werks,           "工厂
    matnr   TYPE csap_mbom-matnr,           "主件物料(母件）
    stlan   TYPE csap_mbom-stlan,           "BOM用途
    stlal   TYPE csap_mbom-stlal,           "可选的 BOM
    message TYPE char255,                   "信息
    icon_id TYPE icon-id,                   "图标
  END OF typ_alv,


* excel表头

  BEGIN OF typ_fieldnames,
    name TYPE char10,                    "标题名称
  END OF typ_fieldnames,


* BOM 链接物料

  BEGIN OF
    typ_mast,
    matnr TYPE mast-matnr,                "物料编号
    werks TYPE mast-werks,                "工厂
    stlan TYPE mast-stlan,                "BOM 用途
    stlal TYPE mast-stlal,                "可选的 BOM
  END OF typ_mast.



DATA:
  gt_file     TYPE TABLE OF typ_file,         "excle文件
  gt_data_in  TYPE TABLE OF typ_data_in,      "导入数据
  gt_alv      TYPE TABLE OF typ_alv.          "alv信息

DATA: gt_dynfields TYPE TABLE OF dynpread.
DATA: gs_dynfields TYPE dynpread.

DATA: zline_in TYPE i.

DATA: R_WERKS   TYPE RANGE OF T001W-WERKS WITH HEADER LINE.
