clear all
close all
clc

im_reference = imread('Adirondack.png');
im_distorted = imread('Adirondack_Cai16.png');

[refF,refF_color,refNSS] = get_ref_feature(im_reference);
[disF1,disF1_color,disNSS1] = get_dis_feature(im_distorted);
disF=[disF1;disF1_color];
disNSS=disNSS1;

distortion = mean(abs([refF;refF_color] - [disF1;disF1_color]))*mean(abs(refNSS - disNSS1))


