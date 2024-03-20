function [y] = LineFinding(filename)

%morphology�� ���� �ñ����� ���� bwmorph ������ ��
Image1 = imread(filename); %�̹��� �ҷ�����
ImageGray = rgb2gray(Image1); %RGB�� ȸ������ ��ȯ
ImageBW = imbinarize(ImageGray,0.6); %ȸ���� �̹����� ����ȭ
ImageRBW = (ImageBW==0);%��� ����
mask1 = ones(1,20);% ���η� �� ����ũ ����
ImageLine = imerode(ImageRBW, mask1);%ħ���� �̿��� ��� ���μ� ���� ����
ImageThinLine = bwmorph(ImageLine,'thin'); % �̹����� ����ȭ
% ���� �� ���� �� ����ȭ�ߴ���, ���� ����� �ȵ�..
temp1 = sum(ImageThinLine'); %sum�� ���������� ���� ����/ ���� transpose�ؼ� ���� ���� ����
% y������ ������׷� �ۼ�
[a b] = size(Image1);
temp2 = temp1>0.5*a;%�̹����� �� ������ 50%���� ª�� �� ����
y = find(temp2);%���μ��� �����ϴ� y���� ��ǥ ����
end