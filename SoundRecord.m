function result = SoundRecord(time)

recorder = audiorecorder(44100,16,1);
% record(recorder,time);
recordblocking(recorder,time); %���� ���߿� ��ũ��Ʈ�� ������� �ʵ��� hold
result = getaudiodata(recorder);
