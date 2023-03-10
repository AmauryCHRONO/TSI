close all;clear variables;

%Variables
img=imread('flower.png');
filtre=[1;2;1];
derivatif=[-1;0;1];
equart_type=0.1;

%Création du filtre de Soble
X=filtre*derivatif';
Y=derivatif*filtre';

%Calcule du gradiant
img=im2double(img);
Gx=imfilter(img,X);
Gy=imfilter(img,Y);

%Calcule de la norme
G=sqrt((Gx.^2)+(Gy.^2));

%Affichage des images
figure(1);
subplot(221);imshow(img);
subplot(222);imshow(G,[]);
subplot(223);imshow(Gx,[]);
subplot(224);imshow(Gy,[]);

%Ajout du bruit blanc
B=randn(256)*equart_type;

imgB=img+B;

%Calcule du gradiant
GBx=imfilter(imgB,X);
GBy=imfilter(imgB,Y);

%Calcule de la norme
GB=sqrt((GBx.^2)+(GBy.^2));

%Affichage des images
figure(2);
subplot(221);imshow(imgB);
subplot(222);imshow(GB,[]);
subplot(223);imshow(GBx,[]);
subplot(224);imshow(GBy,[]);
