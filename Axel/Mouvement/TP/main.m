clc;close all;clear variables;

%Parametres
dir = 'MiniCooper'; %Choix des images à traiter
lambda = 1; 
threshold = 1e-07; %Seuil pour critere d'arret
mean_filter = '9-voisinage'; %Choix du filtre moyenneur
nbr_images = 8; %Nombre d'images à traiter
display_step = 6; %Pas d'affichage du champ de vecteurs
im2display = 1;%Choix de l'image a afficher seule

for i = 1:nbr_images-1
    image1_f = [dir,'/i000',int2str(i),'.png'];  
    image2_f = [dir,'/i000',int2str(i+1),'.png'];      
    
    [u,v,H,W,I1,it] = motion_hs(image1_f,image2_f,lambda,mean_filter,threshold);
    it
    [X,Y] = meshgrid(1:W,1:H);
    figure(1)
    subplot(2,fix(nbr_images/2),i)
    imshow(I1,[])
    hold on
    quiver(X(1:display_step:H,1:display_step:W),Y(1:display_step:H,1:display_step:W),...
        u(1:display_step:H,1:display_step:W), v(1:display_step:H,1:display_step:W),5,'linewidth',0.5)
    title(sprintf('Flux optique entre les images %d et %d',i,i+1))
    if i == im2display 
        figure(2)
        imshow(I1,[])
        hold on
        quiver(X(1:display_step:H,1:display_step:W),Y(1:display_step:H,1:display_step:W),...
        u(1:display_step:H,1:display_step:W), v(1:display_step:H,1:display_step:W),5,'linewidth',0.5)
        title(sprintf('Flux optique entre les images %d et %d',i,i+1))
    end
end

    
