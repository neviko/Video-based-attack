function distance = calculateDistancesHelper(pointsMatrix,point1,point2,drawLine,isDeley)

yDist = abs(pointsMatrix(point1,2)- pointsMatrix(point2,2)); %Y distance
xDist = abs(pointsMatrix(point1,1)- pointsMatrix(point2,1)); %X distance
distance = sqrt((yDist)^2+(xDist)^2); %real distance after pitagoras



if(drawLine)
    if(isDeley) % if the deley param is true make deley
      pause(0.35); 
    end
    %draw the line in the image
    plot([pointsMatrix(point1,1) pointsMatrix(point2,1)],[pointsMatrix(point1,2) pointsMatrix(point2,2)],'Color','w','LineWidth',2)
end


end

