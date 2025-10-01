clear all
close all
clc
%disp('Parametros universais das Redes')
%disp('Numero de ondas planas')
nmax_f = 3;
%Intervalos para Bandas  [Hz]
i_fi_f = 10;
i_ff_f = 1000;
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
fr_f = 0;
% Fator de Amortecimento do Ressonador ?
%disp('Fator de Amortecimento do Ressonador')
eta_p_f = 1e-2;
% Rigidez da Placa
%disp('Rigidez transversal da Placa [N/m]')
D = (E_f*(he_f^3))/(12*(1-(ni_f^2)));

%--------------------------------------------------------------------------
% CRIAR ARQUIVO DE LOG
%--------------------------------------------------------------------------
% Criar estrutura de diretorios para base de dados
parent_database_dir = fullfile(fileparts(pwd), '1_database_fullpath');
database_dir = fullfile(parent_database_dir, 'bare_plate');

% Criar diretorio principal se nao existir
if ~exist(parent_database_dir, 'dir')
    mkdir(parent_database_dir);
end

% Criar subdiretorio para bare plate
if ~exist(database_dir, 'dir')
    mkdir(database_dir);
end

% Nome do arquivo de log com prefixo 0_ e timestamp
log_filename = sprintf('0_log_pwe_bare_plate_processing_%s.txt', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
log_filepath = fullfile(database_dir, log_filename);

% Abrir arquivo de log
log_file = fopen(log_filepath, 'w');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'LOG DE PROCESSAMENTO PWE - PLACA LISA (BARE PLATE)\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Data/Hora de inicio: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
fprintf(log_file, '\nParametros utilizados:\n');
fprintf(log_file, '  - Constante de rede (a): %.3f m\n', a_f);
fprintf(log_file, '  - Espessura da placa (h): %.3f mm\n', he_f*1000);
fprintf(log_file, '  - Modulo de Young (E): %.2f GPa\n', E_f/1e9);
fprintf(log_file, '  - Densidade (rho): %.0f kg/m3\n', ro_f);
fprintf(log_file, '  - Coef. Poisson (nu): %.2f\n', ni_f);
fprintf(log_file, '  - Frequencia inicial: %.0f Hz\n', i_fi_f);
fprintf(log_file, '  - Frequencia final: %.0f Hz\n', i_ff_f);
fprintf(log_file, '==========================================================================\n\n');

% Inicializar timer geral
tic_geral = tic;

% REDE QUADRADA
fprintf('Processando rede quadrada...\n');
tic_quadrada = tic;
func0_1_square_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
tempo_quadrada = toc(tic_quadrada);
disp('Base de dados para Placa lisa rede quadrada do PWE Full Path atualizada!');
fprintf(log_file, 'REDE QUADRADA:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_quadrada);

% REDE RETANGULAR
fprintf('Processando rede retangular...\n');
tic_retangular = tic;
func0_2_rectangular_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
tempo_retangular = toc(tic_retangular);
disp('Base de dados para Placa lisa rede retangular do PWE Full Path atualizada!');
fprintf(log_file, 'REDE RETANGULAR:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_retangular);

% REDE TRIANGULAR
fprintf('Processando rede triangular...\n');
tic_triangular = tic;
func0_3_triangular_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
tempo_triangular = toc(tic_triangular);
disp('Base de dados para Placa lisa rede triangular do PWE Full Path atualizada!');
fprintf(log_file, 'REDE TRIANGULAR:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_triangular);

% REDE HEXAGONAL
fprintf('Processando rede hexagonal...\n');
tic_hexagonal = tic;
func0_4_hexagonal_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
tempo_hexagonal = toc(tic_hexagonal);
disp('Base de dados para Placa lisa rede hexagonal do PWE Full Path atualizada!');
fprintf(log_file, 'REDE HEXAGONAL:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_hexagonal);

% REDE KAGOME
fprintf('Processando rede kagome...\n');
tic_kagome = tic;
func0_5_kagome_pwe_plot_line_data_full_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
tempo_kagome = toc(tic_kagome);
disp('Base de dados para Placa lisa rede kagome do PWE Full Path atualizada!');
fprintf(log_file, 'REDE KAGOME:\n');
fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_kagome);

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