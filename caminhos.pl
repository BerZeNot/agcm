:- multifile user:file_search_path/2.

/* file_search_path(Apelido, Caminho)
	  Apelido é como será chamado um Caminho absoluto
	  ou relativo no sistema de arquivos
*/

% Diretório principal do servidor: sempre coloque o caminho completo.


%% Diretório do Paulo
user:file_search_path(dir_base, '/home/paulo/Documentos/Anotações_Faculdade/2nd_semestre/Programação_Lógica/Trabalho_final/agcm/').

%% Diretório do Igor
%% user:file_search_path(dir_base, 'C:\\Users\\augus\\OneDrive\\Documentos\\Prolog').

%% Diretório do Davide
%% user:file_search_path(dir_base, 'C:\\Users\\Pichau\\Desktop').

% Diretório do projeto
user:file_search_path(projeto, dir_base(agcm)).

% Diretório de configuração
user:file_search_path(config, projeto(config)).


%% Front-end
user:file_search_path(frontend, projeto(frontend)).

% Recursos estáticos
user:file_search_path(dir_css, frontend(css)).
user:file_search_path(dir_js, frontend(js)).
user:file_search_path(dir_img, frontend(img)).
user:file_search_path(dir_webfonts, frontend(webfonts)).

% Páginas


% Gabaritos
user:file_search_path(gabarito, frontend(gabaritos)).


%% Back-end
user:file_search_path(backend, projeto(backend)).

%% Banco de dados
user:file_search_path(bd, backend(bd)).
user:file_search_path(bd_tabs, bd(tabelas)).

% API REST
user:file_search_path(api, backend(api)).
user:file_search_path(api1, api(v1)).

%% Middle-end
user:file_search_path(middle_end, projeto(middle_end)).
