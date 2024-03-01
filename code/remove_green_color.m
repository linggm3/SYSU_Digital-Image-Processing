function enhanced_image = remove_green_color(img)
    % 颜色校正
    img_yuv = rgb2ycbcr(img);
    img_yuv(:, :, 1) = histeq(img_yuv(:, :, 1));
    corrected_image = ycbcr2rgb(img_yuv);

    % 散射光估计
    dark_channel = min(corrected_image, [], 3);
    estimated_scattering = 1.0 - double(imerode(dark_channel, strel('square', 15))) / 255.0;

    % 去除散射光
    restored_image = double(corrected_image) ./ repmat(estimated_scattering, [1, 1, size(corrected_image, 3)]);
    enhanced_image = corrected_image;%uint8(min(max(restored_image, 0), 255));
end
