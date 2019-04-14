function [white_in_row] = WhitePixelInRow( I )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(I);
    
    for j=1:m
     
     % initialize two variables for black and white pixels
         white_pix = 0;
         %black_pix = 0;
         
        % loop for column, loop will run for all column in a row
        for i=1:n
            
        % check that for black and white pixles.
            if I(j,i)==1
                % increament white pixels variable for each occurance of white
                % pixel.
                white_pix = white_pix + 1;
           % else
           %     black_pix = black_pix + 1;
            end
        end   
    % place the number of white and black pixles in a row in an array
    white_in_row(:,j) = white_pix;
    %black_in_row(:,j) = black_pix;
    end
    white_in_row = white_in_row;
end
