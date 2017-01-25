function indiFit=fitness(target)
%% 该函数用于计算个体适应度值
%x           input     个体
%cityCoor    input     城市坐标
%cityDist    input     城市距离
%indiFit     output    个体适应度值
global sel theta lambda alpha beta k2 vtotal w x kdam lr;

m=size(target,1);
n=size(w,2);
indiFit=zeros(m,1);
for i=1:m
    l = zeros(1,sel);
    b = zeros(1,sel);
    v = zeros(1,sel);
    Cons = zeros(1,sel);
    h_water = zeros(1,sel);
    tar = target(i,:);
    count = 1;
    for j = 1:n
        if tar(j) == 0
            continue
        end
        if count == 1
            l(count) = sum(x(1:j));
        else
            l(count) = sum(x(1:j)) - sum(l(1:(count -1)));
        end
        count = count + 1 ;
    end
    count = 1;
    for j = 1:n
        if tar(j) == 0
            continue
        end
        b(count) = w(j);
        count = count + 1 ;
    end
    count = 1;
    for j = 1:n
        if tar(j) == 0
            continue
        end
        h_water(count) = tar(n+j)*lambda;
        count = count + 1 ;
    end
    for j = 1:sel
        v(j) = l(j)*(w(j)+h_water(j)/tan(theta))*h_water(j);
    end
    Cons = k2.*(b*kdam).^alpha.*(h_water/lambda).^beta;
    indiFit(i) = sum(Cons);
    if sum(v) < vtotal
        indiFit(i) = indiFit(i) + 10^15;
    end
    safe = 0;
    safe_temp = [];
    for j = 1:sel
        htemp = h_water(j)/lambda;
        if(htemp<30)
            safe = safe + 1;
            safe_temp = [safe_temp 1];
        elseif htemp<45
            safe = safe + 2;
            safe_temp = [safe_temp 2];
        elseif htemp<70
            safe = safe + 3;
            safe_temp = [safe_temp 3];
        else 
            safe = safe + 4;
            safe_temp = [safe_temp 4];
        end
    end
    %if length(find(l>lr)) ~= 0
    %    indiFit(i) = indiFit(i) + 10^15;
    %end
    
    %safe/sum(tar(1:n))
    %l
    %b
    %h_water/lambda
    %Cons
    %safe_temp
    if safe > sel*2.5
        indiFit(i) = indiFit(i) + 10^15;
    end
end