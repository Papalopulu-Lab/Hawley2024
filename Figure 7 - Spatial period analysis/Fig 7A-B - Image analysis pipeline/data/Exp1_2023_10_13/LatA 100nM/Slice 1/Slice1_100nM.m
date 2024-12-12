clear, clc, close all

polyNum = 4;

%% load data and rotate
imag=imread('Lat A 100nM Slice1 z13.png');
dx=1/2.35; % Magnification factor pixels/um
figure(1), clf, subplot(121), imshow(imag)
title('Raw data')
im=imrotate(imag,45,'bilinear','crop');
figure(1), subplot(122), imshow(im)
title('Rotated image')

%left roi
left_x = 200;
left_y = 400;
left_w = 20;
left_h = 500;

% %left roi
% left_x = 200;
% left_y = 300;
% left_w = 20;
% left_h = 640;

rectangle('Position',[left_x, left_y, left_w, left_h],...
          'Curvature',[0,0],...
         'LineWidth',1, 'EdgeColor','w')

%right roi
right_x = 570;
right_y = left_y;
right_w = 20;
right_h = left_h;

rectangle('Position',[right_x, right_y, right_w, right_h],...
          'Curvature',[0,0],...
         'LineWidth',1, 'EdgeColor','w')

heightInMicrons = left_h*dx

% Crop to region of interest

roi_left=im(left_y:left_y+left_h, left_x:left_x+left_w);

figure(2), subplot(241), imagesc(roi_left), title('Left side'), axis equal, xlim([0 size(roi_left,2)]);



roi_right=im(right_y:right_y+right_h, right_x:right_x+right_w);
subplot(245), imagesc(roi_right), title('Right side'), axis equal, xlim([0 size(roi_left,2)]);;
colormap(jet)

%%
% get the mean across DV
% figure(10)
% plot(double(roi_left')); hold on 
% plot(mean(double(roi_left')))
venus_left=mean(double(roi_left'));
venus_right=mean(double(roi_right'));
xl=[1:numel(venus_left)]*dx; % distance vect
xr=[1:numel(venus_right)]*dx;

% plot the data
figure(2),subplot(2,4,2),plot(xl,venus_left),hold on
xlabel('Distance (um)'), ylabel('Fluorescent Intensity');
% estimate trend
p = polyfit(xl,venus_left,polyNum);
fit = polyval(p,xl);
plot(xl,fit,'r'), title('Detrending line');
% acf of detrended
% get the ACF of mean venus
venus_left=venus_left-fit;
subplot(243), plot(xl,venus_left,'r');
[r_left, lags]=xcorr(venus_left);
% apply some smoothing to acf-optional
r_left = smoothdata(r_left);
lags=lags*dx; % from pix to um
% plot the acf
subplot(244),plot(lags,r_left), title('ACF');
xlabel('Relative distance (um)'), ylabel('ACF');
%% analyse the rhs in the same way
figure(2), subplot(246), plot(xr,venus_right), title('Detrending line'), hold on
xlabel('Distance (um)'), ylabel('Fluorescent Intensity');
% estimate trend
p = polyfit(xr,venus_right,polyNum);
fit = polyval(p,xr);
plot(xr,fit,'r'), title('Detrended data');
% acf of detrended
% get the ACF of mean venus
venus_right=venus_right-fit;
subplot(247), plot(xr,venus_right,'r'), title('Detrended data');

[r_right,lags]=xcorr(venus_right);
lags=lags*dx;
% apply some smoothing to acf-optional
r_right = smoothdata(r_right);
subplot(248), plot(lags,r_right), title('ACF');
xlabel('Relative distance (um)'), ylabel('ACF');
