function spatial_calibration_demo()
% spatial_calibration_demo This demo allows you to
% spatially calibrate your image and then
% make distance or area measurements.

global originalImage;
% Check that user has the Image Processing Toolbox installed.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
%
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% Read in a standard MATLAB gray scale demo image.
%{
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
button = menu('Use which demo image?', 'CameraMan', 'Moon', 'Eight', 'Coins', 'Peppers', 'Exit');
switch button
	case 1
		baseFileName = 'cameraman.tif';
	case 2
		baseFileName = 'moon.tif';
	case 3
		baseFileName = 'eight.tif';
	case 4
		baseFileName = 'coins.png';
	case 5
		baseFileName = 'peppers.png';
end
%}

% Get the full filename, with path prepended.
fullFileName = getImagePath();
% Check if file exists.
if ~exist(fullFileName, 'file')
	% File doesn't exist -- didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
% Read in the chosen standard MATLAB demo image.
originalImage = imread(fullFileName);
% Get the dimensions of the image.
% numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(originalImage);
% Display the original gray scale image.
figureHandle = figure;
subplot(1,2, 1);
imshow(originalImage, []);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off')

message = sprintf('First you will be doing spatial calibration.');
reply = questdlg(message, 'Calibrate spatially', 'OK', 'Cancel', 'OK');
if strcmpi(reply, 'Cancel')
	% User said Cancel, so exit.
	return;
end
button = 1; % Allow it to enter loop.

while button ~= 4
	if button > 1
		% Let them choose the task, once they have calibrated.
		button = menu('Select a task', 'Calibrate', 'Measure Distance', 'Measure Area', 'Exit Demo');
	end
	switch button
		case 1
			Calibrate();
			% Change to something else so it will ask them
			% for the task on the next time through the loop.
			button = 99;
		case 2
			DrawLine();
		case 3
			DrawArea();
		otherwise
			close(figureHandle);
			break;
	end
end

end

%=====================================================================
function Calibrate()
global lastDrawnHandle;
global calibration;

instructions = sprintf('Left click to anchor first endpoint of line.\nRight-click or double-left-click to anchor second endpoint of line.\n\nAfter that I will ask for the real-world distance of the line.');
title(instructions);
msgboxw(instructions);

[cx, cy, rgbValues, xi,yi] = improfile(1000);
% rgbValues is 1000x1x3.  Call Squeeze to get rid of the singleton dimension and make it 1000x3.
rgbValues = squeeze(rgbValues);
distanceInPixels = sqrt( (xi(2)-xi(1)).^2 + (yi(2)-yi(1)).^2);
if length(xi) < 2
	return;
end
% Plot the line.
hold on;
lastDrawnHandle = plot(xi, yi, 'y-', 'LineWidth', 2);

% Ask the user for the real-world distance.
userPrompt = {'Enter real world units (e.g. microns):','Enter distance in those units:'};
dialogTitle = 'Specify calibration information';
numberOfLines = 1;
def = {'microns', '500'};
answer = inputdlg(userPrompt, dialogTitle, numberOfLines, def);
if isempty(answer)
	return;
end
calibration.units = answer{1};
calibration.distanceInPixels = distanceInPixels;
calibration.distanceInUnits = str2double(answer{2});
calibration.distancePerPixel = calibration.distanceInUnits / distanceInPixels;

return;	% from Calibrate()
end

%=====================================================================
% --- Executes on button press in DrawLine.
function DrawLine()
try
	global lastDrawnHandle;
	global calibration;
	fontSize = 14;
	
	instructions = sprintf('Draw a line.\nFirst, left-click to anchor first endpoint of line.\nRight-click or double-left-click to anchor second endpoint of line.\n\nAfter that I will ask for the real-world distance of the line.');
	title(instructions);
	msgboxw(instructions);
	subplot(1,2, 1); % Switch to image axes.
	[cx,cy, rgbValues, xi,yi] = improfile(1000);
	% Get the profile again but spaced at the number of pixels instead of 1000 samples.
	hImage = findobj(gca,'Type','image');
	theImage = get(hImage, 'CData');
	lineLength = round(sqrt((xi(1)-xi(2))^2 + (yi(1)-yi(2))^2))
	[cx,cy, rgbValues] = improfile(theImage, xi, yi, lineLength);
	
	% rgbValues is 1000x1x3.  Call Squeeze to get rid of the singleton dimension and make it 1000x3.
	rgbValues = squeeze(rgbValues);
	distanceInPixels = sqrt( (xi(2)-xi(1)).^2 + (yi(2)-yi(1)).^2);
	distanceInRealUnits = distanceInPixels * calibration.distancePerPixel;
	
	if length(xi) < 2
		return;
	end
	% Plot the line.
	hold on;
	lastDrawnHandle = plot(xi, yi, 'y-', 'LineWidth', 2);
	
	% Plot profiles along the line of the red, green, and blue components.
	subplot(1,2,2);
	[rows, columns] = size(rgbValues);
	if columns == 3
		% It's an RGB image.
		plot(rgbValues(:, 1), 'r-', 'LineWidth', 2);
		hold on;
		plot(rgbValues(:, 2), 'g-', 'LineWidth', 2);
		plot(rgbValues(:, 3), 'b-', 'LineWidth', 2);
		title('Red, Green, and Blue Profiles along the line you just drew.', 'FontSize', 14);
	else
		% It's a gray scale image.
		plot(rgbValues, 'k-', 'LineWidth', 2);
	end
	xlabel('X', 'FontSize', fontSize);
	ylabel('Gray Level', 'FontSize', fontSize);
	title('Intensity Profile', 'FontSize', fontSize);
	grid on;
	
	% Inform use via a dialog box.
	txtInfo = sprintf('Distance = %.1f %s, which = %.1f pixels.', ...
		distanceInRealUnits, calibration.units, distanceInPixels);
	msgboxw(txtInfo);
	% Print the values out to the command window.
	fprintf(1, '%\n', txtInfo);
	
catch ME
	errorMessage = sprintf('Error in function DrawLine().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
end  % from DrawLine()

%=====================================================================
function DrawArea()
global originalImage;
global lastDrawnHandle;
global calibration;
try
	txtInfo = sprintf('Left click to anchor vertices.\nDouble left click to anchor final point of polygon.');
	title(txtInfo);
	msgboxw(txtInfo);
	
	% Get size information.
	[rows, columns, numberOfColorBands] = size(originalImage);
	
	% Get a gray scale version.
	if numberOfColorBands > 1
		grayImage = rgb2gray(originalImage);
	else
		grayImage = originalImage;
	end
	
	subplot(1,2, 1); % Switch to image axes.
	% Ask user to draw a polygon.
	[maskImage, xi, yi] = roipolyold();
	
	% Draw the polygon over the image on the main screen.
	hold on;
	lastDrawnHandle = plot(xi, yi, 'r-', 'LineWidth', 2);
	numberOfPixels = sum(maskImage(:));
	area = numberOfPixels * calibration.distancePerPixel^2;
	
	% Get the mean gray level of the gray scale image.
	mean_GL = mean(grayImage(maskImage)); % Of the gray scale version.

	% Print the area values out to the command window.
	txtInfo = sprintf('Area = %8.1f square %s.\nMean gray level = %.2f.', ...
		area, calibration.units, mean_GL);
	fprintf(1,'%s\n', txtInfo);
	title(txtInfo, 'FontSize', 14);

	% Done with measurement of area.
	% Now, just for fun, get the mean value and display the histogram.
	if numberOfColorBands >= 3
		% It's a color image.  Get the mean RGB Values.
		redPlane = double(originalImage(:, :, 1));
		greenPlane = double(originalImage(:, :, 2));
		bluePlane = double(originalImage(:, :, 3));
		mean_RGB_GL(1) = mean(redPlane(maskImage));
		mean_RGB_GL(2) = mean(greenPlane(maskImage));
		mean_RGB_GL(3) = mean(bluePlane(maskImage));
		fprintf('%s\nRed mean = %.2f\nGreen mean = %.2f\nBlue mean = %.2f', ...
			txtInfo, mean_RGB_GL(1), mean_RGB_GL(2), mean_RGB_GL(3));
	end	
	
	% Just for fun, let's get its histogram within the masked region.
	[pixelCount, grayLevels] = imhist(grayImage(maskImage));
	subplot(1,2, 2); % Switch to plot axes.
	cla;
	bar(pixelCount);
	grid on;
	caption = sprintf('Histogram within area.    Mean gray level = %.2f', mean_GL);
	title(caption, 'FontSize', 14);
	xlim([0 grayLevels(end)]); % Scale x axis manually.
	% Show the mean as a vertical red bar on the histogram.
	hold on;
	maxYValue = ylim;
	line([mean_GL, mean_GL], [0 maxYValue(2)], 'Color', 'r', 'linewidth', 2);
catch ME
	errorMessage = sprintf('Error in function DrawArea().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end

end % od DrawArea()

%=====================================================================
function msgboxw(message)
uiwait(msgbox(message));
end