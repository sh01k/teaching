%% 1st order Markov process

T = 512;
n = randn(T,1);
rho = 0.9;

r = zeros(T,1);
for tt=1:T-1
    r(tt+1) = r(tt)*rho + n(tt);
end

%Hamming window
win_hamm = (0.54-0.46*cos(2*pi*(0:T-1)/(T-1)))';

%Autocorrelation
cn = real(ifft(abs(fft(n.*win_hamm,T*2)).^2, T*2));
cn = cn(1:T)/cn(1);
cr = real(ifft(abs(fft(r.*win_hamm,T*2)).^2, T*2));
cr = cr(1:T)/cr(1);

%FFT
N = fft(n.*win_hamm,T);
R = fft(r.*win_hamm,T);

figure(1);
plot(1:T,n,1:T,r);
axis tight;
xlabel('t');
legend('n(t)','r(t)');

figure(2);
plot(1:T,cn,1:T,cr);
axis tight;
xlim([1,64]);
xlabel('\tau');
legend('C_n(\tau)','C_r(\tau)');

figure(3);
plot(1:T/2,10*log10(abs(N(1:T/2)).^2),1:T/2,10*log10(abs(R(1:T/2)).^2));
axis tight;
xlabel('\omega');
legend('N(\omega)','R(\omega)');

