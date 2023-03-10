close all;clear variables;
%% Question 1
%Ouverture de l'image
img = imread('pieces.png');
img = im2double(img);

%% Question2

%Moyenne aléatoire
m1 = max(img(:)) * rand(1,1);
m2 = max(img(:)) * rand(1,1);

%Nombre d'itération
o=1;

%Compteur de valeur proche des moyennes 
cpt1 = 0;
cpt2 = 0;

%Somme des valeurs proche des moyennes
somme1 = 0;
somme2 = 0;

%Création de la nouvelle image
newimg=zeros(221,261);

%k-mean
while(1)
    m12 = m1;
    m22 = m2;
    
    for i =1:221 
        for j=1:261 
            x = abs(img(i,j) -m12);
            y = abs(img(i,j) - m22);
            if(x == min(x,y))
                newimg(i,j)=0;
                cpt1 = cpt1 +1;
                somme1 = img(i,j) + somme1;
            elseif(y == min(x,y))
                newimg(i,j)=1;
                cpt2 = cpt2+1;
                somme2 = img(i,j) + somme2;
            end
        end
    end
    m1 = somme1/cpt1;
    m2 = somme2/cpt2;
    o=o+1;
    
     if (abs(m1 - m12))<0.01 && (abs(m2 - m22))<0.01
         break;
    end
end

%%Question 3 et affichage questions 2 et 3
[l,L]=size(img);
N=l*L;

[h,x]=imhist(img);
[newh,newx]=imhist(newimg);

figure(1);
subplot(321);bar(x,h);
subplot(322);bar(newx,newh);
subplot(323);imshow(img);
subplot(324);imshow(newimg);

%Histogramme
H=h/N;
newH=newh/N;

sumH=cumsum(H);
sumnewH=cumsum(newH);

 subplot(325);yyaxis left;bar(x,H);axis([-0.1 1.1 0 1.1]);yyaxis right;plot(x,sumH);axis([-0.1 1.1 0 1.1]);
 subplot(326);yyaxis left;bar(newx,newH);axis([-0.1 1.1 0 1.1]);yyaxis right;plot(x,sumnewH);axis([-0.1 1.1 0 1.1]);






%% Question 5 et 6
NEWimg=zeros(221,261);
for i=1:221
    for j=1:261
        Int=img(i,j);
        NEWimg(i,j)=sumH(floor((Int)*255)+1);
    end
end

[NEWh,NEWx]=imhist(NEWimg);
NEWH=NEWh./(l*L);
sumNEWH=cumsum(NEWH);

figure(2);
subplot(211);imshow(NEWimg,[]);
subplot(212);yyaxis left;bar(NEWx,NEWH);axis([-0.1 1.1 0 1.1]);yyaxis right;plot(NEWx,sumNEWH);axis([-0.1 1.1 0 1.1]);

%% Question 7
%Moyenne aléatoire
m1 = max(NEWimg(:)) * rand(1,1);
m2 = max(NEWimg(:)) * rand(1,1);

%Nombre d'itération
o=1;

%Compteur de valeur proche des moyennes 
cpt1 = 1;
cpt2 = 1;

%Somme des valeurs proche des moyennes
somme1 = 0;
somme2 = 0;

%Création de la nouvelle image
imgT=zeros(221,261);

while(1)
    m12 = m1;
    m22 = m2;
    
    for i =1:221 
        for j=1:261 
            x = abs(NEWimg(i,j) -m12);
            y = abs(NEWimg(i,j) - m22);
            if(x == min(x,y))
                imgT(i,j)=0;
                cpt1 = cpt1 +1;
                somme1 = NEWimg(i,j) + somme1;
            elseif(y == min(x,y))
                imgT(i,j)=1;
                cpt2 = cpt2+1;
                somme2 = NEWimg(i,j) + somme2;
            end
        end
    end
    m1 = somme1/cpt1;
    m2 = somme2/cpt2;
    o=o+1;
    
     if (abs(m1 - m12))<0.01 && (abs(m2 - m22))<0.01
         break;
    end
end


figure(3);
subplot(321);[h,x]=imhist(img);bar(x,h);
subplot(322);[newh,newx]=imhist(imgT);bar(newx,newh);
subplot(323);imshow(img);
subplot(324);imshow(imgT);













