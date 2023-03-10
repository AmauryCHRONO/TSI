close all;clear variables;
figure(1);
I=imread('mire.png');
I=im2double(I);
imshow(I)
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
figure(2);
subplot(131);imshow(R,[]);
subplot(132);imshow(G,[]);
subplot(133);imshow(B,[]);
Rr=zeros(1200,1920,3);
Rr(:,:,1)=R;
Gr=zeros(1200,1920,3);
Gr(:,:,2)=G;
Br=zeros(1200,1920,3);
Br(:,:,3)=B;


figure(3);
subplot(131);imshow(Rr,[]);
subplot(132);imshow(Gr,[]);
subplot(133);imshow(Br,[]);

HSV=rgb2hsv(I);
Rh=HSV(:,:,1);
Gh=HSV(:,:,2);
Bh=HSV(:,:,3);
figure(4);
subplot(141);imshow(Rh,[]);
subplot(142);imshow(Gh,[]);
subplot(143);imshow(Bh,[]);
subplot(144);imshow(HSV,[]);