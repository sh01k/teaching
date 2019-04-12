%% Training
%download from http://yann.lecun.com/exdb/mnist/
train_image_file = 'train-images-idx3-ubyte';
train_label_file = 'train-labels-idx1-ubyte';
test_image_file = 't10k-images-idx3-ubyte';
test_label_file = 't10k-labels-idx1-ubyte';

%load data
images = load_mnist_image(train_image_file, 1, 1);
labels = load_mnist_label(train_label_file, 1);

%define weights
W1 = randn(50,784); W2 = randn(10,50); 
b1 = randn(50,1); b2 = randn(10,1); 

%learning rate
eps = 0.01;
max_itr = 100;

batch_size = 100;

for jj = 1:max_itr
    E = 0;
    for ii = 1:size(images,2)/batch_size
        %prediction
        x = images(:,(ii-1)*batch_size+1:ii*batch_size);
        u1 = W1*x+b1;
        z1 = sigmoid(u1);
        u2 = W2*z1+b2;
        y = softmax(u2);
        
        d = labels(:,(ii-1)*batch_size+1:ii*batch_size);
        E = E + sum(cross_entropy_error(y,d));

        %backpropagation
        delta2 = y-d;
        delta1 = (W2'*delta2).*sigmoid_grad(u1);
        grad2 = delta2*[z1; ones(1,batch_size)]';
        grad1 = delta1*[x; ones(1,batch_size)]';

        %update weights
        W2 = W2 - eps*grad2(:,1:(size(grad2,2)-1));
        b2 = b2 - eps*grad2(:,size(grad2,2));
        W1 = W1 - eps*grad1(:,1:(size(grad1,2)-1));
        b1 = b1 - eps*grad1(:,size(grad1,2));
    end
    E = E/size(images,2);
    fprintf('itr: %d, cost: %f\n',jj,E);
end

%% Test
%load data
images_test = load_mnist_image(test_image_file, 1, 1);
labels_test = load_mnist_label(test_label_file, 0);

accuracy_cnt = 0;
for ii = 1:size(images_test,2)/batch_size
    %prediction
    x = images_test(:,(ii-1)*batch_size+1:ii*batch_size);
    u1 = W1*x+b1;
    z1 = sigmoid(u1);
    u2 = W2*z1+b2;
    y = softmax(u2);

    [~,idx] = max(y,[],1);
    d = labels_test((ii-1)*batch_size+1:ii*batch_size)'+1;
    accuracy_cnt = accuracy_cnt + sum(d==idx);
end
accuracy_rate = accuracy_cnt/size(images_test,2)*100;

fprintf('Accuracy rate: %f%%\n',accuracy_rate);

%% Functions
function [images,numImages,numRows,numCols] = load_mnist_image(fname, normalize, flatten)
fp = fopen(fname, 'rb');

magic = fread(fp, 1, 'int32', 0, 'b');
if magic ~= 2051; fprintf('Incorrect magic number\n'); return; end

numImages = fread(fp, 1, 'int32', 0, 'b');
numRows = fread(fp, 1, 'int32', 0, 'b');
numCols = fread(fp, 1, 'int32', 0, 'b');

images = fread(fp, inf, 'uchar');
images = reshape(images, numCols, numRows, numImages);
images = permute(images,[2 1 3]);

fclose(fp);

if flatten
    images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));
end

if normalize
    images = double(images) / 255;
end

end

function [labels,numLabels] = load_mnist_label(fname, one_hot_flg)
fp = fopen(fname, 'rb');

magic = fread(fp, 1, 'int32', 0, 'b');
if magic ~= 2049; fprintf('Incorrect magic number\n'); return; end

numLabels = fread(fp, 1, 'int32', 0, 'b');

labels = fread(fp, inf, 'uchar');

fclose(fp);

if one_hot_flg
    labels_vec = zeros(10,numLabels);
    for ii=1:numLabels
        labels_vec(labels(ii)+1,ii) = 1;
    end
    labels = labels_vec;
end

end

function y = sigmoid(x)
y = 1.0 ./ (1.0 + exp(-x));
end

function y = sigmoid_grad(x)
y = (1.0 - sigmoid(x)) .* sigmoid(x);
end

function y = softmax(x)
c = max(x,[],1);
y = exp(x-c)./sum(exp(x-c));
end

function E = cross_entropy_error(y,d)
E = -sum(d.*log(y+1e-7),1);
end
