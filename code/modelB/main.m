%% 该文件演示基于TSP-PSO算法
clc;clear
global s in rain sr step in0;

%% 各大坝数据

in = [4.2	3.5	13.7	1.1	1.8	10.9	4.3	3.2	6.6	3.8	14.8	258	42.5	111.5	13.5	44.4];
s = [0.8	0.8	3.4	0.3	0.5	2.5	1	1.4	1.8	1.9	3.4	60	13.3	36.1	4.7	14.4];
sr = [2	2	3	1	1	3	2	2	2	2	3	4	4	4	3	4];

n = length(s);
rain = ones(1,n);
%rain = randi([-1,1],1,n)
step = 5;
in0 = 4.3;
%in0 = 0.86;
%in0 = 2.5;
sn = step*n;
%%
nMax=40;                      %进化次数
indiNumber=800;               %个体数目
individual=zeros(indiNumber,n);
%^初始化粒子位置
for i=1:indiNumber
    individual(i,1:(sn))=rand(1,sn).*repmat(s,1,step).*0.5;
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
    N
    %计算适应度值
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
        c1=unidrnd(sn-1); %产生交叉位
        c2=unidrnd(sn-1); %产生交叉位
        while c1==c2
            c1=round(rand*(sn-2))+1;
            c2=round(rand*(sn-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourPbest(i,chb1:chb2);
        ncros=size(cros,2);
        
        %插入交叉区域
        xnew1(i,chb1:chb2)=cros;
        
        %新路径长度变短则接受
        dist=0;
        dist = fitness(xnew1(i,:));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
        % 与全体最优进行交叉
        c1=round(rand*(sn-2))+1;  %产生交叉位
        c2=round(rand*(sn-2))+1;  %产生交叉位
        while c1==c2
            c1=round(rand*(sn-2))+1;
            c2=round(rand*(sn-2))+1;
        end
        chb1=min(c1,c2);
        chb2=max(c1,c2);
        cros=tourGbest(chb1:chb2);
        ncros=size(cros,2);
        %插入交叉区域
        xnew1(i,chb1:chb2)=cros;
        %新路径长度变短则接受
        dist=0;
        dist = fitness(xnew1(i,:));
        if indiFit(i)>dist
            individual(i,:)=xnew1(i,:);
        end
        
        % 变异操作
        c1=round(rand*(sn-1))+1;   %产生变异位
        c2=round(rand*(sn-1))+1;   %产生变异位
        while c1==c2
            c1=round(rand*(sn-2))+1;
            c2=round(rand*(sn-2))+1;
        end
        c1 = c1;
        c2 = c2;
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
        if count > 10
            for i=1:indiNumber
                individual(i,1:(sn))=rand(1,sn).*s.*0.5;
            end
            count = 1;
        end
    end
end
%% 结果作图
figure
tourGbest
fitness(tourGbest)
plot(L_best(find(L_best<10^10)))
title('Training Process')
xlabel('Iteration times')
ylabel('Construction cost/million')
grid on