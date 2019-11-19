classdef GRID_user_defined
    
    properties
        GRID
        MIDPOINTS
        LAYERTHICK
        variable_names
        variable_gridded
        length %added grid length
        air_MIDPOINTS;
        MIDPOINTS_delta;
    end
    
    methods
        function grid = initalize_from_file(grid, section)
            pos_list = get_range_TOP_BOTTOM(section);
            grid_breaks = cell2mat(section(pos_list(1,1):pos_list(1,2), 1:3));
            grid_breaks(2:end,1) = grid_breaks(2:end,1) + grid_breaks(2:end,2);
            grid.GRID =[];
            for i=1:size(grid_breaks)
                grid.GRID = [grid.GRID; [grid_breaks(i,1):grid_breaks(i,2):grid_breaks(i,3)]'];
            end
        end
        
        function grid = reduce_grid(grid, forcing)
            grid.GRID(grid.GRID > forcing.PARA.domain_depth)=[];
            grid.MIDPOINTS = (grid.GRID(2:end,1) + grid.GRID(1:end-1,1))./2; %CT_grid
            grid.LAYERTHICK = (grid.GRID(2:end,1) - grid.GRID(1:end-1,1)); %K_grid
            
            %%NC added
            grid.MIDPOINTS_delta = (-grid.MIDPOINTS(1:end-1,1)+grid.MIDPOINTS(2:end,1));%CT_delta
            grid.MIDPOINTS_delta = [grid.MIDPOINTS_delta; grid.MIDPOINTS_delta(end)];
            grid.length = 1:size(grid.GRID)-1; %NC -added grid length
            grid.length = grid.length';
            grid.air_MIDPOINTS = ones(80,1);
        end
        
        function grid = initializeExcessIce2(grid)
            
            grid.excessGroundIce = grid.waterIce>grid.natPor;
            
        end
        
    end
    
end

