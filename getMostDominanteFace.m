function [ dominanteFace ] = getMostDominanteFace( boxes )
%return the most dominante face in image

if(isempty(boxes))
    dominanteFace=[];
    return;
end

maxArea=0;

for i=1:size(boxes,2)
   if(iscell(boxes)) %cell type handle
       currArr = cell2mat(boxes(1,i)); %convert cell to matrix       
       currArea = currArr(1,3)*currArr(1,4); %Calculate the rectancle area (width*height)
       if(currArea > maxArea)
           maxArea = currArea;
           maxFaceIdx=i;      
       end
             
       
   else %double matrix handle
       currArr = boxes(:,i);
       currArea = currArr(3,1)*currArr(4,1); %Calculate the rectancle area (width*height)
       if(currArea > maxArea)
           maxArea = currArea;
           maxFaceIdx=i;      
       end
   end
   
 
   

end

dominanteFace = boxes(:,maxFaceIdx);% copy the most dominante face

