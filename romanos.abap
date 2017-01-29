*&---------------------------------------------------------------------*
*& Report y_romano
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report y_romano.

class local_class definition create public.

  public section.


    types:
      begin of ty_referencia,
        arabico  type numc10,
        numero   type char1,
        anterior type char1,
        proximo  type char1,
      end of ty_referencia,

      begin of ty_out,
        arabico type numc10,
        romano  type char20,
      end of ty_out,

      out_t type table of ty_out.

    class-data:
      referencia type table of ty_referencia  .

    methods constructor .

    methods romanos
      importing
        !arabico      type num10
      returning
        value(romano) type char20 .

    methods exibir
      changing
        !out type out_t .

  protected section.


  private section.

    methods unidades
      importing
        !arabico type num10
      exporting
        !romano  type char20 .

    methods converter
      importing
        !arabico  type num10
        !superior type numc10
      exporting
        !romano   type char20 .

    methods set4
      importing
        !velho type char1
      exporting
        !novo  type char2 .

    methods set0
      importing
        !velho type char1
      exporting
        !novo  type char2 .

endclass.

class local_class implementation.

  method constructor .

*    referencia =
*      value #(
*        ( numero = 'I' anterior = ''  proximo = 'V' ) " 1
*        ( numero = 'V' anterior = 'I' proximo = 'X' ) " 5
*        ( numero = 'X' anterior = 'V' proximo = 'L' ) " 10
*        ( numero = 'L' anterior = 'X' proximo = 'C' ) " 50
*        ( numero = 'C' anterior = 'L' proximo = 'C' ) " 100
*        ( numero = 'D' anterior = 'C' proximo = 'M' ) " 500
*        ( numero = 'M' anterior = 'D' proximo = '?' ) " 1000
*      ).
    referencia =
      value #(
        ( arabico = 1     numero = 'I' anterior = ''  proximo = 'V' )
        ( arabico = 5     numero = 'V' anterior = 'I' proximo = 'X' )
        ( arabico = 10    numero = 'X' anterior = 'V' proximo = 'L' )
        ( arabico = 50    numero = 'L' anterior = 'X' proximo = 'C' )
        ( arabico = 100   numero = 'C' anterior = 'L' proximo = 'C' )
        ( arabico = 500   numero = 'D' anterior = 'C' proximo = 'M' )
        ( arabico = 1000  numero = 'M' anterior = 'D' proximo = '?' )
      ) .


  endmethod.

  method romanos.

    data:
      unidades type char20,
      dezenas  type char20,
      centenas type char20.

    clear romano .

    data:
      saldo_divisao type numc10,
      superior      type numc10.

    do .

      data(controle) = 10 ** sy-index .


      data(divisao) = arabico div controle .
      saldo_divisao = arabico mod controle .

      superior = controle / 10 .

*      case sy-index.
*
*        when 1 .
*
*          me->converter(
*            exporting
*              arabico  = saldo_divisao
*              superior = 1
*            importing
*              romano   = unidades
*          ).
*
*        when 2 .
*
*          me->converter(
*            exporting
*              arabico  = saldo_divisao
*              superior = 10
*            importing
*              romano   = dezenas
*          ).
*
*        when 3 .
*
*          me->converter(
*            exporting
*              arabico  = saldo_divisao
*              superior = 100
*            importing
*              romano   = centenas
*          ).
*
*        when 3 .
*
*          me->converter(
*            exporting
*              arabico  = saldo_divisao
*              superior = 1000
*            importing
*              romano   = centenas
*          ).
*
*        when others .
*          exit .
*      endcase .

      if superior eq 0 .

        exit .

      else.

        me->converter(
          exporting
            arabico  = saldo_divisao
            superior = superior
          importing
            romano   = unidades
        ).

        if unidades is not initial .
          concatenate unidades romano into romano .
          clear unidades .
        endif .

      endif .

    enddo .

  endmethod.


  method exibir .

    data:
      table type ref to cl_salv_table  .

    if out[] is not initial .

      try .

          call method cl_salv_table=>factory(
*           exporting
*             list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*             r_container    =     " Abstract Container for GUI Controls
*             container_name =
            importing
              r_salv_table = table
            changing
              t_table      = out
                             ).

        catch cx_salv_msg .

      endtry .

      table->display( ).

    endif .

  endmethod.


  method unidades .

    data: contador type i,
          novo     type char2,
          velho    type char1.


    do arabico times .

*     Percorre os numeros para preenchimento
      contador = contador + 1 .

      try.
          data(divisao) = contador div 5 .
        catch cx_sy_zerodivide .
      endtry.

      try.
          data(saldo_divisao) = contador mod 5 .
        catch cx_sy_zerodivide .
      endtry.

      case divisao.

        when 0 .

          case saldo_divisao .

            when 4 .
              me->set4(
                exporting
                  velho = romano(1)
                importing
                  novo  = novo
              ).

              romano = novo .


            when others .
              concatenate romano 'I' into romano .
              condense romano no-gaps .

          endcase.

        when 4 .

        when others .

          case saldo_divisao .

            when 0 .
              velho = romano(2) .
              me->set0(
                exporting
                  velho = velho
                importing
                  novo  = novo
              ).

              romano = novo .

            when 4 .
              me->set4(
                exporting
                  velho = romano(1)
                importing
                  novo  = novo
              ).

              romano = novo .

            when others .
              concatenate romano 'I' into romano .
              condense romano no-gaps .

          endcase.

      endcase .

    enddo.

  endmethod.

  method converter .

    data:
      contador type i,
      novo     type char2,
      velho    type char1.

    data(controle) = arabico div superior .

    data(validador) = superior * 10 .

    if arabico ge validador .
      exit .
    endif.

    do controle times .

      data(divisao) = sy-index div 5 .
      data(saldo_divisao) = sy-index mod 5 .


      case divisao.

        when 0 .

          case saldo_divisao .

            when 4 .
              controle = ( sy-index + 1 ) * superior .

              read table referencia into data(line)
                with key arabico = controle .
              if sy-subrc eq 0 .
*               concatenate line-anterior line-numero into romano .
                romano = line-numero .
              endif .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate line-numero romano into romano .
              endif .


            when others .

              controle  = sy-index * superior .
              read table referencia into line
                with key arabico = controle .
              concatenate romano line-numero into romano .
              condense romano no-gaps .

          endcase.

        when others .

          case saldo_divisao .

            when 0 .

              contador = sy-index * superior .
              read table referencia into line
                with key arabico = contador .
              if sy-subrc eq 0 .
                romano = line-numero .
              endif .

            when 4 .

              contador = ( sy-index + 1 ) * superior .

              read table referencia into line
                with key arabico = contador .
              if sy-subrc eq 0 .
                romano = line-numero .
              endif .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate line-numero romano into romano .
              endif .

            when others .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate romano line-numero into romano .
                condense romano no-gaps .
              endif .

          endcase.

      endcase .

    enddo.

  endmethod.


  method set4 .

    read table referencia into data(line)
*     with table key numero = velho .
      with key numero = velho .

    if sy-subrc eq 0 .

      if line-anterior is initial .

        concatenate velho line-proximo
               into novo .

      else.

        concatenate line-anterior line-proximo
               into novo .

      endif .

    endif .

  endmethod.

  method set0 .

    read table referencia into data(line)
*     with table key numero = velho .
      with key numero = velho .

    if sy-subrc eq 0 .

      if line-anterior is initial .

        novo = line-proximo .

      endif .

    endif .

  endmethod.

endclass.



data:
  report  type ref to local_class,
  arabico type num10,
  out     type local_class=>out_t.


start-of-selection .

  create object report .

*
*  do 10 times .
*
*    arabico = sy-index .
*    data(line) =
*      value local_class=>ty_out( arabico = arabico
*                                 romano  = report->romanos( arabico = arabico ) ) .
*    append line to out .
*    clear  line .
*
*  enddo .
*
*  do 10 times .
*
*    arabico = sy-index * 10  .
*
*    line =
*      value local_class=>ty_out( arabico = arabico
*                                 romano  = report->romanos( arabico = arabico ) ) .
*    append line to out .
*    clear  line .
*
*  enddo .
*
*
*  do 10 times .
*
*    arabico = sy-index * 100  .
*
*    line =
*      value local_class=>ty_out( arabico = arabico
*                                 romano  = report->romanos( arabico = arabico ) ) .
*    append line to out .
*    clear  line .
*
*  enddo .
*

  do 1000 times .

    arabico = sy-index .

    data(line) =
      value local_class=>ty_out( arabico = arabico
                                 romano  = report->romanos( arabico = arabico ) ) .
    append line to out .
    clear  line .

  enddo .


  report->exibir(
    changing
      out = out
  ).