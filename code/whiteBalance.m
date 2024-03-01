function balancedImage = whiteBalance(img)
    im1 = rgb2ycbcr(img);  % 将图片的 RGB 值转换成 YCbCr 值
    Lu = im1(:,:,1);
    Cb = im1(:,:,2);
    Cr = im1(:,:,3);
    [x, y, ~] = size(img);
    tst = zeros(x, y);

    % 计算 Cb、Cr 的均值 Mb、Mr
    Mb = mean(mean(Cb));
    Mr = mean(mean(Cr));

    % 计算 Cb、Cr 的均方差
    Db = sum(sum(Cb - Mb)) / (x * y);
    Dr = sum(sum(Cr - Mr)) / (x * y);

    % 根据阈值要求提取出 near-white 区域的像素点
    cnt = 1;
    for i = 1:x
        for j = 1:y
            b1 = Cb(i,j) - (Mb + Db * sign(Mb));
            b2 = Cr(i,j) - (1.5 * Mr + Dr * sign(Mr));
            if (b1 < abs(1.5 * Db) & b2 < abs(1.5 * Dr))
                Ciny(cnt) = Lu(i,j);
                tst(i,j) = Lu(i,j);
                cnt = cnt + 1;
            end
        end
    end
    cnt = cnt - 1;
    iy = sort(Ciny,'descend');  % 将提取出的像素点按亮度值从大到小排列
    nn = round(cnt / 10);
    Ciny2(1:nn) = iy(1:nn);  % 提取出 near-white 区域中 10% 亮度值较大的像素点做参考白点

    % 提取出参考白点的 RGB 三信道的值
    mn = min(Ciny2);
    for i = 1:x
        for j = 1:y
            if tst(i,j) < mn
                tst(i,j) = 0;
            else
                tst(i,j) = 1;
            end
        end
    end
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    R = double(R) .* tst;
    G = double(G) .* tst;
    B = double(B) .* tst;

    % 计算参考白点的 RGB 均值
    Rav = mean(mean(R));
    Gav = mean(mean(G));
    Bav = mean(mean(B));
    Ymax = double(max(max(Lu))) / 15;  % 计算出图片的亮度最大值

    % 计算 RGB 三信道的增益
    Rgain = Ymax / Rav;
    Ggain = Ymax / Gav;
    Bgain = Ymax / Bav;

    % 通过增益调整图片的 RGB 三信道
    img(:,:,1) = img(:,:,1) * Rgain;
    img(:,:,2) = img(:,:,2) * Ggain;
    img(:,:,3) = img(:,:,3) * Bgain;
    balancedImage = img;
end
