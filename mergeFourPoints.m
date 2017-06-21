% mergeFourPoints merges multiple detection of same face
%
% dst = mergeFourPoints(src)
%
%Output parameter:
% dst: merged fourpoints data
%
%
%Input parameter:
% src: fourpoints data to be merged
%
%
%NOTE: This function is internally called in detectRotFaceParts
%
%Version: 20160607

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Face Parts Detection:                                    %
%                                                          %
% Copyright (C) 2016 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dst = mergeFourPoints(src)

if( size(src,1) > 0 )
 pos = zeros(size(src,1),2);
 pos(:,1) = mean(src(:,[1,3,5,7]),2);
 pos(:,2) = mean(src(:,[2,4,6,8]),2);

 pos = horzcat(pos,[1:size(src,1)]');

 dst = [];
 while( ~isempty(pos) )
  if( size(pos,1) == 1 )
   dst = vertcat(dst,src(pos(1,3),:));
   pos = [];
  else
  
   tmp = src(pos(1,3),:);
   rad = norm(pos(1,1:2) - tmp(1,1:2)) + norm(pos(1,1:2) - tmp(1,3:4)) + norm(pos(1,1:2) - tmp(1,5:6)) + norm(pos(1,1:2) - tmp(1,7:8));
   th = rad / 8;
  
   p = 1;
   for i=2:size(pos,1)
    rad = norm(pos(1,1:2) - pos(i,1:2));
    if( rad < th )
     tmp = vertcat(tmp,src(pos(i,3),:));
     p = horzcat(p,i);
    end
   end
   if( size(tmp,1) > 1 )
       num = tmp > 0;
       tmp = sum(tmp) ./ sum(num);
   end
   dst = vertcat(dst,tmp);
   pos(p,:) = [];
  end
 end
else
 dst = src;
end
