function [data] = processData(data)

    [numExperiments, numSlices] = size(data.cellLengths);

    
    data.allCellLengths = [];
    data.allProtLengths = [];
    data.allProtDensity = [];

    for experiment = 1:numExperiments
        for slice= 1:numSlices
%             data.cellLengths{experiment, slice}
            numCells = size(data.cellLengths{experiment, slice}, 1);

            data.cellLengths;
            data.protLengths;
            
            %remove zero length protrusions from protLength
            zeroIdx = data.protLengths{experiment, slice}(:,1) == 0;
            data.protLengths{experiment, slice}(zeroIdx, :) = [];


            for cell = 1:numCells
            %Calculate protrusion density
            idx_prot = data.protLengths{experiment, slice}(:,2) == cell;
            idx_cell = data.cellLengths{experiment, slice}(:,2) == cell;
%             data.protDensity{experiment, slice} = 

            protDensity = numel(data.protLengths{experiment, slice}(idx_prot,1))/data.cellLengths{experiment, slice}(idx_cell,1);
            data.allProtDensity = [data.allProtDensity; protDensity];
            end

            data.allCellLengths = [data.allCellLengths; data.cellLengths{experiment, slice}(:,1)];
            data.allProtLengths = [data.allProtLengths; data.protLengths{experiment, slice}(:,1)];
            
        end
    end
    data.numProt  = length(data.allProtLengths);
    data.numCells = length(data.allCellLengths);

end

