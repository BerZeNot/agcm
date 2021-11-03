/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina de realizacao (cadastro) de sangria */
realizarSangria(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Sangria')],
        [ div(class(container),
              [ \html_requires(js('agcm.js')),
                h1('Realizar sangria'),
                \form_sangria
              ]) ]).


form_sangria -->
    html(form([ id('sangria-form'),
                onsubmit("redirecionaResposta( event, '/sangria' )"),
                action('/api/v1/sangria/') ],
              [ \metodo_de_envio('POST'),
                \campo_realizar_sangria(numero, 'Numero', number),
                \campo_realizar_sangria(valor, 'Valor', float),
                \campo_realizar_sangria(hora, 'Hora', text),
                \realizar_ou_cancelar_sangria('/sangria')
              ])).


realizar_ou_cancelar_sangria(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Realizar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Realizar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_realizar_sangria(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
