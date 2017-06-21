function [ before,after ] = SplitDecimalNumber( num )
%return the number before the point and after the point

before = floor(num);
after = num - before;

end

