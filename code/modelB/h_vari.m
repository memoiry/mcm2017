%% ���ļ���ʾ����TSP-PSO�㷨
clc;clear
global sel theta lambda alpha beta k2 vtotal w x kdam lr;
%% ���������
w = [246	219	206	407	281	359	413	319	218	248	323	260	534	999	380	815	937	372	916	939	929	1112	1205	1142	1152	1214	825	452	408	577];
x = [7652 7772	8362	10476	2160	3178	7621	10306	9952	12451	12462	16279	14300	33250	8019	296342	20229	7362	18229	13764	15215	11072	12405	17455	16545	10831	15501	23437	80157	9472];
n = length(w);
sel = 10;
kv = 40;
%lr = 3000;
kdam = 1.2;
vtotal = 180.6*10^9/kv;
lambda = 0.75;
alpha = 1.27274;
beta = 1.71658;
k2 = 0.0000356525;
theta = 45*pi/180;
h_low = 20;
h_high = 100;
h = waitbar(0,'Please wait...');

%% ������м����
for interval = 2:2:20
    inte = h_low:interval:h_high;
    lent = length(inte);
    tourtt = [];
    nMax=100;                      %��������
    indiNumber=1000;               %������Ŀ
    individual=zeros(indiNumber,n*2);
    %^��ʼ������λ��
    for i=1:indiNumber
        individual(i,1:n)=randperm(n)>(n-sel);
        individual(i,(n+1):(2*n))=inte(randi([1,lent],1,n));
    end
    
    %% ������Ⱥ��Ӧ��
    indiFit=fitness(individual);
    [value,index]=min(indiFit);
    tourPbest=individual;                              %��ǰ��������
    tourGbest=individual(index,:) ;                    %��ǰȫ������
    recordPbest=inf*ones(1,indiNumber);                %�������ż�¼
    recordGbest=indiFit(index);                        %Ⱥ�����ż�¼
    xnew1=individual;
    %% ѭ��Ѱ������·��
    L_best=zeros(1,nMax);
    count = 1;
    for N=1:nMax
        %������Ӧ��ֵ
        waitbar(((interval/2-1)*nMax+N)/(nMax*10),h)
        indiFit=fitness(individual);
        
        %���µ�ǰ���ź���ʷ����
        for i=1:indiNumber
            if indiFit(i)<recordPbest(i)
                recordPbest(i)=indiFit(i);
                tourPbest(i,:)=individual(i,:);
            end
            if indiFit(i)<recordGbest
                recordGbest=indiFit(i);
                tourGbest=individual(i,:);
            end
        end
        
        [value,index]=min(recordPbest);
        recordGbest(N)=recordPbest(index);
        
        % �������
        for i=1:indiNumber
            % ��������Ž��н���, �߶�
            c1=unidrnd(n-1); %��������λ
            c2=unidrnd(n-1); %��������λ
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            chb1=min(c1,c2);
            chb2=max(c1,c2);
            cros=tourPbest(i,(n+chb1):(n+chb2));
            ncros=size(cros,2);
            
            %���뽻������
            xnew1(i,(n+chb1):(n+chb2))=cros;
            
            %��·�����ȱ�������
            dist=0;
            dist = fitness(xnew1(i,:));
            if indiFit(i)>dist
                individual(i,:)=xnew1(i,:);
            end
            
            % ��ȫ�����Ž��н���
            c1=round(rand*(n-2))+1;  %��������λ
            c2=round(rand*(n-2))+1;  %��������λ
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            chb1=min(c1,c2);
            chb2=max(c1,c2);
            cros=tourGbest((n+chb1):(n+chb2));
            ncros=size(cros,2);
            %���뽻������
            xnew1(i,(n+chb1):(n+chb2))=cros;
            %��·�����ȱ�������
            dist=0;
            dist = fitness(xnew1(i,:));
            if indiFit(i)>dist
                individual(i,:)=xnew1(i,:);
            end
            
            % �������
            c1=round(rand*(n-1))+1;   %��������λ
            c2=round(rand*(n-1))+1;   %��������λ
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            c1 = n + c1;
            c2 = n + c2;
            temp=xnew1(i,c1);
            xnew1(i,c1)=xnew1(i,c2);
            xnew1(i,c2)=temp;
            
            %��·�����ȱ�������
            dist=0;
            dist = fitness(xnew1(i,:));
            if indiFit(i)>dist
                individual(i,:)=xnew1(i,:);
            end
        end
        
        [value,index]=min(indiFit);
        L_best(N)=indiFit(index);
        tourGbest=individual(index,:);
        if individual(index,:) > tourGbest
            count = count + 1;
            if count > 5
                for i=1:indiNumber
                    individual(i,1:n)=randperm(n)>(n-sel);
                    individual(i,(n+1):(2*n))=inte(randi([1,lent],1,n));
                end
                count = 1;
            end
        end
    end
    tourtt = [tourtt ;fitness(tourGbest)];
end
close(h)
%%
%% �����ͼ
figure
res = fitness(tourtt);
plot(10:20,res','pr')
xlabel('The number of sites')
ylabel('The optimal Construction cost/million')
grid on
figure
plot([2.3,2.09,2.1667,1.5385,1.7143,1.4,1.25,1.2941,1.333,1.2632,1],'pr')
xlabel('The number of sites')
ylabel('The average safe grade')