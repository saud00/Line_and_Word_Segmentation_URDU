function [ourLines] = findLine(A, B, C, D)
%LINEDIMS Summary of this function goes here
%   Detailed explanation goes here

W = A;
valley = B;
peakLoc = C;
img = D;
 
v = 1;
p = 1;
idx = 0;
exdims =[];
dims =[];
lastR = 0;
vProfile = [];
[~, pc] = size(peakLoc);
[~, vc] = size(valley);
[rows cols] = size(img);

for q = 1:pc
    for qr = 1: rows
        % filling rows around baseline of text-line to avoid getting into
        % next text-line while tracing non-linear text-line boudary indexes
        if(peakLoc(q) == qr)
          img(qr-3,:) = 1;  
          img(qr-2,:) = 1;
          img(qr-1,:) = 1;  
          img(qr,:) = 1;
          img(qr+1,:) = 1;
          img(qr+2,:) = 1;
          img(qr+3,:) = 1;
        end
    end
end
%  imwrite(img, '123.jpg');

 for pr=1:rows
    % check for valley index
    if(pr == valley(v))   
            % finding text-line boundry indexes between consecutive
            % non-overlapped/non-touched text-lines
            if(W(pr) == 0)    
                for c = 1:cols
                    % keeping valley indexes in array
                    vProfile = [vProfile; v pr c];                 
                end
                % check if not last valley index then incrment 
                if( v < vc) 
                    v = v + 1;
                end
                % check if peak index is less than send second last peak index  
                if(p < pc-1)
                    p = p + 1;                   
                end          
            % finding text-line boundary between consecutive
            % overlapped/touched text-lines
            elseif(pr>peakLoc(p)  &&  pr<peakLoc(p+1))
                % threshold to limit non-linear text-line index search not
                % to exceed consecutive peaks
                thresh = valley(v) + floor(peakLoc(p+1)-valley(v))/2; 
                for c = 1:cols
                    for r = 1:rows
                        % check gap (non-text) pixels in the range, if
                        % text-lines are overlapped
                        if(r>peakLoc(p)+3 && r<thresh)
                            if(img(r,c)==0)                                 
                                dims = [v r c]; 
                            else
                                exdims = [v valley(v) c];                                
                                lastR = r;
                                idx = idx + 1;                               
                            end
                        end
                    end
                    % noting text-line boundary indexes in of no non-text
                    % pixels (i.e. touched text-lines) in the range
                    if(lastR-idx == peakLoc(p)+3)                                            
                        vProfile = [vProfile; exdims];
                        exdims=[]; 
                        idx = 0;
                    else                      
                        vProfile = [vProfile; dims];
                        dims = [];
                        exdims =[];
                        idx =0; 
                    end
                    
                    if(c == cols)
                        if(v < vc)
                        v = v + 1;
                        end
                        if(p < pc-1)
                        p = p + 1;
                        end
                    end
                end
            % finding text-line boundary indexes after last text-line
            elseif(v == numel(valley))             
                top = numel(peakLoc);                                     
                if (pr > peakLoc(top)) 
                    if(pr == valley(v))
                        for c = 1:cols
                            for r = 1:rows                                                    
                                dims = [v r c];                                                                 
                            end
                            vProfile = [vProfile; dims];
                            dims = [];
                        end
                    end
                end
            end
    end
end
ourLines = vProfile;