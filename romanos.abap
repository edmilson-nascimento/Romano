
report y_romano.

class local_class definition create public.

  public section.


    types:
      begin of ty_referencia,
        arabico  type numc10,
        romano   type char1,
        anterior type char1,
        proximo  type char1,
      end of ty_referencia,

      begin of ty_out,
        numero  type numc10,
        romano  type char20,
        arabico type char20,
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

    methods arabicos
      importing
        !romano        type char20
      returning
        value(arabico) type numc10 .

    methods exibir
      changing
        !out type out_t .

  protected section.


  private section.

    methods converter
      importing
        !arabico  type num10
        !superior type numc10
      exporting
        !romano   type char20 .

endclass.

class local_class implementation.

  method constructor .

    referencia =
      value #(
        ( arabico = 1     romano = 'I' )
        ( arabico = 5     romano = 'V' )
        ( arabico = 10    romano = 'X' )
        ( arabico = 50    romano = 'L' )
        ( arabico = 100   romano = 'C' )
        ( arabico = 500   romano = 'D' )
        ( arabico = 1000  romano = 'M' )
      ) .

    loop at referencia assigning field-symbol(<line>) .

*     Item anterior
      data(index) = sy-tabix - 1 .
      read table referencia into data(line) index index .
      if sy-subrc eq 0 .
        <line>-anterior = line-romano .
      endif .

*     Próximo item
      index = index + 2 .
      read table referencia into line index index .
      if sy-subrc eq 0 .
        <line>-proximo = line-romano .
      endif .

    endloop.


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
      data(divisao)  = arabico div controle .
      saldo_divisao  = arabico mod controle .

      superior = controle / 10 .

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

  method arabicos .

    data(converte) = romano .

    clear arabico .

    do .

      data(posicao) = sy-index - 1 .

      data(caracter) = converte+posicao(1) .

      posicao = posicao + 1 .

      data(proximo)  = converte+posicao(1) .

      if caracter is initial .
        exit .
      endif .


      read table referencia into data(line)
        with key romano = caracter .

      if sy-subrc eq 0 .

*       Verificando se o proximo caracter é maior
        if proximo is initial .

          arabico = arabico + line-arabico .

        else .

          read table referencia into data(line_prox)
            with key romano = proximo .

          if sy-subrc eq 0 .

            if line-arabico lt line_prox-arabico .

              arabico = arabico + ( line_prox-arabico - line-arabico ) .
              clear converte+posicao(1) .
              condense converte no-gaps .

            else .

              arabico = arabico + line-arabico .

            endif .

          endif .

        endif .

      endif.

    enddo.

  endmethod .


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
                romano = line-romano .
              endif .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate line-romano romano into romano .
              endif .


            when others .

              controle  = sy-index * superior .
              read table referencia into line
                with key arabico = controle .
              concatenate romano line-romano into romano .
              condense romano no-gaps .

          endcase.

        when others .

          case saldo_divisao .

            when 0 .

              contador = sy-index * superior .
              read table referencia into line
                with key arabico = contador .
              if sy-subrc eq 0 .
                romano = line-romano .
              endif .

            when 4 .

              contador = ( sy-index + 1 ) * superior .

              read table referencia into line
                with key arabico = contador .
              if sy-subrc eq 0 .
                romano = line-romano .
              endif .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate line-romano romano into romano .
              endif .

            when others .

              read table referencia into line
                with key arabico = superior .
              if sy-subrc eq 0 .
                concatenate romano line-romano into romano .
                condense romano no-gaps .
              endif .

          endcase.

      endcase .

    enddo.

  endmethod.


endclass.


data:
  report  type ref to local_class,
  arabico type num10,
  out     type local_class=>out_t.

parameters: numero type numc10,
            romano type char20.


start-of-selection .

  create object report .

*  do 1000 times .
*
*    arabico = sy-index .
*
*    data(line) =
*      value local_class=>ty_out( numero  = arabico
*                                 romano  = report->romanos( arabico = arabico )
*                                 arabico = report->arabicos( romano = report->romanos( arabico = arabico ) ) ) .
*    append line to out .
*    clear  line .
*
*  enddo .
*
*
*  report->exibir(
*    changing
*      out = out
*  ).

  if numero is not initial .

    write: / 'Arabico: ', numero, 'Romano: ', report->romanos( arabico = numero ).

  endif .

  if romano is not initial .

    write: / 'Romano: ', romano, 'Arabico: ', report->arabicos( romano = romano ) .

  endif .
