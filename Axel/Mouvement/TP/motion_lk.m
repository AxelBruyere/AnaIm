function [u,v,H,L,I1] = motion_lk(image1,image2,n,mu,sigma,img,nbr_images)

%Parametres d'entree
%    - image1 -> adresse de la premiere image
%    - image2 -> adresse de la seconde image
%    - n -> taille du voisinage considere
%    - mu,sigma -> parametres de la gaussienne pour le poids des voisins
%    - img -> numero de la première image courante
%    - nbr_images -> nombre d'images a traiter 
    
%Parametres de sortie
%   - (u,v) -> le flux optique
%   - (H,W) -> dimensions des images

%Récupération des images
I1 = im2double(imread(image1));
I2 = im2double(imread(image2));
[H,L] = size(I1);

%Calcul des gradients
It = I2-I1;
[Ix,Iy] = imgradientxy(I1);

%Poids des voisins
wt = linspace(-1,1,n*n);
w = 1/(sqrt(2*pi)*sigma)*exp(-(wt-mu).^2/(2*sigma^2));
W = diag(w);
W2 = W^2; %Calcul de W^2 hors de la boucle (temps d'exécution)


%Initialisation de (u,v)
u = zeros(H,L);
v = zeros(H,L);

k = n-fix(n/2)-1;%Variable pour le dimensionnement
iter = 0;
for i = 1+k:H-k
    for j = 1+k:L-k
        iter = iter + 1;

        %Vectorisation des gradients (1*n^2)
        gt = reshape(It(i-k:i+k,j-k:j+k),[],1);
        gx = reshape(Ix(i-k:i+k,j-k:j+k),[],1);
        gy = reshape(Iy(i-k:i+k,j-k:j+k),[],1);
        
        %Matrices A et b
        A = [gx,gy];
        b = -gt;
        
        %Matrice M
        M = [sum((w(:).^2).*(gx(:).^2)),sum((w(:).^2).*gx(:).*gy(:));
             sum((w(:).^2).*gx(:).*gy(:)),sum((w(:).^2).*(gy(:).^2))];
         
        uv = pinv(M)*A'*W2*b;
        u(i,j) = uv(1);
        v(i,j) = uv(2);
        if rem(iter,5000) == 0
            it_disp = ['Iteration',int2str(iter),'/',int2str((H-2*k)*(L-2*k)+1),...
            ' -> Image ',int2str(img),'/',int2str(nbr_images - 1)]
        end
    end
end
it_disp = ['Iteration',int2str((H-2*k)*(L-2*k)+1),'/',int2str((H-2*k)*(L-2*k)+1),...
            ' -> Images ',int2str(img),'-',int2str(img+1)]
