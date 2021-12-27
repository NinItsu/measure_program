function [set_unit, NO_unit] = getIndices(STR)
STR=split(STR,",");
idx_unit=1;
for i=1:length(STR)
    if contains(STR(i),"-")
        min = str2double(strtrim(extractBefore(STR(i),"-")));
        max = str2double(strtrim(extractAfter(STR(i),"-")));
        for j=min:max
            set_unit(idx_unit)=j;
            idx_unit=idx_unit+1;
        end
    else
        set_unit(idx_unit)=str2double(strtrim(STR(i)));
        idx_unit=idx_unit+1;
    end
end
NO_unit=idx_unit-1;
end
