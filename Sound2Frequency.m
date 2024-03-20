function result = Sound2Frequency(record)
Frequency = abs(fft(record)/length(record)); %���ļ��� ������ ũ�⸸ ����
% �ӷ����Ҽ��� ���� ��Ī�κ� ������ ����
Frequency2 = Frequency(1:fix(end/2)+1); 
Frequency2(2:end-1) = 2*Frequency2(2:end-1);
F = 44100*[0:length(Frequency)/2]/length(Frequency);
temp = F(find(Frequency2>max(Frequency2)*0.65));% �Ӱ�ġ �̻����� ū �⺻ ���ļ��� �̾Ƴ�
% ���� ���ļ��� ��� ���� ��ġ�ϴ��� 12���� ���� ���� check
tempresult = zeros(length(temp),12) ;
    for k=1:length(temp)
    reptemp = repmat(temp(k),1,12);
    expcenterFrequency = [-9 -7 -5 -4 -2 0 2 3 5 7 9 11]/12;
    bandwidth = 440*(2.^(expcenterFrequency+1/24)-2.^(expcenterFrequency-1/24));
    CenterFrequency = 440*(2.^(expcenterFrequency));
    IsFrequency = abs(reptemp-CenterFrequency)<bandwidth;
    tempresult(k,:) = IsFrequency;
    end
    
    if length(tempresult(:,1))==1
        result = tempresult';
    else
        result = (sum(tempresult)')>0;
    end
    
end


