function phi = trans(s,s_)

a1 = 0.42;
a2 = 3.7;
a3 = 5.2;
a4 = 8.3;

lel = 1.8;
temp = s_./s;
n = length(temp);
phi = zeros(1,n);
for i = 1:n
    if temp(i) >= 0.42 && temp(i) <=1.7*lel
        phi(i) = 1;
    elseif temp(i) > 1.7*lel && temp(i) <=3.2
        phi(i) = 1.2;
    elseif temp(i) > 3.2 && temp(i) <=8.3
        phi(i) = 1.8;
    else
        phi(i) = 3;
    end
end