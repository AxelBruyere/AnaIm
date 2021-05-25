clear variables; close all; clc;
%% Resolution de Py
% argmin_y 0.5*mu*(y-D*x).^2 + lambda*|y|;
% Ici f(x) = 0.5*mu*(x-z).^2 + lambda*|x|;

%Image etoile
I = im2double(rgb2gray(imread('etoile_z.png')));
X = 0.5*ones(size(I));
%Y = ones(size(I)); y = Y(:);
Z = D(I); Z = 0.5*(Z(:,:,1)+Z(:,:,2));
x = X(:);  z = Z(:);

%%Parametres
u0 = max(max(z))*ones(size(z));
lambda = 1;
gamma = 0.01;
mu = 1;

%%Fonctions (si x vecteur)
f = @(x) 0.5*(x-z).^2;
g = @(x) abs(x);
f_cout = @(x,lambda) f(x)+lambda*g(x);

%%Gradient de f
grad_f = @(x) x-Z;

%%Operateurs proximaux
prox_n1 = @(x,g) (x>g).*(x-g) + (x>=-g & x<=g).*(0) + (x<-g).*(x+g);
prox_n2 = @(x,g) x.^2/(2*g+1);

%%Algorithme du gradient proximal
x1=X; x2=X; x3=X;
gamma = 1; lambda = 0.1;
for k=1:2
     x1 = prox_n1(x1(k)-gamma*grad_f(x1(k)),0.01*gamma);
     x2 = prox_n1(x2(k)-gamma*grad_f(x2(k)),0.05*gamma);
     x3 = prox_n1(x3(k)-gamma*grad_f(x3(k)),0.1*gamma);
end

%%Affichage
figure(1)
subplot(221)
imshow(Z,[]);
title('image observée')

subplot(222)
imshow(x1,[]);
title('\lambda = 0.05')

subplot(223)
imshow(x2,[]);
title('\lambda = 0.5')

subplot(224)
imshow(x3,[]);
title('\lambda = 10')


% %Affichage
% figure(1)
% subplot(121)
% imshow(Z,[]);
% title('image observée')
% 
% subplot(122)
% imshow(x_chapeau,[]);
% title(['\lambda = ',num2str(lambda),'; \gamma = ',num2str(gamma)])



