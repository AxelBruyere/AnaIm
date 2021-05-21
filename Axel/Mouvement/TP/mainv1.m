clc;close all,clear variables;

%Récupération des images
I1 = im2double(imread('MiniCooper/i0007.png'));
I2 = im2double(imread('MiniCooper/i0008.png'));
[H,W] = size(I1);
%Calcul des gradients
It = (I2 - I1);
[Ix,Iy] = imgradientxy(I1);


%Parametres
lambda = 1;
u = zeros(H,W);
v = zeros(H,W);
u_barre = u;
v_barre = v;


n = 2; %Choix du filtre : 1 pour 4-voisinage et 2 pour 9-voisinage
switch n
    case 1
        filtre = 1/4*[0,1,0;
                      1,0,1;
                      0,1,0];
    case 2
        filtre = 1/9*ones(3,3);
        filtre(2,2) = 0;
end

%Initialisation du critere d'arret
mean_ctrl_u = 10;
mean_ctrl_v = 10;
mean_u = 0;
mean_v = 0;

it = 0;%Compteur d'iterations
seuil = 1e-08; %Critere d'arret
while (abs(mean_ctrl_u - mean_u) > seuil || abs(mean_ctrl_v - mean_v) > seuil )
    it = it + 1;
        mean_ctrl_u = mean_u;
        mean_ctrl_v = mean_v;
        u_barre = imfilter(u,filtre);
        v_barre = imfilter(v,filtre);

        u = u_barre - Ix.*(Ix.*u_barre + Iy.*v_barre + It)./...
            (lambda^2+Ix.^2+Iy.^2);
        v = v_barre - Iy.*(Ix.*u_barre + Iy.*v_barre + It)./...
            (lambda^2+Ix.^2+Iy.^2);
        
        mean_u = mean(mean(u));
        mean_v = mean(mean(v));        
end


%%Affichage
figure(1) 
subplot 131
imshow(Ix,[])
title('Gradient selon x')
subplot 132
imshow(Iy,[])
title('Gradient selon y')
subplot 133
imshow(It,[])
title('Gradient temporel')

figure(2)
subplot 131
imshow(u,[])
subplot 132
imshow(v,[])
subplot 133
imshow(u+v)

[X,Y] = meshgrid(1:W,1:H);
pas = 4;%Pas d'affichage des vecteurs
figure(3)
imshow(I2,[])
hold on
quiver(X(1:pas:H,1:pas:W),Y(1:pas:H,1:pas:W),u(1:pas:H,1:pas:W), v(1:pas:H,1:pas:W),5,'linewidth',1)
% figure(4)
% subplot 121
% imshow(I1,[])
% subplot 122
% imshow(I2,[])



