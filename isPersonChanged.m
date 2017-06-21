function [ isChanged,diffSpatioArr ] = isPersonChanged( disMatrix1,disMatrix2,tracehold )
%The tracehold value will be between 0 to 0.002
% 0 - no mistakes
% 0.5 - half values different
%I compare the ratio between the distances 

if(isempty(disMatrix1) || isempty(disMatrix2))   
    isChanged = false;
    msgbox('The system do not recognize any face','Error message','error');
    return;  
end

if(size(disMatrix1,1) ~= size(disMatrix2,1) )
    isChanged = false;
    diffSpatioArr=[];
    return;  
end

if(tracehold < 0 || tracehold > 1) % for my tests i make the tracehold to be 0.02
    isChanged = false;
    diffSpatioArr = [];
    return;
end




massiveChangesCountr=0; %will be incremented when the ratio between two calculations will be in large scale

maxNumOfMistakes = floor(size(disMatrix2,1) * 0.1); % 10 precentege of the calculated distances 

%Previos frame,Current frame,'Ratio',big distance
diffSpatioArr=cell(0,7);

%dataset({diffSpatioArr 'Previos frame','Current frame','Distance','Ratio'}); %set columns names

for (i=1:size(disMatrix2,1))
    if(disMatrix1{i,2} >= disMatrix2{i,2}) %get positive ratio
        
        posRatio= disMatrix1{i,2}/disMatrix2{i,2}; 
        
    else
        posRatio= disMatrix2{i,2}/disMatrix1{i,2};
    end
    
    
    [intNum,decNum] =SplitDecimalNumber(posRatio);
    %{
    if(intNum > 1)
        msgbox('Tampering detected!\nThe distances ratio between the last two frames was very high','Error message','error');
        isChanged = true;
        return;
    end
    %}
    diffSpatioArr{i,1}= disMatrix1{i,1}; % disName
    diffSpatioArr{i,2}= disMatrix1{i,2}; % prev dis
    diffSpatioArr{i,3}= disMatrix2{i,2}; % curr dis
    diffSpatioArr{i,4}= doubleHash(disMatrix1{i,2}); %hash Distance 1
    diffSpatioArr{i,5}= doubleHash(disMatrix2{i,2}); %hash Distance 2
    diffSpatioArr{i,6}= posRatio; %ratio
    
    
    if(decNum > tracehold)
        massiveChangesCountr = massiveChangesCountr+1;
        diffSpatioArr{i,7} = 1; % if have a big change - 1
    end
end

if(massiveChangesCountr >= maxNumOfMistakes)
    isChanged = true;
    return;
else
   isChanged = false; 
end


end

