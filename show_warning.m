function y = show_warning(id, msg)
if id == 1
    warning(msg);
else
    show_progress(id, msg);
end