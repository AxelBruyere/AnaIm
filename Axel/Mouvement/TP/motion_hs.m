function [u,v,H,W,I1,it] = motion_hs(image1,image2,lambda,mean_filter,threshold)
%Parametres d'entree :
%   image1 -> adresse de la premiere image
%   image2 -> adresse de la seconde image
%   lambda
%   mean-filter -> choix du filtre moyenneur 
%   threshold -> critere d'arret

%Parametres de sortie : 
%   -(u,v) -> le flux optique
%   -(H,W) les dimensions des images
%   -it -> nombre d'iterations faites

%Récupération des images
I1 = im2double(imread(image1));
I2 = im2double(imread(image2));
[H,W] = size(I1);

%Calcul des gradients
It = (I2 - I1);
[Ix,Iy] = imgradientxy(I1);

%Initialisation de (u,v) et (u\,v\)
u = zeros(H,W);
v = zeros(H,W);
u_barre = u;
v_barre = v;

%Creation du filtre moyenneur
switch mean_filter
    case '4-voisinage'
        filtre = 1/4*[0,1,0;
                      1,0,1;
                      0,1,0];
    case '9-voisinage'
        filtre = 1/9*ones(3,3);
        filtre(3,3) = 0;
    case'25-voisinage'
        filtre = 1/25 * ones(5,5);
        filtre(5,5) = 0;
end

%Initialisation du critere d'arret
mean_ctrl_u = 10;
mean_ctrl_v = 10;
mean_u = 0;
mean_v = 0;

it = 0;%Compteur d'iterations

%Calcul du flux optique
while (abs(mean_ctrl_u - mean_u) > threshold || abs(mean_ctrl_v - mean_v) > threshold )
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