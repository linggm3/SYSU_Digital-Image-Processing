function histEqImage = localHistogramEqualization(img)
for channel = 1:3
histEqImage(:, :, channel) = adapthisteq(img(:, :, channel), 'NumTiles', [8, 8], 'ClipLimit', 0.02);
end
img_ori = double(histEqImage);
[h, w, c] = size(img_ori);

R = img_ori(:,:,1);
G = img_ori(:,:,2);
B = img_ori(:,:,3);

% % 直方图均衡
% hsv_img = rgb2hsv(img_ori);
% I = hsv_img(:,:,3);
% hsv_img(:,:,3) = HistEq(I);%需要添加
% RGB_eq = hsv2rgb(hsv_img);

% 对比度拉伸
reR = reshape(R, h * w, 1);
reG = reshape(G, h * w, 1);
reB = reshape(B, h * w, 1);

[sort_R, index_R] = sort(reR, 'ascend');
[sort_G, index_G] = sort(reG, 'ascend');
[sort_B, index_B] = sort(reB, 'ascend');

cutRate = 0.0001; % 裁剪比例
limit = round(cutRate * h * w);

R_stretch = ContrastStretch(R, sort_R(1), sort_R(h * w - limit), sort_G(limit), sort_B(h * w));
G_stretch = ContrastStretch(G, sort_G(limit), sort_R(h * w), sort_R(limit), sort_B(h * w - limit));
B_stretch = ContrastStretch(B, sort_B(1), sort_B(h * w), sort_R(1), sort_B(h * w - limit));

% 限制对比度自适应直方图均衡
clip_limit = 0.1;
tile_num = [round(h / 100), round(w / 100)]; % 分块数

if tile_num(1) < 2
    tile_num(1) = 2;
end
if tile_num(2) < 2
    tile_num(2) = 2;
end

hsv_img = rgb2hsv(img);
hsv_img(:,:,3) = adapthisteq(hsv_img(:,:,3), 'NumTiles', tile_num, 'ClipLimit', clip_limit);
RGB_clahe = hsv2rgb(hsv_img);
%histEqImage = RGB_clahe;
histEqImage = cat(3, R_stretch, G_stretch, B_stretch);
end