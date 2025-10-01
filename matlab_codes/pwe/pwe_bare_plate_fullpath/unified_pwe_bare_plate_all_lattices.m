function unified_pwe_bare_plate_all_lattices = pwe_unified_calculation(lattice_type, nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f)
%--------------------------------------------------------------------------
% UNIFIED_PWE_BARE_PLATE_ALL_LATTICES
%--------------------------------------------------------------------------
% Descricao: Funcao unificada para calcular a estrutura de bandas usando PWE
%            para placa lisa com diferentes tipos de rede cristalina
%
% Entrada:
%   lattice_type : Tipo de rede ('square', 'rectangular', 'triangular', 'hexagonal', 'kagome')
%   nmax_f       : Numero maximo de ondas planas (ordem de truncamento)
%   i_fi_f       : Frequencia inicial [Hz]
%   i_ff_f       : Frequencia final [Hz]
%   a_f          : Constante de rede da celula unitaria [m]
%   he_f         : Espessura da placa [m]
%   E_f          : Modulo de Young do material da placa [Pa]
%   gamma_f      : Razao de massa entre ressonador e celula unitaria
%   ro_f         : Densidade do material da placa [kg/m3]
%   ni_f         : Coeficiente de Poisson do material da placa
%   fr_f         : Frequencia do ressonador [Hz]
%   eta_p_f      : Fator de amortecimento da placa
%
% Saida:
%   unified_pwe_bare_plate_all_lattices : Status de execucao (1 = sucesso)
%
% Autor: [Seu nome]
% Data: [Data atual]
% Versao: 1.0
%--------------------------------------------------------------------------

% Validar tipo de rede
valid_lattices = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
if ~ismember(lattice_type, valid_lattices)
    error('Tipo de rede invalido. Use: square, rectangular, triangular, hexagonal ou kagome');
end

% Configuracoes especificas para cada tipo de rede
switch lattice_type
    case 'square'
        lattice_id = 1;
        % Parametros da rede quadrada
        a1 = a_f;
        a2 = a_f;
        b1 = 2*pi/a1;
        b2 = 2*pi/a2;
        % Vetores primitivos da rede direta
        v1 = [a1, 0];
        v2 = [0, a2];
        % Vetores primitivos da rede reciproca
        g1 = [b1, 0];
        g2 = [0, b2];
        % Pontos de alta simetria
        gamma_point = [0, 0];
        x_point = [pi/a1, 0];
        m_point = [pi/a1, pi/a2];
        
    case 'rectangular'
        lattice_id = 2;
        % Parametros da rede retangular
        a1 = a_f;
        a2 = 1.5*a_f;  % Razao de aspecto 1.5
        b1 = 2*pi/a1;
        b2 = 2*pi/a2;
        % Vetores primitivos
        v1 = [a1, 0];
        v2 = [0, a2];
        g1 = [b1, 0];
        g2 = [0, b2];
        % Pontos de alta simetria
        gamma_point = [0, 0];
        x_point = [pi/a1, 0];
        m_point = [pi/a1, pi/a2];
        
    case 'triangular'
        lattice_id = 3;
        % Parametros da rede triangular
        a1 = a_f;
        a2 = a_f;
        b1 = 4*pi/(sqrt(3)*a1);
        b2 = 2*pi/a2;
        % Vetores primitivos
        v1 = [a1, 0];
        v2 = [a1/2, sqrt(3)*a2/2];
        g1 = [b1, -b2/sqrt(3)];
        g2 = [0, 2*b2/sqrt(3)];
        % Pontos de alta simetria
        gamma_point = [0, 0];
        m_point = [pi/a1, 0];
        k_point = [4*pi/(3*a1), 0];
        
    case 'hexagonal'
        lattice_id = 4;
        % Parametros da rede hexagonal (honeycomb)
        a1 = a_f;
        a2 = a_f;
        b1 = 4*pi/(sqrt(3)*a1);
        b2 = 2*pi/a2;
        % Vetores primitivos
        v1 = [a1, 0];
        v2 = [a1/2, sqrt(3)*a2/2];
        g1 = [b1, -b2/sqrt(3)];
        g2 = [0, 2*b2/sqrt(3)];
        % Pontos de alta simetria
        gamma_point = [0, 0];
        m_point = [pi/a1, pi/(sqrt(3)*a2)];
        k_point = [4*pi/(3*a1), 0];
        
    case 'kagome'
        lattice_id = 5;
        % Parametros da rede kagome
        a1 = a_f;
        a2 = a_f;
        b1 = 4*pi/(sqrt(3)*a1);
        b2 = 2*pi/a2;
        % Vetores primitivos
        v1 = [a1, 0];
        v2 = [a1/2, sqrt(3)*a2/2];
        g1 = [b1, -b2/sqrt(3)];
        g2 = [0, 2*b2/sqrt(3)];
        % Pontos de alta simetria
        gamma_point = [0, 0];
        m_point = [pi/a1, pi/(sqrt(3)*a2)];
        k_point = [4*pi/(3*a1), 0];
end

%--------------------------------------------------------------------------
% PARAMETROS DO MATERIAL E GEOMETRIA
%--------------------------------------------------------------------------
h = he_f;           % Espessura da placa
E = E_f;            % Modulo de Young
rho = ro_f;         % Densidade
nu = ni_f;          % Coeficiente de Poisson
D = E*h^3/(12*(1-nu^2));  % Rigidez de flexao

% Area da celula unitaria
S = abs(v1(1)*v2(2) - v1(2)*v2(1));

% Massa da celula unitaria
m_cell = rho * h * S;

%--------------------------------------------------------------------------
% GERACAO DOS VETORES G DA REDE RECIPROCA
%--------------------------------------------------------------------------
n_max = nmax_f;
n1 = -n_max:n_max;
n2 = -n_max:n_max;

G = [];
for i = 1:length(n1)
    for j = 1:length(n2)
        G_temp = n1(i)*g1 + n2(j)*g2;
        G = [G; G_temp];
    end
end

num_G = size(G, 1);

%--------------------------------------------------------------------------
% DEFINICAO DO CAMINHO NO ESPACO K
%--------------------------------------------------------------------------
% Caminho completo na zona de Brillouin
if ismember(lattice_type, {'square', 'rectangular'})
    % Gamma -> X -> M -> Gamma
    k_path = [gamma_point; x_point; m_point; gamma_point];
else
    % Gamma -> M -> K -> Gamma (para redes triangular, hexagonal, kagome)
    k_path = [gamma_point; m_point; k_point; gamma_point];
end

% Numero de pontos por segmento
n_points_per_segment = 50;
k_points = [];

for i = 1:(size(k_path, 1) - 1)
    k_start = k_path(i, :);
    k_end = k_path(i+1, :);
    
    % Interpolacao linear
    k_x = linspace(k_start(1), k_end(1), n_points_per_segment);
    k_y = linspace(k_start(2), k_end(2), n_points_per_segment);
    
    if i < (size(k_path, 1) - 1)
        k_points = [k_points; [k_x(1:end-1)', k_y(1:end-1)']];
    else
        k_points = [k_points; [k_x', k_y']];
    end
end

num_k = size(k_points, 1);

%--------------------------------------------------------------------------
% CALCULO DA ESTRUTURA DE BANDAS
%--------------------------------------------------------------------------
fprintf('Calculando PWE para rede %s...\n', lattice_type);

% Inicializar matrizes de resultados
omega_bands = zeros(num_k, num_G);

% Loop sobre pontos k
for ik = 1:num_k
    kx = k_points(ik, 1);
    ky = k_points(ik, 2);
    
    % Construir matrizes K e M
    K = zeros(num_G, num_G);
    M = zeros(num_G, num_G);
    
    for i = 1:num_G
        % Matriz de rigidez
        k_G_x = kx + G(i, 1);
        k_G_y = ky + G(i, 2);
        K(i, i) = D * S * (k_G_x^2 + k_G_y^2)^2;
        
        % Matriz de massa
        M(i, i) = rho * h * S;
    end
    
    % Problema de autovalores generalizado
    [V, omega2] = eig(K, M);
    omega2 = diag(omega2);
    
    % Ordenar frequencias
    [omega2_sorted, idx] = sort(real(omega2));
    omega_bands(ik, :) = sqrt(abs(omega2_sorted));
end

% Converter para frequencia em Hz
freq_bands = omega_bands / (2*pi);

%--------------------------------------------------------------------------
% SALVAR RESULTADOS
%--------------------------------------------------------------------------
% Normalizar vetor de onda
k_norm = zeros(num_k, 1);
for ik = 2:num_k
    dk = norm(k_points(ik, :) - k_points(ik-1, :));
    k_norm(ik) = k_norm(ik-1) + dk;
end
k_norm = k_norm / k_norm(end);  % Normalizar para [0, 1]

% Gerar nomes de arquivo
label_file_w_kk = sprintf('%d_1_a_%.2f_h_%g_lattice_k_bare_pwe_w_data_full_path.csv', lattice_id, a_f, h);
label_file_freq = sprintf('%d_2_a_%.2f_h_%g_lattice_k_bare_pwe_f_data_full_path.csv', lattice_id, a_f, h);

% Escrever arquivos
writematrix(k_norm, label_file_w_kk);
writematrix(freq_bands, label_file_freq);

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

movefile(label_file_w_kk, database_dir);
movefile(label_file_freq, database_dir);

fprintf('Arquivos salvos em: %s\n', database_dir);
fprintf('  - %s\n', label_file_w_kk);
fprintf('  - %s\n', label_file_freq);

% Retornar status de sucesso
unified_pwe_bare_plate_all_lattices = 1;

end