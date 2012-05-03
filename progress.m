function progress( percent, minmax )
% PROGRESS Displays a progress bar.
%
%   PROGRESS(PERCENT) plots a horizontal progress bar at PERCENT*100 percent.
%   PERCENT has to be a value between 0 and 1.
%
%   PROGRESS(PERCENT,[MIN MAX]) calculates the percentage according to MIN
%   and MAX: percent = (PERCENT-MIN)/(MAX-MIN)*100
%
%   If PERCENT is at MAX (or 1 if no min/max given), the window will be
%   closed.
%
%   Example:
%
%   progress(0.6); -> 60%
%   
%   progress(300, [200,400]) -> 50%

global progress_handle;

if nargin == 1
    minmax = [0 1];
end

percent = min(percent, minmax(2));
percent = max(percent, minmax(1));

if (~exist('progress_handle', 'var') || ~ishandle(progress_handle))
    progress_handle = figure();
    set(progress_handle, 'units', 'normalized');
    set(progress_handle, 'position',[.25 .425 .5 .15]);
end

hold on;


fill([minmax(1) percent percent minmax(1)], [0 0 1 1],'g');
fill([percent minmax(2) minmax(2) percent], [0 0 1 1],'r'); 
title(['\fontsize{20}\bf',num2str((percent-minmax(1))/(minmax(2)-minmax(1))*100),'%']);

set(gca, 'ytick', []); % disable y axis

hold off;

if(percent == minmax(2))
    close(progress_handle);
    clear progress_handle;
end

end

