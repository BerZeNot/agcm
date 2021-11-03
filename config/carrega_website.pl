% Configuração do servidor

% Carrega do servidor e as rotas
:- load_files([ servidor,
				rotas
			],
			[	silent(true),
				if(not_loaded) ]).

% Inicializa o servidor para ouvir a porta 5500
:- initialization(servidor(5500) ).

% Carrega os arquivos do frontend
:- load_files([ gabarito(bootstrap5),
                gabarito(boot5rest),
                frontend(home),
                frontend(produtos),
                frontend(cadastrarProduto),
                frontend(editarProduto),
                frontend(pessoas),
                frontend(cadastrarPessoa),
                frontend(editarPessoa),
                frontend(cliente),
                frontend(cadastrarCliente),
                frontend(editarCliente),
                frontend(itemvenda),
                frontend(cadastrarItemVenda),
                frontend(editarItemVenda),
                frontend(sangria),
                frontend(cadastrarSangria),
                frontend(editarSangria),
				        frontend(funcionarios),
				        frontend(fluxodecaixa),
                frontend(gerenciadorVendas)
              ],
              [	silent(true),
                if(not_loaded) ]).

% Carrega os arquivos do backend
:- load_files([ api1(produtos), % API REST
                api1(pessoas),
                api1(cliente),
                api1(itemvenda),
                api1(sangria),
				api1(funcionarios),
				api1(fluxodecaixa),
                api1(vendas)
              ],
              [ silent(true),
                if(not_loaded) ]).
