function [ hashedNumber ] = doubleHash( number )
%hash double number to string
    hashedNumber=[];

    if(isempty(number))        
        return;
    end
    
    [before,after]=SplitDecimalNumber(number); %split number before and after the dot
    
    after =round( after*1000); % disable the double by multing 10*num of digits.
    
    while before >0
       lastDigit =  mod(before,10); %get the last digit
       hashedDigit = doubleHashHelper(lastDigit); %hashing
       hashedNumber = strcat(hashedNumber,hashedDigit); %add the new hash value to the hash string
       before = floor(before/10); %devide by 10 and floor 
    end
    
    
     while after >0
       lastDigit =  mod(after,10); %get the last digit
       hashedDigit = doubleHashHelper(lastDigit); %hashing
       hashedNumber = strcat(hashedNumber,hashedDigit); %add the new hash value to the hash string
       after = floor(after/10); %devide by 10 and floor 
    end


end

