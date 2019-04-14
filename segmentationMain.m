% Following code provides line segmentation of input text image. It works
% as:
% Read the input documnet image and binarize.
% Invert binarized image to make text white and background black.
% 
clc
close all
clear all

% path of input images folder
%myFolder = 'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage';
myFolder ='D:\Data\Thesis\Dataset\MyDataset\OriginalImages';
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
path = pwd;
% read  images in directory
% fileContents = fullfile(myFolder, '*.bmp');
fileContents = fullfile(myFolder, '77.jpeg');
%fileContents = fullfile(myFolder, '*.png');
Files = dir(fileContents);   
%=========================================================================   

for k = 1:length(Files)
    
    disp(['Writing image:' num2str(k)]);
    baseFileName = Files(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    
    id = 1;
   % for finding exact peak in "findPeaks" function you need to manually set this value
    TUNE = -10;
    
    % read input image
    imageArray = imread(fullFileName);
    %figure,imshow(imageArray);
   
    % Binarize the image
    binaryImage=im2bw(imageArray);
    % figure,imshow(binaryImage);
    
    % take complement to convert text in white    
    % figure,imshow(binaryImage);
    I = imcomplement(binaryImage);
    
% structuring element to initially dilate documnet image

SE=strel('rectangle',[9 50]);
dilatedImage = imdilate(I,SE);    
II = imcomplement(dilatedImage);
imwrite(II ,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\dilatedImage.jpg');
% figure, imshow(dilatedImage );
    
% dilate image to join diacricitcs with main bodies and remove noise
% having pixels less the 100 pixels
    mySE=strel('rectangle',[11 2]);
    dilatedImg = imdilate(I,mySE);        
%     dilatedImg = bwareaopen(dilatedImg,100);
    imwrite(dilatedImg,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\joinDicricticsWithMain.jpg');

%     [cCons num] = bwlabel(dilatedImg);
%     [cCons1 num1] = bwlabel(I);    
%     tot_Num_Of_PCCs = num;
%     tot_Num_Of_CCs = num1;

% find sum of white pixels in each row of dilated image
    W = whiteAndBlack(dilatedImg);

% find sum white pixels in each row of (non dilated) image
    P = whiteAndBlack(I);
    %figure, bar(P), title('Plot of White Pixels in Each Row');

% This function finds median of zone heihghts in non-dilated image 
    [zoneHeightMed] = zoneHeight(P);

% using median height of all zones as threshold to find single peak (local
% row with max number of text pixesl) in text-line of documnent
    threshold = floor(zoneHeightMed)

% TUNE can be added/subtracted for (limiting threshold+TUNE in the range  60-80 by mnaually 
% inspecting image written after segmentation) for better line segmentation
% accordingly. Peaks are found in each zone of the dilated image
    [pks,locs] = findpeaks(W,'minpeakdistance',threshold+TUNE);  

% finding valley indices between 2 consecutive peaks (in dilated) image, that is probable textline boudary
    valleyIndexArray = valleyInfo(W,locs);    

% using valleys (row with min number of text pixels) for finding linear and
% non-linear text-line indxes    
    lineAt = findLine(W, valleyIndexArray, locs, dilatedImage);    
% lineAt = findLine(W, valleyIndexArray, locs, dilatedImg);
        
% writing lines-segmented document image
    segmentedLines = imcomplement(drawLine(lineAt, I));
    %figure,imshow(segmentedLines);
    imwrite(segmentedLines,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\joinDicricticsWithMain.jpg');

% extracting ligatures from extracted text-lines
% ourLines = getLinesAndLigatures(I, lineAt, k, path, valleyIndexArray, locs); 
ourLines = getLinesAndLigatures(I, lineAt, k, path, valleyIndexArray, locs); 
    

%Error  Ourligature = primSecLigatures(lineAt,I,baseline); 
% imwrite(Ourligature,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\Ligatures.png')



end  

