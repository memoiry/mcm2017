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
%% n
x = [0.8 1.5 2 2.5 3 3.5 4 4.5];
rec = [408.6000  410.0000  412.0000  413.8000  414.2000  418.0000  419.0000  425.0000]

[P,S]=polyfit(x,rec,1);
x1=0.8:0.01:4.5;
f=polyval(P,x1);
plot(x,rec,'ro',x1,f,'-')

xlabel('In_0')
ylabel('Objective value')
grid on
%% n
x = b;
rec = a;

[P,S]=polyfit(x,rec,1);
x1=1:0.01:1.8;
f=polyval(P,x1);
plot(x,rec,'ro',x1,f,'-')

xlabel('variance')
ylabel('Objective value')
grid on
%%
plot(safe_trans+cons_trans,'pr')
xlabel('The number of sites selected')
ylabel('The sum of the normalized average security level and the normalized optimal cost')
grid on

