function dehazedImage = imageDehazing(img)
    % 将图像转换为double类型
    img = im2double(img);

    % 1. 计算暗通道
    darkChannel = min(img, [], 3);  % 计算每个像素在所有颜色通道中的最小值
    patchSize = 15;  % 定义局部窗口的大小
    darkChannel = ordfilt2(darkChannel, 1, ones(patchSize, patchSize), 'symmetric');

    % 2. 估计大气光
    [~, idx] = sort(darkChannel(:), 'descend');
    idx = idx(1:max(floor(numel(idx) * 0.001), 1));  % 选择暗通道图像中最亮的 0.1% 的像素
    atmosphericLight = max(img(idx));

    % 3. 估计透射图
    omega = 0.95;  % 保留一部分大气光
    transmission = 1 - omega * min(min(img ./ atmosphericLight, [], 3), [], 3);
    transmission = max(transmission, 0.1);  % 设置透射图的下限阈值

    % 4. 恢复无雾图像
    dehazedImage = (img - atmosphericLight) ./ max(transmission, 0.1) + atmosphericLight;
    dehazedImage = min(max(dehazedImage, 0), 1);  % 确保像素值在合理范围内
end
