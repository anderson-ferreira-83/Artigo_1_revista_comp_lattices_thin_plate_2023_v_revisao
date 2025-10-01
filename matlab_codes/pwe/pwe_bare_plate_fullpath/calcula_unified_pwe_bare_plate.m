%--------------------------------------------------------------------------
% CALCULA_UNIFIED_PWE_BARE_PLATE
%--------------------------------------------------------------------------
% Descricao: Script para calcular e atualizar a base de dados PWE para
%            placa lisa usando a funcao unificada para todas as redes
%
% Entrada: Nenhuma (parametros definidos internamente)
%
% Saida: Base de dados atualizada para todos os tipos de rede
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
bare_plate_dir = fullfile(database_dir, 'bare_plate');

if ~exist(database_dir, 'dir')
    mkdir(database_dir);
    fprintf('Diretorio de base de dados criado em: %s\n', database_dir);
else
    fprintf('Usando diretorio de base de dados existente: %s\n', database_dir);
end

if ~exist(bare_plate_dir, 'dir')
    mkdir(bare_plate_dir);
end

fprintf('\n');

%--------------------------------------------------------------------------
% PARAMETROS UNIVERSAIS DAS REDES
%--------------------------------------------------------------------------
% Numero de ondas planas
nmax_f = 3;

% Intervalos para Bandas [Hz]
i_fi_f = 10;
i_ff_f = 1000;

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

% Frequencia do ressonador [Hz] (0 para placa lisa)
fr_f = 0;

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
fprintf('\n');

%--------------------------------------------------------------------------
% CRIAR ARQUIVO DE LOG
%--------------------------------------------------------------------------
% Gerar timestamp unico para log e arquivos comprimidos
timestamp_str = datestr(now, 'yyyy-mm-dd_HH-MM-SS');

% Nome do arquivo de log com prefixo 0_ e timestamp
log_filename = sprintf('0_log_pwe_bare_plate_unified_processing_%s.txt', timestamp_str);
log_filepath = fullfile(bare_plate_dir, log_filename);

% Abrir arquivo de log
log_file = fopen(log_filepath, 'w');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'LOG DE PROCESSAMENTO PWE - PLACA LISA (UNIFIED)\n');
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

%--------------------------------------------------------------------------
% DEFINIR TIPOS DE REDE A CALCULAR
%--------------------------------------------------------------------------
lattice_types = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
lattice_names = {'Quadrada', 'Retangular', 'Triangular', 'Hexagonal', 'Kagome'};

%--------------------------------------------------------------------------
% VERIFICACAO DE INTEGRIDADE DA BASE DE DADOS
%--------------------------------------------------------------------------
fprintf('Verificando integridade da base de dados existente...\n');

% Contar arquivos esperados por rede (2 arquivos por rede para bare plate)
arquivos_esperados = length(lattice_types) * 2;
arquivos_encontrados = 0;
base_integra = true;
detalhes_verificacao = {};

for k = 1:length(lattice_types)
    % Gerar nomes dos arquivos esperados para bare plate
    arquivo_k = sprintf('%d_1_a_%.2f_h_%g_lattice_k_bare_pwe_w_data_full_path.csv', k, a_f, he_f);
    arquivo_f = sprintf('%d_2_a_%.2f_h_%g_lattice_k_bare_pwe_f_data_full_path.csv', k, a_f, he_f);
    
    caminho_k = fullfile(bare_plate_dir, arquivo_k);
    caminho_f = fullfile(bare_plate_dir, arquivo_f);
    
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
        status_warmup = unified_pwe_bare_plate_all_lattices('square', ...
            nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
        tempo_warmup = toc(tic_warmup);
        fprintf('Warm-up concluido em %.3f segundos\n', tempo_warmup);
        
        % Registrar warm-up no log
        fprintf(log_file, 'WARM-UP EXECUTADO:\n');
        fprintf(log_file, '  - Tempo de warm-up: %.3f segundos\n', tempo_warmup);
        fprintf(log_file, '  - Funcao: rede quadrada (overhead de inicializacao isolado)\n\n');
        
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

if executar_simulacoes
    %--------------------------------------------------------------------------
    % CALCULO DAS BASES DE DADOS PARA CADA TIPO DE REDE
    %--------------------------------------------------------------------------
    fprintf('Iniciando calculo PWE para placa lisa (medidas precisas)...\n');
    fprintf('=========================================\n\n');
end

% Timer geral (excluindo warm-up)
tic_total = tic;

% Array para armazenar tempos individuais
tempos_individuais = zeros(1, length(lattice_types));

if executar_simulacoes
    for i = 1:length(lattice_types)
    fprintf('----------------------------------------\n');
    fprintf('Rede %d/%d: %s\n', i, length(lattice_types), lattice_names{i});
    fprintf('----------------------------------------\n');
    
    % Timer individual
    tic_individual = tic;
    
    try
        % Chamar funcao unificada
        status = unified_pwe_bare_plate_all_lattices(lattice_types{i}, ...
            nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
        
        if status == 1
            tempo_individual = toc(tic_individual);
            tempos_individuais(i) = tempo_individual;
            fprintf('Base de dados para rede %s atualizada com sucesso!\n', lattice_names{i});
            fprintf('Tempo de execucao: %.2f segundos\n', tempo_individual);
            
            % Registrar no log
            fprintf(log_file, 'REDE %s:\n', upper(lattice_names{i}));
            fprintf(log_file, '  - Tempo de processamento: %.2f segundos\n\n', tempo_individual);
        else
            fprintf('ERRO: Falha ao processar rede %s\n', lattice_names{i});
            
            % Registrar erro no log
            fprintf(log_file, 'REDE %s: ERRO NO PROCESSAMENTO\n\n', upper(lattice_names{i}));
        end
        
    catch ME
        fprintf('ERRO ao processar rede %s:\n', lattice_names{i});
        fprintf('  %s\n', ME.message);
        
        % Registrar erro no log
        fprintf(log_file, 'REDE %s: EXCECAO CAPTURADA\n', upper(lattice_names{i}));
        fprintf(log_file, '  - Erro: %s\n\n', ME.message);
    end
    
    fprintf('\n');
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

% Finalizar log
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'RESUMO FINAL\n');
fprintf(log_file, '==========================================================================\n');
fprintf(log_file, 'Tempo total de processamento: %.2f segundos (%.2f minutos)\n', tempo_total, tempo_total/60);
fprintf(log_file, 'Data/Hora de conclusao: %s\n', datestr(now, 'dd-mmm-yyyy HH:MM:SS'));
fprintf(log_file, '\nTempos individuais por rede:\n');
for i = 1:length(lattice_names)
    if tempos_individuais(i) > 0
        fprintf(log_file, '  - Rede %-12s: %.2f segundos\n', lattice_names{i}, tempos_individuais(i));
    else
        fprintf(log_file, '  - Rede %-12s: ERRO\n', lattice_names{i});
    end
end
fprintf(log_file, '==========================================================================\n');

% Fechar arquivo de log
fclose(log_file);

fprintf('=========================================\n');
fprintf('CALCULO CONCLUIDO\n');
fprintf('=========================================\n');
fprintf('Tempo total de execucao: %.2f segundos\n', tempo_total);
fprintf('Base de dados salva em: %s\n', bare_plate_dir);
fprintf('\n');

% Listar arquivos criados
csv_files = dir(fullfile(bare_plate_dir, '*.csv'));
if ~isempty(csv_files)
    fprintf('Arquivos CSV criados:\n');
    for i = 1:length(csv_files)
        fprintf('  - %s (%.2f KB)\n', csv_files(i).name, csv_files(i).bytes/1024);
    end
else
    fprintf('AVISO: Nenhum arquivo CSV foi encontrado no diretorio de saida.\n');
end

fprintf('\n========================================\n');
fprintf('LOG DE PROCESSAMENTO SALVO EM:\n%s\n', log_filepath);
fprintf('========================================\n');

%--------------------------------------------------------------------------
% SISTEMA DE COMPRESSAO DA BASE DE DADOS
%--------------------------------------------------------------------------
% Verificar se existem arquivos CSV para comprimir
csv_files = dir(fullfile(bare_plate_dir, '*.csv'));
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
            mat_filename = sprintf('pwe_bare_plate_database_a_%.2f_h_%.3f_all_lattice_%s.mat', a_f, he_f, timestamp_str);
            mat_filepath = fullfile(bare_plate_dir, mat_filename);
            
            % Estrutura para armazenar todos os dados
            database = struct();
            database.metadata = struct();
            database.metadata.created = datestr(now);
            database.metadata.num_files = length(csv_files);
            database.metadata.lattice_types = lattice_types;
            database.metadata.parameters = struct('a_f', a_f, 'he_f', he_f, 'E_f', E_f, ...
                'gamma_f', gamma_f, 'ro_f', ro_f, 'ni_f', ni_f, 'fr_f', fr_f, 'eta_p_f', eta_p_f);
            
            % Carregar e organizar dados por rede
            for k = 1:length(lattice_types)
                lattice = lattice_types{k};
                database.(lattice) = struct();
                
                % Arquivos para bare plate (sem frequencia de ressonador)
                arquivo_k = sprintf('%d_1_a_%.2f_h_%g_lattice_k_bare_pwe_w_data_full_path.csv', k, a_f, he_f);
                arquivo_f = sprintf('%d_2_a_%.2f_h_%g_lattice_k_bare_pwe_f_data_full_path.csv', k, a_f, he_f);
                
                fprintf('  Processando rede %s...\n', lattice_names{k});
                
                try
                    % Carregar dados k
                    data_k = readmatrix(fullfile(bare_plate_dir, arquivo_k));
                    database.(lattice).k_data = data_k;
                    
                    % Carregar dados f
                    data_f = readmatrix(fullfile(bare_plate_dir, arquivo_f));
                    database.(lattice).f_data = data_f;
                    
                catch ME
                    fprintf('    Aviso: Erro ao processar rede %s - %s\n', lattice_names{k}, ME.message);
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
                    delete(fullfile(bare_plate_dir, csv_files(j).name));
                end
                fprintf('  Arquivos CSV originais removidos.\n');
            end
            
        case '2'
            % Compressao ZIP
            fprintf('\nCriando arquivo ZIP...\n');
            
            zip_filename = sprintf('pwe_bare_plate_database_a_%.2f_h_%.3f_all_lattice_%s.zip', a_f, he_f, timestamp_str);
            zip_filepath = fullfile(bare_plate_dir, zip_filename);
            
            % Criar lista de arquivos CSV
            csv_paths = {};
            for j = 1:length(csv_files)
                csv_paths{j} = fullfile(bare_plate_dir, csv_files(j).name);
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
                    delete(fullfile(bare_plate_dir, csv_files(j).name));
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

fprintf('\n--- Fim do processamento ---\n');