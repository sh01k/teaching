%% 1st order Markov process

T = 512;% %Duration
w = 2*pi*(0:(T/2-1))'/T; %Frequency

rho = 0.9; %AR coefficient
n = randn(T,1); %Random noise

%Generate signal
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

a = 1-rho;
cr_i = exp(-a.*(0:T-1));

%FFT
Sn = abs(fft(n.*win_hamm,T)).^2/T;
Sr = abs(fft(r.*win_hamm,T)).^2/T;

Sr_i = 2*a./(a^2+w.^2);

%Draw figures
figure(1);
plot(1:T,n,1:T,r);
axis tight;
xlabel('t');
legend('n(t)','r(t)');

figure(2);
plot(1:T,cn,1:T,cr,1:T,cr_i);
axis tight;
xlim([1,64]);
xlabel('\tau');
legend('C_n(\tau)','C_r(\tau)','C_{r,i}(\tau)');

figure(3);
plot(w,10*log10(Sn(1:T/2)),w,10*log10(Sr(1:T/2)),w,10*log10(Sr_i));
axis tight;
xlabel('\omega');
legend('S_n(\omega)','S_r(\omega)','S_{r,i}(\omega)');

