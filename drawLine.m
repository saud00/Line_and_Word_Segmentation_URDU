function  imgWithLines = drawLine (A, B)
% array containing text-line boundary indexes found in findLine function
lineAt = A;
img = B;
[ir ic] = size(img);
[rows cols] = size(lineAt);
lineNum = lineAt(:,1);
[r c] = size(lineNum);
idx = 1;
% using text-line boundary index to draw tex-line boundaries in orginal
% (non-dilated) image
    for j = 1:r     
        if(lineAt(j,1) == idx)
            img(lineAt(j,2),lineAt(j,3))=1;                    
        else
            idx = idx + 1;
        end
    end
    imgWithLines = img;
    
end
