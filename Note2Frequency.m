function frequency = Note2Frequency(LineLocation, NoteLocation)
%% �� ã�Ƴ� ���� ���� (������ 5�� �� ���δ� �߶�)
%������ 5�� ���� ��ġ ����
Last5Line = LineLocation(end-4:end); 
%��ǥ�� ��ġ�� ������ �ٷ� �����ϱ� ���� ����
LineCreteria = (LineLocation(end-4) - LineLocation(end-5))/2+LineLocation(end-5); 
%���� �� �����ϴ� ��ǥ ����
InnerCreteria = find(NoteLocation(:,2)>LineCreteria);
NoteInLastLine5 = NoteLocation(InnerCreteria,:); %���� ���� �����ϴ� ��ǥ�� ��ġ ��ǥ ���
%% ��ǥ ���ļ� ã�� ����
% �� �� �� ���� ã��
Distance2 = abs(sum(Last5Line-Last5Line(5))/10);
Distance = Distance2/2;

% frequecy�� �� 12����� ���� (������� �����鸸 ��) 
RepNoteY = repmat(NoteInLastLine5(:,2),1,12);
RepNoteX = repmat(NoteInLastLine5(:,1),1,12);
TempDistance = Distance*repmat([-2:9],length(NoteInLastLine5(:,2)),1);
% whereIs = RepNoteY+TempDistance-Last5Line(end);
%���� ���ؼ� �� ���� ���翩�� �ľ�(����ȣ�� ���° ������ ��Ÿ��)
WhichFrequencyIsON = abs((RepNoteY+TempDistance-Last5Line(end)))<(Distance/2);
frequency = (RepNoteX.*WhichFrequencyIsON)'>0;


