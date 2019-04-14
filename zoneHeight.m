function [med] = zoneHeight( X )
%This function finds: 
% median of the zones' heights in the documnet image 
%======================================================================

%  assigning function's input to a variable
A = X; 
%  finding rows and columns in a array
[r1, c2]= size(A);
% this array stores height of each zone                   
eachZoneHeight=[];

% intializing variable for storing zone height
zh = 0; 
% intiailizing index for storing Zone Peaks and Each Zone Heights in
% separate arrays
x = 1;
%========================================================================
% check each row of A (count of text pixels in each row of documnet image) 
% for zone (continuous run of rows with non zero text pixels) height,
% storing each zone height in a array
%========================================================================
   for c=1:c2   
            % storing zone height in a documnet
            if(A(c) ~= 0)                   
                % finding each zone height
                zh = zh+1;                                                    
     
            % if array element is found 0 then height (number of rows) of each zone is assigned to variable  
            % zone information (zInfo), and then stored in array appending each zone information at its end (zoneIn)
            elseif(zh>=5)                     
                %storing each zone height
                eachZoneHeight(:,x)= zh;                                      
                % incrementing array index for storing height of zones
                x = x + 1;                   
                % reinitialinzing zone height variable to store height of next zone
                zh = 0;                    
            end 
            % storing zone height for only one zone in a document.                                                 
   end
             
%========================================================================   
% returning median of each zone height containing zone height
% there is only zone then
if(numel(eachZoneHeight)==1)
med = zh;
% if there are zones more than one
else
med = median(eachZoneHeight);
end
%END of function
end