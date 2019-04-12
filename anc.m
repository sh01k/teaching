%% Parameters

% Noise source position [m]
x_ns = -2.0;

% Reference mic position [m]
x_rm = -1.0;

% Loudspeaker
%position [m]
x_ls = 0;

% Error mic position [m]
x_em = 2.0;

%Sound speed [m/s]
c = 340.0;

%Sampling frequency [Hz]
fs = 16000;

%FFT parameters
fftlen = 1024;
fftshift = fftlen/2;

%Time [s]
t = (1:fftshift)'/fs;

%% 

%Noise source signal
s_len = fs*8;
s = rand(s_len,1)-0.5;

%Impulse responses
h_s2r = sinc((t-abs(x_rm-x_ns)/c)*fs)/abs(x_rm-x_ns);
g = sinc((t-abs(x_em-x_ls)/c)*fs)/abs(x_em-x_ls);
h_s2e = sinc((t-abs(x_em-x_ns)/c)*fs)/abs(x_em-x_ns);

%Noise at reference mic
x_s = conv(h_s2r,s);

%Noise on error mic
n = conv(h_s2e,s);

%Number of frames
num_frm = floor(length(x_s)/fftlen)-1;

pw_e = zeros(num_frm,1);
pw_n = zeros(num_frm,1);

%Buffer
d_t = zeros(fftshift,1);
d_buff = zeros(fftshift,1);

y_t = zeros(fftshift,1);
y_buff = zeros(fftshift,1);

%Initial filter
h_est = zeros(fftshift,1);

g_mat = convmtx(g,fftshift*2-1);
norm2_g = norm(g_mat).^2;

alpha = 0.04;
beta = 1e-6;

for ii=1:num_frm
    x_t = x_s((ii-1)*fftshift+1:ii*fftshift);
    n_t = n((ii-1)*fftshift+1:ii*fftshift);
    
    %Loudspeaker output
    dd_t = real(ifft(fft(h_est,fftlen).*fft(x_t,fftlen)));
    d_t = dd_t(1:fftshift)+d_buff;
    d_buff = dd_t(fftshift+1:fftlen);
    
    %Driving signal at error mic
    yy_t = real(ifft(fft([g; zeros(fftshift,1)],fftlen).*fft([d_t; zeros(fftshift,1)],fftlen)));
    y_t = yy_t(1:fftshift)+y_buff;
    y_buff = yy_t(fftshift+1:fftlen);
    
    %Signal at error mic
    e_t = y_t + n_t;
    
    pw_e(ii) = sum(abs(e_t).^2);
    pw_n(ii) = sum(abs(n_t).^2);
    
    %Filter update
    h_grad = 2*g_mat(1:2*fftshift-1,:)'*[e_t; zeros(fftshift-1,1)]*[x_t; zeros(fftshift-1,1)]';
    norm2_x = sum(abs(x_t).^2);
    for jj=1:fftshift
        h_est = h_est - (alpha/(beta+norm2_g*norm2_x))*h_grad(jj:fftshift+jj-1,jj);
    end
    
%     figure(1);
%     plot(t,n_t,t,d_t);
%     xlim([t(1),t(fftshift)]);
%     ylim([-0.3,0.3]);
%     grid on;
    
    figure(2);
    plot(t,n_t,t,e_t);
    xlim([t(1),t(fftshift)]);
    ylim([-0.2,0.2]);
    grid on;
    
    drawnow;
end

figure(3);
plot(1:num_frm,10*log10(pw_e./pw_n));
xlim([1,num_frm]);
grid on;