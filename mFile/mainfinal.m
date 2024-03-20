%% 꼭 설명해야하는 내용
%% 1. 이미지 처리를 통한 악보 인식
% 이미지처리를 통해 오선줄과 음표 찾기 - 팽창, 세선화, 무게중심 찾기 이용
% 오선줄로부터 상대적 위치를 통해 악보의 음 인식

%% 2. 녹음 및 분석을 통한 음 인식
% 음의 최소단위 간격으로 음을 녹음
% 녹음된 음을 FFT를 통해 주파수로 변환
% 음에 해당하는 주파수와 비교하여 연주된 음 인식
%% 3. 연주 여부 인식 (데이터 비교)
% 연주된 음 데이터와 악보의 음 데이터를 비교하여 마지막 줄의 연주 여부를 확인
% 악보의 음 데이터 2 : 연주된 최근 음 3개를 비교하여 마지막 줄의 연주 여부를 확인
% 악보 데이터 2개를 비교하는 이유 : 새로 들어오는 음이 다른 것에 대해 tolerance를 준 것
% 녹음 데이터 3개를 비교하는 이유 : 지나간 음에 대해 tolerance를 준 것

%% 기타 특이사항
% 중간의 분석 및 대조에 의한 연산시간을 고려하여 녹음시간에 P제어 실시
% 녹음 주기 (실제 녹음시간 + 연산시간)가 일정하도록 함
% 최대한 반복문 없이 실행하여 연산시간 단축 시도

%% 초기값 설정 및 악보 인식

clear;
clc;
LineLocation=[];
NoteLocation=[];
LineLocation1=[];
NoteLocation1=[];
LineLocation = LineFinding('ice.png'); %선의 위치를 [a]로 출력
NoteLocation = noteselect('ice.png');
LineLocation1 = LineFinding('littlestar.jpg');
NoteLocation1 = noteselect('littlestar.jpg');
SoundVectorOfScore = Note2Frequency(LineLocation, NoteLocation); %해당 soundvector 추출
imshow('ice.png')
page=0;
% 음표의 좌표를 [x y]로 출력
% 출력된 음표를 선의 위치와 비교, soundMatrix 생성
 

%% 음향 분석
%fft에 소요되는 시간 측정 필요
% 데이터 녹음에 소요되는 시간 측정 필요
% 녹음 
%recoder객체 생성
a = 1;% 페이지가 넘어가기 전까지 record와 비교 수행
count = zeros(1,2); %(1)에는 몇번 일치했는지 기록, 2에는 연속 녹음 진행 횟수 기록
% 같은 phrase가 나타나기 전 대기 (마지막줄까지 대기)
initialRecordingTime = 60/90;
RecordingTime = initialRecordingTime;
SoundVectorOfRecorder = [];
waitingCreteria =(length(NoteLocation)-length(SoundVectorOfScore))*2/3;
countMatch = 0;

while a == 1
tic %데이터 처리시간 확인
SoundData = SoundRecord(RecordingTime);
SoundVectorOfRecorder = [SoundVectorOfRecorder Sound2Frequency(SoundData)];

    if length(SoundVectorOfRecorder(1,:))<3
        count(2)= count(2)+1;
         continue
    else 
%% 논리 비교 과정
% 일정시간 연주된 후, 논리를 비교하도록 설정
        [countMatch,count(2)]= ComparisonF(SoundVectorOfScore,SoundVectorOfRecorder,count);
        if (count(2) >waitingCreteria) && (countMatch>=1)
            % 빠른 test용은 count(2) > waitingCreteria를 count(2)> 0으로 수정
            % 실전용은 count(2)> 0을 count(2) >waitingCreteria로 수정
        count(1) = count(1)+1; %연속적으로 음이 일치하는 정도 check
        fprintf('count(일치횟수, 음 감지 횟수) = (%d,%d)\n',count(1),count(2))
            if count(1) >= length(SoundVectorOfScore(1,:))*0.8
            page = page+1;
            count = [0 0]; % 다음페이지 count 초기화
                if page == 2 %마지막 페이지에서 끝냄
                    disp('FINISHED')                    
                break
                end
            toc;
            close all;
           
            disp('nextpage')  %imshow('nextpage'); 다음페이지로 이동 
            imshow('littlestar.jpg')
            SoundVectorOfScore = Note2Frequency(LineLocation1, NoteLocation1);
           
            continue
            end
        else
            count(1) = 0; % 틀리면 다시 0부터 count
        end

    end                        

time = toc;
fprintf("녹음시간 %f\n",time);
timeover = time - initialRecordingTime;
if timeover<10^-3
    continue;
else
RecordingTime = RecordingTime - 0.75*timeover; %가중치를 적게 줘서 적은 진동으로 수렴시킨다.
end

end

