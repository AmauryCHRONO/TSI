close all;clear variables;

%Ouverture de l'image
img = imread('pieces.png');
img = im2double(img);

[l,L]=size(img);
N=l*L;

[h,x]=imhist(img);
H=h/N;
sumH=cumsum(H);

newimg=zeros(221,261);
for i=1:221
    for j=1:261
        Int=img(i,j);
        newimg(i,j)=sumH(floor((Int)*255)+1);
    end
end


%Moyenne aléatoire
m1 = max(newimg(:)) * rand(1,1);
m2 = max(newimg(:)) * rand(1,1);

%Compteur de valeur proche des moyennes 
cpt1 = 1;
cpt2 = 1;

%Somme des valeurs proche des moyennes
somme1 = 1;
somme2 = 1;

%Création de la nouvelle image
IMG=zeros(221,261);

%k-mean
while(1)
    m12 = m1;
    m22 = m2;
    
    for i =1:221 
        for j=1:261 
            x = abs(newimg(i,j) -m12);
            y = abs(newimg(i,j) - m22);
            if(x == min(x,y))
                IMG(i,j)=0;
                cpt1 = cpt1 +1;
                somme1 = newimg(i,j) + somme1;
            elseif(y == min(x,y))
                IMG(i,j)=1;
                cpt2 = cpt2+1;
                somme2 = newimg(i,j) + somme2;
            end
        end
    end
    m1 = somme1/cpt1;
    m2 = somme2/cpt2;
    
     if (abs(m1 - m12))<0.01 && (abs(m2 - m22))<0.01
         break;
    end
end
if (IMG(34,188)==1)
    IMG=abs(IMG-1);
end

figure(1);
subplot(141);imshow(newimg,[]);
subplot(142);imshow(IMG,[]);

SE=strel('disk',3);
A=imdilate(IMG,SE);
B=imerode(A,SE);


mar=zeros(221,261);
mar(1,:)=B(1,:);
mar(:,1)=B(:,1);
mar(221,:)=B(221,:);
mar(:,261)=B(:,261);

D=imreconstruct(mar,B);

D=B-D;



subplot(143);imshow(B,[]);

subplot(144);imshow(D);

bweuler(D)
bweuler(B)
