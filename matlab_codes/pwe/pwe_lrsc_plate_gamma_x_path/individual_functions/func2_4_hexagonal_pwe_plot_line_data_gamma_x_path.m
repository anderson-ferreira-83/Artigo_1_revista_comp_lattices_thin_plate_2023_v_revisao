function lattice4_honeycomb_plot_scatter_no_norm_vt = honeycomb_dispersion(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
%disp('Parametros - Rede Honeycomb')
im = sqrt(-1);
%% Numero de ondas planas
nmax = nmax_f;
%% Discretizacao para curva de dispersao
nk = .125e3;
% Intervalos para Bandas em funcao do Numero de onda
i_bdi = 0;
i_bdf = 5;
%% Intervalos para Bandas em funcao da Frequencia
i_fi = i_fi_f;
i_ff = i_ff_f;
%% Parametros Xiao 2012 - Sound Transmisison Loss - Ref [2]
% Numero imaginario
im=sqrt(-1);
% size= 2*nmax+1
n1=(-nmax:nmax);
a1 = a_f;
a2 = a1 ;
lat_a = a1;
E = E_f;
h = he_f;
ni = ni_f;
ro = ro_f;
gamma = gamma_f;
% Fator de Amortecimento do Ressonador
eta_p = eta_p_f;
eta_r  = eta_p;
% Rigidez da Placa
D = (E*(h^3))/(12*(1-(ni^2)));
%disp('Frequencia de Bragg [Hz]')
%f_B = (1/(2*pi))*((pi/a_f)^2)*sqrt(D/(ro_f*he_f))
% Area da Celula Unitaria
%disp('Area da Celula unitaria [m²]')
S = (lat_a^2)*(3*sqrt(3)/2);
%% Parametros Ressoanadores
% Selecao de frequencia dos Ressonadores
fr = [fr_f]*[1 1];
% Numero de ressonadores
%disp('Número de ressonadores')
N = length(fr);
% Calculo das frequencias angulares
omega_r2 = [(2.*pi.*fr)];
% Posicao do ressonador na celula
%disp('Posicao do ressonador na celula [m]')
%disp('r_j = [x_i  y_i] [m]')
r_j = lat_a*[0 1/2;0 -1/2];
% Massa do Ressonador
%disp('Massa do ressonador na celula [kg]')
m_R = gamma*ro*S*h./N;
%m_R = gamma*ro*S*h;
if N(1)==0
    m_R(1)=0;
end
% Calculo dos Vetores
%Vetores de indice G:
% Vetor que armazena os indices Gis
G = [];
for i=-nmax:nmax
    for j=-nmax:nmax
        G = [G;(i-j)*((2*pi)/(a1*sqrt(3))) (i+j)*((2*pi)/(a1*sqrt(3)))*(1/sqrt(3))];
    end
end
% Trajetorias
gamma   = [0 0];
X       = (pi/lat_a)*[4/(3*sqrt(3))     0];
M       = (pi/lat_a)*[1/sqrt(3)         1/3];
X_l     = (pi/lat_a)*[2*sqrt(3)/9       2/3];
M_l     = (pi/lat_a)*[0                 2/3];
%----------------------
path0 = [gamma;    X;   M;     X_l;     M_l];
pathf = [X;        M;   X_l;   M_l;     gamma];

freq = [];
w_kk = [];

cont_plot=1;
for bd=1:1
    cont=1;
    k_0 = path0(bd,:);
    k_f = pathf(bd,:);
    dk = (k_f-k_0)./nk;
    for w=1:length(N)
        kk=k_0;
        for  ik=0:nk
            kx = kk(1);
            ky = kk(2);
            % Vetor que armazena os elementos da Matriz de Rigidez "K"
            K = eye(length(n1)^2);
            % Vetor que armazena os elementos da Matriz de Massa "M"
            M = eye(length(n1)^2);
            % Criacao do vetor que armazena os elementos da Matriz Eq (19)
            k_r_j = [];
            for j=1:N(w)
                % Calculo da Eq (19)
                k_r_j(j) = m_R(cont)/(1/((omega_r2(j).^2)*(1+im*eta_r)));
            end
            if N(w)==0
                D_r_j = 0;
            end
            for i=1:(length(n1)^2)
                %Calcula K
                K(i,i) = D*S*((kx + G(i,1))^2 + (ky + G(i,2))^2)^2;
                % Massa da Placa
                M(i,i)= ro*h*S;
            end
            P = zeros(length(n1)^2,N);
            P_t = zeros(length(n1)^2,N).';
            U = zeros(length(n1)^2);
            for k = 1:N(w)
                for i=1:(length(n1)^2)
                    P(i,k) = exp ( im *( G(i,1)*r_j(k,1) + G(i,2)*r_j(k,2) ) );
                    P_t(k,i) = exp (-im *( G(i,1)*r_j(k,1) + G(i,2)*r_j(k,2) ) );
                end
                % Rigidez dos ressonadores tem que estar fora do primeiro loop
                U = U + k_r_j(k)*P(:,k)*P_t(k,:);
            end
            A_n = zeros(length(n1)^2+(N(w)));
            A_n(1:length(n1)^2,1:length(n1)^2) = M;
            A_d =zeros(length(n1)^2 + N(w));
            A_d(1:length(n1)^2,1:length(n1)^2) = K + U;
            if N ~= 0
                for i=1:N
                    % Inclusao das Massas dos Ressonadores individuais
                    A_n(length(n1)^2+i,length(n1)^2+i)= m_R(cont);
                    % Inclus?o dos vetores com produto dos Ressonadores individuais
                    A_d(1:length(n1)^2,length(n1)^2+i)= -k_r_j(i)*P(:,i);
                    A_d(length(n1)^2+i,1:length(n1)^2)= -k_r_j(i)*P_t(i,:);
                    % Inclusao da Rigidez dos Ressonadores individuais
                    A_d(length(n1)^2+i,length(n1)^2+i)=  k_r_j(i);
                end
            end
            % Obtencao dos autovalores e autofrequencias
            [V1, D1] = eig(A_n \ A_d);
            % Ordenando as auto frequencias [rad/s]
            [omega_sorted, idx] = sort(sqrt(diag(D1)));
            % Ordenando os auto vetores atraves das respectivas
            % autofrequencias
            V_sorted = V1(:, idx);
            %---------------------------------------------------------
            % Preenchimento da Matriz das auto-frequencias 'f_ij':
            % i = (length(n1)^2+N) -> Numero de linhas
            % j = ((bd=3)*N*lenght(0:nk)) -> Discretizacao da FIBZ
            % Valor real das auto-frequencias em [Hz]
            freq(:,cont_plot) = real((abs(omega_sorted))./(2*pi));
            %---------------------------------------------------------
            % Preenchimento da Matriz dos numeros de ondas  '(w_kk)_ij':
            % i = (length(n1)^2+N) -> Numero de linhas
            % j = ((bd=3)*N*lenght(0:nk)) -> Discretizacao da FIBZ
            for i=1:length(n1)^2 + N;
                w_kk(i,cont_plot) =(lat_a/(2*pi))*sqrt((kx)^2 + (ky)^2);
            end
            %---------------------------------------------------------
            kk = kk + dk;
            % Contador para preechimentos das colunas das matrizes
            % de 'w_kk'(numero de onda) e das auto-frequencias 'freq'
            cont_plot = cont_plot + 1;
        end
    end
end
%%
label_file_w_kk = sprintf('4_1_a_%.2f_h_%g_lattice_h_res_%g_pwe_w_data_gamma_x_path.csv',lat_a,h,fr(1));
writematrix(w_kk,label_file_w_kk);
sourceFilePath = fullfile(pwd,label_file_w_kk);
targetDirectory = strcat(pwd,'\1_database');
movefile(sourceFilePath, targetDirectory);

label_file_freq = sprintf('4_2_a_%.2f_h_%g_lattice_h_res_%g_pwe_f_data_gamma_x_path.csv',lat_a,h,fr(1));
writematrix(freq,label_file_freq);
sourceFilePath = fullfile(pwd,label_file_freq);
targetDirectory = strcat(pwd,'\1_database');
movefile(sourceFilePath, targetDirectory);
end
