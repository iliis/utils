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

persistent progress_handle;

if nargin == 1
    minmax = [0 1];
end

% clip 'percent' value to valid range
percent = min(percent, minmax(2));
percent = max(percent, minmax(1));

% create plot for progress bar if it doesn't yet exist
ish = ishghandle(progress_handle);
if (isempty(progress_handle) || isempty(ish) || ~ish(1))
    progress_handle = figure();
    set(progress_handle, 'units', 'normalized');
    % center on screen
    set(progress_handle, 'position',[.25 .425 .5 .15]);
end

hold on;

fill([minmax(1) percent percent minmax(1)], [0 0 1 1],'g');
fill([percent minmax(2) minmax(2) percent], [0 0 1 1],'r'); 
title(['\fontsize{20}\bf',num2str((percent-minmax(1))/(minmax(2)-minmax(1))*100),'%']);

set(gca, 'ytick', []); % disable y axis

hold off;

% close progress bar plot window if we're done (i.e. progress == 100%)
if(percent == minmax(2))
    close(progress_handle);
    clear progress_handle;
end

% force update of plot window (and the entire rest of the MATLAB GUI)
drawnow

end

