function y=check_device_ID()
devs = playrec('getDevices');
validIDs = -1;

prompt = sprintf(' -1) No Device\n');

for k=1:length(devs)
    if(devs(k).outputChans)
        prompt = [prompt, sprintf(' %2d) %s (%s) %d channels\n', ...
            devs(k).deviceID, devs(k).name, ...
            devs(k).hostAPI, devs(k).outputChans)];
        validIDs = [validIDs, devs(k).deviceID];
    end
end

% fprintf([prompt, '\n']);

currentscreensize=get(0,'screensize');
figpcs = uifigure('Name','Available output devices','Position',[currentscreensize(3)/3,currentscreensize(4)/4,currentscreensize(3)/3,currentscreensize(4)/2]);
figpcs.Scrollable = 'on';
label1 = uilabel(figpcs,...
    'Position',[1 1 currentscreensize(3) currentscreensize(4)*2],...
    'Text',prompt);
label1.WordWrap = 'on';
label1.HorizontalAlignment = 'left';
label1.VerticalAlignment = 'top';
end