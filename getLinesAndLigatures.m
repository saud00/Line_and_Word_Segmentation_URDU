 function myLine= getLinesAndLigatures(A, B, C, D, E, F)

img = A;
lineAt = B;
k = C;
path = D;
valley = E;
peakLoc = F;
lastValley = valley(numel(valley));

[rows cols] = size(img);
[m q]= size(lineAt);
trimLineAt = [];
prevLine = [];

t = 1;
p = 2;

folderID = sprintf('image_%02d', k);
directory =  sprintf('%s\\%s', path, folderID);
newFolder = mkdir(folderID);

for i = 1:m 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For extracting first text-line of document and its ligatures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(lineAt(i,1) == 1)
        % extract text-line
        trimLineAt = [trimLineAt; lineAt(i,2) lineAt(i,3)];   
 
        if(i == cols)
            % return a maximum (i.e. of the largest connected connected) in each column of Array having line indexes
            maxima = max(trimLineAt, [],1);
            I = img;
            [tr tc] = size(trimLineAt);
            
            for c = 1:cols 
                if(trimLineAt(t,2) == c)
                    for r = 1: rows     
                        if(r > trimLineAt(t,1))
                            I(r,c) = 0;                                                    
                        end
                    end                
                end
                if(t < tr)
                t = t + 1;
                end
            end
        
            myLine = I(1:maxima(1,1),:);            
            dirID = sprintf('line_%02d', 1 );            
% SELF           n = sprintf('D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\firstLine.jpg');
 %           myLine1=imcomplement(myLine);   
            myLine1=myLine;   
%SELF            imwrite(myLine1,n);
            imwrite(myLine1,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\firstLine.jpg');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Extracting ligature from first text-line
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % dilating ligatures to join diacritics with main bodies
            SE=strel('rectangle',[9 2]);
            dilatedLine = imdilate(myLine,SE);       
            %figure, imshow(dilatedLine);
            
            [L N] = bwlabel(dilatedLine);    
            Stats = regionprops(L,'all');
            
            % Loop for bounding boxes
            for j = 1:N         
            
                dirID1 = sprintf('%02d',1);
                % Get the coordinates of the boxes
                startX = Stats(j).BoundingBox(1)+ 0.5;
                startY= Stats(j).BoundingBox(2) + 0.5;
                w = Stats(j).BoundingBox(3);
                h = Stats(j).BoundingBox(4);                
               % remove  small noise 
                if(w < 5) || (h < 5)
                    continue
                end
                
                % extract component from binarized image
                lig = myLine(startY:startY+h-1,startX:startX+w-1); 
%               figure, imshow(lig)                          
                prim = lig;
                           
                [primR primC] = size(prim);
                [Lprim Nprim] = bwlabel(prim,8);
                Sprim = regionprops(Lprim,'all');                
                % earsing parts other ligatures with the extracted ligature
                % as by product
                    for pj = 1: Nprim
                        if(Nprim > 1)
                            startXp = Sprim(pj).BoundingBox(1)+ 0.5;
                            startYp= Sprim(pj).BoundingBox(2) + 0.5;
                            wp = Sprim(pj).BoundingBox(3);
                            hp = Sprim(pj).BoundingBox(4);
                    
                            minXp = startXp;
                            maxXp = startXp+wp-1 ;
                            % clean a ligature if it start/end is same as the extracted ligature 
                            % and its size is less half the extracte (desired) ligature 
                            if(minXp== 1)&&(maxXp <= floor(0.5*primC))||(minXp >= floor(0.5*primC))&&(maxXp==primC)
                                primIdx = find(Lprim == pj);
                                prim(primIdx) = 0; 
                               figure,imshow(prim)
                            end                         
                            
                        end
                    end                  
 %self           n = sprintf('D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\FirstLineLig.jpg');
%             imwrite((prim),n);
% self            imwrite(prim,n);  
                    imwrite(prim,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\LigOfFirstLine.jpg');  

            end
                                     
            t = 1;
            prevLine = [prevLine; trimLineAt];
            trimLineAt = [];
        end
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For extracting text-lines other than fist one and its ligatures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(lineAt(i,1) == p) 
        % extrac text-line
        trimLineAt = [trimLineAt; lineAt(i,2) lineAt(i,3)];
        % check for text-line indexes that are multiple of number of
        % columns in image for each text-line
        if(i == p*cols)
            prevMin = min(prevLine,[],1);            
            trimMax = max(trimLineAt,[],1);        
            
            [tr tc] = size(trimLineAt);
            I1 = img;
            % text-line boundary index at upper largest component in text-line
            % (i.e. minima)
            for c = 1:cols 
                if(prevLine(t,2) == c)
                    for r = 1: rows     
                        if(r < prevLine(t,1))
                            I1(r,c) = 0;                                                    
                        end
                    end                
                end
                if( t < tr)
                    t = t + 1;
                end
            end
            
            I2 = I1;
            t = 1;
            % text-line boundary index at lower largest component in text-line
            % (i.e. mixima)
            for c = 1:cols 
                if(trimLineAt(t,2) == c)
                    for r = 1: rows     
                        if(r > trimLineAt(t,1))
                            I2(r,c) = 0;                                                    
                        end
                    end                
                end
                if(t < tr)
                    t = t+1;
                end
            end           
            
            myLine2 = I2(prevMin(1,1):trimMax(1,1),:);            
            dirID = sprintf('line_%02d', p );            
%Self            n = sprintf('D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\otherLines_Lig.jpg');
%             myLine3 = imcomplement(myLine2);
             myLine3 = myLine2;
            imwrite(myLine3,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\otherLinesAndLig.jpg'); 
            
%             prevLine = [];
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            SE=strel('rectangle',[9 2]);
            dilatedLine = imdilate(myLine2,SE);       
            %figure, imshow(dilatedLine);
            
            [L N] = bwlabel(dilatedLine);    
            Stats = regionprops(L,'all');
            
            % Loop for bounding boxes
            for j = 1:N         
            
                dirID1 = sprintf('%02d',p);
                % Get the coordinates of the boxes
                startX = Stats(j).BoundingBox(1)+ 0.5;
                startY= Stats(j).BoundingBox(2) + 0.5;
                w = Stats(j).BoundingBox(3);
                h = Stats(j).BoundingBox(4);                
                
                if(w < 5) || (h < 5)
                    continue
                end
                
                % extract component from binarized image
                lig = myLine2(startY:startY+h-1,startX:startX+w-1); 
%               figure, imshow(lig)                          
                prim = lig;
                           
                [primR primC] = size(prim);
                [Lprim Nprim] = bwlabel(prim,8);
                Sprim = regionprops(Lprim,'all');                
                
                    for pj = 1: Nprim
                        if(Nprim > 1)
                            startXp = Sprim(pj).BoundingBox(1)+ 0.5;
                            startYp= Sprim(pj).BoundingBox(2) + 0.5;
                            wp = Sprim(pj).BoundingBox(3);
                            hp = Sprim(pj).BoundingBox(4);
                    
                            minXp = startXp;
                            maxXp = startXp+wp-1 ;
                            
                            if(minXp==1)&&(maxXp <= floor(0.5*primC))||(minXp >= floor(0.5*primC))&&(maxXp==primC)
                                primIdx = find(Lprim == pj);
                                prim(primIdx) = 0; 
%                               figure,imshow(prim)
                            end                         
                            
                        end
                    end                  
 %Self               n = sprintf('D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\primLig.jpg');
    %            imwrite(prim,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\primLig.jpg');
                 imwrite(prim,'D:\Data\Thesis\code\linesAndLigatureSegmentation\documentImage\primLig.jpg'); 
           
%                 imwrite(imcomplement(prim),n);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            prevLine = [];
            prevLine = [prevLine; trimLineAt];
            trimLineAt = [];                                           
            t = 1;
            p = p + 1;
        end        
    end
end 
% end of function