*&---------------------------------------------------------------------*
*& Include ZPPB001_TOP2
*&---------------------------------------------------------------------*


DATA: BEGIN OF STB OCCURS 1000.
    INCLUDE STRUCTURE STPOX.
DATA:TMATNR LIKE MARA-MATNR.
DATA: END OF STB.



DATA: BEGIN OF STB1 OCCURS 1000.
    INCLUDE STRUCTURE STPOX.
DATA:TMATNR LIKE MARA-MATNR.
DATA: END OF STB1.



DATA: BEGIN OF TOPMAT.
    INCLUDE STRUCTURE CSTMAT.
DATA: END OF TOPMAT.


DATA: BEGIN OF MATCAT OCCURS 50.
    INCLUDE STRUCTURE CSCMAT.
DATA: END OF MATCAT.


DATA:IT_MAKT LIKE MAKT OCCURS 0 WITH HEADER LINE.
DATA:IT_MBEW LIKE MBEW OCCURS 0 WITH HEADER LINE.

DATA: BEGIN OF ITAB OCCURS 0,
        MATNR LIKE MARA-MATNR,       "物料编码
        MATKL LIKE MARA-MATKL,       "物料组
        PRCTR LIKE MARC-PRCTR,       "利润中心
        WERKS LIKE MARC-WERKS,       "工厂
        VBELN LIKE VBAP-VBELN,
        POSNR LIKE VBAP-POSNR,
        STLAL LIKE MAST-STLAL,
        STLAN LIKE MAST-STLAN,
      END OF ITAB.


DATA: BEGIN OF ITAB1 OCCURS 0,
        WERKS(4)   TYPE C,                 "工厂
        MATNR(18)  TYPE C,                 "物料编码
        TMATNR(18) TYPE C,                 "父层物料编码
        OJTXB(40)  TYPE C,                 "成品或半成品的物料描述
        EMMBM      TYPE EMMBM,             "BOM需求数量
        BMEIN      TYPE BASME,             "BOM基本单位
        STLAL      TYPE STKO-STLAL,        "可选的BOM
        STLAN      TYPE MAST-STLAN,        "BOM用途
        STUFE      TYPE C,                 "层次（在多层 BOM 展开中）
        POSNR(6)   TYPE C,                 "BOM 项目号
        POSTP(1)   TYPE C,                 "项目类别
        IDNRK(40)  TYPE C,                 "BOM 组件
        MENGE      TYPE P DECIMALS 3,      "以基本计量单位为准的已计算的组件数量
        MMEIN      TYPE  MEINS,            "单位
        OJTXP(40)  TYPE C,                 "对象描述（项目）
        MAKTX      TYPE MAKT-MAKTX,        "物料描述
        BESKZ      TYPE MARC-BESKZ,        "采购类型
        POTX1      TYPE C,                 "BOM文本描述
        LGORT      TYPE STPOX-LGORT,       "生产仓储地点
        ITSOB      TYPE STPO-ITSOB,        "特殊获取
        SANKA      TYPE STPO-SANKA,        "成本核算标识相关
        RGEKZ      TYPE STPOX-RGEKZ,       "返冲
        COST       TYPE MBEW-STPRS,        "成本价
        PEINH      TYPE MBEW-PEINH,        "成本价格单位
*注销   byWUCL  2019.09.17
*        PR00       TYPE P DECIMALS 2,      "代理价
        ANDAT      TYPE ANDAT,             "创建日期
        ANNAM      TYPE ANNAM,             "创建者

      END OF ITAB1.

DATA: MATNR1 LIKE MARA-MATNR.

DATA: ALV_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      ALV_LAYOUT   TYPE SLIS_LAYOUT_ALV.

DATA:P_MATNR LIKE MAKT-MATNR.


DATA TMATNR(18) TYPE C.

DATA PM_MEHRS TYPE CSDATA-XFELD. "层次
*注销   byWUCL  2019.09.17
*DATA E_PR00 TYPE CHAR20.
DATA I_MATNR(40) TYPE C.
