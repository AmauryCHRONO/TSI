close all;clear variables;
iso=[100,200,400,800,1600,3200,6400,12800];
SNR=zeros(1,8);
spectre=zeros(1,8);
for i=1:8
    fname=sprintf('iso%d.jpg',iso(i));
    I=imread(fname);
    I=rgb2gray(I);
    Ir=im2double(I(989:1090,939:1132));
    moy=mean2(Ir);
    sigma=std2(Ir);
    SNR(i)=20*log10(moy/sigma);
    imgFFT=fft2(I);
    imgFFT=fftshift(imgFFT);
    spectre=log(abs(imgFFT));
    sub=sprintf('24%d',i);
    figure(2);
    subplot(sub);imshow(spectre,[]);
end
figure(1);
plot(iso,SNR);

figure(2);
