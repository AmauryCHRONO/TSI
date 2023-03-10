close all;clear variables;

%Variables
img=imread('flower.png');
img=im2double(img);
K=15;
[h,l]=size(img);
coordK=randi(h,h,2);
labele =zeros(h,l);


% for i=1:h
%     for j=1:l
%         dist=sqrt((coordK(i,1)-i)^2+(coordK(i,2)-j)^2);
%         labele(i,j)= min(dist);
%     end
% end

idx= kmeans(img,2);