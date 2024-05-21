folder_path = '附件2';
file_extension = '.bmp';  % 文件扩展名
files = dir(fullfile(folder_path, ['*', file_extension]));  % 使用文件名匹配模式获取文件列表
% 创建一个存储图像的单元数组
img_data = cell(1, length(files));
for i = 1:length(files)
    img_path = fullfile(folder_path, files(i).name);
    img = imread(img_path);
    binary_img = imbinarize(img);
    img_data{i} = binary_img;
end

% 图像保存在img_data单元数组中

num_images = length(img_data);
similarity_matrix = cell(num_images, num_images);

for i = 1:num_images
    for j = 1:num_images
        if i == j
            continue;  % 跳过同一张图像的比较
        end
        
        % 计算i右边沿与j左边沿的相似度
        right_edge_i = img_data{i}(:, end);
        left_edge_j = img_data{j}(:, 1);
        right_similarity = sum(right_edge_i == left_edge_j) / numel(right_edge_i);

        % 计算j右边沿与i左边沿的相似度
        right_edge_j = img_data{j}(:, end);
        left_edge_i = img_data{i}(:, 1);
        left_similarity = sum(left_edge_i == right_edge_j) / numel(left_edge_i);
        
        % 计算平均相似度
        similarity = [right_similarity, left_similarity];
        
        % 将相似度存储到相似度矩阵中
        similarity_matrix{i, j} = similarity;
    end
end

right_solutions = cell(1, num_images);
for i = 1:num_images
    right_max_similarity = 0;
    for j = 1:num_images
        if i == j
            continue;
        end
        current_similarity = similarity_matrix{i, j}(1);
        if current_similarity > right_max_similarity
            right_max_similarity = current_similarity;
            right_solution = [j, 0];
            right_solutions{i} = right_solution;
        end
    end
end

left_solutions = cell(1, num_images);
for i = 1:num_images
    left_max_similarity = 0;
    for j = 1:num_images
        if i == j
            continue;
        end
        current_similarity = similarity_matrix{i, j}(1);
        if current_similarity > left_max_similarity
            left_max_similarity = current_similarity;
            left_solution = [j, 0];
            left_solutions{i} = left_solution;
        end
    end
end

% 显示相似度矩阵
disp(similarity_matrix);
disp(right_solutions);
disp(left_solutions);
max_val = 0;
for i = 1:num_images
    val = sum(img_data{i}(:, 1));
    if val > max_val
        max_val = val;
        start = i;
    end
end
index = [];
resluts1 = [];
current = start;
for i = 1:ceil(num_images/2)
    next = right_solutions{current}(1);
    if next == start
        reslut = img_data{current};
        idx = current;
        index = [index, idx];
    else
        reslut = [img_data{current}, img_data{next}];
        idx = [current, next];
        index = [index, idx];
    end
    resluts1 = [resluts1, reslut];
    current = right_solutions{next}(1);
end
imshow(resluts1);
disp([num2str(index)]);