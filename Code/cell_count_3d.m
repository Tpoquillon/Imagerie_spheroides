%% Test
I1 = imread("..\Database1\msk\label_09.tif");
I2 = imread("..\Database1\msk\label_07.tif");
%%
slices = {I1, I2};
%%
slices_labeled = bwlabel3d(slices, 4);

%%
slices_labeled = cell(length(slices),1);
    label = 1;
    for i=1:length(slices)
        slice_labeled= bwlabel(slices{i},4);
        for j = 1:max(slice_labeled,[],"all")
            slice_labeled(slice_labeled==j) = label;
            label = label +1;
        slices_labeled{i} = slice_labeled;            
        end
    end
%% Function

function count = count_3d_cells(Slices, fusion_threshold)




end

% Atribut a label to each cell
function slices_labeled = bwlabel3d(slices, connectivity)
    slices_labeled = cell(length(slices),1);
    label = 1;
    for i=1:length(slices)
        slice_labeled= bwlabel(slices{i},connectivity);
        for j = 1:max(slice_labeled,[],"all")
            slice_labeled(slice_labeled==j) = label;
            label = label +1;
        slices_labeled{i} = slice_labeled;            
        end
    end
end