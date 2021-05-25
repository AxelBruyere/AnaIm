clc;close all;clear variables;

%%Parametres
nbr_images = 2; %Nombre d'images à traiter
dir = 'MiniCooper'; %Choix des images à traiter
method = 'LK'; %Choix de l'algorithme ('HS' pour Horn et Schunk, 'LK' pour 
                                                          %Lucas et Kanade

%Parametres de l'algorithme de Horn et Schunk
lambda = 1; 
threshold = 1e-07; %Seuil pour le critere d'arret
mean_filter = '9-voisinage'; %Choix du filtre moyenneur

%Parametres de l'algorithme de Lucas et Kanade
n = 25;      %Dimensions du voisinage (matrice n * n, n impair pour centrer le pixel courant)
mu = 0; sigma = 1; %Parametre de la gaussienne (poids des voisins)

%Parametres d'affichage
display_step = 6; %Pas d'affichage du champ de vecteurs
im2display = 2;%Choix de l'image a afficher seule (affiche le mouvement 
               %entre les images i et i+1)


for i = 1:nbr_images-1
    image1_f = [dir,'/i000',int2str(i),'.png'];  
    image2_f = [dir,'/i000',int2str(i+1),'.png'];      

%%Estimation du flux
    switch method
        case 'HS'
            [u,v,H,W,I1,it] = motion_hs(image1_f,image2_f,lambda,mean_filter,threshold);
        case 'LK'
            [u,v,H,W,I1] = motion_lk(image1_f,image2_f,n,mu,sigma);
    end

    
%%Affichage
    [X,Y] = meshgrid(1:W,1:H);
    figure(1)
    subplot(2,fix(nbr_images/2),i)
    imshow(I1,[])
    hold on
    quiver(X(1:display_step:H,1:display_step:W),Y(1:display_step:H,1:display_step:W),...
        u(1:display_step:H,1:display_step:W), v(1:display_step:H,1:display_step:W),5,'linewidth',0.5)
    title(sprintf('Flux optique entre les images %d et %d',i,i+1))
     if i == im2display 
        figure(10)
        imshow(I1,[])
        hold on
        quiver(X(1:display_step:H,1:display_step:W),Y(1:display_step:H,1:display_step:W),...
        u(1:display_step:H,1:display_step:W), v(1:display_step:H,1:display_step:W),5,'linewidth',0.5)
        title(sprintf('Flux optique entre les images %d et %d',i,i+1))
     end
end
   
