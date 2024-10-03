function [flippedAngles] = flipAnglesHorizontally(angles)

flippedAngles = angles*0;

    for n = 1:length(angles)
        
        if angles(n) >= 0 && angles(n) <= 180
            flippedAngles(n) = 180 - angles(n);
        end
    
        if angles(n) > 180 && angles(n) < 360
            flippedAngles(n) = 540 - angles(n);
        end
        
        if angles(n) < 0 && angles(n) >= -180
            flippedAngles(n) = -180 - angles(n);
        end
        
    end
end

