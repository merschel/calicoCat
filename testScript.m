clear
clc

n = 6;


m = n*(n+1)*(n+2)/6;

h = cell(m,1);

count1 = 0;
count2 = n;
count3 = (n^2+n)/2;
count4 = n^2;
for i = 1:n
    count1 = count1 + 1;
    h{count1} = [0,i];
    for j = i+1:n
        count2 = count2 + 1;
        h{count2} = [i,j];
        count3 = count3 + 1;
        h{count3} = [0,i,j];
        for k = j+1:n
            count4 = count4 + 1;
            h{count4} = [i,j,k ];
        end
    end
end

