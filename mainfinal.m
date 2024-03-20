%% �� �����ؾ��ϴ� ����
%% 1. �̹��� ó���� ���� �Ǻ� �ν�
% �̹���ó���� ���� �����ٰ� ��ǥ ã�� - ��â, ����ȭ, �����߽� ã�� �̿�
% �����ٷκ��� ����� ��ġ�� ���� �Ǻ��� �� �ν�

%% 2. ���� �� �м��� ���� �� �ν�
% ���� �ּҴ��� �������� ���� ����
% ������ ���� FFT�� ���� ���ļ��� ��ȯ
% ���� �ش��ϴ� ���ļ��� ���Ͽ� ���ֵ� �� �ν�
%% 3. ���� ���� �ν� (������ ��)
% ���ֵ� �� �����Ϳ� �Ǻ��� �� �����͸� ���Ͽ� ������ ���� ���� ���θ� Ȯ��
% �Ǻ��� �� ������ 2 : ���ֵ� �ֱ� �� 3���� ���Ͽ� ������ ���� ���� ���θ� Ȯ��
% �Ǻ� ������ 2���� ���ϴ� ���� : ���� ������ ���� �ٸ� �Ϳ� ���� tolerance�� �� ��
% ���� ������ 3���� ���ϴ� ���� : ������ ���� ���� tolerance�� �� ��

%% ��Ÿ Ư�̻���
% �߰��� �м� �� ������ ���� ����ð��� ����Ͽ� �����ð��� P���� �ǽ�
% ���� �ֱ� (���� �����ð� + ����ð�)�� �����ϵ��� ��
% �ִ��� �ݺ��� ���� �����Ͽ� ����ð� ���� �õ�

%% �ʱⰪ ���� �� �Ǻ� �ν�

clear;
clc;
LineLocation=[];
NoteLocation=[];
LineLocation1=[];
NoteLocation1=[];
LineLocation = LineFinding('ice.png'); %���� ��ġ�� [a]�� ���
NoteLocation = noteselect('ice.png');
LineLocation1 = LineFinding('littlestar.jpg');
NoteLocation1 = noteselect('littlestar.jpg');
SoundVectorOfScore = Note2Frequency(LineLocation, NoteLocation); %�ش� soundvector ����
imshow('ice.png')
page=0;
% ��ǥ�� ��ǥ�� [x y]�� ���
% ��µ� ��ǥ�� ���� ��ġ�� ��, soundMatrix ����
 

%% ���� �м�
%fft�� �ҿ�Ǵ� �ð� ���� �ʿ�
% ������ ������ �ҿ�Ǵ� �ð� ���� �ʿ�
% ���� 
%recoder��ü ����
a = 1;% �������� �Ѿ�� ������ record�� �� ����
count = zeros(1,2); %(1)���� ��� ��ġ�ߴ��� ���, 2���� ���� ���� ���� Ƚ�� ���
% ���� phrase�� ��Ÿ���� �� ��� (�������ٱ��� ���)
initialRecordingTime = 60/90;
RecordingTime = initialRecordingTime;
SoundVectorOfRecorder = [];
waitingCreteria =(length(NoteLocation)-length(SoundVectorOfScore))*2/3;
countMatch = 0;

while a == 1
tic %������ ó���ð� Ȯ��
SoundData = SoundRecord(RecordingTime);
SoundVectorOfRecorder = [SoundVectorOfRecorder Sound2Frequency(SoundData)];

    if length(SoundVectorOfRecorder(1,:))<3
        count(2)= count(2)+1;
         continue
    else 
%% �� �� ����
% �����ð� ���ֵ� ��, ���� ���ϵ��� ����
        [countMatch,count(2)]= ComparisonF(SoundVectorOfScore,SoundVectorOfRecorder,count);
        if (count(2) >waitingCreteria) && (countMatch>=1)
            % ���� test���� count(2) > waitingCreteria�� count(2)> 0���� ����
            % �������� count(2)> 0�� count(2) >waitingCreteria�� ����
        count(1) = count(1)+1; %���������� ���� ��ġ�ϴ� ���� check
        fprintf('count(��ġȽ��, �� ���� Ƚ��) = (%d,%d)\n',count(1),count(2))
            if count(1) >= length(SoundVectorOfScore(1,:))*0.8
            page = page+1;
            count = [0 0]; % ���������� count �ʱ�ȭ
                if page == 2 %������ ���������� ����
                    disp('FINISHED')                    
                break
                end
            toc;
            close all;
           
            disp('nextpage')  %imshow('nextpage'); ������������ �̵� 
            imshow('littlestar.jpg')
            SoundVectorOfScore = Note2Frequency(LineLocation1, NoteLocation1);
           
            continue
            end
        else
            count(1) = 0; % Ʋ���� �ٽ� 0���� count
        end

    end                        

time = toc;
fprintf("�����ð� %f\n",time);
timeover = time - initialRecordingTime;
if timeover<10^-3
    continue;
else
RecordingTime = RecordingTime - 0.75*timeover; %����ġ�� ���� �༭ ���� �������� ���Ž�Ų��.
end

end

