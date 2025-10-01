clear all
close all
clc
% Parametros universais das Redes
% Intervalos para Bandas [Hz]
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
%disp('Coef gamma')
gamma_f = 0.5;
% Densidade [kg/m^3]
% disp('Densidade [kg/m^3]')
ro_f = 600;
% Coef. de Poisson
%disp('Coef. de Poisson')
ni_f = .39;
% Fator de Amortecimento do Ressonador ?
%disp('Fator de Amortecimento do Ressonador')
eta_p_f = 1e-2;
% Defina o número de iterações do seu loop
num_iteracoes = 15;
%%
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
disp('Atualizando a Base de dados da Rede Quadrada do EPWE');
for i=1:num_iteracoes
    fr_f = 10*i;
    %Registre o tempo inicial
    tempo_inicial = tic;
    func3_1_square_epwe_plot_line_data(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)    
    % Registre o tempo após a conclusão do loop
    tempo_final = toc(tempo_inicial);
    %Armazene o tempo decorrido na matriz
    tempos(i) = tempo_final;  
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
disp('Base de dados da Rede Quadrada do EPWE atualizada!');
tempo_medio = .95*mean(tempos);
tempos.'
fprintf('Tempo médio gasto com o loop: %.4f segundos\n', tempo_medio);

%%
disp('Atualizando a Base de dados da Rede Retangular do EPWE');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tempos = zeros(1, num_iteracoes);
for i=1:num_iteracoes
    % Registre o tempo inicial
    tempo_inicial = tic;
    fr_f = 10*i;  
    func3_2_rectangular_epwe_plot_line_data(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)
        % Registre o tempo após a conclusão do loop
    tempo_final = toc(tempo_inicial);
    % Armazene o tempo decorrido na matriz
    tempos(i) = tempo_final;
    pause(0.1);
    % Atualize a barra de progresso
    progresso = i / num_iteracoes;
    waitbar(progresso, h, sprintf('Progresso: %.1f%%', progresso*100));
    % Exiba o tempo decorrido em segundos
    tempo_decorrido = toc;
    update_text = sprintf('Progresso: %.1f%% - Tempo: %.1f segundos', progresso*100, tempo_decorrido);
    waitbar(progresso, h, update_text);
end
% Calcule a média dos tempos decorridos
close(h);
disp('Base de dados da Rede Retangular do EPWE atualizada!');
tempo_medio = .95*mean(tempos);
tempos.'
fprintf('Tempo médio gasto com o loop: %.4f segundos\n', tempo_medio);
% Fechar a barra de progresso quando o loop terminar
% %%
disp('Atualizando a Base de dados da Rede Triangular do EPWE');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %Registre o tempo inicial
    tempo_inicial = tic;
    func3_3_triangular_epwe_plot_line_data(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)
    % Registre o tempo após a conclusão do loop
    tempo_final = toc(tempo_inicial);
    %Armazene o tempo decorrido na matriz
    tempos(i) = tempo_final;  
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
disp('Base de dados da Rede Triangular do EPWE atualizada!');
tempo_medio = .95*mean(tempos);
tempos.'
fprintf('Tempo médio gasto com o loop: %.4f segundos\n', tempo_medio);
%% Inicialize a barra de progresso
disp('Atualizando a Base de dados da Rede Hexagonal do EPWE');
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %Registre o tempo inicial
    tempo_inicial = tic;
    func3_4_honeycomb_epwe_plot_line_data(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)
    %Registre o tempo após a conclusão do loop
    tempo_final = toc(tempo_inicial);
    %Armazene o tempo decorrido na matriz
    tempos(i) = tempo_final;
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
disp('Base de dados da Rede Hexagonal do EPWE atualizada!');
tempo_medio = .95*mean(tempos);
tempos.'
fprintf('Tempo médio gasto com o loop: %.4f segundos\n', tempo_medio);

%%
disp('Atualizando a Base de dados da Rede Kagome do EPWE');
% Inicialize a barra de progresso
h = waitbar(0, 'Progresso: 0%');
% Inicialize o temporizador
tic
for i=1:num_iteracoes
    fr_f = 10*i;
    %Registre o tempo inicial
    tempo_inicial = tic;
    func3_5_kagome_epwe_plot_line_data(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)
    %Registre o tempo após a conclusão do loop
    tempo_final = toc(tempo_inicial);
    %Armazene o tempo decorrido na matriz
    tempos(i) = tempo_final;
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
disp('Base de dados da Rede Kagome do EPWE atualizada!');
tempo_medio = .95*mean(tempos);
tempos.'
fprintf('Tempo médio gasto com o loop: %.4f segundos\n', tempo_medio);
