function  myLigatures = primSecLigatures(A, binaryImage, C)

lineAtIdx = A;
I = binaryImage;  
baseLine = C;
rowIdx = 1;


% findinging number of lines after segmentation
n = numel(lineAtIdx);
% variable for stroing start of line
rowIdx = 1;  
%secCompInfo = [];
%tempInfo = [];
%=========================================================================   
for j = 1 : n     
        
    baseLineIdx = baseLine(j);       
    line = I(rowIdx:lineAtIdx(j),:);  
    SE=strel('rectangle',[15 2]);
    dilatedLine = imdilate(line,SE);       
    % figure, imshow(dilatedLine);
       
    [L N] = bwlabel(dilatedLine);                       
    % Get bounding box stats
    Stats = regionprops(L,'all');

    folderID = sprintf('Ligatures From Lines\\Line#_%02d', j);    
    directory =  sprintf('%s\\%s', path, folderID);
    newFolder = mkdir(folderID);
      
        % Loop for bounding boxes
        for i = 1:N         
            
            dirID = sprintf('ligature_%04d', i );
            % Get the coordinates of the boxes
            startX = Stats(i).BoundingBox(1)+ 0.5;
            startY= Stats(i).BoundingBox(2) + 0.5;
            w = Stats(i).BoundingBox(3);
            h = Stats(i).BoundingBox(4);
        
            % extract component from binarized image
            lig = line(startY:startY+h-1,startX:startX+w-1);   
            
            %figure, imshow(I);
           
            % Labeling non-dialated lines
            [L1 N1] = bwlabel(lig,8);
           
            if(N1 == 1)  
                prim = lig;
   %Self             n = sprintf('%s_%s%s',directory,dirID,'.png');
                imwrite(prim,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\Lig.png');                         
                continue 
            end
            
            %folderID1 = sprintf('%s\\ligature_%04d_%02d', folderID,N1,i);
            %dirID1 = sprintf('primary_%02d', N);
           
            %dirID3 = sprintf();
            %directory1 = sprintf('%s\\%s',path, folderID1);
            %newFolder1 = mkdir(folderID1);
                
            if(N1 >= 2)               
                
                % Find the area of each component  
                areas = regionprops(L1,'area');  
                primComp = find([areas.Area] == max([areas.Area])); %Find the (label of) biggest component
                
                idx = find(L1 ~= primComp); %Find the indices of all the labels other than that of primComp
                Prim = lig;
                Prim(idx)= 0;                                
                % figure, imshow(I);      
                %dirID2 = sprintf('secondary_%02d' N1);
                %n =sprintf(ligature_%04d_%02d_%s %s',directory1,k,i,dirID1,'.png');
%Self              n = sprintf('%s\\%s_%02d%s',directory,dirID,i,'.png');
                imwrite(Prim,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\PrimaryLig.png');         
                
                idx = find(L1 == primComp); %Find the indices of all the labels other than that of primComp
                myLig1 = lig;
                myLig1(idx)= 0;      
                
                [diacritics N2]= bwlabel(myLig1,8);
                Stats1 = regionprops(diacritics, 'all');
                
                %dirID1 = sprintf('secondary ligature_%02d', k );
                %secondary = sprintf('CLE High Frequency Ligatures\\ligature_%04d\\Secondary Ligature_%02d',k,i);
                %folderID2 = sprintf('%s\\%s',folderID,secondary); 
                %primaryFolder = mkdir(secondary);
                %directory2 = sprintf('%s\\%s',path,secondary);
                
                for m = 1:N2                    
                    
                    %dirID2 = sprintf('secondary_%02d',m ); 
                   
                    startX = Stats1(m).BoundingBox(1)+ 0.5;
                    startY= Stats1(m).BoundingBox(2) + 0.5;
                    w = Stats1(m).BoundingBox(3);
                    h = Stats1(m).BoundingBox(4);    
                    
                    secLig = myLig1(startY:startY+h-1,startX:startX+w-1); 
                    
                    %secondary = sprintf('secondary ligature_%04d', j);
                    
  %                  n = sprintf('%s\\%s_%02d_%0d%s',directory,dirID,i, m, '.png');

                   % n =sprintf('%s\\ligature_%04d_%02d_%s%s',directory1,k,i,dirID2,'.png');
                    imwrite(secLig,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\SecLig.png');   
                    
                end
                
                
                
            end
               
        end         
end  
