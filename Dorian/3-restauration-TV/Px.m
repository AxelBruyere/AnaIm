clear variables; close all; clc;
%% Resolution de Px
% f(x) = 0.5*(H*x-Z).^2 + 0.5*mu*(D*x-Y).^2;

%Image etoile
I = im2double(rgb2gray(imread('etoile_z.png')));

X = randn(size(I));  
Y = D(I);  Y = 0.5*(Y(:,:,1)+Y(:,:,2)); Y = ones(size(Y));
Z = I;
x = X(:); y = Y(:); z = Z(:);

%Fonctions et parametres
ker = 'gaussian';
mu = 0.1; 
f = @(x) 0.5*(H(x,ker,7)-z).^2 + 0.5*mu*(D(x)-y).^2;
grad = @(x) Hadj(H(x,ker,3)-z,ker,3) + mu*Dadj(D(x)-y);

%Descente de gradient
k = 0; pas = 0.7;
aim = 1.0e-04; max_it = 200;

while (norm(grad(x))>aim && k<max_it)
    x = x - pas*grad(x);
    k = k + 1;
end




%%Affichage
figure(1)
subplot(221)
imshow(I,[]);
title('Observation z');
subplot(222)
imshow(Y,[]);
title('Gradient de z');
subplot(223)
imshow(H(Z,ker,7),[]);
title('Observation z floutee');
subplot(224)
imshow(reshape(x,size(I)),[]);
title('Xn');








