a1 = tourtt(1,:);
a2 = tourtt(8,:);
sel = 10;
fitness(a1)

%%
load tourtt
global sel;
sel = 16;
a2 = tourtt(7,:);
fitness(a2)
find(a2 == 1)
%%
global sel;
cons = [];
safe = [1.3,1.2727,1.5,1,1.2857,1.0667,1,1.1176,1.2222,1.2105,1];
for sel = 10:20
    cons = [cons fitness(tourtt(sel-9,:))];
end
%%
global sel;
for sel = 10:20
    fitness(tourtt(sel-9,:));
end
%% trans
safe_trans = mapminmax(safe,0,1)
cons_trans = mapminmax(cons,0,1)
%% 安全拟合
x = 10:20
safe_ = [1.3,1.2727,1.5,1,1.2857,1.0667,1,1.1176,1.2222,1.2105,1];
[P,S]=polyfit(x,safe_,1);
[Y,delta]=polyconf(P,1:11,S)
x1=10:0.1:20;
f=polyval(P,x1);
plot(x,safe_,'ro',x1,f,'-')

xlabel('The number of sites selected')
ylabel('The average safe level')
grid on
% 造价拟合
figure
x = 10:20
[P,S]=polyfit(x,cons,1);
x1=10:0.1:20;
f=polyval(P,x1);
plot(x,cons,'ro',x1,f,'-')
xlabel('The number of sites selected')
ylabel('The optimal Construction cost/million')
grid on
%%
plot(safe_trans+cons_trans,'pr')
xlabel('The number of sites selected')
ylabel('The sum of the normalized average security level and the normalized optimal cost')
grid on

