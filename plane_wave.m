%% Plane wave function

c = 340; %sound speed [m/s]
freq = 1000; %frequency [Hz]
k = 2*pi*freq/c; %wave number [rad/m]

%length [m]
Lx = 1.2; 
Lz = 1.0;

%interval [m]
dx = 0.01;
dz = 0.01;

%number of points
Nx = ceil(Lx/dx);
Nz = ceil(Lz/dz);

x = ((0:Nx-1)-Nx/2)'*dx;
y = 0;
z = (0:Nz-1)'*dz;

x_vec = reshape(x*ones(1,Nz),1,Nx*Nz);
y_vec = reshape(y*ones(Nx,Nz),1,Nx*Nz);
z_vec = reshape((z*ones(1,Nx))',1,Nx*Nz);

%direction
theta = pi/3;
phi = 0;

%wave number
kx = k*cos(phi)*sin(theta);
ky = k*sin(phi)*sin(theta);
kz = sqrt(k^2-kx^2-ky^2);
k_vec = [kx, ky, kz]';

%pressure
p_pw = exp(1i*k_vec'*[x_vec;y_vec;z_vec]);
p_pw = reshape(p_pw,Nx,Nz);

%draw figures
figure(1);
imagesc([min(x),max(x)],[min(z),max(z)],real(p_pw).');
set(gca,'YDir','normal');
axis equal;
axis tight;
caxis([-1,1]);
colormap(flipud(pink));
colorbar;
xlabel('x (m)'); ylabel('z (m)');
