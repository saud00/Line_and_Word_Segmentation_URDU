function [peaks roughPeaks]= peakInfo(W)

maxima = 0;
p = 0;
q = 0;
r = 1;
peaksArray = [];
newPeaksArray= [];

[~, c] = size(W);

    for j = 1 : c
        
        if(W(j) >= maxima)           
            maxima = W(j);
            maxIndex = j;
             p = p + 1;
            
        elseif(q < 5)
            q = q + 1;
            
        elseif((p >= 5)&&(maxima >= 20))
               peaksArray(:,r) = maxIndex;
               r = r + 1;
               p = 0;               
               q = 0;
               maxima = 0; 
        end
    end
[~, cols] =  size(peaksArray);
z= 1;
    for i = 2: cols
        if(peaksArray(i)-peaksArray(i-1) >= 10)
            newPeaksArray(:,z)= peaksArray(i-1);
            z = z + 1;
        elseif(W(peaksArray(i)) > W(peaksArray(i-1)))
            newPeak = W(peaksArray(i));
            newPeaksArray(:,z)= peaksArray(i);
        else
            newPeak = W(peaksArray(i-1));
            newPeaksArray(:,z)= peaksArray(i-1);        
        end
    end
%peaks  = peaksArray;
roughPeaks = peaksArray;

peaks = newPeaksArray;
end