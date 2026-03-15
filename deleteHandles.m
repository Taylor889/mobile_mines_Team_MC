function deleteHandles(h)
%DELETEHANDLES Safely delete graphics handles

    if nargin == 0 || isempty(h)
        return
    end

    % Make sure h is a column vector
    h = h(:);

    % Keep only valid graphics handles
    valid = arrayfun(@(x) isgraphics(x), h);
    h = h(valid);

    % Delete safely
    if ~isempty(h)
        delete(h);
    end
end