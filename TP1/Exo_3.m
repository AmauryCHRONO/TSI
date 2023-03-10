close all;clear variables;

%Variables
img=imread('journal.png');
p=1;
nc=50;

%Obtention de la taille
img=im2double(img);
[h,w]=size(img);

%Transformée de fourrier
imgFFT=fft2(img);
imgFFT=fftshift(imgFFT);

%Affichage
figure(1);
imshow(log(abs(imgFFT)),[]);

%Filtre Butterworth
[U,V]=meshgrid(-w/2+1/2:w/2-1/2,-h/2+1/2:h/2-1/2);
D=sqrt((U.^2)+(V.^2));
H=1./(1+((D./nc).^2*p));

%Filtrage
imgfFFT=imgFFT.*H;
figure(2);
imshow(H.*log(abs(imgFFT)),[]);

%Transformée de fourrier inverse
imgfFFT=ifftshift(imgfFFT);
imgf=ifft2(imgfFFT);

%Affichage
figure(3);
subplot(121);imshow(img);
subplot(122);imshow(imgf,[]);