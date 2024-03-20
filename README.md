# Page Turing Over System For Musicians
## Brief
MATLAB을 이용한 악보를 자동으로 넘겨주는 프로그램입니다.<br>
Microphone으로 인식한 연주와 image 형태로 저장된 악보를 대조하여 자동으로 다음 페이지로 넘어갑니다.<br>
<br>
## 전체 알고리즘
![image](https://github.com/ksm19416/autoPageTurning_MATLAB/assets/58544529/6aac5672-1e91-4ce3-9816-6ec570c1c0f2)
## 악보 인식 방법
![image](https://github.com/ksm19416/autoPageTurning_MATLAB/assets/58544529/fda138a7-a670-49cb-9567-e94e9081ab5b)
오선줄을 추출하여 음 위치 기준을 찾고, 음표를 추출하여 음 위치를 추출합니다.
## 연주 인식 방법
![image](https://github.com/ksm19416/autoPageTurning_MATLAB/assets/58544529/9fd1e4a9-40e6-43e0-8414-d9adcc4b5ed9) 
<br>단위 시간마다 입력된 음에 대해 FFT를 수행하여 음을 인식합니다. 이 때, Maximum의 65%는 cut-off하여 배수음을 제거합니다.
## 실제 실행 과정
![image](https://github.com/ksm19416/autoPageTurning_MATLAB/assets/58544529/42e45b13-b75b-4341-9f49-a991a30bbdc3)
연주 입력이 인식되면, 단위시간마다 프로그램의 작동 여부를 확인하는 문구가 발생하며, 악보와 일치할 경우 일치횟수를 count합니다. 악보와 80% 이상 일치할 때, 다음 페이지로 넘어갑니다.
