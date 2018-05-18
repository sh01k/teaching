%% Linear prediction

%Order
L = 11;

%Frame
N = 1024; %length
N0 = 4096; %start

%Sampling freq
fs = 8000;

%Frequency
f = (0:N/2-1)*fs/N;

%Hamming window
win_hamm = (0.54-0.46*cos(2*pi*(0:N-1)/(N-1)))';

%Read audio file
[data, fs_org] = audioread('path_to_audio_file.wav');
data_ds = resample(data,fs,fs_org); %downsample
x = data_ds(N0+1:N0+N); %truncation

%FFT
X = fft(x.*win_hamm,N);

%Autocorrelation
R = real(ifft(abs(fft(x.*win_hamm,N*2)).^2, N*2));
R = R(1:N)/N;

%LP coefficient estimation
Rmat = toeplitz(R(1:L));
h = Rmat\R(2:L+1);

res = zeros(N,1); %residual
J = 0; %mean square error
for ii=L+1:N
    res(ii) = x(ii)-h'*x(ii-1:-1:ii-L);
    J = J + (x(ii)-h'*x(ii-1:-1:ii-L))^2;
end
J = J/(N-L);

%Power spectrum density
psd = J./(abs(fft([1; -h], N)).^2);

%Draw figures
figure(1);
plot((1:N)/fs, x, (1:N)/fs, res);
axis tight;
xlabel('Time [s]');
legend('Signal','Error');

figure(2);
plot(f,10*log10(abs(X(1:N/2)).^2/N),f,10*log10(psd(1:N/2)));
axis tight;
xlabel('Frequency [Hz]');
legend('FFT spectrum','LP spectrum');

