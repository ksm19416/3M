function [result1,result2] = ComparisonF(SoundFromScore,SoundFromRecording,ComparisonNum)
%% �� �� ��� : �� ���� record�࿡ �ϳ��� sound�� ��ġ���θ� ��
% �켱 record�� ������ ��� ���� �� �ְ� sound�� record�� ����
if sum(SoundFromRecording(:,end))~=0
    if ComparisonNum(1) == 0
    TempScore = repmat(SoundFromScore(:,ComparisonNum(1)+1),1,3);%�Ǻ����� n��°���� ��
    TempSound = SoundFromRecording(:,end-2:end);
    IsCorrect = (sum(TempScore == TempSound)>=11);
    else 
    TempScore = repmat(SoundFromScore(:,ComparisonNum(1)+1),1,3);
    TempScore = [TempScore ; repmat(SoundFromScore(:,ComparisonNum(1)),1,3)];
    TempSound = repmat(SoundFromRecording(:,end-2:end),2,1);
    IsCorrect = (sum(TempScore == TempSound)>=22); % 11�� �̻� ��ġ�ϴ��� Ȯ��
    end
result1 = sum(IsCorrect); % ��ġ�ϴ� ���� ��ȯ
result2 = (ComparisonNum(2)+1); % ���� ���ֵ� ������ �ľǵǸ� ī��Ʈ
else
result1 = 0 ;
result2 = 0;
end
