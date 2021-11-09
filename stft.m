function [PS,f,t] = stft(x,nfft,noverlap,fs)
%Function to calculate averaged spectrum
%[ps,f] = welch(x,nfft,noverlap,fs);
%  Output arguments
%		ps	spectrogram
%		f	frequency vector for plotting
%       t   time vector for plotting
%  Input arguments
%		x data
%		nfft window size
%      	noverlap number of overlaping points in adjacent segements
%	    fs sample frequency
%	Uses Rectangular window
N = length(x);
%if N < xcol
%   x = x';						
%   N = xcol;
%end  
half_segment = fix(nfft/2);      % Half segment length
if isempty(noverlap) == 1
    noverlap = half_segment;              % Set default overlap at 50%
end
if isempty(fs) == 0
    f = (1:half_segment)* fs/nfft;  	% Calculate frequency vector
else 
    f = (1:half_segment)* pi/nfft;  % Default freqeucny vector
end
increment = nfft - noverlap; 
nu_avgs = fix(N/increment) -1;          % Determine the number of segments
%
for i = 1:nu_avgs 			    % Calculate spectra for each data point
   first_point = 1 + (i-1) * increment;
   if first_point+nfft-1 > length(x)    % Prevent index over run
       first_point = length(x) - nfft+1;
   end   
   data = x(first_point:first_point+nfft-1); % Get data segment
   PS_temp = abs((fft(data)).^2);           	% Calculate PS (normalized)
   PS(i,:) = PS_temp(2:half_segment+1)/(nfft/2);      % Remove redundant
   t(i) = (i - 1)*nfft/fs;             		% Construct time vector
end