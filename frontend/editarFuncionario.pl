/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina para edicao de um funcionario */
editar_funcionario(AtomId, _Pedido):-
    atom_number(AtomId, Id),
    ( funcionarios:funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
                              NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario)
    ->
    reply_html_page(
        boot5rest,
        [ title('Funcionarios')],
        [ div(class(container),
              [ 
                \html_requires(css('estiloGeral.css')),
                \html_requires(js('agcm.js')),
                h1('Editar funcionario'),
                \form_funcionario(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
                                  NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario)
              ]) ])
    ; throw(http_reply(not_found(Id)))
    ).


form_funcionario(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
                 NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario) -->
    html(form([ id('funcionario-form'),
                onsubmit("redirecionaResposta( event, '/funcionarios' )"),
                action('/api/v1/funcionarios/~w' - Id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel_funcionario(id, 'Id', number, Id),
                \campo_cad_funcionario(nome, 'Nome', text, Nome),
                \campo_cad_funcionario(endereco, 'Endereco', text, Endereco),
                \campo_cad_funcionario(telefone, 'Telefone', number, Telefone),
                \campo_cad_funcionario(bairro, 'Bairro', text, Bairro),
                \campo_cad_funcionario(cpf, 'CPF', number, Cpf),
                \campo_cad_funcionario(identidade, 'Identidade', text, Identidade),
                \campo_cad_funcionario(complemento, 'Complemento', text, Complemento),
                \campo_cad_funcionario(numfunc, 'Numero do Funcionario', number, NumFunc),
                \campo_cad_funcionario(admissao, 'Admissao', text, Admissao),
                \campo_cad_funcionario(carteiratrabalho, 'Carteira de Trabalho', text, CarteiraTrabalho),
                \campo_cad_funcionario(ferias, 'Ferias', text, Ferias),
                \campo_cad_funcionario(horario, 'Horario', text, Horario),
                \confirmar_ou_cancelar_funcionario('/funcionarios')
              ])).


confirmar_ou_cancelar_funcionario(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Confirmar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cad_funcionario(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


campo_nao_editavel_funcionario(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       % name(Nome),%  nao eh para enviar o Id
                       value(Valor),
                       readonly ])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
