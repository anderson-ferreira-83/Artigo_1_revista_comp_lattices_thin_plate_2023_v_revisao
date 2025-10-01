%--------------------------------------------------------------------------
% CALCULA_UNIFIED_PWE_LRSC_GAMMA_X_PLATE
%--------------------------------------------------------------------------
% Descricao: Script unificado para gerar base de dados PWE-LRSC completa
%            para placas com ressonadores locais usando analise Gamma-X path
%            com verificacao de integridade, sistema de warm-up e compressao
%
% Caracteristicas:
%   - Processa todas as 5 redes cristalinas (square, rectangular, triangular, hexagonal, kagome)
%   - Analise do caminho Gamma-X na zona de Brillouin
%   - Verificacao de integridade da base de dados
%   - Sistema de warm-up para isolar overhead de inicializacao
%   - Análise estatística avançada dos tempos de processamento
%   - Opcoes de compressao (MAT/ZIP) com reducao de 70-90% do tamanho
%   - Logs detalhados com timestamp sincronizado
%   - Base de dados salva em: 2_database_gamma_x_path/lrsc_plate/
%
% Uso: calcula_unified_pwe_lrsc_gamma_x_plate
%
% Saidas:
%   - Arquivos .csv organizados por rede e frequencia do ressonador
%   - Arquivo .mat comprimido com todos os dados (opcional)
%   - Arquivo .zip com todos os .csv (opcional)
%   - Log detalhado com estatisticas de performance
%
% Autor: Anderson H.R. Ferreira
% Data: July 2025
% Versao: 1.0 - Gamma-X Path Analysis
%--------------------------------------------------------------------------

clear all
close all
clc

%--------------------------------------------------------------------------
% PARAMETROS UNIVERSAIS DAS REDES
%--------------------------------------------------------------------------
nmax_f = 3;          % Numero maximo de ondas planas
i_fi_f = 10;         % Frequencia inicial [Hz]
i_ff_f = 100;        % Frequencia final [Hz]
a_f = 0.10;          % Constante de rede [m]
he_f = 0.002;        % Espessura da placa [m]
E_f = 0.86e9;        % Modulo de Young [Pa]
gamma_f = 0.5;       % Razao de massa ressonador/celula
ro_f = 600;          % Densidade [kg/m^3]
ni_f = 0.39;         % Coeficiente de Poisson
eta_p_f = 1e-2;      % Fator de amortecimento

% Configuracao de frequencias do ressonador
use_limited_iterations = false;  % Modo de teste limitado
if use_limited_iterations
    num_iteracoes = 5;           % Apenas 5 frequencias para teste
    fprintf('MODO TESTE: Processando apenas %d frequencias\\n', num_iteracoes);
else
    % Configuracao de frequencias (seguindo padrao fullpath)
    freq_base = 10:10:100;       % 10-100 Hz em passos de 10 (conforme i_ff_f)
    
    % Frequencias especificas adicionais para cada rede (seguindo fullpath)
    freq_especificas_square = 105;
    freq_especificas_rectangular = 99;
    freq_especificas_triangular = 145;
    freq_especificas_hexagonal = [59, 137];
    freq_especificas_kagome = [35, 101];
    
    % Combinar frequencias base com especificas
    freq_square = unique([freq_base, freq_especificas_square]);
    freq_rectangular = unique([freq_base, freq_especificas_rectangular]);
    freq_triangular = unique([freq_base, freq_especificas_triangular]);
    freq_hexagonal = unique([freq_base, freq_especificas_hexagonal]);
    freq_kagome = unique([freq_base, freq_especificas_kagome]);
    
    % Total de frequencias unicas para processamento
    all_frequencies = unique([freq_base, freq_especificas_square, freq_especificas_rectangular, ...
                             freq_especificas_triangular, freq_especificas_hexagonal, freq_especificas_kagome]);
    num_iteracoes = length(all_frequencies);
    fprintf('MODO COMPLETO: Processando %d frequencias unicas (padrao fullpath)\\n', num_iteracoes);
end

%--------------------------------------------------------------------------
% VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS
%--------------------------------------------------------------------------
parent_database_dir = fullfile(fileparts(pwd), '2_database_gamma_x_path');
database_dir = fullfile(parent_database_dir, 'lrsc_plate');

% Criar diretorios se nao existirem
if ~exist(parent_database_dir, 'dir')
    mkdir(parent_database_dir);
    fprintf('Diretorio criado: %s\\n', parent_database_dir);
end

if ~exist(database_dir, 'dir')
    mkdir(database_dir);
    fprintf('Diretorio criado: %s\\n', database_dir);
end

% Verificacao de integridade
fprintf('\\n=== VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS ===\\n');
fprintf('Verificando base de dados em: %s\\n', database_dir);

% Contar arquivos existentes por tipo de rede
lattices = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
lattice_ids = [1, 2, 3, 4, 5];
arquivos_encontrados = 0;
arquivos_esperados = num_iteracoes * 5 * 2;  % freq × redes × tipos de arquivo

for i = 1:length(lattices)
    lattice_id = lattice_ids(i);
    pattern_w = sprintf('%d_1_a_%.2f_h_%g_lattice_k_res_*_pwe_lrsc_w_data_gamma_x_path.csv', ...
                       lattice_id, a_f, he_f);
    pattern_f = sprintf('%d_2_a_%.2f_h_%g_lattice_k_res_*_pwe_lrsc_f_data_gamma_x_path.csv', ...
                       lattice_id, a_f, he_f);
    
    files_w = dir(fullfile(database_dir, pattern_w));
    files_f = dir(fullfile(database_dir, pattern_f));
    
    lattice_files = length(files_w) + length(files_f);
    arquivos_encontrados = arquivos_encontrados + lattice_files;
    
    fprintf('  - %s: %d arquivos encontrados\\n', lattices{i}, lattice_files);
end

fprintf('Total de arquivos: %d/%d\\n', arquivos_encontrados, arquivos_esperados);

% Decidir se executar simulacoes
base_integra = (arquivos_encontrados == arquivos_esperados);  % 100% de tolerancia (seguindo fullpath)
executar_simulacoes = ~base_integra;

if base_integra
    fprintf(' Base integra: SIM (%.1f%% completa)\\n', ...
            100 * arquivos_encontrados / arquivos_esperados);
    fprintf('\\nA base de dados ja esta completa.\\n');
    fprintf('Opcoes disponíveis:\\n');
    fprintf('  1. Prosseguir para compressao (manter base existente)\\n');
    fprintf('  2. Refazer toda a simulacao (sobrescrever base existente)\\n');
    
    opcao_refazer = input('Escolha uma opcao (1 ou 2): ');
    
    if opcao_refazer == 2
        fprintf('Refazendo toda a simulacao...\\n');
        executar_simulacoes = true;
        base_integra = false;
    else
        fprintf('Pulando simulacoes...\\n');
    end
else
    fprintf(' Base integra: NAO (%.1f%% completa)\\n', ...
            100 * arquivos_encontrados / arquivos_esperados);
    fprintf('Executando simulacoes para completar base de dados...\\n');
end

%--------------------------------------------------------------------------
% SISTEMA DE WARM-UP PARA ISOLAMENTO DE OVERHEAD
%--------------------------------------------------------------------------
tempo_warmup = 0;  % Inicializar variavel

if executar_simulacoes
    fprintf('\\n=== SISTEMA DE WARM-UP ===\\n');
    fprintf('Executando warm-up para isolar overhead de inicializacao MATLAB...\\n');
    
    tic;
    try
        % Warm-up com parametros reduzidos
        status_warmup = unified_pwe_lrsc_plate_gamma_x_all_lattices('square', 3, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, 50, eta_p_f);
        tempo_warmup = toc;
        fprintf(' Warm-up concluído em %.3f segundos\\n', tempo_warmup);
        
        % Limpar arquivos de warm-up
        warmup_files = dir(fullfile(database_dir, '*_res_50_*'));
        for k = 1:length(warmup_files)
            delete(fullfile(database_dir, warmup_files(k).name));
        end
        fprintf('Arquivos de warm-up removidos\\n');
        
    catch ME
        fprintf('⚠�?  Aviso: Warm-up falhou - %s\\n', ME.message);
        tempo_warmup = 0;
    end
end

%--------------------------------------------------------------------------
% GERACAO DO TIMESTAMP PARA LOGS E COMPRESSAO
%--------------------------------------------------------------------------
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
log_filename = fullfile(database_dir, sprintf('0_log_pwe_lrsc_gamma_x_unified_processing_%s.txt', timestamp));

%--------------------------------------------------------------------------
% PROCESSAMENTO PRINCIPAL
%--------------------------------------------------------------------------
if executar_simulacoes
    fprintf('\\n=== PROCESSAMENTO PRINCIPAL ===\\n');
    fprintf('Iniciando processamento das 5 redes cristalinas (Gamma-X Path)...\\n');
    
    % Abrir arquivo de log
    log_file = fopen(log_filename, 'w');
    if log_file == -1
        error('Erro ao criar arquivo de log: %s', log_filename);
    end
    
    % Cabecalho do log
    fprintf(log_file, '=================================================================\\n');
    fprintf(log_file, 'LOG DE PROCESSAMENTO PWE-LRSC GAMMA-X PATH\\n');
    fprintf(log_file, '=================================================================\\n');
    fprintf(log_file, 'Data/Hora: %s\\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));
    fprintf(log_file, 'Timestamp: %s\\n', timestamp);
    fprintf(log_file, 'Base de dados: %s\\n', database_dir);
    if use_limited_iterations
        modo_str = 'TESTE LIMITADO';
    else
        modo_str = 'COMPLETO';
    end
    fprintf(log_file, 'Modo: %s\\n', modo_str);
    fprintf(log_file, 'Numero de frequencias: %d\\n', num_iteracoes);
    fprintf(log_file, 'Warm-up: %.3f segundos\\n', tempo_warmup);
    fprintf(log_file, '\\nParametros fisicos:\\n');
    fprintf(log_file, '  - Constante de rede (a): %.3f m\\n', a_f);
    fprintf(log_file, '  - Espessura (h): %.4f m\\n', he_f);
    fprintf(log_file, '  - Modulo de Young (E): %.2e Pa\\n', E_f);
    fprintf(log_file, '  - Razao de massa (gamma): %.2f\\n', gamma_f);
    fprintf(log_file, '  - Densidade (rho): %.0f kg/m³\\n', ro_f);
    fprintf(log_file, '  - Coef. Poisson (nu): %.2f\\n', ni_f);
    fprintf(log_file, '  - Amortecimento (eta): %.2e\\n', eta_p_f);
    fprintf(log_file, '  - Truncamento PWE (nmax): %d\\n', nmax_f);
    fprintf(log_file, '=================================================================\\n\\n');
    
    % Armazenar tempos por rede para analise estatistica
    tempos_por_rede = cell(5, 1);
    nomes_redes = lattices;
    
    % Loop principal por rede cristalina
    for rede_idx = 1:length(lattices)
        lattice_type = lattices{rede_idx};
        fprintf('\\n--- Processando rede: %s ---\\n', upper(lattice_type));
        fprintf(log_file, '--- REDE: %s ---\\n', upper(lattice_type));
        
        % Barra de progresso
        h = waitbar(0, sprintf('Rede %s: 0%%', upper(lattice_type)));
        
        % Inicializar vetor de tempos para esta rede
        tempos_rede = zeros(num_iteracoes, 1);
        tempo_inicio_rede = tic;
        
        % Loop por frequencia do ressonador
        for i = 1:num_iteracoes
            if use_limited_iterations
                fr_f = 10 * i;  % Frequencias simples para teste
            else
                fr_f = all_frequencies(i);  % Frequencias configuradas
            end
            
            % Processar esta frequencia
            tic_freq = tic;
            try
                status = unified_pwe_lrsc_plate_gamma_x_all_lattices(lattice_type, nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
                tempo_freq = toc(tic_freq);
                tempos_rede(i) = tempo_freq;
                
                % Atualizar barra de progresso
                progresso = i / num_iteracoes;
                update_text = sprintf('Rede %s: %.1f%% - fr=%.0fHz - %.2fs', ...
                                    upper(lattice_type), progresso*100, fr_f, tempo_freq);
                waitbar(progresso, h, update_text);
                
            catch ME
                tempo_freq = toc(tic_freq);
                fprintf('⚠�?  Erro na frequencia %.0f Hz da rede %s: %s\\n', fr_f, lattice_type, ME.message);
                fprintf(log_file, '  ERRO fr=%.0f Hz: %s\\n', fr_f, ME.message);
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
        taxa_sucesso = 100 * num_sucessos / num_iteracoes;
        
        % Armazenar tempos para analise posterior
        tempos_por_rede{rede_idx} = tempos_validos;
        
        % Estatisticas basicas
        if ~isempty(tempos_validos)
            tempo_min = min(tempos_validos);
            tempo_max = max(tempos_validos);
            tempo_medio = mean(tempos_validos);
            tempo_mediano = median(tempos_validos);
            tempo_std = std(tempos_validos);
            
            % Percentis
            p25 = prctile(tempos_validos, 25);
            p75 = prctile(tempos_validos, 75);
            p90 = prctile(tempos_validos, 90);
            p95 = prctile(tempos_validos, 95);
            
            % Deteccao de outliers (IQR method)
            IQR = p75 - p25;
            limite_inferior = p25 - 1.5 * IQR;
            limite_superior = p75 + 1.5 * IQR;
            outliers = sum(tempos_validos < limite_inferior | tempos_validos > limite_superior);
            
            % Metricas de performance
            eficiencia = tempo_min / tempo_medio;  % Quao proximo do melhor caso
            consistencia = 1 - (tempo_std / tempo_medio);  % Baixa variabilidade = alta consistencia
            
            % Log detalhado da rede
            fprintf(log_file, '\\nResumo da rede %s:\\n', upper(lattice_type));
            fprintf(log_file, '  - Frequencias processadas: %d/%d (%.1f%% sucesso)\\n', num_sucessos, num_iteracoes, taxa_sucesso);
            fprintf(log_file, '  - Tempo total: %.3f segundos\\n', tempo_total_rede);
            fprintf(log_file, '  - Tempo por simulacao:\\n');
            fprintf(log_file, '    * Minimo: %.3f s\\n', tempo_min);
            fprintf(log_file, '    * Maximo: %.3f s\\n', tempo_max);
            fprintf(log_file, '    * Media: %.3f s\\n', tempo_medio);
            fprintf(log_file, '    * Mediana: %.3f s\\n', tempo_mediano);
            fprintf(log_file, '    * Desvio padrao: %.3f s\\n', tempo_std);
            fprintf(log_file, '  - Percentis:\\n');
            fprintf(log_file, '    * P25: %.3f s, P75: %.3f s\\n', p25, p75);
            fprintf(log_file, '    * P90: %.3f s, P95: %.3f s\\n', p90, p95);
            fprintf(log_file, '  - Outliers: %d (%.1f%%)\\n', outliers, 100*outliers/num_sucessos);
            fprintf(log_file, '  - Metricas de performance:\\n');
            fprintf(log_file, '    * Eficiencia: %.3f (1.0 = ideal)\\n', eficiencia);
            fprintf(log_file, '    * Consistencia: %.3f (1.0 = sem variacao)\\n', consistencia);
            fprintf(log_file, '\\n');
            
            % Console output resumido
            fprintf(' %s: %d simulacoes em %.2fs (media: %.3fs/sim, eficiencia: %.3f)\\n', ...
                    upper(lattice_type), num_sucessos, tempo_total_rede, tempo_medio, eficiencia);
        else
            fprintf(' %s: Nenhuma simulacao bem-sucedida\\n', upper(lattice_type));
            fprintf(log_file, 'ERRO: Nenhuma simulacao bem-sucedida para %s\\n\\n', upper(lattice_type));
        end
    end
    
    %----------------------------------------------------------------------
    % ANALISE ESTATISTICA COMPARATIVA ENTRE REDES
    %----------------------------------------------------------------------
    fprintf(log_file, '\\n=================================================================\\n');
    fprintf(log_file, 'ANALISE ESTATISTICA COMPARATIVA ENTRE REDES\\n');
    fprintf(log_file, '=================================================================\\n');
    
    % Calcular estatisticas comparativas
    medias_redes = zeros(5, 1);
    std_redes = zeros(5, 1);
    eficiencia_redes = zeros(5, 1);
    
    for i = 1:5
        if ~isempty(tempos_por_rede{i})
            medias_redes(i) = mean(tempos_por_rede{i});
            std_redes(i) = std(tempos_por_rede{i});
            eficiencia_redes(i) = min(tempos_por_rede{i}) / medias_redes(i);
        else
            medias_redes(i) = NaN;
            std_redes(i) = NaN;
            eficiencia_redes(i) = NaN;
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
    
    fprintf(log_file, '\\nRanking de performance (mais rapida para mais lenta):\\n');
    for i = 1:length(idx_ranking)
        rede_idx = idx_ranking(i);
        fprintf(log_file, '  %d. %s: %.3f ± %.3f segundos (eficiencia: %.3f)\\n', ...
                i, upper(nomes_redes{rede_idx}), medias_ordenadas(i), std_redes(rede_idx), eficiencia_redes(rede_idx));
    end
    
    % Analise de variabilidade
    fprintf(log_file, '\\nAnalise de variabilidade:\\n');
    coef_variacao = std_redes ./ medias_redes;
    [~, idx_mais_consistente] = min(coef_variacao);
    [~, idx_menos_consistente] = max(coef_variacao);
    
    if ~isnan(coef_variacao(idx_mais_consistente))
        fprintf(log_file, '  - Rede mais consistente: %s (CV=%.3f)\\n', ...
                upper(nomes_redes{idx_mais_consistente}), coef_variacao(idx_mais_consistente));
    end
    if ~isnan(coef_variacao(idx_menos_consistente))
        fprintf(log_file, '  - Rede menos consistente: %s (CV=%.3f)\\n', ...
                upper(nomes_redes{idx_menos_consistente}), coef_variacao(idx_menos_consistente));
    end
    
    % Estatisticas globais
    todos_tempos = [];
    for i = 1:5
        todos_tempos = [todos_tempos; tempos_por_rede{i}];
    end
    
    if ~isempty(todos_tempos)
        fprintf(log_file, '\\nEstatisticas globais do processamento:\\n');
        fprintf(log_file, '  - Total de simulacoes: %d\\n', length(todos_tempos));
        fprintf(log_file, '  - Tempo medio global: %.3f ± %.3f segundos\\n', mean(todos_tempos), std(todos_tempos));
        fprintf(log_file, '  - Tempo total estimado: %.1f minutos\\n', sum(todos_tempos)/60);
        fprintf(log_file, '  - Faixa de tempos: [%.3f, %.3f] segundos\\n', min(todos_tempos), max(todos_tempos));
    end
    
    % Fechar arquivo de log
    fprintf(log_file, '\\n=================================================================\\n');
    fprintf(log_file, 'PROCESSAMENTO CONCLUIDO: %s\\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));
    fprintf(log_file, '=================================================================\\n');
    fclose(log_file);
    
    fprintf('\\n Processamento concluído! Log salvo em:\\n   %s\\n', log_filename);
    
else
    fprintf('\\n Base de dados já está integra. Prosseguindo para opções de compressão...\\n');
end

%--------------------------------------------------------------------------
% OPCOES DE COMPRESSAO E ARMAZENAMENTO
%--------------------------------------------------------------------------
fprintf('\\n=== OPCOES DE COMPRESSAO ===\\n');

% Contar arquivos CSV atuais
csv_files = dir(fullfile(database_dir, '*.csv'));
num_csv = length(csv_files);
tamanho_csv_bytes = sum([csv_files.bytes]);
tamanho_csv_mb = tamanho_csv_bytes / (1024^2);

fprintf('Arquivos CSV encontrados: %d (%.1f MB)\\n', num_csv, tamanho_csv_mb);

% Opcoes de compressao
fprintf('\\nOpcoes de compressao disponíveis:\\n');
fprintf('  1. Formato MAT - Recomendado (reducao: 80-90%%, carregamento: 10-50x mais rapido)\\n');
fprintf('  2. Formato ZIP - Compatibilidade externa (reducao: 70-80%%)\\n');
fprintf('  3. Nenhuma compressao\\n');

opcao = input('Escolha uma opcao (1, 2 ou 3): ');

switch opcao
    case 1
        %------------------------------------------------------------------
        % COMPRESSAO EM FORMATO MAT
        %------------------------------------------------------------------
        fprintf('\\n--- Compressao para formato MAT ---\\n');
        
        mat_filename = sprintf('pwe_lrsc_gamma_x_database_a_%.2f_h_%g_all_lattice_%s.mat', ...
                              a_f, he_f, timestamp);
        mat_filepath = fullfile(database_dir, mat_filename);
        
        fprintf('Organizando dados para formato MAT...\\n');
        
        % Estrutura organizada por rede
        database = struct();
        database.metadata = struct();
        database.metadata.creation_date = datestr(now, 'dd/mm/yyyy HH:MM:SS');
        database.metadata.timestamp = timestamp;
        database.metadata.analysis_type = 'gamma_x_path';
        database.metadata.parameters = struct('a_f', a_f, 'he_f', he_f, 'E_f', E_f, ...
                                             'gamma_f', gamma_f, 'ro_f', ro_f, 'ni_f', ni_f, ...
                                             'eta_p_f', eta_p_f, 'nmax_f', nmax_f);
        database.metadata.num_csv_files = num_csv;
        database.metadata.csv_size_mb = tamanho_csv_mb;
        
        % Organizar dados por rede
        for i = 1:length(lattices)
            lattice_name = lattices{i};
            lattice_id = lattice_ids(i);
            
            % Encontrar arquivos desta rede
            pattern_w = sprintf('%d_1_a_%.2f_h_%g_lattice_k_res_*_pwe_lrsc_w_data_gamma_x_path.csv', ...
                               lattice_id, a_f, he_f);
            pattern_f = sprintf('%d_2_a_%.2f_h_%g_lattice_k_res_*_pwe_lrsc_f_data_gamma_x_path.csv', ...
                               lattice_id, a_f, he_f);
            
            files_w = dir(fullfile(database_dir, pattern_w));
            files_f = dir(fullfile(database_dir, pattern_f));
            
            % Inicializar estrutura da rede
            database.(lattice_name) = struct();
            database.(lattice_name).lattice_id = lattice_id;
            database.(lattice_name).num_frequencies = length(files_w);
            database.(lattice_name).w_data = {};
            database.(lattice_name).f_data = {};
            database.(lattice_name).frequencies = [];
            
            % Carregar dados
            for j = 1:length(files_w)
                % Extrair frequencia do nome do arquivo
                filename_w = files_w(j).name;
                freq_match = regexp(filename_w, 'k_res_([0-9.]+)_', 'tokens');
                if ~isempty(freq_match)
                    freq = str2double(freq_match{1}{1});
                    database.(lattice_name).frequencies(end+1) = freq;
                    
                    % Carregar dados w e f
                    w_data = readmatrix(fullfile(database_dir, files_w(j).name));
                    f_filename = strrep(strrep(files_w(j).name, '_1_', '_2_'), '_w_data_', '_f_data_');
                    f_data = readmatrix(fullfile(database_dir, f_filename));
                    
                    database.(lattice_name).w_data{end+1} = w_data;
                    database.(lattice_name).f_data{end+1} = f_data;
                end
            end
            
            fprintf('  - %s: %d frequencias carregadas\\n', lattice_name, length(files_w));
        end
        
        % Salvar arquivo MAT
        fprintf('Salvando arquivo MAT...\\n');
        save(mat_filepath, 'database', '-v7.3');
        
        % Verificar compressao
        mat_info = dir(mat_filepath);
        tamanho_mat_mb = mat_info.bytes / (1024^2);
        reducao_percentual = 100 * (1 - tamanho_mat_mb / tamanho_csv_mb);
        
        fprintf(' Arquivo MAT criado: %s\\n', mat_filename);
        fprintf('   Tamanho: %.1f MB (reducao: %.1f%%)\\n', tamanho_mat_mb, reducao_percentual);
        
        % Opcao de remover CSVs
        fprintf('\\nDeseja remover os arquivos CSV originais? (economia de espaco)\\n');
        fprintf('ATENCAO: Esta acao e irreversivel!\\n');
        remover_csv = input('Remover CSVs? (s/n): ', 's');
        
        if strcmpi(remover_csv, 's') || strcmpi(remover_csv, 'sim')
            fprintf('Removendo %d arquivos CSV...\\n', num_csv);
            for i = 1:length(csv_files)
                delete(fullfile(database_dir, csv_files(i).name));
            end
            fprintf(' Arquivos CSV removidos com sucesso!\\n');
        else
            fprintf(' Arquivos CSV mantidos.\\n');
        end
        
    case 2
        %------------------------------------------------------------------
        % COMPRESSAO EM FORMATO ZIP
        %------------------------------------------------------------------
        fprintf('\\n--- Compressao para formato ZIP ---\\n');
        
        zip_filename = sprintf('pwe_lrsc_gamma_x_database_a_%.2f_h_%g_all_lattice_%s.zip', ...
                              a_f, he_f, timestamp);
        zip_filepath = fullfile(database_dir, zip_filename);
        
        % Criar ZIP com todos os arquivos CSV
        csv_list = {};
        for i = 1:length(csv_files)
            csv_list{i} = fullfile(database_dir, csv_files(i).name);
        end
        
        fprintf('Criando arquivo ZIP com %d arquivos CSV...\\n', length(csv_list));
        zip(zip_filepath, csv_list);
        
        % Verificar compressao
        zip_info = dir(zip_filepath);
        tamanho_zip_mb = zip_info.bytes / (1024^2);
        reducao_percentual = 100 * (1 - tamanho_zip_mb / tamanho_csv_mb);
        
        fprintf(' Arquivo ZIP criado: %s\\n', zip_filename);
        fprintf('   Tamanho: %.1f MB (reducao: %.1f%%)\\n', tamanho_zip_mb, reducao_percentual);
        
        % Opcao de remover CSVs
        fprintf('\\nDeseja remover os arquivos CSV originais? (economia de espaco)\\n');
        fprintf('ATENCAO: Esta acao e irreversivel!\\n');
        remover_csv = input('Remover CSVs? (s/n): ', 's');
        
        if strcmpi(remover_csv, 's') || strcmpi(remover_csv, 'sim')
            fprintf('Removendo %d arquivos CSV...\\n', num_csv);
            for i = 1:length(csv_files)
                delete(fullfile(database_dir, csv_files(i).name));
            end
            fprintf(' Arquivos CSV removidos com sucesso!\\n');
        else
            fprintf(' Arquivos CSV mantidos.\\n');
        end
        
    case 3
        %------------------------------------------------------------------
        % NENHUMA COMPRESSAO
        %------------------------------------------------------------------
        fprintf('\\nNenhuma compressao selecionada. Arquivos CSV mantidos como estao.\\n');
        
    otherwise
        fprintf('Opcao invalida. Nenhuma compressao realizada.\\n');
end

%--------------------------------------------------------------------------
% RESUMO FINAL
%--------------------------------------------------------------------------
fprintf('\\n=================================================================\\n');
fprintf('RESUMO FINAL - PWE LRSC GAMMA-X PATH DATABASE\\n');
fprintf('=================================================================\\n');
fprintf('�? Diretorio: %s\\n', database_dir);
fprintf(' Arquivos CSV: %d (%.1f MB)\\n', num_csv, tamanho_csv_mb);
fprintf(' Timestamp: %s\\n', timestamp);

if executar_simulacoes
    fprintf(' Log de processamento: 0_log_pwe_lrsc_gamma_x_unified_processing_%s.txt\\n', timestamp);
else
    fprintf(' Base de dados previamente integra - simulacoes nao executadas\\n');
end

switch opcao
    case 1
        fprintf(' Compressao MAT: %.1f MB (%.1f%% reducao)\\n', tamanho_mat_mb, reducao_percentual);
    case 2
        fprintf('🗜�?  Compressao ZIP: %.1f MB (%.1f%% reducao)\\n', tamanho_zip_mb, reducao_percentual);
    case 3
        fprintf(' Sem compressao\\n');
end

fprintf('=================================================================\\n');
fprintf(' Base de dados PWE-LRSC Gamma-X Path completa!\\n');
fprintf('=================================================================\\n');

