function y = show_progress(id, progress)
if id == 1
    fprintf(sprintf([progress,'\n']));
else
    if isempty(id.Value{1})
        id.Value{1}=progress;
    else
        id.Value=[id.Value;progress];
    end
    scroll(id, 'bottom')
end