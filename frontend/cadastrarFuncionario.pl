/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina de cadastro de funcionario */
cadastroFuncionario(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Funcionario')],
        [ div(class(container),
              [ \html_requires(js('agcm.js')),
                h1('Cadastrar funcionario'),
                \form_funcionario
              ]) ]).


form_funcionario -->
    html(form([ id('funcionario-form'),
                onsubmit("redirecionaResposta( event, '/funcionarios' )"),
                action('/api/v1/funcionarios/') ],
              [ \metodo_de_envio('POST'),
                \campo_cad_funcionario(nome, 'Nome', text),
                \campo_cad_funcionario(endereco, 'Endereco', text),
                \campo_cad_funcionario(telefone, 'Telefone', number),
                \campo_cad_funcionario(bairro, 'Bairro', text),
                \campo_cad_funcionario(cpf, 'CPF', number),
                \campo_cad_funcionario(identidade, 'Identidade', text),
                \campo_cad_funcionario(complemento, 'Complemento', text),
                \campo_cad_funcionario(numfunc, 'Numero do Funcionario', number),
                \campo_cad_funcionario(admissao, 'Admissao', text),
                \campo_cad_funcionario(carteiratrabalho, 'Carteira de Trabalho', text),
                \campo_cad_funcionario(ferias, 'Ferias', text),
                \campo_cad_funcionario(horario, 'Horario', text),
                \cadastrar_ou_cancelar_funcionario('/funcionarios')
              ])).


cadastrar_ou_cancelar_funcionario(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Cadastrar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cad_funcionario(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
