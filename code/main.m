clc;
clear all;

% 读取水下图像
img_name = 'D:\360MoveData\Users\Administrator\Desktop\OpenCV Tutorial\水下图像处理\InputImages\1.png';  % 请替换为实际的图像文件名
RGBimg = imread(img_name);
danzhi = localHistogramEqualization(RGBimg);
zhibai = whiteBalance(danzhi);
img = whiteBalance(RGBimg);
enhancedImage = localHistogramEqualization(img);
sim = imageDehazing(enhancedImage);



% 显示图像
figure;

subplot(2, 2, 1);
imshow(uint8(RGBimg));
title('原始图像');

subplot(2, 2, 2);
imshow(uint8(enhancedImage));
title('直方图均衡处理');
imgout_name = 'D:\360MoveData\Users\Administrator\Desktop\OpenCV Tutorial\水下图像处理\InputImages\';
imwrite(uint8(enhancedImage), 'InputImages/output/白平衡+直方图均衡out1.jpg');

imwrite(uint8(danzhi), 'InputImages/output/直方图均衡out1.jpg');
imwrite(uint8(zhibai), 'InputImages/output/直方图均衡+白平衡out1.jpg');
subplot(2, 2, 3);
imshow(uint8(img));
title('白平衡');
imwrite(uint8(img), 'InputImages/output/白平衡out1.jpg');

subplot(2, 2, 4);
imshow(uint8(sim));
title('去雾');
imwrite(uint8(sim), 'InputImages/output/白平衡+直方图均衡+去雾out1.jpg');