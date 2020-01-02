*&---------------------------------------------------------------------*
*& Report ZPPB001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPPB001.



TABLES:
  SSCRFIELDS,"选择屏幕-新增按钮
  CSAP_MBOM,
  MAST,
  MAKT,
  MARC,
  STKO,
  STPO,
  VBAP,
  STZU,
  MARA,
  MBEW.
TYPE-POOLS: SLIS.

INCLUDE ZPPB001_TOP1.

INCLUDE ZPPB001_TOP2.

INCLUDE ZPPB001_SCREEN.

INCLUDE ZPPB001_FORM.

SELECTION-SCREEN: FUNCTION KEY 1, "激活下载创建修改模板按钮
                  FUNCTION KEY 2,  "激活下载修改模板按钮
                  FUNCTION KEY 3.  "激活下载删除模板按钮

*屏幕
INITIALIZATION.
*状态栏按钮显示的文本
  SSCRFIELDS-FUNCTXT_01 = '下载导入模板'.
  SSCRFIELDS-FUNCTXT_02 = '下载修改模板'.
  SSCRFIELDS-FUNCTXT_03 = '下载删除模板'.


AT SELECTION-SCREEN.
  CASE SSCRFIELDS-UCOMM.
    WHEN 'FC01'.         "下载BOM导入模板
      PERFORM FRM_DOWNLOAD_TEMPLATE.
    WHEN 'FC02'.         "下载BOM修改模板
      PERFORM FRM_DOWNLOAD_TEMPLATE3.
    WHEN 'FC03'.         "下载BOM删除模板
      PERFORM FRM_DOWNLOAD_TEMPLATE2.
    WHEN OTHERS.
  ENDCASE.


  CASE SY-UCOMM.
    WHEN 'ONLI'.
*数据导入勾选的情况
      IF RB_IN = 'X'.
        CASE  'X'.
          WHEN RB_INS.
*权限检查
            AUTHORITY-CHECK OBJECT 'Z_TCODE'
            ID 'TCD' FIELD SY-TCODE     "ABAP 系统字段：当前事务代码
            ID 'ACTVT' FIELD '01'.
            IF SY-SUBRC <>   0.
              MESSAGE E001(00) WITH '没有事物代码' SY-TCODE '的创建权限'.
            ENDIF.
          WHEN RB_UPD.
            AUTHORITY-CHECK OBJECT 'Z_TCODE'
            ID 'TCD' FIELD SY-TCODE
            ID 'ACTVT' FIELD '01'.
            IF SY-SUBRC <> 0.
              MESSAGE E001(00) WITH '没有事物代码' SY-TCODE '的修改权限'.
            ENDIF.
          WHEN RB_DEL .
            AUTHORITY-CHECK OBJECT 'Z_TCODE'
             ID 'TCD' FIELD SY-TCODE
             ID 'ACTVT' FIELD '06'.
            IF SY-SUBRC <> 0.
              MESSAGE E001(00) WITH '没有事物代码' SY-TCODE '的删除权限'.
            ENDIF.
        ENDCASE.
*数据导出勾选的情况
      ELSEIF RB_OUT = 'X'.
        AUTHORITY-CHECK OBJECT 'Z_TCODE'
                    ID 'TCD' FIELD SY-TCODE
                    ID 'ACTVT' FIELD '03'.
        IF SY-SUBRC <> 0.
          MESSAGE E001(00) WITH '没有事物代码' SY-TCODE '的显示权限'.
        ELSE.
          CLEAR:R_WERKS,R_WERKS[].
          SELECT WERKS AS LOW
            FROM T001W
            INTO CORRESPONDING FIELDS OF TABLE R_WERKS
           WHERE WERKS IN S_WERKS.

          IF R_WERKS[] IS INITIAL.
            MESSAGE E001(00) WITH '工厂不存在'.
          ELSE.
            LOOP AT R_WERKS.
              AUTHORITY-CHECK OBJECT 'C_STUE_WRK'
                ID 'ACTVT' FIELD '03'
                ID 'CSWRK' FIELD R_WERKS-LOW.
              IF SY-SUBRC <> 0.
                DELETE R_WERKS.
                CONTINUE.
              ELSE.
                R_WERKS-SIGN = 'I'.
                R_WERKS-OPTION = 'EQ'.
                R_WERKS-HIGH = ''.
                MODIFY R_WERKS.
              ENDIF.
            ENDLOOP.
            IF R_WERKS[] IS INITIAL.
              MESSAGE E001(00) WITH '您没有相关工厂的权限'.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.
  ENDCASE.



AT SELECTION-SCREEN OUTPUT.
  PERFORM FRM_MODIFY_SCREEN.


  AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_UFILE.
*使用TXT格式导入
IF RB_TXT = 'X'.

PERFORM FRM_F4_FILE USING P_UFILE
                            CL_GUI_FRONTEND_SERVICES=>FILETYPE_TEXT.

 ELSE .

  PERFORM GET_FILEPATH CHANGING P_UFILE.

ENDIF.




START-OF-SELECTION.
***************************************
*数据导入勾选的情况
  IF RB_IN = 'X'.
*删除BOM勾选的情况
    IF RB_DEL IS NOT INITIAL.
      DATA: LV_ANSWER TYPE C.
*（弹出框函数）'删除确认
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR       = '删除确认'
          TEXT_QUESTION  = '请确认删除操作！'
          DEFAULT_BUTTON = '2'
        IMPORTING
          ANSWER         = LV_ANSWER
*     TABLES
*         PARAMETER      =
        EXCEPTIONS
          TEXT_NOT_FOUND = 1
          OTHERS         = 2.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      CASE LV_ANSWER.
        WHEN '1'.  "save change
        WHEN '2'.  "exit without
          LEAVE LIST-PROCESSING.
        WHEN 'A'.  "cancel -  no action
          LEAVE LIST-PROCESSING.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

*   导入数据的取得
    PERFORM FRM_GET_DATA_IN.
*   BAPI执行
    PERFORM FRM_BAPI_BOM.
*   展示alv信息
    PERFORM FRM_ALV_OUTPUT.

*  导出数据
  ELSE.
*  导出数据的取得
    PERFORM FRM_GET_DATA_OUT.
*  ALV 展示
    PERFORM FRM_EXCEL_OUTPUT.
  ENDIF.


FORM FRM_TOP_OF_PAGE USING CL_DD TYPE REF TO CL_DD_DOCUMENT.
  DATA: M_P    TYPE I.
  DATA: M_BUFF TYPE STRING,
        M_LINE TYPE STRING.

  M_BUFF = '<html>'.

  CALL METHOD CL_DD->HTML_INSERT
    EXPORTING
      CONTENTS = M_BUFF
    CHANGING
      POSITION = M_P.

  DATA: L_STR  TYPE STRING.

  M_LINE = ZLINE_IN.

  CASE 'X'.
    WHEN RB_INS.   "创建BOM
      CONCATENATE '<LEFT>◆ 共成功创建：' M_LINE ' 条BOM</LEFT>' INTO L_STR  .
    WHEN RB_UPD.   "修改删除BOM行项目
      CONCATENATE '<LEFT>◆ 共修改成功：' M_LINE ' 条BOM</LEFT>' INTO L_STR  .
    WHEN RB_DEL.   "删除BOM
      CONCATENATE '<LEFT>◆ 共成功删除：' M_LINE ' 条BOM</LEFT>' INTO L_STR  .
    WHEN OTHERS.
  ENDCASE.

  M_BUFF = L_STR.
  CALL METHOD CL_DD->HTML_INSERT
    EXPORTING
      CONTENTS = M_BUFF
    CHANGING
      POSITION = M_P.

ENDFORM.
