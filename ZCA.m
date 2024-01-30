function [xRot,xPCAwhite,xZCAwhite]=ZCA(x)
epsilon=0.01;
% x=imread('caps.bmp');
%x=rgb2gray(x);
x=double(x);
avg=mean(x(:));
% x=x-repmat(avg,size(x,1),1);%ȥ��ֵ

x=x-avg;
sigma=x*x'/size(x,2);%Э�������
[U,S,V] = svd(sigma);
xRot=U'*x;
xPCAwhite = diag(1./sqrt(diag(S) + epsilon)) * U' * x;
xZCAwhite = U * diag(1./sqrt(diag(S) + epsilon)) * U' * x;

