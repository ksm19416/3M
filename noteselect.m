function result = noteselect(filename)

%���ȭ, ����ȭ, ����
img = imread(filename); %�̹��� �ҷ�����
imgGRAY = rgb2gray(img);% RGB���� �����
imgREV= imcomplement(imgGRAY); %��� ����
imgFNL=imbinarize(imgREV); %����ȭ

%�𼭸� ���� �����
[imgX, imgY] = size(imgFNL);
imgFNL(1:3,:) = 0;
imgFNL(imgX-3:imgX,:) = 0;
imgFNL(:,1:3) = 0;
imgFNL(:,imgX-3:imgX) = 0; %�𼭸� 3��°���� 0���� �����.

se1 = strel('line', 50, 0);      %���ηα� ���� �̿��� ���� ����
IMG= imopen(imgFNL,se1);
IMG_thin = bwmorph(IMG, 'thin'); 

IMG1 = bwmorph(imgFNL,'thin');
IMG_Re = imreconstruct(IMG_thin, IMG1);
IMG_sub = IMG_Re - IMG_thin; %���� ������(�����Ǻ����� ������ ����)

IMG_BR = bwmorph(IMG_sub, 'bridge'); %�������� ���� ���� 1�� ���� �Ųٱ�

se2 = strel('disk',1);               % �Ӹ��� octagonũ�� 3���� ������ ������ �ȵǹǷ� ��â��Ų��. 
imgimg = imdilate(IMG_BR,se2);

imgimgimg = bwmorph(imgimg, 'thin'); % ���� �����

IMG_holes = imfill(imgimgimg, 4, 'holes'); %����ä���


%% ���� ���ڸ�ǥ �������̷� ���ϱ�

%���� ���� ����
THIN_number = bwlabel(IMG_thin);
MAX_thin = sum(THIN_number');
MAX_thin_one = nnz(MAX_thin);
MAX_thin_number = 5*round(MAX_thin_one/5); %Ƣ�� ���� �����ϹǷ� ������� ����

%���� ���� ���� ���ϱ�
Pos_line1 = find(sum((THIN_number==1)'));
Pos_line5 = find(sum((THIN_number==5)'));
Interval_line = Pos_line5-Pos_line1; 

%���۸� �������ϱ�

hoehoe = imdilate(IMG_holes, se2);
se3=strel('octagon' ,3);
IMG_Head22 = imopen(hoehoe, se3);
IMG_2Hole = imreconstruct(IMG_Head22,IMG_holes);
IMG_3Hole = imerode(IMG_2Hole,se2);  %�����ٸ� ����

% ��ǥ�� ����� ���� for���� �ʿ��� ����
A = bwlabel(IMG_holes);
MAX = max(max(A));
A_select_zero = (zeros([imgX,imgY])); %��� ���� 0���� �����ؼ� �󺧰��� ������ ��ģ��.

cnt=1; % Counter

for i=1:1:MAX %�� �ο��ϰ� �ϳ��� ������ ����� ���ϴ°� ����. 
    
   Select_Label = (A==i); 
   HC_select = sum(Select_Label'); %������ �������� 
   
   [LSx,LSy] = max(sum(Select_Label)); %�������� �� ���� ū ���� ã�Ƽ� +1��ġ������ ��������
   
   Select_Label(:,(LSy+2):imgY) = 0;
   [XX,Line_select] = size(find(sum(Select_Label')==1));
   
   % ������ ���տ��� 1�� ������ ��������*0.45���� ������ �����. 
   if(Line_select<((Interval_line)*0.45))         %������ ���������� ����� ������ �������� ����� �������Ѵ�.
       Select_Label = (zeros([imgX,imgY]));        
   end                                         
   
   A_select_zero = A_select_zero + Select_Label;
end

A_select_zero = imreconstruct(imbinarize(A_select_zero),IMG_holes); %������ ��ü�� ��� ����


%% ���� �����ϴ� �Ӹ� ������

A_select_zero = imdilate(A_select_zero,se2); % �Ӹ����� �����ϱ����� ũ�⸦ Ű��

se4=strel('octagon' ,3);
IMG_Head = imopen(A_select_zero, se4); %�Ӹ��� ����

se5 = strel('disk', 1);
B_select_zero1 = imdilate(IMG_BR, se5);           % �����ִ� �Ӹ��� ã������ �밡���۾�
B_select_zero2 = bwmorph(B_select_zero1, 'skel');
B_select_zero3 = bwmorph(B_select_zero2, 'fill');
B_select_zero4 = bwmorph(B_select_zero3, 'remove');
B_select_zero = imfill(B_select_zero4, 'holes');
IMG_HOLE = imopen(B_select_zero, se4);

IMG_LEFT = imbinarize(B_select_zero-B_select_zero1);  % �����ִ� ��ü�� ����� ä�� ��ü�� ���� ���� �� ���� 

NOTE_HOLE = imreconstruct(IMG_LEFT,IMG_Head); %�� ��ǥ�� �����´�.

P1 = IMG_Head;
P2 = imreconstruct(NOTE_HOLE,P1);

se6=strel('disk',3);

IMG_Head2 = imclose(P1, se6); %�ʹ� �������ʰ� �ձ��ϰ� ����
IMG_Head3 = imclose(P2, se6);
%% �����߽�

[L, n] = bwlabel(IMG_Head2); %�����߽� ��ǥ �������
result = zeros(n,2);
   for k = 1:n
    [r,c] = find(L == k);
    result(k,1) = mean(c);
    result(k,2) = mean(r);
   end
   
[L2, n2] = bwlabel(IMG_Head3); %�� ��Ʈ �����߽� ��ǥ �������
resultN = zeros(n2,2);
   for k = 1:n2
    [r,c] = find(L2 == k);
    resultN(k,1) = mean(c)+1;
    resultN(k,2) = mean(r);
   end
   result = [result; resultN];
   result = sortrows(result);% x�� ������� ��ǥ���� ����
%end