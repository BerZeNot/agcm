/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina para edicao (alteracao) de uma sangria */
editar_sangria(AtomNumero, _Pedido):-
    atom_number(AtomNumero, Numero),
    ( sangria:sangria(Numero, Valor, Hora)
    ->
    reply_html_page(
        boot5rest,
        [ title('Sangria')],
        [ div(class(container),
              [ \html_requires(js('agcm.js')),
                h1('Editar sangria'),
                \form_sangria(Numero, Valor, Hora)
              ]) ])
    ; throw(http_reply(not_found(Numero)))
    ).


form_sangria(Numero, Valor, Hora) -->
    html(form([ id('sangria-form'),
                onsubmit("redirecionaResposta( event, '/sangria' )"),
                action('/api/v1/sangria/~w' - Numero) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel_sangria(numero, 'Numero', number, Numero),
                \campo_sangria(valor, 'Valor', float, Valor),
                \campo_sangria(hora, 'Hora', text, Hora),
                \confirmar_ou_cancelar('/sangria')
              ])).


confirmar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_sangria(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


campo_nao_editavel_sangria(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       value(Valor),
                       readonly ])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
