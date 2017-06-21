function [ hashValue ] = doubleHashHelper( number )
%this function hashing a single number 

    if(isempty(number))
        hashValue=[];
        return;
    end

    if(number==0)
        hashValue='Mu';

    elseif(number==1)
        hashValue='Pf,';  

    elseif(number==2)
        hashValue='rr';    

    elseif(number==3)
        hashValue='7W';    

    elseif(number==4)
        hashValue='X1q';

    elseif(number==5)
        hashValue='%';   

    elseif(number==6)
        hashValue='ZO';

    elseif(number==7)
        hashValue='b9';

    elseif(number==8)
        hashValue='@#';

    elseif(number==9)
        hashValue='$m@';    
    end


end

