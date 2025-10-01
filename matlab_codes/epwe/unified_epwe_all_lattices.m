%--------------------------------------------------------------------------
% UNIFIED_EPWE_ALL_LATTICES
%--------------------------------------------------------------------------
% Descricao: Funcao unificada para simulacao EPWE em todas as redes
%            cristalinas com ressonadores locais - Gamma-X path
%
% Parametros:
%   lattice_type - Tipo de rede ('square', 'rectangular', 'triangular', 'hexagonal', 'kagome')
%   nmax         - Numero maximo de ondas planas
%   i_fi_f       - Frequencia inicial [Hz]
%   i_ff_f       - Frequencia final [Hz] 
%   a_f          - Constante de rede [m]
%   he_f         - Espessura da placa [m]
%   E_f          - Modulo de Young [Pa]
%   gamma_f      - Razao de massa ressonador/celula
%   ro_f         - Densidade [kg/m^3]
%   ni_f         - Coeficiente de Poisson
%   fr_f         - Frequencia do ressonador [Hz]
%   eta_p_f      - Fator de amortecimento
%
% Saidas:
%   status       - Status da execucao (1=sucesso, 0=erro)
%
% Autor: Anderson H.R. Ferreira
% Data: July 2025
% Versao: 1.0 - EPWE Unified Implementation
%--------------------------------------------------------------------------

function status = unified_epwe_all_lattices(lattice_type, nmax, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f)

try
    % Adicionar pasta individual_functions ao path do MATLAB
    current_dir = fileparts(mfilename('fullpath'));
    individual_functions_dir = fullfile(current_dir, 'individual_functions');
    if exist(individual_functions_dir, 'dir')
        addpath(individual_functions_dir);
    end
    
    % Garantir que o diretorio temporario 1_database existe
    temp_dir = fullfile(current_dir, '1_database');
    if ~exist(temp_dir, 'dir')
        mkdir(temp_dir);
    end
    
    % Verificar tipo de rede suportado
    supported_lattices = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
    if ~ismember(lattice_type, supported_lattices)
        error('Tipo de rede nao suportado: %s', lattice_type);
    end
    
    % Chamar funcao especifica baseada no tipo de rede
    switch lower(lattice_type)
        case 'square'
            func3_1_square_epwe_plot_line_data(a_f, he_f, E_f, gamma_f, ro_f, ni_f, eta_p_f, fr_f);
        case 'rectangular'
            func3_2_rectangular_epwe_plot_line_data(a_f, he_f, E_f, gamma_f, ro_f, ni_f, eta_p_f, fr_f);
        case 'triangular'
            func3_3_triangular_epwe_plot_line_data(a_f, he_f, E_f, gamma_f, ro_f, ni_f, eta_p_f, fr_f);
        case 'hexagonal'
            func3_4_honeycomb_epwe_plot_line_data(a_f, he_f, E_f, gamma_f, ro_f, ni_f, eta_p_f, fr_f);
        case 'kagome'
            func3_5_kagome_epwe_plot_line_data(a_f, he_f, E_f, gamma_f, ro_f, ni_f, eta_p_f, fr_f);
    end
    
    % Mover arquivos do diretorio padrao (1_database) para o diretorio correto (3_database_epwe)
    move_epwe_files_to_correct_directory(current_dir, lattice_type, a_f, he_f, fr_f);
    
    status = 1;  % Sucesso
    
catch ME
    fprintf('Erro na simulacao EPWE para %s: %s\\n', lattice_type, ME.message);
    status = 0;  % Erro
end

end

%--------------------------------------------------------------------------
% FUNCAO AUXILIAR PARA MOVER ARQUIVOS PARA DIRETORIO CORRETO
%--------------------------------------------------------------------------
function move_epwe_files_to_correct_directory(base_dir, lattice_type, a_f, he_f, fr_f)
    % Mapear tipos de rede para IDs e letras
    switch lower(lattice_type)
        case 'square'
            lattice_id = 1; lattice_letter = 's';
        case 'rectangular'
            lattice_id = 2; lattice_letter = 'r';
        case 'triangular'
            lattice_id = 3; lattice_letter = 't';
        case 'hexagonal'
            lattice_id = 4; lattice_letter = 'h';
        case 'kagome'
            lattice_id = 5; lattice_letter = 'k';
        otherwise
            return; % Tipo nao suportado, sair silenciosamente
    end
    
    % Diretorios de origem e destino
    source_dir = fullfile(base_dir, '1_database');
    target_dir = fullfile(base_dir, '3_database_epwe');
    
    % Criar diretorios se nao existirem
    if ~exist(source_dir, 'dir')
        mkdir(source_dir);
    end
    if ~exist(target_dir, 'dir')
        mkdir(target_dir);
    end
    
    % Aguardar um pouco para garantir que os arquivos foram escritos
    pause(0.2);
    
    % Padroes de arquivos a mover (seguindo exatamente o padrao das funcoes individuais)
    patterns = {
        sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_%g_epwe_real_w_data_gamma_x_path.csv', lattice_id, a_f, he_f, lattice_letter, fr_f),
        sprintf('%d_1_a_%.2f_h_%g_lattice_%s_res_%g_epwe_imag_w_data_gamma_x_path.csv', lattice_id, a_f, he_f, lattice_letter, fr_f),
        sprintf('%d_2_a_%.2f_h_%g_lattice_%s_res_%g_epwe_f_data_gamma_x_path.csv', lattice_id, a_f, he_f, lattice_letter, fr_f)
    };
    
    % Debug: mostrar padroes esperados
    fprintf('    Procurando arquivos com padroes:\\n');
    for idx = 1:length(patterns)
        fprintf('      %s\\n', patterns{idx});
    end
    
    % Procurar e mover arquivos
    for i = 1:length(patterns)
        file_in_current = fullfile(base_dir, patterns{i});
        file_in_source = fullfile(source_dir, patterns{i});
        target_file = fullfile(target_dir, patterns{i});
        
        moved = false;
        
        % Verificar se arquivo foi criado no diretorio atual
        if exist(file_in_current, 'file')
            try
                movefile(file_in_current, target_file);
                fprintf('    Movido do diretorio atual: %s\\n', patterns{i});
                moved = true;
            catch ME
                warning('Erro ao mover arquivo do diretorio atual %s: %s', patterns{i}, ME.message);
            end
        end
        
        % Se nao moveu ainda, verificar se arquivo esta no source_dir
        if ~moved && exist(file_in_source, 'file')
            try
                movefile(file_in_source, target_file);
                fprintf('    Movido do 1_database: %s\\n', patterns{i});
                moved = true;
            catch ME
                warning('Erro ao mover arquivo do source_dir %s: %s', patterns{i}, ME.message);
            end
        end
        
        % Se ainda nao encontrou, listar arquivos similares para debug
        if ~moved
            fprintf('    AVISO: Arquivo nao encontrado: %s\\n', patterns{i});
            fprintf('      Procurando arquivos similares...\\n');
            
            % Padroes mais gerais para busca
            search_patterns = {
                sprintf('*lattice_%s_res_%g*', lattice_letter, fr_f),
                sprintf('%d_*_res_%g*', lattice_id, fr_f),
                sprintf('*res_%g*epwe*', fr_f)
            };
            
            for search_pattern = search_patterns
                files_current = dir(fullfile(base_dir, search_pattern{1}));
                files_source = dir(fullfile(source_dir, search_pattern{1}));
                
                if ~isempty(files_current)
                    fprintf('        No diretorio atual: ');
                    for j = 1:min(3, length(files_current))
                        fprintf('%s ', files_current(j).name);
                    end
                    fprintf('\\n');
                end
                
                if ~isempty(files_source)
                    fprintf('        No 1_database: ');
                    for j = 1:min(3, length(files_source))
                        fprintf('%s ', files_source(j).name);
                    end
                    fprintf('\\n');
                end
            end
        end
    end
end