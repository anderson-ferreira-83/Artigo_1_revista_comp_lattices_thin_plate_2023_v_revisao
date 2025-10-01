function unified_pwe_lrsc_plate_all_lattices = pwe_lrsc_unified_calculation(lattice_type, nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f)
%--------------------------------------------------------------------------
% UNIFIED_PWE_LRSC_PLATE_ALL_LATTICES
%--------------------------------------------------------------------------
% Descricao: Funcao unificada para calcular a estrutura de bandas usando PWE
%            para placa com ressonadores locais (LRSC) com diferentes tipos 
%            de rede cristalina
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
%   unified_pwe_lrsc_plate_all_lattices : Status de execucao (1 = sucesso)
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

% Numero complexo unitario
im = sqrt(-1);

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
        % Posicao do ressonador na celula unitaria
        r_res = [a1/2, a2/2];
        N_res = 1;  % Numero de ressonadores por celula
        
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
        % Posicao do ressonador
        r_res = [a1/2, a2/2];
        N_res = 1;
        
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
        % Posicao do ressonador
        r_res = [(v1(1) + v2(1))/3, (v1(2) + v2(2))/3];
        N_res = 1;
        
    case 'hexagonal'
        lattice_id = 4;
        % Parametros da rede hexagonal
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
        % Posicoes dos ressonadores (2 por celula para honeycomb)
        r_res = [0, 0; 2*a1/3, 0];
        N_res = 2;
        
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
        % Posicoes dos ressonadores (3 por celula para kagome)
        r_res = [0, 0; a1/2, 0; a1/4, sqrt(3)*a2/4];
        N_res = 3;
end

%--------------------------------------------------------------------------
% PARAMETROS DO MATERIAL E GEOMETRIA
%--------------------------------------------------------------------------
h = he_f;           % Espessura da placa
E = E_f;            % Modulo de Young
rho = ro_f;         % Densidade
nu = ni_f;          % Coeficiente de Poisson
D = E*h^3/(12*(1-nu^2));  % Rigidez de flexao
eta_r = eta_p_f;    % Amortecimento do ressonador

% Area da celula unitaria
S = abs(v1(1)*v2(2) - v1(2)*v2(1));

% Massa da celula unitaria
m_cell = rho * h * S;

% Massa do ressonador
m_R = gamma_f * m_cell / N_res;

% Frequencia angular do ressonador
omega_r = 2 * pi * fr_f;

% Rigidez do ressonador
k_r = m_R * omega_r^2;

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
% CALCULO DA ESTRUTURA DE BANDAS COM RESSONADORES
%--------------------------------------------------------------------------
fprintf('Calculando PWE-LRSC para rede %s com fr = %.1f Hz...\n', lattice_type, fr_f);

% Inicializar matrizes de resultados
omega_bands = zeros(num_k, num_G + N_res);

% Loop sobre pontos k
for ik = 1:num_k
    kx = k_points(ik, 1);
    ky = k_points(ik, 2);
    
    % Construir matrizes K e M para placa
    K_plate = zeros(num_G, num_G);
    M_plate = zeros(num_G, num_G);
    
    for i = 1:num_G
        % Matriz de rigidez da placa
        k_G_x = kx + G(i, 1);
        k_G_y = ky + G(i, 2);
        K_plate(i, i) = D * S * (k_G_x^2 + k_G_y^2)^2;
        
        % Matriz de massa da placa
        M_plate(i, i) = rho * h * S;
    end
    
    % Matrizes de acoplamento placa-ressonador
    P = zeros(num_G, N_res);
    P_t = zeros(N_res, num_G);
    U = zeros(num_G, num_G);
    
    % Calcular matrizes de fase
    for j = 1:N_res
        for i = 1:num_G
            % Fator de fase exp(i*G*r_j)
            phase = exp(im * (G(i,1)*r_res(j,1) + G(i,2)*r_res(j,2)));
            P(i,j) = phase;
            P_t(j,i) = conj(phase);
        end
    end
    
    % Matriz de rigidez efetiva com ressonadores
    for j = 1:N_res
        k_r_j = k_r / (1 + im*eta_r);
        U = U + k_r_j * P(:,j) * P_t(j,:);
    end
    
    % Construir matrizes globais do sistema acoplado
    size_total = num_G + N_res;
    K_total = zeros(size_total, size_total);
    M_total = zeros(size_total, size_total);
    
    % Preencher blocos da matriz
    K_total(1:num_G, 1:num_G) = K_plate + U;
    M_total(1:num_G, 1:num_G) = M_plate;
    
    % Termos de acoplamento
    for j = 1:N_res
        k_r_j = k_r / (1 + im*eta_r);
        
        % Acoplamento placa-ressonador
        K_total(1:num_G, num_G+j) = -k_r_j * P(:,j);
        K_total(num_G+j, 1:num_G) = -k_r_j * P_t(j,:);
        
        % Rigidez e massa do ressonador
        K_total(num_G+j, num_G+j) = k_r_j;
        M_total(num_G+j, num_G+j) = m_R;
    end
    
    % Problema de autovalores generalizado
    [V, omega2] = eig(K_total, M_total);
    omega2 = diag(omega2);
    
    % Ordenar frequencias
    [omega2_sorted, idx] = sort(real(omega2));
    omega_bands(ik, :) = sqrt(abs(omega2_sorted));
end

% Converter para frequencia em Hz
freq_bands = real(omega_bands) / (2*pi);

% Selecionar apenas as bandas relevantes (primeiras num_G bandas)
freq_bands = freq_bands(:, 1:num_G);

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

% Gerar nomes de arquivo com frequencia do ressonador
label_file_w_kk = sprintf('%d_1_a_%.2f_h_%g_lattice_k_res_%g_pwe_lrsc_w_data_full_path.csv', ...
    lattice_id, a_f, h, fr_f);
label_file_freq = sprintf('%d_2_a_%.2f_h_%g_lattice_k_res_%g_pwe_lrsc_f_data_full_path.csv', ...
    lattice_id, a_f, h, fr_f);

% Escrever arquivos
writematrix(k_norm, label_file_w_kk);
writematrix(freq_bands, label_file_freq);

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

movefile(label_file_w_kk, database_dir);
movefile(label_file_freq, database_dir);

fprintf('Arquivos salvos em: %s\n', database_dir);
fprintf('  - %s\n', label_file_w_kk);
fprintf('  - %s\n', label_file_freq);

% Retornar status de sucesso
unified_pwe_lrsc_plate_all_lattices = 1;

end