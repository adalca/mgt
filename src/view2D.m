function view2D(images, varargin)
% Visualize multiple 2D images in subplots
%   view2D(images) visualize multiple images into subplots. If images is an image, this is roughly
%   equivalent to imagesc(images). However, th emore interesting case is when images is a cell of
%   images. By default, view2D computes and uses an appropriate subplot grid (according to your
%   sceen dimensions, as determined by get(0, 'Screensize') ). 
%
%   view2D(images, param, value, ...) allows for the following param/value pairs:
%       'subgrid': vector with two elements specifying the subgrid dimensions (e.g. [2, 3]). By
%       default, this is determined based on your current screensize.
%       'caxis': the color axis.
%       'titles': a cell array with as many elements as images, determining the titles of each
%       image.
%
% Contact: adalca.mit.edu

    [images, nRows, nCols, inputs] = parseinputs(images, varargin{:});

    figuresc()
    for i = 1:numel(images)
        subplot(nRows, nCols, i);
        imagesc(images{i});
        if numel(inputs.caxis) == 2
            caxis(inputs.caxis);
        end
        title(inputs.titles{i})
        axis off;
        axis equal;
    end

end


function [images, nRows, nCols, inputs] = parseinputs(images, varargin)

    if isnumeric(images)
        images = {images};
    end

    p = inputParser();
    p.addRequired('images', @(x) iscell(x));
    p.addParameter('subgrid', -1, @isnumeric)
    p.addParameter('caxis', -1);
    p.addParameter('titles', repmat({''}, [1, numel(images)]), @iscell);
    p.parse(images, varargin{:});
    
    if isscalar(p.Results.subgrid) && p.Results.subgrid == -1
        [nRows, nCols] = subgrid(numel(images));
    else
        nRows = p.Results.subgrid(1);
        nCols = p.Results.subgrid(2);
    end
    
    inputs = p.Results;
end

function [hei, len] = subgrid(N)

    screensize = get(0, 'Screensize');
    W = screensize(3);
    H = screensize(4);

    hei = max(round(sqrt(N*H/W)), 1);
    len = ceil(N/hei);
end
