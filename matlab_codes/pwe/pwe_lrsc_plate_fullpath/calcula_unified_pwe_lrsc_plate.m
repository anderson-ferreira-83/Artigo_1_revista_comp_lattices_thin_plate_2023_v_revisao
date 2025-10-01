%--------------------------------------------------------------------------
% CALCULA_UNIFIED_PWE_LRSC_PLATE
%--------------------------------------------------------------------------
% Descricao: Script para calcular e atualizar a base de dados PWE para
%            placa com ressonadores locais (LRSC) usando a funcao unificada 
%            para todas as redes cristalinas
%
% Entrada: Nenhuma (parametros definidos internamente)
%
% Saida: Base de dados atualizada para todos os tipos de rede com diferentes
%        frequencias de ressonancia
%
% Autor: [Seu nome]
% Data: [Data atual]
% Versao: 1.0
%--------------------------------------------------------------------------

clear all
close all
clc

%--------------------------------------------------------------------------
% VERIFICAR E CRIAR DIRETORIO DE BASE DE DADOS
%--------------------------------------------------------------------------
% Criar diretorio 1_database_fullpath um nivel acima do diretorio atual
current_dir = pwd;
parent_dir = fileparts(current_dir);
database_dir = fullfile(parent_dir, '1_database_fullpath');
lrsc_plate_dir = fullfile(database_dir, 'lrsc_plate');

if ~exist(database_dir, 'dir')
    mkdir(database_dir);
    fprintf('Diretorio de base de dados criado em: %s\n', database_dir);
else
    fprintf('Usando diretorio de base de dados existente: %s\n', database_dir);
end

if ~exist(lrsc_plate_dir, 'dir')
    mkdir(lrsc_plate_dir);
end

fprintf('\n');

%--------------------------------------------------------------------------
% PARAMETROS UNIVERSAIS DAS REDES
%--------------------------------------------------------------------------
% Numero de ondas planas
nmax_f = 3;

% Intervalos para Bandas [Hz]
i_fi_f = 10;
i_ff_f = 100;

% Tamanho da rede [m]
a_f = 1e-1;

% Espessura da placa [m]
he_f = 2e-3;

% Modulo de Elasticidade [Pa]
E_f = 0.86e9;

% Razao das massas da celula da placa
gamma_f = 0.5;

% Densidade [kg/m3]
ro_f = 600;

% Coeficiente de Poisson
ni_f = 0.39;

% Fator de Amortecimento do Ressonador
eta_p_f = 1e-2;

% Rigidez da Placa [N/m]
D = (E_f*(he_f^3))/(12*(1-(ni_f^2)));

fprintf('Parametros gerais:\n');
fprintf('  Constante de rede: %.3f m\n', a_f);
fprintf('  Espessura da placa: %.3f mm\n', he_f*1000);
fprintf('  Modulo de Young: %.2f GPa\n', E_f/1e9);
fprintf('  Densidade: %.0f kg/m3\n', ro_f);
fprintf('  Rigidez da placa: %.2e N.m\n', D);
fprintf('  Razao de massa (gamma): %.2f\n', gamma_f);
fprintf('  Amortecimento: %.1e\n', eta_p_f);
fprintf('\n');

%--------------------------------------------------------------------------
% CRIAR ARQUIVO DE LOG
%--------------------------------------------------------------------------
% Gerar timestamp unico para log e arquivos comprimidos
timestamp_str = datestr(now, 'yyyy-mm-dd_HH-MM-SS');

% Nome do arquivo de log com prefixo 0_ e timestamp
log_filename = sprintf('0_log_pwe_lrsc_unified_processing_%s.txt', timestamp_str);
log_filepath = fullfile(lrsc_plate_dir, log_filename);

% Abrir arquivo de log
log_file = fopen(log_filepath, 'w');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'LOG DE PROCESSAMENTO PWE-LRSC (UNIFIED)\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Data/Hora de inicio: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
fprintf(log_file, '\nParametros utilizados:\n');
fprintf(log_file, '  - Constante de rede (a): %.3f m\n', a_f);
fprintf(log_file, '  - Espessura da placa (h): %.3f mm\n', he_f*1000);
fprintf(log_file, '  - Modulo de Young (E): %.2f GPa\n', E_f/1e9);
fprintf(log_file, '  - Densidade (rho): %.0f kg/m3\n', ro_f);
fprintf(log_file, '  - Coef. Poisson (nu): %.2f\n', ni_f);
fprintf(log_file, '  - Razao de massa (gamma): %.2f\n', gamma_f);
fprintf(log_file, '  - Frequencia inicial: %.0f Hz\n', i_fi_f);
fprintf(log_file, '  - Frequencia final: %.0f Hz\n', i_ff_f);
fprintf(log_file, '==========================================================================\n\n');

%--------------------------------------------------------------------------
% DEFINIR TIPOS DE REDE E FREQUENCIAS DE RESSONANCIA
%--------------------------------------------------------------------------
lattice_types = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
lattice_names = {'Quadrada', 'Retangular', 'Triangular', 'Hexagonal', 'Kagome'};

% Definir frequencias de ressonancia para cada rede
% Frequencias base: 10 ate 1000 de 10 em 10
freq_base = 10:10:1000;

% Frequencias especificas adicionais para cada rede
freq_especificas = struct();
freq_especificas.square = 105;
freq_especificas.rectangular = 99;
freq_especificas.triangular = 145;
freq_especificas.hexagonal = [59, 137];
freq_especificas.kagome = [35, 101];

% Combinar frequencias base com especificas e remover duplicatas
resonator_frequencies = struct();
resonator_frequencies.square = unique([freq_base, freq_especificas.square]);
resonator_frequencies.rectangular = unique([freq_base, freq_especificas.rectangular]);
resonator_frequencies.triangular = unique([freq_base, freq_especificas.triangular]);
resonator_frequencies.hexagonal = unique([freq_base, freq_especificas.hexagonal]);
resonator_frequencies.kagome = unique([freq_base, freq_especificas.kagome]);

% Configurar numero de iteracoes
% Esta variavel controla se o script processa todas as frequencias ou apenas algumas:
% - true: Processa apenas 'num_iteracoes_limitado' frequencias (util para testes rapidos)
% - false: Processa TODAS as frequencias definidas (pode levar muito tempo)
use_limited_iterations = false;  % Processar todas as frequencias
num_iteracoes_limitado = 2;      % Numero de frequencias para modo limitado (usado apenas se use_limited_iterations = true)

%--------------------------------------------------------------------------
% VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS
%--------------------------------------------------------------------------
fprintf('Verificando integridade da base de dados existente...\n');

% Contar arquivos esperados por rede
arquivos_esperados = 0;
arquivos_encontrados = 0;
base_integra = true;
detalhes_verificacao = {};

for k = 1:length(lattice_types)
    lattice = lattice_types{k};
    fr_values = resonator_frequencies.(lattice);
    
    if use_limited_iterations
        num_iter = min(num_iteracoes_limitado, length(fr_values));
    else
        num_iter = length(fr_values);
    end
    
    for j = 1:num_iter
        % Gerar nomes dos arquivos esperados
        fr_f = fr_values(j);
        arquivo_k = sprintf('%d_1_a_%.2f_h_%g_lattice_k_res_%g_pwe_lrsc_w_data_full_path.csv', k, a_f, he_f, fr_f);
        arquivo_f = sprintf('%d_2_a_%.2f_h_%g_lattice_k_res_%g_pwe_lrsc_f_data_full_path.csv', k, a_f, he_f, fr_f);
        
        caminho_k = fullfile(lrsc_plate_dir, arquivo_k);
        caminho_f = fullfile(lrsc_plate_dir, arquivo_f);
        
        arquivos_esperados = arquivos_esperados + 2;
        
        % Verificar existencia e integridade
        if exist(caminho_k, 'file') && exist(caminho_f, 'file')
            try
                % Tentar ler os arquivos para verificar integridade
                data_k = readmatrix(caminho_k);
                data_f = readmatrix(caminho_f);
                
                % Verificar se os dados são válidos (não vazios, sem NaN)
                if ~isempty(data_k) && ~isempty(data_f) && all(isfinite(data_k(:))) && all(isfinite(data_f(:)))
                    arquivos_encontrados = arquivos_encontrados + 2;
                else
                    base_integra = false;
                    detalhes_verificacao{end+1} = sprintf('Arquivos corrompidos: %s, %s', arquivo_k, arquivo_f);
                end
            catch ME
                base_integra = false;
                detalhes_verificacao{end+1} = sprintf('Erro ao ler: %s, %s - %s', arquivo_k, arquivo_f, ME.message);
            end
        else
            base_integra = false;
            if ~exist(caminho_k, 'file')
                detalhes_verificacao{end+1} = sprintf('Arquivo ausente: %s', arquivo_k);
            end
            if ~exist(caminho_f, 'file')
                detalhes_verificacao{end+1} = sprintf('Arquivo ausente: %s', arquivo_f);
            end
        end
    end
end

fprintf('Verificacao concluida:\n');
fprintf('  - Arquivos esperados: %d\n', arquivos_esperados);
fprintf('  - Arquivos encontrados: %d\n', arquivos_encontrados);
if base_integra && arquivos_encontrados == arquivos_esperados
    status_base = 'SIM';
else
    status_base = 'NAO';
end
fprintf('  - Base integra: %s\n', status_base);

if ~base_integra || arquivos_encontrados ~= arquivos_esperados
    fprintf('  - Problemas detectados:\n');
    for k = 1:length(detalhes_verificacao)
        fprintf('    * %s\n', detalhes_verificacao{k});
    end
    fprintf('  -> Executando simulacoes para completar/corrigir base de dados...\n\n');
    executar_simulacoes = true;
else
    fprintf('  -> Base de dados completa e integra. Pulando simulacoes...\n\n');
    executar_simulacoes = false;
end

if executar_simulacoes
    %--------------------------------------------------------------------------
    % WARM-UP PARA ISOLAR OVERHEAD DE INICIALIZACAO
    %--------------------------------------------------------------------------
    fprintf('Executando warm-up para isolar overhead de inicializacao...\n');
    fprintf('(Este tempo nao sera contabilizado nas medidas)\n');

    tic_warmup = tic;
    try
        % Executar rede quadrada uma vez para "aquecer" o MATLAB
        status_warmup = unified_pwe_lrsc_plate_all_lattices('square', ...
            nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, 50, eta_p_f);
        tempo_warmup = toc(tic_warmup);
        fprintf('Warm-up concluido em %.3f segundos\n', tempo_warmup);
        
        % Registrar warm-up no log
        fprintf(log_file, 'WARM-UP EXECUTADO:\n');
        fprintf(log_file, '  - Tempo de warm-up: %.3f segundos\n', tempo_warmup);
        fprintf(log_file, '  - Funcao: rede quadrada com fr=50Hz (overhead de inicializacao isolado)\n\n');
        
    catch ME
        fprintf('Aviso: Falha no warm-up - %s\n', ME.message);
        
        % Registrar falha no warm-up no log
        fprintf(log_file, 'WARM-UP FALHOU:\n');
        fprintf(log_file, '  - Erro: %s\n\n', ME.message);
    end

    fprintf('\n');
else
    % Registrar que simulacoes foram puladas
    fprintf(log_file, 'SIMULACOES PULADAS:\n');
    fprintf(log_file, '  - Motivo: Base de dados ja existe e esta integra\n');
    fprintf(log_file, '  - Arquivos verificados: %d/%d\n\n', arquivos_encontrados, arquivos_esperados);
end

% Timer geral
tic_total = tic;
total_calculations = 0;

% Arrays para armazenar estatisticas de cada rede
tempos_por_rede = zeros(1, length(lattice_types));
calculos_por_rede = zeros(1, length(lattice_types));

% Estrutura para estatisticas detalhadas por rede
stats_por_rede = struct();
for k = 1:length(lattice_types)
    stats_por_rede.(lattice_types{k}) = struct(...
        'tempos_individuais', [], ...
        'frequencias_processadas', [], ...
        'sucessos', 0, ...
        'falhas', 0, ...
        'tempo_total', 0 ...
    );
end

if executar_simulacoes
    %--------------------------------------------------------------------------
    % CALCULO DAS BASES DE DADOS PARA CADA TIPO DE REDE
    %--------------------------------------------------------------------------
    fprintf('Iniciando calculo PWE-LRSC para placa com ressonadores (medidas precisas)...\n');
    fprintf('================================================\n\n');

for i = 1:length(lattice_types)
    lattice = lattice_types{i};
    
    fprintf('========================================\n');
    fprintf('REDE %d/%d: %s\n', i, length(lattice_types), lattice_names{i});
    fprintf('========================================\n');
    
    % Obter frequencias para esta rede
    fr_values = resonator_frequencies.(lattice);
    
    % Limitar iteracoes se configurado
    if use_limited_iterations
        num_iter = min(num_iteracoes_limitado, length(fr_values));
        fprintf('Processando %d frequencias de ressonancia (modo limitado)\n', num_iter);
    else
        num_iter = length(fr_values);
        fprintf('Processando %d frequencias de ressonancia\n', num_iter);
    end
    
    % Inicializar barra de progresso
    h = waitbar(0, sprintf('Processando rede %s: 0%%', lattice_names{i}));
    
    % Timer para esta rede
    tic_rede = tic;
    
    for j = 1:num_iter
        fr_f = fr_values(j);
        
        fprintf('\n  Fr = %.0f Hz (%d/%d)... ', fr_f, j, num_iter);
        
        try
            % Timer individual
            tic_calc = tic;
            
            % Chamar funcao unificada
            status = unified_pwe_lrsc_plate_all_lattices(lattice, ...
                nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
            
            if status == 1
                tempo_calc = toc(tic_calc);
                fprintf('OK (%.2f s)\n', tempo_calc);
                total_calculations = total_calculations + 1;
                
                % Armazenar estatisticas detalhadas
                stats_por_rede.(lattice).tempos_individuais = [stats_por_rede.(lattice).tempos_individuais, tempo_calc];
                stats_por_rede.(lattice).frequencias_processadas = [stats_por_rede.(lattice).frequencias_processadas, fr_f];
                stats_por_rede.(lattice).sucessos = stats_por_rede.(lattice).sucessos + 1;
            else
                fprintf('FALHOU\n');
                stats_por_rede.(lattice).falhas = stats_por_rede.(lattice).falhas + 1;
            end
            
        catch ME
            fprintf('ERRO: %s\n', ME.message);
            stats_por_rede.(lattice).falhas = stats_por_rede.(lattice).falhas + 1;
        end
        
        % Atualizar barra de progresso
        progresso = j / num_iter;
        tempo_decorrido = toc(tic_rede);
        update_text = sprintf('Rede %s: %.1f%% - Tempo: %.1f s', ...
            lattice_names{i}, progresso*100, tempo_decorrido);
        waitbar(progresso, h, update_text);
    end
    
    % Fechar barra de progresso
    close(h);
    
    tempo_rede = toc(tic_rede);
    tempos_por_rede(i) = tempo_rede;
    calculos_por_rede(i) = num_iter;
    stats_por_rede.(lattice).tempo_total = tempo_rede;
    
    % Calcular estatisticas detalhadas para esta rede
    tempos = stats_por_rede.(lattice).tempos_individuais;
    sucessos = stats_por_rede.(lattice).sucessos;
    falhas = stats_por_rede.(lattice).falhas;
    
    % Registrar estatisticas completas no log
    fprintf(log_file, 'REDE %s:\n', upper(lattice_names{i}));
    fprintf(log_file, '  - Tempo total de processamento: %.2f segundos\n', tempo_rede);
    fprintf(log_file, '  - Simulacoes realizadas: %d (sucessos: %d, falhas: %d)\n', sucessos + falhas, sucessos, falhas);
    fprintf(log_file, '  - Taxa de sucesso: %.1f%%\n', (sucessos/(sucessos + falhas))*100);
    
    if ~isempty(tempos)
        fprintf(log_file, '  - Frequencia minima: %.0f Hz\n', min(fr_values(1:num_iter)));
        fprintf(log_file, '  - Frequencia maxima: %.0f Hz\n', max(fr_values(1:num_iter)));
        
        % Estatisticas de tempo por simulacao
        fprintf(log_file, '  - Tempo por simulacao:\n');
        fprintf(log_file, '    * Minimo: %.3f s\n', min(tempos));
        fprintf(log_file, '    * Maximo: %.3f s\n', max(tempos));
        fprintf(log_file, '    * Media: %.3f s\n', mean(tempos));
        fprintf(log_file, '    * Mediana: %.3f s\n', median(tempos));
        fprintf(log_file, '    * Desvio padrao: %.3f s\n', std(tempos));
        fprintf(log_file, '    * Coef. variacao: %.1f%%\n', (std(tempos)/mean(tempos))*100);
        
        % Percentis
        if length(tempos) >= 4
            p25 = prctile(tempos, 25);
            p75 = prctile(tempos, 75);
            p90 = prctile(tempos, 90);
            p95 = prctile(tempos, 95);
            fprintf(log_file, '    * P25: %.3f s, P75: %.3f s\n', p25, p75);
            fprintf(log_file, '    * P90: %.3f s, P95: %.3f s\n', p90, p95);
        end
        
        % Taxa de processamento
        fprintf(log_file, '  - Taxa de processamento: %.2f simulacoes/segundo\n', sucessos/tempo_rede);
    end
    
    fprintf(log_file, '\n');
    fprintf('\nRede %s concluida em %.2f segundos\n\n', lattice_names{i}, tempo_rede);
end

else
    % Se nao executou simulacoes, preencher dados basicos para o relatorio
    fprintf('Coletando informacoes da base de dados existente para relatorio...\n');
    tempo_total = toc(tic_total);
end

%--------------------------------------------------------------------------
% RESUMO FINAL
%--------------------------------------------------------------------------
tempo_total = toc(tic_total);

% Finalizar log com analise estatistica comparativa
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'RESUMO FINAL E ANALISE ESTATISTICA COMPARATIVA\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Tempo total de processamento: %.2f segundos (%.2f minutos)\n', tempo_total, tempo_total/60);
fprintf(log_file, 'Total de calculos realizados: %d\n', total_calculations);
fprintf(log_file, 'Data/Hora de conclusao: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));

% Coletrar todos os tempos para analise comparativa
todos_tempos = [];
todos_labels = {};
tempos_medios_por_rede = zeros(1, length(lattice_types));
taxas_processamento = zeros(1, length(lattice_types));

for i = 1:length(lattice_types)
    lattice = lattice_types{i};
    tempos = stats_por_rede.(lattice).tempos_individuais;
    sucessos = stats_por_rede.(lattice).sucessos;
    tempo_total_rede = stats_por_rede.(lattice).tempo_total;
    
    if ~isempty(tempos)
        todos_tempos = [todos_tempos, tempos];
        todos_labels = [todos_labels, repmat(lattice_names(i), 1, length(tempos))];
        tempos_medios_por_rede(i) = mean(tempos);
        taxas_processamento(i) = sucessos / tempo_total_rede;
    end
end

fprintf(log_file, '\n--- ANALISE COMPARATIVA ENTRE REDES ---\n');
fprintf(log_file, 'Ranking por tempo medio de simulacao (do mais rapido ao mais lento):\n');

% Criar ranking de performance
[tempos_ordenados, indices] = sort(tempos_medios_por_rede(tempos_medios_por_rede > 0));
lattice_ranking = lattice_names(tempos_medios_por_rede > 0);
lattice_ranking = lattice_ranking(indices);

for i = 1:length(tempos_ordenados)
    fprintf(log_file, '  %d. %-12s: %.3f s/simulacao\n', i, lattice_ranking{i}, tempos_ordenados(i));
end

% Analise de eficiencia relativa
if length(tempos_ordenados) > 1
    tempo_base = tempos_ordenados(1); % Rede mais rapida como referencia
    fprintf(log_file, '\nEficiencia relativa (usando %s como referencia = 1.00x):\n', lattice_ranking{1});
    for i = 1:length(tempos_ordenados)
        fator = tempos_ordenados(i) / tempo_base;
        if fator > 1
            complemento = sprintf('(%.0f%% mais lento)', (fator-1)*100);
        else
            complemento = '(referencia)';
        end
        fprintf(log_file, '  - %-12s: %.2fx %s\n', lattice_ranking{i}, fator, complemento);
    end
end

% Estatisticas globais
if ~isempty(todos_tempos)
    fprintf(log_file, '\n--- ESTATISTICAS GLOBAIS (TODAS AS REDES) ---\n');
    fprintf(log_file, 'Total de simulacoes: %d\n', length(todos_tempos));
    fprintf(log_file, 'Tempo por simulacao:\n');
    fprintf(log_file, '  - Media global: %.3f s\n', mean(todos_tempos));
    fprintf(log_file, '  - Mediana global: %.3f s\n', median(todos_tempos));
    fprintf(log_file, '  - Desvio padrao global: %.3f s\n', std(todos_tempos));
    fprintf(log_file, '  - Coef. variacao global: %.1f%%\n', (std(todos_tempos)/mean(todos_tempos))*100);
    fprintf(log_file, '  - Tempo minimo: %.3f s\n', min(todos_tempos));
    fprintf(log_file, '  - Tempo maximo: %.3f s\n', max(todos_tempos));
    
    % Detectar outliers (valores acima de 2 desvios padrao)
    limite_outlier = mean(todos_tempos) + 2*std(todos_tempos);
    outliers = todos_tempos > limite_outlier;
    if any(outliers)
        fprintf(log_file, '  - Outliers detectados: %d simulacoes (%.1f%% do total)\n', ...
            sum(outliers), (sum(outliers)/length(todos_tempos))*100);
    else
        fprintf(log_file, '  - Nenhum outlier detectado (2-sigma)\n');
    end
end

fprintf(log_file, '\n--- RESUMO POR REDE ---\n');
for i = 1:length(lattice_names)
    if tempos_por_rede(i) > 0
        sucessos = stats_por_rede.(lattice_types{i}).sucessos;
        falhas = stats_por_rede.(lattice_types{i}).falhas;
        fprintf(log_file, '  - %-12s: %.2f s total, %d sim., %.3f s/sim., %.2f sim./s\n', ...
            lattice_names{i}, tempos_por_rede(i), sucessos, ...
            tempos_medios_por_rede(i), taxas_processamento(i));
    else
        fprintf(log_file, '  - %-12s: NAO PROCESSADA\n', lattice_names{i});
    end
end

fprintf(log_file, '==========================================================================\n');

% Fechar arquivo de log
fclose(log_file);

fprintf('================================================\n');
fprintf('CALCULO CONCLUIDO\n');
fprintf('================================================\n');
fprintf('Total de calculos realizados: %d\n', total_calculations);
fprintf('Tempo total de execucao: %.2f segundos (%.2f minutos)\n', ...
    tempo_total, tempo_total/60);
fprintf('Base de dados salva em: %s\n', lrsc_plate_dir);
fprintf('\n');

% Listar arquivos criados
csv_files = dir(fullfile(lrsc_plate_dir, '*_pwe_lrsc_*.csv'));
if ~isempty(csv_files)
    fprintf('Arquivos CSV criados para LRSC:\n');
    
    % Organizar por tipo de rede
    for i = 1:length(lattice_types)
        lattice_files = csv_files(contains({csv_files.name}, sprintf('%d_', i)));
        if ~isempty(lattice_files)
            fprintf('\n  Rede %s:\n', lattice_names{i});
            for j = 1:length(lattice_files)
                fprintf('    - %s (%.2f KB)\n', lattice_files(j).name, ...
                    lattice_files(j).bytes/1024);
            end
        end
    end
else
    fprintf('AVISO: Nenhum arquivo CSV de LRSC foi encontrado no diretorio de saida.\n');
end

fprintf('\n========================================\n');
fprintf('LOG DE PROCESSAMENTO SALVO EM:\n%s\n', log_filepath);
fprintf('========================================\n');

%--------------------------------------------------------------------------
% SISTEMA DE COMPRESSAO DA BASE DE DADOS
%--------------------------------------------------------------------------
% Verificar se existem arquivos CSV para comprimir
csv_files = dir(fullfile(lrsc_plate_dir, '*.csv'));
if ~isempty(csv_files)
    % Calcular tamanho total dos CSVs
    tamanho_total_bytes = sum([csv_files.bytes]);
    tamanho_total_mb = tamanho_total_bytes / (1024^2);
    
    % Apresentar opcoes de compressao
    fprintf('\n==============================================\n');
    fprintf('OPCOES DE COMPRESSAO DA BASE DE DADOS\n');
    fprintf('==============================================\n');
    fprintf('Arquivos CSV encontrados: %d\n', length(csv_files));
    fprintf('Tamanho total: %.2f MB (%.2f GB)\n', tamanho_total_mb, tamanho_total_mb/1024);
    fprintf('\nOpcoes de compressao disponiveis:\n');
    fprintf('  1. Formato .MAT (recomendado) - Compressao ~80%%, leitura 10-50x mais rapida\n');
    fprintf('  2. Arquivo .ZIP - Compressao ~70%%, mantem CSVs comprimidos\n');
    fprintf('  3. Nao comprimir (manter CSVs originais)\n');
    
    % Prompt interativo para escolha  
    resposta = input('\nEscolha uma opcao (1, 2 ou 3): ', 's');
    
    switch resposta
        case '1'
            % Compressao em formato MAT
            fprintf('\nConvertendo para formato .MAT...\n');
            
            % Criar arquivo MAT com parametros fisicos e timestamp do log
            mat_filename = sprintf('pwe_lrsc_database_a_%.2f_h_%.3f_all_lattice_%s.mat', a_f, he_f, timestamp_str);
            mat_filepath = fullfile(lrsc_plate_dir, mat_filename);
            
            % Estrutura para armazenar todos os dados
            database = struct();
            database.metadata = struct();
            database.metadata.created = datestr(now);
            database.metadata.num_files = length(csv_files);
            database.metadata.lattice_types = lattice_types;
            database.metadata.parameters = struct('a_f', a_f, 'he_f', he_f, 'E_f', E_f, ...
                'gamma_f', gamma_f, 'ro_f', ro_f, 'ni_f', ni_f, 'eta_p_f', eta_p_f);
            
            % Carregar e organizar dados por rede
            for k = 1:length(lattice_types)
                lattice = lattice_types{k};
                database.(lattice) = struct();
                
                lattice_files = csv_files(contains({csv_files.name}, sprintf('%d_', k)));
                fprintf('  Processando rede %s: %d arquivos...\n', lattice_names{k}, length(lattice_files));
                
                for j = 1:length(lattice_files)
                    filename = lattice_files(j).name;
                    filepath = fullfile(lrsc_plate_dir, filename);
                    
                    try
                        data = readmatrix(filepath);
                        
                        % Extrair frequencia do nome do arquivo
                        tokens = regexp(filename, '_res_(\d+(?:\.\d+)?)_pwe', 'tokens');
                        if ~isempty(tokens)
                            freq = str2double(tokens{1}{1});
                            
                            % Determinar tipo de dados (k ou f)
                            if contains(filename, '_1_a_')
                                database.(lattice).(['k_' num2str(freq)]) = data;
                            elseif contains(filename, '_2_a_')
                                database.(lattice).(['f_' num2str(freq)]) = data;
                            end
                        end
                    catch ME
                        fprintf('    Aviso: Erro ao processar %s - %s\n', filename, ME.message);
                    end
                end
            end
            
            % Salvar arquivo MAT com compressao
            save(mat_filepath, 'database', '-v7.3', '-nocompression');
            
            % Verificar compressao
            mat_info = dir(mat_filepath);
            compressao_percent = (1 - mat_info.bytes/tamanho_total_bytes) * 100;
            
            fprintf('\n  Conversao concluida!\n');
            fprintf('  Arquivo MAT: %s\n', mat_filename);
            fprintf('  Tamanho original: %.2f MB\n', tamanho_total_mb);
            fprintf('  Tamanho comprimido: %.2f MB\n', mat_info.bytes/(1024^2));
            fprintf('  Compressao: %.1f%%\n', compressao_percent);
            
            % Perguntar se deseja remover CSVs originais
            remover_csv = input('\n  Remover arquivos CSV originais? (s/n): ', 's');
            if strcmpi(remover_csv, 's')
                for j = 1:length(csv_files)
                    delete(fullfile(lrsc_plate_dir, csv_files(j).name));
                end
                fprintf('  Arquivos CSV originais removidos.\n');
            end
            
        case '2'
            % Compressao ZIP
            fprintf('\nCriando arquivo ZIP...\n');
            
            zip_filename = sprintf('pwe_lrsc_database_a_%.2f_h_%.3f_all_lattice_%s.zip', a_f, he_f, timestamp_str);
            zip_filepath = fullfile(lrsc_plate_dir, zip_filename);
            
            % Criar lista de arquivos CSV
            csv_paths = {};
            for j = 1:length(csv_files)
                csv_paths{j} = fullfile(lrsc_plate_dir, csv_files(j).name);
            end
            
            % Criar ZIP
            zip(zip_filepath, csv_paths);
            
            % Verificar compressao
            zip_info = dir(zip_filepath);
            compressao_percent = (1 - zip_info.bytes/tamanho_total_bytes) * 100;
            
            fprintf('\n  Compressao ZIP concluida!\n');
            fprintf('  Arquivo ZIP: %s\n', zip_filename);
            fprintf('  Tamanho original: %.2f MB\n', tamanho_total_mb);
            fprintf('  Tamanho comprimido: %.2f MB\n', zip_info.bytes/(1024^2));
            fprintf('  Compressao: %.1f%%\n', compressao_percent);
            
            % Perguntar se deseja remover CSVs originais
            remover_csv = input('\n  Remover arquivos CSV originais? (s/n): ', 's');
            if strcmpi(remover_csv, 's')
                for j = 1:length(csv_files)
                    delete(fullfile(lrsc_plate_dir, csv_files(j).name));
                end
                fprintf('  Arquivos CSV originais removidos.\n');
            end
            
        case '3'
            fprintf('\nMantendo arquivos CSV originais sem compressao.\n');
            
        otherwise
            fprintf('\nOpcao invalida. Mantendo arquivos CSV originais.\n');
    end
    
    fprintf('\n==============================================\n');
else
    fprintf('\nNenhum arquivo CSV encontrado para compressao.\n');
end

fprintf('\n--- Fim do processamento LRSC ---\n');