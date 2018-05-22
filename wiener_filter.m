%% Wiener filtering for speech enhancement

%Sampling freq
fs = 8000;

%Frame
fftlen = 256;
fftshift = fftlen/2;

%Frequency
f = (0:fftlen/2-1)*fs/fftlen;

%Squre root of Hann window
win_sqrthann = sqrt(0.5-0.5*cos(2*pi*(0:fftlen-1)/(fftlen-1)))';

%Read audio file
[data, fs_org] = audioread('path_to_audio_file.wav');
s = resample(data,fs,fs_org); %downsample
len = length(s);

snr = 10;
Ps_i = sum(abs(s).^2)/len;
Pn_i = Ps_i/(10^(snr/10));

%Generate noise
n = sqrt(Pn_i)*randn(len,1);

%Observation
x = s + n;

%Estimate noise amplitude from first several frames
nFrame_noise = 10;
Sn = zeros(fftlen,1);
for tt=1:nFrame_noise
    Sn = Sn + abs(fft(x((tt-1)*fftshift+1:(tt-1)*fftshift+fftlen).*win_sqrthann,fftlen));
end
Sn = Sn/nFrame_noise;

%Filtering
s_est = zeros(len,1);
for tt=1:floor((len-fftlen)/fftshift)
    x_t = x((tt-1)*fftshift+1:(tt-1)*fftshift+fftlen);
    X_t = fft(x_t.*win_sqrthann,fftlen);
    Sx = abs(X_t);
    
    %Spectral subtraction to estimate speech psd
    Ss = abs(Sx - Sn);
    
    Pn = Sn.^2;
    Ps = Ss.^2;
    WF = Ps./(Pn+Ps);
    
    S_t = X_t.*WF;
    s_t = real(ifft(S_t,fftlen)).*win_sqrthann;
    s_est((tt-1)*fftshift+1:(tt-1)*fftshift+fftlen) = s_est((tt-1)*fftshift+1:(tt-1)*fftshift+fftlen) + s_t;
end

figure(1);
plot(1:len,x);
xlim([1,len]); ylim([-0.5,0.5]);
grid on;

figure(2);
plot(1:len,s);
xlim([1,len]); ylim([-0.5,0.5]);
grid on;

figure(3);
plot(1:length(s_est),s_est);
xlim([1,len]); ylim([-0.5,0.5]);
grid on;
