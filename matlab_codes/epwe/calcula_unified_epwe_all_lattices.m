%--------------------------------------------------------------------------
% CALCULA_UNIFIED_EPWE_ALL_LATTICES
%--------------------------------------------------------------------------
% Descricao: Script unificado para gerar base de dados EPWE completa
%            para placas com ressonadores locais usando analise Gamma-X path
%            com verificacao de integridade, sistema de warm-up e compressao
%
% Caracteristicas:
%   - Processa todas as 5 redes cristalinas (square, rectangular, triangular, hexagonal, kagome)
%   - Analise do caminho Gamma-X na zona de Brillouin usando EPWE
%   - Verificacao de integridade da base de dados
%   - Sistema de warm-up para isolar overhead de inicializacao
%   - Analise estatistica avancada dos tempos de processamento
%   - Opcoes de compressao (MAT/ZIP) com reducao de 70-90% do tamanho
%   - Logs detalhados com timestamp sincronizado
%   - Base de dados salva em: 3_database_epwe/
%   - Gera arquivos real e imaginario separados para parte w
%
% Uso: calcula_unified_epwe_all_lattices
%
% Saidas:
%   - Arquivos .csv organizados por rede e frequencia do ressonador
%   - Formato: {lattice_id}_{data_type}_a_{a}_h_{h}_lattice_{letter}_res_{fr}_epwe_{real/imag}_w_data_gamma_x_path.csv
%   - Arquivo .mat comprimido com todos os dados (opcional)
%   - Arquivo .zip com todos os .csv (opcional)
%   - Log detalhado com estatisticas de performance
%
% Autor: Anderson H.R. Ferreira
% Data: July 2025
% Versao: 1.0 - EPWE Gamma-X Path Analysis
%--------------------------------------------------------------------------

clear all
close all
clc

%--------------------------------------------------------------------------
% CONFIGURACAO DE PATH PARA FUNCOES INDIVIDUAIS
%--------------------------------------------------------------------------
% Adicionar pasta individual_functions ao path do MATLAB
current_dir = pwd;
individual_functions_dir = fullfile(current_dir, 'individual_functions');
if exist(individual_functions_dir, 'dir')
    addpath(individual_functions_dir);
    fprintf('Pasta individual_functions adicionada ao path\n');
else
    error('Pasta individual_functions nao encontrada em: %s', individual_functions_dir);
end

%--------------------------------------------------------------------------
% PARAMETROS UNIVERSAIS DAS REDES
%--------------------------------------------------------------------------
nmax_f = 2;          % Numero maximo de ondas planas
i_fi_f = 10;         % Frequencia inicial [Hz]
i_ff_f = 100;        % Frequencia final [Hz]
a_f = 0.10;          % Constante de rede [m]
he_f = 0.002;        % Espessura da placa [m]
E_f = 0.86e9;        % Modulo de Young [Pa]
gamma_f = 0.5;       % Razao de massa ressonador/celula
ro_f = 600;          % Densidade [kg/m^3]
ni_f = 0.39;         % Coeficiente de Poisson
eta_p_f = 1e-2;      % Fator de amortecimento

% Configuracao de frequencias do ressonador (seguindo padrao PWE LRSC)
use_limited_iterations = false;  % Modo de teste limitado

if use_limited_iterations
    frequencias_ressonador = [20, 40, 60];  % Teste limitado
    fprintf('MODO DE TESTE: usando apenas %d frequencias\n', length(frequencias_ressonador));
else
    % Configuracao de frequencias (seguindo padrao PWE LRSC Gamma-X)
    freq_base = 10:10:100;       % 10-100 Hz em passos de 10 (conforme i_ff_f)
    
    % Frequencias especificas adicionais para cada rede (seguindo PWE LRSC)
    freq_especificas_square = 105;
    freq_especificas_rectangular = 99;
    freq_especificas_triangular = 145;
    freq_especificas_hexagonal = [59, 137];
    freq_especificas_kagome = [35, 101];
    
    % Frequencias por rede (seguindo exatamente o padrao PWE)
    freq_square = unique([freq_base, freq_especificas_square]);
    freq_rectangular = unique([freq_base, freq_especificas_rectangular]);
    freq_triangular = unique([freq_base, freq_especificas_triangular]);  
    freq_hexagonal = unique([freq_base, freq_especificas_hexagonal]);
    freq_kagome = unique([freq_base, freq_especificas_kagome]);
    
    fprintf('MODO COMPLETO: usando frequencias por rede (padrao PWE LRSC Gamma-X)\n');
    fprintf('  Square: %d frequencias %s Hz\n', length(freq_square), mat2str(freq_square));
    fprintf('  Rectangular: %d frequencias %s Hz\n', length(freq_rectangular), mat2str(freq_rectangular));
    fprintf('  Triangular: %d frequencias %s Hz\n', length(freq_triangular), mat2str(freq_triangular));
    fprintf('  Hexagonal: %d frequencias %s Hz\n', length(freq_hexagonal), mat2str(freq_hexagonal));
    fprintf('  Kagome: %d frequencias %s Hz\n', length(freq_kagome), mat2str(freq_kagome));
end

% Configuracao das redes cristalinas
lattices = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
lattice_ids = [1, 2, 3, 4, 5];
lattice_letters = {'s', 'r', 't', 'h', 'k'};  % Para nomenclatura dos arquivos

% Setup de diretorios
current_dir = pwd;
database_dir = fullfile(current_dir, '3_database_epwe');
if ~exist(database_dir, 'dir')
    mkdir(database_dir);
    fprintf('Diretorio criado: %s\n', database_dir);
end

% Timestamp para logs e arquivos
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');

%--------------------------------------------------------------------------
% VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS
%--------------------------------------------------------------------------
fprintf('\n=================================================================\n');
fprintf('VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS EPWE\n');
fprintf('=================================================================\n');
fprintf('Verificando base de dados em: %s\n', database_dir);

% Contar arquivos existentes por tipo de rede
arquivos_encontrados = 0;
arquivos_esperados = 0;

for i = 1:length(lattices)
    lattice_name = lattices{i};
    lattice_id = lattice_ids(i);
    lattice_letter = lattice_letters{i};
    
    % Contar arquivos esperados (3 tipos: real_w, imag_w, f) x num_frequencias
    if use_limited_iterations
        num_freq = length(frequencias_ressonador);
    else
        % Usar frequencias especificas por rede
        switch i
            case 1  % square
                num_freq = length(freq_square);
            case 2  % rectangular
                num_freq = length(freq_rectangular);
            case 3  % triangular
                num_freq = length(freq_triangular);
            case 4  % hexagonal
                num_freq = length(freq_hexagonal);
            case 5  % kagome
                num_freq = length(freq_kagome);
        end
    end
    esperados_rede = num_freq * 3;  % real_w + imag_w + f
    arquivos_esperados = arquivos_esperados + esperados_rede;
    
    % Contar arquivos existentes
    pattern_real_w = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_*_epwe_real_w_data_gamma_x_path.csv', ...
                            lattice_id, a_f, he_f, lattice_letter);
    pattern_imag_w = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_*_epwe_imag_w_data_gamma_x_path.csv', ...
                            lattice_id, a_f, he_f, lattice_letter);
    pattern_f = sprintf('%d_2_a_%.2f_h_%g_lattice_%s_res_*_epwe_f_data_gamma_x_path.csv', ...
                       lattice_id, a_f, he_f, lattice_letter);
    
    files_real_w = dir(fullfile(database_dir, pattern_real_w));
    files_imag_w = dir(fullfile(database_dir, pattern_imag_w));
    files_f = dir(fullfile(database_dir, pattern_f));
    
    encontrados_rede = length(files_real_w) + length(files_imag_w) + length(files_f);
    arquivos_encontrados = arquivos_encontrados + encontrados_rede;
    
    fprintf('  %s: %d/%d arquivos (%.1f%% completo)\n', ...
            lattice_name, encontrados_rede, esperados_rede, ...
            100 * encontrados_rede / esperados_rede);
end

fprintf('Total de arquivos: %d/%d\n', arquivos_encontrados, arquivos_esperados);

% Decidir se executar simulacoes
base_integra = (arquivos_encontrados == arquivos_esperados);
executar_simulacoes = ~base_integra;

if base_integra
    fprintf(' Base integra: SIM (%.1f%% completa)\n', ...
            100 * arquivos_encontrados / arquivos_esperados);
    fprintf('\nA base de dados ja esta completa.\n');
    fprintf('Opcoes disponíveis:\n');
    fprintf('  1. Prosseguir para compressao (manter base existente)\n');
    fprintf('  2. Refazer toda a simulacao (sobrescrever base existente)\n');
    
    opcao_refazer = input('Escolha uma opcao (1 ou 2): ');
    
    if opcao_refazer == 2
        fprintf('Refazendo toda a simulacao...\n');
        executar_simulacoes = true;
        base_integra = false;
    else
        fprintf('Pulando simulacoes...\n');
    end
else
    fprintf(' Base integra: NAO (%.1f%% completa)\n', ...
            100 * arquivos_encontrados / arquivos_esperados);
    fprintf('Executando simulacoes para completar base de dados...\n');
end

%--------------------------------------------------------------------------
% SISTEMA DE WARM-UP PARA ISOLAMENTO DE OVERHEAD
%--------------------------------------------------------------------------
tempo_warmup = 0;

if executar_simulacoes
    fprintf('\n=== SISTEMA DE WARM-UP ===\n');
    fprintf('Executando warm-up para isolar overhead de inicializacao MATLAB...\n');
    
    tic;
    try
        % Warm-up com parametros reduzidos
        status_warmup = unified_epwe_all_lattices('square', nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, 50, eta_p_f);
        tempo_warmup = toc;
        fprintf(' Warm-up concluido em %.3f segundos\n', tempo_warmup);
        
        % Limpar arquivos de warm-up
        warmup_files = dir(fullfile(database_dir, '*_res_50_*'));
        for k = 1:length(warmup_files)
            delete(fullfile(database_dir, warmup_files(k).name));
        end
        fprintf('Arquivos de warm-up removidos\n');
        
    catch ME
        fprintf('Aviso: Warm-up falhou (%s), continuando sem warm-up\n', ME.message);
        tempo_warmup = toc;
    end
end

%--------------------------------------------------------------------------
% SIMULACOES PRINCIPAIS
%--------------------------------------------------------------------------
if executar_simulacoes
    fprintf('\n=== PROCESSAMENTO PRINCIPAL ===\n');
    
    % Calcular total de simulacoes primeiro (necessario para o log)
    if use_limited_iterations
        total_simulacoes = length(frequencias_ressonador) * 5;  % 5 redes
    else
        total_simulacoes = length(freq_square) + length(freq_rectangular) + length(freq_triangular) + length(freq_hexagonal) + length(freq_kagome);
    end
    
    % Criar arquivo de log
    log_filename = sprintf('0_log_epwe_unified_processing_%s.txt', timestamp);
    log_filepath = fullfile(database_dir, log_filename);
    log_file = fopen(log_filepath, 'w');
    
    % Cabecalho do log
    fprintf(log_file, '=================================================================\n');
    fprintf(log_file, 'LOG DE PROCESSAMENTO EPWE GAMMA-X PATH\n');
    fprintf(log_file, '=================================================================\n');
    fprintf(log_file, 'Data/Hora: %s\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));
    fprintf(log_file, 'Timestamp: %s\n', timestamp);
    fprintf(log_file, 'Base de dados: %s\n', database_dir);
    if use_limited_iterations
        modo_str = 'TESTE LIMITADO';
    else
        modo_str = 'COMPLETO';
    end
    fprintf(log_file, 'Modo: %s\n', modo_str);
    if use_limited_iterations
        fprintf(log_file, 'Numero de frequencias: %d\n', length(frequencias_ressonador));
    else
        fprintf(log_file, 'Numero total de frequencias: %d\n', total_simulacoes);
    end
    fprintf(log_file, 'Warm-up: %.3f segundos\n', tempo_warmup);
    fprintf(log_file, '\nParametros fisicos:\n');
    fprintf(log_file, '  - Constante de rede (a): %.3f m\n', a_f);
    fprintf(log_file, '  - Espessura (h): %.4f m\n', he_f);
    fprintf(log_file, '  - Modulo de Young (E): %.2e Pa\n', E_f);
    fprintf(log_file, '  - Razao de massa (gamma): %.2f\n', gamma_f);
    fprintf(log_file, '  - Densidade (rho): %.0f kg/m^3\n', ro_f);
    fprintf(log_file, '  - Coef. Poisson (nu): %.2f\n', ni_f);
    fprintf(log_file, '  - Amortecimento (eta): %.2e\n', eta_p_f);
    fprintf(log_file, '  - Truncamento EPWE (nmax): %d\n', nmax_f);
    fprintf(log_file, '=================================================================\n\n');
    
    % Armazenar tempos por rede para analise estatistica
    tempos_por_rede = cell(5, 1);
    nomes_redes = lattices;
    
    % Frequencias por rede
    if use_limited_iterations
        freq_por_rede = {frequencias_ressonador, frequencias_ressonador, frequencias_ressonador, frequencias_ressonador, frequencias_ressonador};
    else
        freq_por_rede = {freq_square, freq_rectangular, freq_triangular, freq_hexagonal, freq_kagome};
    end
    
    % Contadores e estatisticas
    simulacao_atual = 0;
    tempos_simulacao = [];
    
    fprintf('Iniciando processamento das 5 redes cristalinas (EPWE Gamma-X Path)...\n');
    
    tempo_inicio_principal = tic;
    
    % Loop principal por rede cristalina
    for rede_idx = 1:length(lattices)
        lattice_type = lattices{rede_idx};
        fprintf('\n--- Processando rede: %s ---\n', upper(lattice_type));
        fprintf(log_file, '--- REDE: %s ---\n', upper(lattice_type));
        
        % Barra de progresso
        h = waitbar(0, sprintf('Rede %s: 0%%', upper(lattice_type)));
        
        % Frequencias para esta rede especifica
        freq_atual = freq_por_rede{rede_idx};
        
        % Inicializar vetor de tempos para esta rede
        tempos_rede = zeros(length(freq_atual), 1);
        tempo_inicio_rede = tic;
        
        % Loop por frequencia do ressonador
        for i = 1:length(freq_atual)
            fr_f = freq_atual(i);
            simulacao_atual = simulacao_atual + 1;
            
            % Processar esta frequencia
            tic_freq = tic;
            try
                status = unified_epwe_all_lattices(lattice_type, nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
                tempo_freq = toc(tic_freq);
                tempos_rede(i) = tempo_freq;
                
                % Atualizar barra de progresso
                progresso = i / length(freq_atual);
                update_text = sprintf('Rede %s: %.1f%% - fr=%.0fHz - %.2fs', ...
                                    upper(lattice_type), progresso*100, fr_f, tempo_freq);
                waitbar(progresso, h, update_text);
                
                % Log detalhado por simulacao
                fprintf(log_file, '  %s, fr=%.0f Hz: %.3f s (status=%d)\n', ...
                        lattice_type, fr_f, tempo_freq, status);
                
            catch ME
                tempo_freq = toc(tic_freq);
                fprintf('AVISO: Erro na frequencia %.0f Hz da rede %s: %s\n', fr_f, lattice_type, ME.message);
                fprintf(log_file, '  ERRO fr=%.0f Hz: %s\n', fr_f, ME.message);
                tempos_rede(i) = NaN;  % Marcar como erro
            end
            
            pause(0.01);  % Pequena pausa para atualizar interface
        end
        
        % Fechar barra de progresso
        close(h);
        
        % Tempo total da rede
        tempo_total_rede = toc(tempo_inicio_rede);
        
        % Filtrar tempos validos (remover NaN)
        tempos_validos = tempos_rede(~isnan(tempos_rede));
        num_sucessos = length(tempos_validos);
        taxa_sucesso = 100 * num_sucessos / length(freq_atual);
        
        % Armazenar tempos para analise posterior
        tempos_por_rede{rede_idx} = tempos_validos;
        
        % Estatisticas basicas
        if ~isempty(tempos_validos)
            tempo_min = min(tempos_validos);
            tempo_max = max(tempos_validos);
            tempo_medio = mean(tempos_validos);
            tempo_std = std(tempos_validos);
            
            fprintf('\n  Rede %s concluida:\n', upper(lattice_type));
            fprintf('    - Tempo total: %.2f s\n', tempo_total_rede);
            fprintf('    - Taxa sucesso: %.1f%% (%d/%d)\n', taxa_sucesso, num_sucessos, length(freq_atual));
            fprintf('    - Tempo medio: %.3f s (std: %.3f s)\n', tempo_medio, tempo_std);
            fprintf('    - Min/Max: %.3f / %.3f s\n', tempo_min, tempo_max);
            
            % Log resumo da rede
            fprintf(log_file, '  Resumo %s:\n', upper(lattice_type));
            fprintf(log_file, '    - Total: %.2f s\n', tempo_total_rede);
            fprintf(log_file, '    - Sucessos: %d/%d (%.1f%%)\n', num_sucessos, length(freq_atual), taxa_sucesso);
            fprintf(log_file, '    - Medio: %.3f s (std: %.3f s)\n', tempo_medio, tempo_std);
            fprintf(log_file, '    - Min/Max: %.3f / %.3f s\n\n', tempo_min, tempo_max);
        else
            fprintf('\n  ERRO: Rede %s: TODAS AS SIMULACOES FALHARAM\n', upper(lattice_type));
            fprintf(log_file, '  ERRO: Rede %s: TODAS FALHARAM\n\n', upper(lattice_type));
        end
    end
    
    % Estatisticas finais
    tempo_total_principal = toc(tempo_inicio_principal);
    
    % Coletar estatisticas por rede
    medias_redes = zeros(length(lattices), 1);
    std_redes = zeros(length(lattices), 1);
    eficiencia_redes = zeros(length(lattices), 1);
    
    for i = 1:length(lattices)
        if ~isempty(tempos_por_rede{i})
            medias_redes(i) = mean(tempos_por_rede{i});
            std_redes(i) = std(tempos_por_rede{i});
            eficiencia_redes(i) = length(tempos_por_rede{i}) / length(freq_por_rede{i});
        else
            medias_redes(i) = NaN;
            std_redes(i) = NaN;
            eficiencia_redes(i) = 0;
        end
    end
    
    % Ranking de performance (tempo medio crescente)
    % Filtrar valores válidos (não NaN) antes de ordenar
    indices_validos = ~isnan(medias_redes);
    medias_validas = medias_redes(indices_validos);
    indices_originais = find(indices_validos);
    
    if ~isempty(medias_validas)
        [medias_ordenadas, idx_temp] = sort(medias_validas, 'ascend');
        idx_ranking = indices_originais(idx_temp);
    else
        medias_ordenadas = [];
        idx_ranking = [];
    end
    
    fprintf(log_file, '\nRanking de performance (mais rapida para mais lenta):\n');
    for i = 1:length(idx_ranking)
        rede_idx = idx_ranking(i);
        fprintf(log_file, '  %d. %s: %.3f ± %.3f segundos (eficiencia: %.3f)\n', ...
                i, upper(nomes_redes{rede_idx}), medias_ordenadas(i), std_redes(rede_idx), eficiencia_redes(rede_idx));
    end
    
    % Analise de variabilidade
    fprintf(log_file, '\nAnalise de variabilidade:\n');
    coef_variacao = std_redes ./ medias_redes;
    [~, idx_mais_consistente] = min(coef_variacao);
    [~, idx_menos_consistente] = max(coef_variacao);
    
    if ~isnan(coef_variacao(idx_mais_consistente))
        fprintf(log_file, '  - Rede mais consistente: %s (CV=%.3f)\n', ...
                upper(nomes_redes{idx_mais_consistente}), coef_variacao(idx_mais_consistente));
    end
    if ~isnan(coef_variacao(idx_menos_consistente))
        fprintf(log_file, '  - Rede menos consistente: %s (CV=%.3f)\n', ...
                upper(nomes_redes{idx_menos_consistente}), coef_variacao(idx_menos_consistente));
    end
    
    % Estatisticas globais
    todos_tempos = cat(1, tempos_por_rede{:});
    if ~isempty(todos_tempos)
        tempo_medio_global = mean(todos_tempos);
        tempo_mediano_global = median(todos_tempos);
        tempo_std_global = std(todos_tempos);
        tempo_min_global = min(todos_tempos);
        tempo_max_global = max(todos_tempos);
        total_sucessos = length(todos_tempos);
        taxa_sucesso_global = 100 * total_sucessos / total_simulacoes;
        
        fprintf('\n=================================================================\n');
        fprintf('ESTATISTICAS GLOBAIS DE PERFORMANCE\n');
        fprintf('=================================================================\n');
        fprintf('Total de simulacoes planejadas: %d\n', total_simulacoes);
        fprintf('Simulacoes bem sucedidas: %d (%.1f%%)\n', total_sucessos, taxa_sucesso_global);
        fprintf('Tempo total de processamento: %.2f segundos (%.2f minutos)\n', tempo_total_principal, tempo_total_principal/60);
        fprintf('\nTempos por simulacao:\n');
        fprintf('  - Medio: %.3f s\n', tempo_medio_global);
        fprintf('  - Mediano: %.3f s\n', tempo_mediano_global);
        fprintf('  - Desvio padrao: %.3f s\n', tempo_std_global);
        fprintf('  - Minimo: %.3f s\n', tempo_min_global);
        fprintf('  - Maximo: %.3f s\n', tempo_max_global);
        
        % Log final detalhado
        fprintf(log_file, '\n=================================================================\n');
        fprintf(log_file, 'ESTATISTICAS FINAIS\n');
        fprintf(log_file, '=================================================================\n');
        fprintf(log_file, 'Tempo total processamento: %.2f segundos\n', tempo_total_principal);
        fprintf(log_file, 'Total simulacoes: %d\n', total_simulacoes);
        fprintf(log_file, 'Bem sucedidas: %d (%.1f%%)\n', total_sucessos, taxa_sucesso_global);
        fprintf(log_file, '\nEstatisticas temporais:\n');
        fprintf(log_file, '  - Tempo medio: %.3f s\n', tempo_medio_global);
        fprintf(log_file, '  - Tempo mediano: %.3f s\n', tempo_mediano_global);
        fprintf(log_file, '  - Desvio padrao: %.3f s\n', tempo_std_global);
        fprintf(log_file, '  - Min/Max: %.3f / %.3f s\n', tempo_min_global, tempo_max_global);
    else
        fprintf('\nERRO: TODAS AS SIMULACOES FALHARAM\n');
        fprintf(log_file, '\nERRO: TODAS AS SIMULACOES FALHARAM\n');
    end
    
    % Fechar arquivo de log
    fprintf(log_file, '\n=================================================================\n');
    fprintf(log_file, 'PROCESSAMENTO CONCLUIDO: %s\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));
    fprintf(log_file, '=================================================================\n');
    fclose(log_file);
    
    fprintf('\n Processamento concluido! Log salvo em:\n   %s\n', log_filename);
    
else
    fprintf('\n Base de dados ja esta integra. Prosseguindo para opcoes de compressao...\n');
end

%--------------------------------------------------------------------------
% OPCOES DE COMPRESSAO E ARMAZENAMENTO
%--------------------------------------------------------------------------
fprintf('\n=== OPCOES DE COMPRESSAO ===\n');

% Contar arquivos CSV atuais
csv_files = dir(fullfile(database_dir, '*.csv'));
num_csv = length(csv_files);
tamanho_csv_bytes = sum([csv_files.bytes]);
tamanho_csv_mb = tamanho_csv_bytes / (1024^2);

fprintf('Arquivos CSV encontrados: %d (%.1f MB)\n', num_csv, tamanho_csv_mb);

% Opcoes de compressao
fprintf('\nOpcoes de compressao disponíveis:\n');
fprintf('  1. Formato MAT - Recomendado (reducao: 80-90%%, carregamento: 10-50x mais rapido)\n');
fprintf('  2. Formato ZIP - Compatibilidade externa (reducao: 70-80%%)\n');
fprintf('  3. Nenhuma compressao\n');

opcao = input('Escolha uma opcao (1, 2 ou 3): ');

switch opcao
    case 1
        %------------------------------------------------------------------
        % COMPRESSAO EM FORMATO MAT
        %------------------------------------------------------------------
        fprintf('\n--- Compressao para formato MAT ---\n');
        
        mat_filename = sprintf('epwe_database_a_%.2f_h_%g_all_lattice_%s.mat', ...
                              a_f, he_f, timestamp);
        mat_filepath = fullfile(database_dir, mat_filename);
        
        fprintf('Organizando dados para formato MAT...\n');
        
        % Estrutura organizada por rede
        database = struct();
        database.metadata = struct();
        database.metadata.creation_date = datestr(now, 'dd/mm/yyyy HH:MM:SS');
        database.metadata.timestamp = timestamp;
        database.metadata.analysis_type = 'epwe_gamma_x_path';
        database.metadata.parameters = struct('a_f', a_f, 'he_f', he_f, 'E_f', E_f, ...
                                             'gamma_f', gamma_f, 'ro_f', ro_f, 'ni_f', ni_f, ...
                                             'eta_p_f', eta_p_f, 'nmax_f', nmax_f);
        database.metadata.num_csv_files = num_csv;
        database.metadata.csv_size_mb = tamanho_csv_mb;
        
        % Organizar dados por rede
        for i = 1:length(lattices)
            lattice_name = lattices{i};
            lattice_id = lattice_ids(i);
            lattice_letter = lattice_letters{i};
            
            % Encontrar arquivos desta rede
            pattern_real_w = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_*_epwe_real_w_data_gamma_x_path.csv', ...
                                   lattice_id, a_f, he_f, lattice_letter);
            pattern_imag_w = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_*_epwe_imag_w_data_gamma_x_path.csv', ...
                                   lattice_id, a_f, he_f, lattice_letter);
            pattern_f = sprintf('%d_2_a_%.2f_h_%g_lattice_%s_res_*_epwe_f_data_gamma_x_path.csv', ...
                               lattice_id, a_f, he_f, lattice_letter);
            
            files_real_w = dir(fullfile(database_dir, pattern_real_w));
            files_imag_w = dir(fullfile(database_dir, pattern_imag_w));
            files_f = dir(fullfile(database_dir, pattern_f));
            
            % Inicializar estrutura da rede
            database.(lattice_name) = struct();
            database.(lattice_name).lattice_id = lattice_id;
            database.(lattice_name).num_frequencies = length(files_f);
            database.(lattice_name).real_w_data = {};
            database.(lattice_name).imag_w_data = {};
            database.(lattice_name).f_data = {};
            database.(lattice_name).frequencies = [];
            
            % Carregar dados
            for j = 1:length(files_f)
                % Extrair frequencia do nome do arquivo
                filename_f = files_f(j).name;
                freq_match = regexp(filename_f, 'res_([0-9.]+)_', 'tokens');
                if ~isempty(freq_match)
                    freq = str2double(freq_match{1}{1});
                    database.(lattice_name).frequencies(end+1) = freq;
                    
                    % Carregar dados f
                    f_data = readmatrix(fullfile(database_dir, files_f(j).name));
                    database.(lattice_name).f_data{end+1} = f_data;
                    
                    % Carregar dados real_w e imag_w correspondentes
                    freq_str = sprintf('%.0f', freq);
                    real_w_filename = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_%s_epwe_real_w_data_gamma_x_path.csv', ...
                                            lattice_id, a_f, he_f, lattice_letter, freq_str);
                    imag_w_filename = sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_%s_epwe_imag_w_data_gamma_x_path.csv', ...
                                            lattice_id, a_f, he_f, lattice_letter, freq_str);
                    
                    if exist(fullfile(database_dir, real_w_filename), 'file')
                        real_w_data = readmatrix(fullfile(database_dir, real_w_filename));
                        database.(lattice_name).real_w_data{end+1} = real_w_data;
                    else
                        database.(lattice_name).real_w_data{end+1} = [];
                    end
                    
                    if exist(fullfile(database_dir, imag_w_filename), 'file')
                        imag_w_data = readmatrix(fullfile(database_dir, imag_w_filename));
                        database.(lattice_name).imag_w_data{end+1} = imag_w_data;
                    else
                        database.(lattice_name).imag_w_data{end+1} = [];
                    end
                end
            end
            
            fprintf('  - %s: %d frequencias carregadas\n', lattice_name, length(files_f));
        end
        
        % Salvar arquivo MAT
        fprintf('Salvando arquivo MAT...\n');
        save(mat_filepath, 'database', '-v7.3');
        
        % Verificar compressao
        mat_info = dir(mat_filepath);
        tamanho_mat_mb = mat_info.bytes / (1024^2);
        reducao_percentual = 100 * (1 - tamanho_mat_mb / tamanho_csv_mb);
        
        fprintf(' Arquivo MAT criado: %s\n', mat_filename);
        fprintf('   Tamanho: %.1f MB (reducao: %.1f%%)\n', tamanho_mat_mb, reducao_percentual);
        
        % Opcao de remover CSVs
        fprintf('\nDeseja remover os arquivos CSV originais? (economia de espaco)\n');
        fprintf('ATENCAO: Esta acao e irreversivel!\n');
        remover_csv = input('Remover CSVs? (s/n): ', 's');
        
        if strcmpi(remover_csv, 's') || strcmpi(remover_csv, 'sim')
            fprintf('Removendo %d arquivos CSV...\n', num_csv);
            for i = 1:length(csv_files)
                delete(fullfile(database_dir, csv_files(i).name));
            end
            fprintf(' Arquivos CSV removidos com sucesso!\n');
        else
            fprintf(' Arquivos CSV mantidos.\n');
        end
        
    case 2
        %------------------------------------------------------------------
        % COMPRESSAO EM FORMATO ZIP
        %------------------------------------------------------------------
        fprintf('\n--- Compressao para formato ZIP ---\n');
        
        zip_filename = sprintf('epwe_database_a_%.2f_h_%g_all_lattice_%s.zip', ...
                              a_f, he_f, timestamp);
        zip_filepath = fullfile(database_dir, zip_filename);
        
        % Criar ZIP com todos os arquivos CSV
        csv_list = {};
        for i = 1:length(csv_files)
            csv_list{i} = fullfile(database_dir, csv_files(i).name);
        end
        
        fprintf('Criando arquivo ZIP com %d arquivos CSV...\n', length(csv_list));
        zip(zip_filepath, csv_list);
        
        % Verificar compressao
        zip_info = dir(zip_filepath);
        tamanho_zip_mb = zip_info.bytes / (1024^2);
        reducao_percentual = 100 * (1 - tamanho_zip_mb / tamanho_csv_mb);
        
        fprintf(' Arquivo ZIP criado: %s\n', zip_filename);
        fprintf('   Tamanho: %.1f MB (reducao: %.1f%%)\n', tamanho_zip_mb, reducao_percentual);
        
        % Opcao de remover CSVs
        fprintf('\nDeseja remover os arquivos CSV originais? (economia de espaco)\n');
        fprintf('ATENCAO: Esta acao e irreversivel!\n');
        remover_csv = input('Remover CSVs? (s/n): ', 's');
        
        if strcmpi(remover_csv, 's') || strcmpi(remover_csv, 'sim')
            fprintf('Removendo %d arquivos CSV...\n', num_csv);
            for i = 1:length(csv_files)
                delete(fullfile(database_dir, csv_files(i).name));
            end
            fprintf(' Arquivos CSV removidos com sucesso!\n');
        else
            fprintf(' Arquivos CSV mantidos.\n');
        end
        
    case 3
        %------------------------------------------------------------------
        % NENHUMA COMPRESSAO
        %------------------------------------------------------------------
        fprintf('\nNenhuma compressao selecionada. Arquivos CSV mantidos como estao.\n');
        
    otherwise
        fprintf('Opcao invalida. Nenhuma compressao realizada.\n');
end

%--------------------------------------------------------------------------
% RESUMO FINAL
%--------------------------------------------------------------------------
fprintf('\n=================================================================\n');
fprintf('RESUMO FINAL - EPWE DATABASE\n');
fprintf('=================================================================\n');
fprintf('Diretorio: %s\n', database_dir);
fprintf(' Arquivos CSV: %d (%.1f MB)\n', num_csv, tamanho_csv_mb);
fprintf(' Timestamp: %s\n', timestamp);

if executar_simulacoes
    fprintf(' Log de processamento: 0_log_epwe_unified_processing_%s.txt\n', timestamp);
else
    fprintf(' Base de dados previamente integra - simulacoes nao executadas\n');
end

switch opcao
    case 1
        fprintf(' Compressao MAT: %.1f MB (%.1f%% reducao)\n', tamanho_mat_mb, reducao_percentual);
    case 2
        fprintf(' Compressao ZIP: %.1f MB (%.1f%% reducao)\n', tamanho_zip_mb, reducao_percentual);
    case 3
        fprintf(' Nenhuma compressao aplicada\n');
end

fprintf('=================================================================\n');
fprintf(' Base de dados EPWE completa!\n');
fprintf('=================================================================\n');