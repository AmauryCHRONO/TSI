close all;clear variables;

%Variables
img=imread('flower.png');
d=0.5;
equart_type=0.1;
[h,w]=size(img);
n=2;
nc=100;
p=5;
N=4;
%Ajout du bruit blanc
B=randn(256)*equart_type;

%Bruitage gaussien de l'image
img=im2double(img);
imgB=img+B;

%Bruitage sel et poivre de l'image
imgC=imnoise(img,'salt & pepper',d);

%Affichage
figure(1)
subplot(121);imshow(imgB);
subplot(122);imshow(imgC);

%transformée de fourier
imgBFFT=fft2(imgB);
imgCFFT=fft2(imgC);
imgBFFT=fftshift(imgBFFT);
imgCFFT=fftshift(imgCFFT);

%Filtre Butterworth
[U,V]=meshgrid(-w/2+1/2:w/2-1/2,-h/2+1/2:h/2-1/2);
D=sqrt((U.^2)+(V.^2));
H=1./(1+((D./nc).^2*p));

imgBBFFT=H.*imgBFFT;
imgBBFFT=ifftshift(imgBBFFT);
imgbb=ifft2(imgBBFFT);

imgCBFFT=H.*imgCFFT;
imgCBFFT=ifftshift(imgCBFFT);
imgcb=ifft2(imgCBFFT);

%filtre médian
imgbm=medfilt2(imgB,[n n]);
imgcm=medfilt2(imgC,[n n]);

%filtre moyenneur
HM=(1/N^2)*ones(N);
imgbM=imfilter(imgB,HM);
imgcM=imfilter(imgC,HM);

%Affichage
figure(2)
subplot(231);imshow(imgbb);
subplot(232);imshow(imgbm);
subplot(233);imshow(imgbM,[]);
subplot(234);imshow(imgcb);
subplot(235);imshow(imgcm);
subplot(236);imshow(imgcM,[]);

err1 = immse(imgbb,img);
err2 = immse(imgbm,img);
err3 = immse(imgbM,img);
err4 = immse(imgcb,img);
err5 = immse(imgcm,img);
err6 = immse(imgcM,img);





