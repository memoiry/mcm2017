%% 该文件演示基于TSP-PSO算法
clc;clear
global sel theta lambda alpha beta k2 vtotal w x kdam lr;
%% 各大坝数据
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

%% 计算城市间距离
for interval = 2:2:20
    inte = h_low:interval:h_high;
    lent = length(inte);
    tourtt = [];
    nMax=100;                      %进化次数
    indiNumber=1000;               %个体数目
    individual=zeros(indiNumber,n*2);
    %^初始化粒子位置
    for i=1:indiNumber
        individual(i,1:n)=randperm(n)>(n-sel);
        individual(i,(n+1):(2*n))=inte(randi([1,lent],1,n));
    end
    
    %% 计算种群适应度
    indiFit=fitness(individual);
    [value,index]=min(indiFit);
    tourPbest=individual;                              %当前个体最优
    tourGbest=individual(index,:) ;                    %当前全局最优
    recordPbest=inf*ones(1,indiNumber);                %个体最优记录
    recordGbest=indiFit(index);                        %群体最优记录
    xnew1=individual;
    %% 循环寻找最优路径
    L_best=zeros(1,nMax);
    count = 1;
    for N=1:nMax
        %计算适应度值
        waitbar(((interval/2-1)*nMax+N)/(nMax*10),h)
        indiFit=fitness(individual);
        
        %更新当前最优和历史最优
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
        
        % 交叉操作
        for i=1:indiNumber
            % 与个体最优进行交叉, 高度
            c1=unidrnd(n-1); %产生交叉位
            c2=unidrnd(n-1); %产生交叉位
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            chb1=min(c1,c2);
            chb2=max(c1,c2);
            cros=tourPbest(i,(n+chb1):(n+chb2));
            ncros=size(cros,2);
            
            %插入交叉区域
            xnew1(i,(n+chb1):(n+chb2))=cros;
            
            %新路径长度变短则接受
            dist=0;
            dist = fitness(xnew1(i,:));
            if indiFit(i)>dist
                individual(i,:)=xnew1(i,:);
            end
            
            % 与全体最优进行交叉
            c1=round(rand*(n-2))+1;  %产生交叉位
            c2=round(rand*(n-2))+1;  %产生交叉位
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            chb1=min(c1,c2);
            chb2=max(c1,c2);
            cros=tourGbest((n+chb1):(n+chb2));
            ncros=size(cros,2);
            %插入交叉区域
            xnew1(i,(n+chb1):(n+chb2))=cros;
            %新路径长度变短则接受
            dist=0;
            dist = fitness(xnew1(i,:));
            if indiFit(i)>dist
                individual(i,:)=xnew1(i,:);
            end
            
            % 变异操作
            c1=round(rand*(n-1))+1;   %产生变异位
            c2=round(rand*(n-1))+1;   %产生变异位
            while c1==c2
                c1=round(rand*(n-2))+1;
                c2=round(rand*(n-2))+1;
            end
            c1 = n + c1;
            c2 = n + c2;
            temp=xnew1(i,c1);
            xnew1(i,c1)=xnew1(i,c2);
            xnew1(i,c2)=temp;
            
            %新路径长度变短则接受
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
%% 结果作图
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