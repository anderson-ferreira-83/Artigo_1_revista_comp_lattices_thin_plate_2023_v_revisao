clear all
close all
clc
%disp('Parametros universais das Redes')
%disp('Numero de ondas planas')
nmax_f = 3;
%Intervalos para Bandas  [Hz]
i_fi_f = 10;
i_ff_f = 100;
%disp('Tamanho da rede [m]')
a_f = 1e-1;
% Espessura da placa [m]
%disp('Espessura da placa [m]')
he_f = 2e-3;
% Mod. Elasticidade [GPa]
%disp('Mod. Elasticidade [GPa]')
E_f = .86e9;
% Raz�o das massas da c�lula da placa
% massa do ressonador
%disp('Coef gamma')
gamma_f = 0.5;
% Densidade ?[kg/m�]
%disp('Densidade [kg/m�]')
ro_f = 600;
% Coef. de Poisson
% Frequ�ncia do ressonador
%disp('Coef. de Poisson')
ni_f = .39;
%disp('Frequencia do ressonador [Hz]')
fr_f = 30;
% Fator de Amortecimento do Ressonador ?
%disp('Fator de Amortecimento do Ressonador')
eta_p_f = 1e-2;
% Rigidez da Placa
%disp('Rigidez transversal da Placa [N/m]')
D = (E_f*(he_f^3))/(12*(1-(ni_f^2)));
% Defina o numero de iteracoes do seu loop
%num_iteracoes = 100;
num_iteracoes = 2;

%--------------------------------------------------------------------------
% CRIAR ARQUIVO DE LOG
%--------------------------------------------------------------------------
% Criar estrutura de diretorios para base de dados
parent_database_dir = fullfile(fileparts(pwd), '1_database_fullpath');
database_dir = fullfile(parent_database_dir, 'lrsc_plate');

% Criar diretorio principal se nao existir
if ~exist(parent_database_dir, 'dir')
    mkdir(parent_database_dir);
end

% Criar subdiretorio para lrsc plate
if ~exist(database_dir, 'dir')
    mkdir(database_dir);
end

% Nome do arquivo de log com prefixo 0_ e timestamp
log_filename = sprintf('0_log_pwe_lrsc_processing_%s.txt', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
log_filepath = fullfile(database_dir, log_filename);

% Abrir arquivo de log
log_file = fopen(log_filepath, 'w');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'LOG DE PROCESSAMENTO PWE-LRSC\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Data/Hora de inicio: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
fprintf(log_file, 'Numero de iteracoes por rede: %d\n', num_iteracoes);
fprintf(log_file, '\nParametros utilizados:\n');
fprintf(log_file, '  - Constante de rede (a): %.3f m\n', a_f);
fprintf(log_file, '  - Espessura da placa (h): %.3f mm\n', he_f*1000);
fprintf(log_file, '  - Modulo de Young (E): %.2f GPa\n', E_f/1e9);
fprintf(log_file, '  - Densidade (rho): %.0f kg/m3\n', ro_f);
fprintf(log_file, '  - Coef. Poisson (nu): %.2f\n', ni_f);
fprintf(log_file, '  - Razao de massa (gamma): %.2f\n', gamma_f);
fprintf(log_file, '==========================================================================\n\n');

% Inicializar timer geral
tic_geral = tic;

%
disp('Atualizando Base de dados da Rede Quadrada do PWE full path');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %fr_f = 105;
    func1_1_square_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
tempo_quadrada = toc;
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Quadrada do PWE full path atualizada!');
% Registrar no log
fprintf(log_file, 'REDE QUADRADA:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n', tempo_quadrada);
fprintf(log_file, '  - Frequencias processadas: %d\n\n', num_iteracoes);
disp(sprintf('\n'));
%%
disp('Atualizando Base de dados da Rede Retangular do PWE full path');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %fr_f = 99;
    func1_2_rectangular_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
tempo_retangular = toc;
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Retangular do PWE full path atualizada!');
% Registrar no log
fprintf(log_file, 'REDE RETANGULAR:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n', tempo_retangular);
fprintf(log_file, '  - Frequencias processadas: %d\n\n', num_iteracoes);
disp(sprintf('\n'));
%%
disp('Atualizando Base de dados da Rede Triangular do PWE full path');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %fr_f = 145;
    func1_3_triangular_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
tempo_triangular = toc;
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Triangular do PWE full path atualizada!');
% Registrar no log
fprintf(log_file, 'REDE TRIANGULAR:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n', tempo_triangular);
fprintf(log_file, '  - Frequencias processadas: %d\n\n', num_iteracoes);
disp(sprintf('\n'));
%%
disp('Atualizando Base de dados da Rede Honeycomb do PWE full path');
%num_iteracoes = 2
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
fr_f = [59 137];
for i=1:num_iteracoes
    fr_f(i)
    %fr_f = 10*i;
    %func1_4_hexagonal_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)    
    func1_4_hexagonal_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f(i),eta_p_f)
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
tempo_hexagonal = toc;
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Hexagonal do PWE full path atualizada!');
% Registrar no log
fprintf(log_file, 'REDE HEXAGONAL:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n', tempo_hexagonal);
fprintf(log_file, '  - Frequencias processadas: %d\n\n', num_iteracoes);
disp(sprintf('\n'));
%%
disp('Atualizando Base de dados da Rede Kagome do PWE full path');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
fr_f = [35 101];
for i=1:num_iteracoes
    fr_f(i)
    %fr_f = 10*i;
    %func1_5_kagome_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)    
    func1_5_kagome_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f(i),eta_p_f)
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
tempo_kagome = toc;
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Kagome do PWE full path atualizada!');
% Registrar no log
fprintf(log_file, 'REDE KAGOME:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n', tempo_kagome);
fprintf(log_file, '  - Frequencias processadas: %d\n\n', num_iteracoes);
disp(sprintf('\n'));

%--------------------------------------------------------------------------
% FINALIZAR LOG
%--------------------------------------------------------------------------
tempo_total = toc(tic_geral);
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'RESUMO FINAL\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Tempo total de processamento: %.2f segundos (%.2f minutos)\n', tempo_total, tempo_total/60);
fprintf(log_file, 'Data/Hora de conclusao: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
fprintf(log_file, '\nTempos individuais por rede:\n');
fprintf(log_file, '  - Rede Quadrada:    %.2f segundos\n', tempo_quadrada);
fprintf(log_file, '  - Rede Retangular:  %.2f segundos\n', tempo_retangular);
fprintf(log_file, '  - Rede Triangular:  %.2f segundos\n', tempo_triangular);
fprintf(log_file, '  - Rede Hexagonal:   %.2f segundos\n', tempo_hexagonal);
fprintf(log_file, '  - Rede Kagome:      %.2f segundos\n', tempo_kagome);
fprintf(log_file, '==========================================================================\n');

% Fechar arquivo de log
fclose(log_file);

fprintf('\n========================================\n');
fprintf('LOG DE PROCESSAMENTO SALVO EM:\n%s\n', log_filepath);
fprintf('========================================\n');