function [feat,feat_color,NSS] = get_dis_feature(img)

%% process
ycbcr_img = double(rgb2ycbcr(img));
Y = ycbcr_img(:,:,1);
Cb = ycbcr_img(:,:,2);
Cr = ycbcr_img(:,:,3);

Y_hat=Y;%(Y-mu)./(sigma+1);

%% naturalness
NSS=brisque_feature_R(Y);
NSS1=brisque_feature_R(Cb);
NSS2=brisque_feature_R(Cr);
f0=[NSS NSS1 NSS2];

%% haze
f1(1) = mean(mean(double(Y_hat)));%
f1(2) = std(std(double(Y_hat)));%
f1(3) = median(median(double(Y_hat)));%
f1(4)= mode(mode(double(Y_hat)));%
f1(5) = entropy(uint8(Y_hat));

%% structure
BL=8;
sigm= 0.5;
win = fspecial('gaussian',BL,sigm);
win = win/sum(sum(win));
mu = filter2(win,Y,'same');
mu_sq = mu.*mu;
sigma = sqrt(abs(filter2(win,Y.*Y,'same') - mu_sq));
% Making CSF
Size=size(Y_hat);
csf = make_csf(Size(1), Size(2), 32)';
% CSF of Image
Img_CSF = double(real( ifft2( ifftshift( fftshift( fft2( double(Y_hat)) ).* csf ) ) ));

Img_CSF=filter2(win,Img_CSF );

imG=imgradient(uint8(Img_CSF),'prewitt');

im= (sum(cat(3,(imG), Img_CSF).^2,3))./2;

f2(1) = mean(mean(double(im)));%
f2(2) = std(std(double(im)));%
f2(3) = median(median(double(im)));%
f2(4)= mode(mode(double(im)));%
f2(5) = entropy(uint8(im));

%% over enhancement
normalize_sigma = sigma./(mu+1);
f3(1) = mean(mean(double(sigma)));%
f3(2) = mean(mean(double(normalize_sigma)));%

%% color
f4(1) = mean(mean(double(Cb)));%
f4(2) = std(std(double(Cb)));%
f4(3) = median(median(double(Cb)));%
f4(4)= mode(mode(double(Cb)));%
f4(5) = entropy(uint8(Cb));

f4(6) = mean(mean(double(Cr)));%
f4(7) = std(std(double(Cr)));%
f4(8) = median(median(double(Cr)));%
f4(9)= mode(mode(double(Cr)));%
f4(10) = entropy(uint8(Cr));

%% feature
feat=[f1';f2';f3'];
feat_color=f4';
NSS=f0';


