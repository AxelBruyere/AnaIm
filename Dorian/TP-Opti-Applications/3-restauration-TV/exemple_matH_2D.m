clear; close all; clc;

%     Ex 1 (2D):
im = im2double(imread('cameraman.tif'));

ker = 'gaussian';  
im_blur = H(im,ker,3);

figure(1); clf;
subplot(121); imshow(im,[]);      title('image originale');
subplot(122); imshow(im_blur,[]); title('image floutée');