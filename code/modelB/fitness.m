function indiFit=fitness(target)
%% 该函数用于计算个体适应度值
%x           input     个体
%cityCoor    input     城市坐标
%cityDist    input     城市距离
%indiFit     output    个体适应度值
global s in rain sr step in0;
m=size(target,1);
ns=size(target,2);
n = ns/step;
indiFit=zeros(m,1);
for i=1:m
    tar = target(i,:);
    s_ = s;
    phi = 0;
    for j = 1:step
        tarj = tar(((step-1)*n+1):(step*n));
        tar_ = [0 tarj];
        tar_ = tar_(1:(end-1));
        s_(1) = s_(1) - tarj(1) + in(1).*rain(1) + in0;
        s_(2:end) = s_(2:end) - tarj(2:end) + tar_(2:end) + in(2:end).*rain(2:end);
        phi = phi + trans(s,s_);
        indiFit(i) = phi*sr';
        if sum(tarj) > sum(in+in0)*0.95
            indiFit(i) = indiFit(i) + 10^15;
        end
    end
end