REPORT ztrcktrsr_editable_alv_fcontrl.

PARAMETERS p.

CLASS main1 DEFINITION.
  PUBLIC SECTION.
    METHODS set_container IMPORTING cont TYPE REF TO cl_gui_container.
    METHODS display.
  PRIVATE SECTION.
    DATA grid TYPE REF TO cl_gui_alv_grid.
    DATA cont TYPE REF TO cl_gui_container.
    TYPES: BEGIN OF _qr_line,
             result TYPE c LENGTH 3,
             reason TYPE c LENGTH 40,
           END OF _qr_line,
           _qr_data TYPE STANDARD TABLE OF _qr_line WITH DEFAULT KEY.
    DATA data TYPE _qr_data.

    METHODS on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
    METHODS get_fcat RETURNING VALUE(fcat) TYPE lvc_t_fcat.
ENDCLASS.

CLASS main1 IMPLEMENTATION.
  METHOD set_container.
    me->cont = cont.
  ENDMETHOD.

  METHOD on_data_changed.
    LOOP AT er_data_changed->mt_good_cells INTO DATA(good_cell).
      CASE good_cell-fieldname.
        WHEN 'RESULT'.
          CASE good_cell-value.
            WHEN 'OK'.
              DATA(field_reason_edit) = abap_false.
            WHEN OTHERS.
              field_reason_edit = abap_true.
          ENDCASE.
      ENDCASE.
    ENDLOOP.
    grid->get_frontend_fieldcatalog(
      IMPORTING
        et_fieldcatalog = DATA(fcat) ).
    IF NOT fcat[ fieldname = 'REASON' ]-edit = field_reason_edit.
      fcat[ fieldname = 'REASON' ]-edit = field_reason_edit.
      grid->set_frontend_fieldcatalog( fcat ).
      grid->refresh_table_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD display.


    IF grid IS BOUND.
      grid->refresh_table_display( ).
    ELSE.

      DATA(fcat) = get_fcat( ).

      grid = NEW #( i_parent = cont ).
      APPEND INITIAL LINE TO data.

      DATA(dropdown) = VALUE lvc_t_dral( handle = 1
           ( value = 'Not Okay' int_value = 'NOK' )
           ( value = 'Okay'     int_value = 'OK' ) ).

      grid->set_drop_down_table( it_drop_down_alias = dropdown ).
      grid->set_table_for_first_display(
        EXPORTING
          is_layout                     = VALUE #( edit_mode = 'X' no_toolbar = abap_true no_rowmark = abap_true )
        CHANGING
          it_outtab                     = data
          it_fieldcatalog               = fcat
        EXCEPTIONS
          OTHERS                        = 4  ).
      IF sy-subrc = 0.
        grid->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
        grid->set_ready_for_input( 1 ).
        SET HANDLER on_data_changed FOR grid.

        cl_gui_container=>set_focus( grid ).
      ELSE.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_fcat.
    fcat = VALUE #(
     ( fieldname = 'RESULT' outputlen = 10 rollname = 'CHAR03' edit = 'X' coltext = 'Result' drdn_hndl = 1 drdn_alias = abap_true )
     ( fieldname = 'REASON' outputlen = 40 rollname = 'CHAR40' edit = 'X' coltext = 'Reason' ) ).

  ENDMETHOD.

ENDCLASS.
CLASS main2 DEFINITION.
  PUBLIC SECTION.
    METHODS set_container IMPORTING cont TYPE REF TO cl_gui_container.
    METHODS display.
  PRIVATE SECTION.
    DATA grid TYPE REF TO cl_gui_alv_grid.
    DATA cont TYPE REF TO cl_gui_container.
    TYPES: BEGIN OF _qr_line,
             result TYPE c LENGTH 3,
             reason TYPE c LENGTH 40,
           END OF _qr_line,
           _qr_data TYPE STANDARD TABLE OF _qr_line WITH DEFAULT KEY.
    DATA data TYPE _qr_data.

    METHODS on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
    METHODS get_fcat RETURNING VALUE(fcat) TYPE lvc_t_fcat.
ENDCLASS.

CLASS main2 IMPLEMENTATION.
  METHOD set_container.
    me->cont = cont.
  ENDMETHOD.

  METHOD on_data_changed.
    LOOP AT er_data_changed->mt_good_cells INTO DATA(good_cell).
      CASE good_cell-fieldname.
        WHEN 'RESULT'.
          CASE to_upper( good_cell-value ).
            WHEN 'OK'.
              DATA(field_reason_edit) = abap_false.
            WHEN OTHERS.
              field_reason_edit = abap_true.
          ENDCASE.
      ENDCASE.
    ENDLOOP.
    grid->get_frontend_fieldcatalog(
      IMPORTING
        et_fieldcatalog = DATA(fcat) ).
    IF NOT fcat[ fieldname = 'REASON' ]-edit = field_reason_edit.
      fcat[ fieldname = 'REASON' ]-edit = field_reason_edit.
      grid->set_frontend_fieldcatalog( fcat ).
      grid->refresh_table_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD display.


    IF grid IS BOUND.
      grid->refresh_table_display( ).
    ELSE.

      DATA(fcat) = get_fcat( ).

      grid = NEW #( i_parent = cont ).
      APPEND INITIAL LINE TO data.

      grid->set_table_for_first_display(
        EXPORTING
          is_layout                     = VALUE #( edit_mode = 'X' no_toolbar = abap_true no_rowmark = abap_true )
        CHANGING
          it_outtab                     = data
          it_fieldcatalog               = fcat
        EXCEPTIONS
          OTHERS                        = 4  ).
      IF sy-subrc = 0.
        grid->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
        grid->set_ready_for_input( 1 ).
        SET HANDLER on_data_changed FOR grid.

        cl_gui_container=>set_focus( grid ).
      ELSE.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_fcat.
    fcat = VALUE #(
     ( fieldname = 'RESULT' outputlen = 10 rollname = 'CHAR03' edit = 'X' coltext = 'Result' )
     ( fieldname = 'REASON' outputlen = 40 rollname = 'CHAR40' edit = 'X' coltext = 'Reason' ) ).

  ENDMETHOD.

ENDCLASS.

INITIALIZATION.
  DATA(docker2) = NEW cl_gui_docking_container( ratio = 80 side = cl_gui_docking_container=>dock_at_bottom ).
  DATA(docker1) = NEW cl_gui_docking_container( ratio = 10 side = cl_gui_docking_container=>dock_at_bottom ).

  DATA(app1) = NEW main1( ).
  app1->set_container( docker1 ).
  app1->display( ).

  DATA(app2) = NEW main2( ).
  app2->set_container( docker2 ).
  app2->display( ).
