clear variables; close all; clc;
%% Resolution de Py
% argmin_y 0.5*mu*(y-D*x).^2 + lambda*|y|;
% Ici f(x) = 0.5*mu*(x-z).^2 + lambda*|x|;

%Image etoile
I = im2double(rgb2gray(imread('etoile_z.png')));
X = ones(size(I));
%Y = ones(size(I)); y = Y(:);
Z = D(I); Z = 0.5*(Z(:,:,1)+Z(:,:,2));
x = X(:);  z = Z(:);

%%Parametres
u0 = max(max(z))*ones(size(z));
lambda = 0.1; gamma = 1;
mu = 1;

%%Fonctions (si x vecteur)
f = @(x) 0.5*mu*(x-z).^2;
g = @(x) abs(x);
f_cout = @(x,lambda) f(x)+lambda*g(x);

%%Gradient de f
grad_f = @(x) mu*(x-Z);

%%Operateurs proximaux
prox_n1 = @(x,g) (x>g).*(x-g) + (x>=-g & x<=g).*(0) + (x<-g).*(x+g);
prox_n2 = @(x,g) x.^2/(2*g+1);

%%Algorithme du gradient proximal
x1=X;
x1_prec = zeros(size(x1));
k =0;
while norm(x1 - x1_prec)>1e-6 && k<10
     x1_prec = x1;
     x1 = prox_n1(x1-gamma*grad_f(x1),lambda*gamma);
     k = k+1;
end

%%Affichage
figure(1)
subplot(121)
imshow(Z,[]);
title('D*x')

subplot(122)
imshow(x1,[]);
title(['x1 ','(\lambda = ',num2str(lambda),', \gamma = ',num2str(gamma),')'])



% %Affichage
% figure(1)
% subplot(121)
% imshow(Z,[]);
% title('image observée')
% 
% subplot(122)
% imshow(x_chapeau,[]);
% title(['\lambda = ',num2str(lambda),'; \gamma = ',num2str(gamma)])



