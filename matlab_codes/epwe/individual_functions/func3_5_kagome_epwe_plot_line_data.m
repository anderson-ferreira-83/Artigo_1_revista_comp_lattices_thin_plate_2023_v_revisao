function func3_5_kagome_epwe_plot_line_data = kagome_dispersion(a_f,he_f,E_f,gamma_f,ro_f,ni_f,eta_p_f,fr_f)

num_Eigenvals = 3;                                 
nmax = 2;                     
n1 = (-nmax:nmax);   
n2 = (-floor((2*nmax+1)^2/2):floor((2*nmax+1)^2/2)); 
im = sqrt(-1); 

im = sqrt(-1);
a1 = a_f;
a2 = a1;
lat_a = a1;
h = he_f;
S = 2*sqrt(3)*lat_a^2;
eta_p = eta_p_f;                          % eta_p=.0;
E = E_f*(1+im*eta_p);
ni = ni_f;
ro = ro_f;
Nr = 3;
rjx = [-lat_a/2 lat_a/2 sqrt(3)*lat_a/3];  
rjy =[-sqrt(3)*lat_a/6 -sqrt(3)*lat_a/6 0];  
gamma = gamma_f*[1/Nr 1/Nr 1/Nr];
mr = gamma*ro*h*S;
D = E*h^3/(12*(1-ni^2));
eta_r = eta_p;                          % eta_r=.0005; 
fr = fr_f*[1 1 1];
kr=mr.*(2*pi*fr).^2*(1+im*eta_r);

N=length(n1);
Lp=2*pi/lat_a;
K=zeros(N^2,N^2);

Np=4096*3;
T=10;
df=1/T;
f=0:df:(Np/2-1)*df;

fi_ref=0;
counter=1;
tic
for kk=2:length(f)
    w=2*pi*f(kk);
    
    % Maneira 1 de calcular as matrizes K0, K1, K2 e K3
    
    c4=0;
    phi=0;                       % phi=atan(1/sqrt(3));  phi=pi/6; phi=pi/5; phi=pi/4; 
    b11=pi/lat_a;
    b12=pi/lat_a*(1/sqrt(3));
    b21=-pi/lat_a;
    b22=pi/lat_a*(1/sqrt(3));
    for i=1:N
        ep0=(((n1(i)*b11*eye(length(n1))+diag(n1*b21))*lat_a).^2)+(((n1(i)*b12*eye(length(n1))+diag(n1*b22))*lat_a).^2);
        ep1=2*((n1(i)*b11*eye(length(n1))+diag(n1*b21))*lat_a*cos(phi)+(n1(i)*b12*eye(length(n1))+diag(n1*b22))*lat_a*sin(phi));
        X0(1+c4:N+c4,1+c4:N+c4)=ep0.^2;
        X1(1+c4:N+c4,1+c4:N+c4)=2*ep0.*ep1;
        X2(1+c4:N+c4,1+c4:N+c4)=2*ep0+ep1.^2;
        X3(1+c4:N+c4,1+c4:N+c4)=2*ep1;
        for j=1:Nr
            Ej(1+c4:N+c4,j)=exp(-im*(((n1(i)*b11*ones(length(n1),1)+(n1.')*b21)*rjx(j)+(n1(i)*b12*ones(length(n1),1)+(n1.')*b22)*rjy(j))));
            Ejl(j,1+c4:N+c4)=exp(im*(((n1(i)*b11*ones(length(n1),1)+(n1.')*b21)*rjx(j)+(n1(i)*b12*ones(length(n1),1)+(n1.')*b22)*rjy(j))));
%             Hj(1+c4:N+c4,1+c4:N+c4)=exp(-im*(((n1(i)*b11*ones(length(n1),1)+(n1.')*b21)*rjx(j)+(n1(i)*b12*ones(length(n1),1)+(n1.')*b22)*rjy(j))))*(exp(im*(((n1(i)*b11*ones(length(n1),1)+(n1.')*b21)*rjx(j)+(n1(i)*b12*ones(length(n1),1)+(n1.')*b22)*rjy(j))))).';
            Dj(j)=kr(j)-kr(j)^2/(kr(j)-w^2*mr(j));
            Djb(j)=Dj(j)./(D*S/(lat_a)^4);
%             Dr(1+c4:N+c4,1+c4:N+c4)=Dr(1+c4:N+c4,1+c4:N+c4)+Dj*Hj(1+c4:N+c4,1+c4:N+c4);
%             Drb(1+c4:N+c4,1+c4:N+c4)=Drb(1+c4:N+c4,1+c4:N+c4)+Djb*Hj(1+c4:N+c4,1+c4:N+c4);
        end
        c4=c4+N;
    end
    Dr=0;
    for j=1:Nr
        Dr=Dr+Djb(j)*Ej(:,j)*Ejl(j,:);
    end
    
    % Maneira 2 de calcular as matrizes K0, K1, K2 e K3
    
%     ep0=diag(diag(((b11*nx+b21*ny)*lat_a).^2+((b12*nx+b22*ny)*lat_a).^2));
%     ep1=2*(diag(diag(((b11*nx+b21*ny)*lat_a*cos(phi))+((b12*nx+b22*ny)*lat_a*sin(phi))))); 
%     X0=ep0.^2; X1=2*ep0.*ep1; X2=2*ep0+ep1.^2; X3=2*ep1;
%     K0=X0; K1=X1; K2=X2; K3=X3;
    
    K0=X0; K1=X1; K2=X2; K3=X3;
    A1=K1; A2=K2; A3=K3;
    kbp4=ro*h*S*w^2/(D*S/(lat_a^4));
    A0=K0-kbp4*eye(length(n2))+Dr;
    M=[-A3 -A2 -A1 -A0;eye(length(n2)) zeros(N^2) zeros(N^2) zeros(N^2);zeros(N^2) eye(length(n2)) zeros(N^2) zeros(N^2);zeros(N^2) zeros(N^2) eye(length(n2)) zeros(N^2)];
    A=M;                                                             
    [V1,D2]=eig(M);
    qb=diag(D2);    
    [qb,ind1]=sort(qb);
    V2=V1(:,ind1);
    Norm=sqrt(real(diag(diag(V2'*V2))));
    V=V2/Norm;
    InAAmeu=zeros(1,length(qb));
    if kk>2; 
        for ii=1:length(qb); 
            s=fi_ref(:,ii)'*V;
            [AAmeu,inAAmeu]=max(abs(s));
            InAAmeu(ii)=inAAmeu;
            aux=V(:,ii);
            V(:,ii)=V(:,InAAmeu(ii));
            V(:,InAAmeu(ii))=aux;
            auxV=qb(ii);
            qb(ii)=qb(InAAmeu(ii));
            qb(InAAmeu(ii))=auxV;
        end
    end
    fi_ref=V;
    neig=4*N^2;   
    q(:,counter)=(((qb(1:neig)))./lat_a); 
    counter=counter+1;     
end
toc

vecii=[];
for ii=1:length(qb)
    for kk=2:size(q,2)
        if real(q(ii,kk))*lat_a/2/pi>=-.5 && real(q(ii,kk))*lat_a/2/pi<=.5  % real(q(ii,kk))*lat_a/2/pi>=1e-3 && real(q(ii,kk))*lat_a/2/pi<=.5
            vecii=[vecii;ii];
        end
    end
end
veciic=unique(vecii);

q_vec = q(veciic,:)*lat_a/2/pi;

label_file_q = sprintf('5_1_a_%.2f_h_%g_lattice_k_res_%g_epwe_real_w_data_gamma_x_path.csv',a1,h,fr);
writematrix(real(q(:,:)*lat_a/2/pi),label_file_q);
%writematrix(real(q_vec(:,:)),label_file_q);
sourceFilePath = fullfile(pwd,label_file_q);
targetDirectory = fullfile(pwd, '1_database');
movefile(sourceFilePath, targetDirectory);

label_file_q = sprintf('5_1_a_%.2f_h_%g_lattice_k_res_%g_epwe_imag_w_data_gamma_x_path.csv',a1,h,fr);
writematrix(imag(q(:,:)*lat_a/2/pi),label_file_q);
%writematrix(imag(q_vec(:,:)),label_file_q);
sourceFilePath = fullfile(pwd,label_file_q);
targetDirectory = fullfile(pwd, '1_database');
movefile(sourceFilePath, targetDirectory);

label_file_f = sprintf('5_2_a_%.2f_h_%g_lattice_k_res_%g_epwe_f_data_gamma_x_path.csv',a1,h,fr);
writematrix(f(2:end),label_file_f);
sourceFilePath = fullfile(pwd,label_file_f);
targetDirectory = fullfile(pwd, '1_database');
movefile(sourceFilePath, targetDirectory);
end

