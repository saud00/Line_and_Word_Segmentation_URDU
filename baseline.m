function bl = baseline(img)

I = img;
W = whiteAndBlack(I);

tempMax = 0;
baseLineIdx = 0;

[~, cols] = size(W);
     
   for c = 1 : cols         
            
       if(W(c)> tempMax)
            tempMax = W(c);
            tempMaxIdx = c;                                                                            
       end
       
   end

bl = tempMaxIdx;
end