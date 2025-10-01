clear all
close all
clc
%%
% Parametros universais das Redes
%disp('Parametros universais das Redes')
%% Numero de ondas planas
%disp('Numero de ondas planas')
nmax_f = 3;
% % Intervalos para Bandas [Hz]
i_fi_f = 10;
i_ff_f = 100;
% Tamanho da rede [m]
%disp('Tamanho da rede [m]')
a_f = 1e-1;
% Espessura da placa [m]
%disp('Espessura da placa [m]')
he_f = 2e-3;
% Mod. Elasticidade [GPa]
%disp('Mod. Elasticidade [GPa]')
E_f = .86e9;
% Razão das massas da célula da placa
% massa do ressonador
%disp('Coef gamma')
gamma_f = 0.5;
% Densidade ?[kg/m³]
%disp('Densidade [kg/m³]')
ro_f = 600;
% Coef. de Poisson
% Frequência do ressonador
%disp('Coef. de Poisson')
ni_f = .39;
% Fator de Amortecimento do Ressonador ?
%disp('Fator de Amortecimento do Ressonador')
eta_p_f = 1e-2;
% Rigidez da Placa
%disp('Rigidez transversal da Placa [N/m]')
D = (E_f*(he_f^3))/(12*(1-(ni_f^2)));
% Defina o número de iterações do seu loop
num_iteracoes = 20;
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    func2_1_square_pwe_plot_line_data_gamma_x_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
toc
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Quadrada do PWE Gamma -> X Path atualizada!');
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    func2_2_rectangular_pwe_plot_line_data_gamma_x_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
toc
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Retangular do PWE Gamma -> X Path atualizada!');
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    func2_3_triangular_pwe_plot_line_data_gamma_x_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)   
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
toc
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Triangular do PWE Gamma -> X Path atualizada!');
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    func2_4_hexagonal_pwe_plot_line_data_gamma_x_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
toc
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Hexagonal do PWE Gamma -> X Path atualizada!');
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    func2_5_kagome_pwe_plot_line_data_gamma_x_path(nmax_f,i_fi_f,i_ff_f,a_f,he_f,E_f,gamma_f,ro_f,ni_f,fr_f,eta_p_f)
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
toc
% Fechar a barra de progresso quando o loop terminar
close(h);
disp('Base de dados da Rede Kagome do PWE Gamma -> X Path atualizada!');
