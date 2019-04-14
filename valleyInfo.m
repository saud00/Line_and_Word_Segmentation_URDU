function valley = valleyInfo(X,Y)

% array containing count of text pixels in each row of dilated image
W = X;
% array containing indexes of local peaks (maximas) in dilated image
peaks = Y;

% finding size of (1*N) input array
[~, cols] = size(peaks);
[~, nCols] = size(W);

% initializing varaibles
minima = nCols;
minima1 = nCols;
minIndex = 0;
minIndex1 = 0;
minimaIndices = [];
m = 1;

% loop for finding indices of valleys:
% using peaks indexes (in peaks array)  to find valley 
% index between two consecutive peaks in array W 
    for j = 2:cols          
        for i = 1:nCols
            if((i > peaks(j-1)) && (i <= peaks(j)))
                if(W(i)<= minima)
                    minima = W(i);
                    minIndex = i;
                end                      
            end            
        end        
        minimaIndices(:,m)= minIndex;
        m = m+1;
        minima = nCols;        
    end
    %  finding line boundary after last peak
    for k = i:nCols
        if(i > cols)
            if(W(i) == 0)
                minima1 = W(i);
                minIndex1 = i; 
            else
                minIndex1 = nCols;
            end
        end
    end
    minimaIndices(:,m) = minIndex1;
% returning valleys' indices
valley = minimaIndices;
end