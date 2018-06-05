%number of angles
ang_num = 64;

%angle [rad]
theta = ((0:ang_num-1)*pi/ang_num)';
phi = ((0:ang_num-1)*2*pi/ang_num)';

theta_mat = theta*ones(1,ang_num);
phi_mat = (phi*ones(1,ang_num))';

theta_vec = reshape(theta_mat,ang_num*ang_num,1);
phi_vec = reshape(phi_mat,ang_num*ang_num,1);

%order and degree
n=3;
m=-2;

%associated Legendre function
Pnm = legendre(n,cos(theta_vec));

%normalization coefficient
n_coef = ((-1).^min(m,0)).*sqrt(((2*n+1)/(4*pi))*(factorial(n-abs(m))/factorial(n+abs(m))));

%spherical harmonic function
Ynm_vec = n_coef.*(Pnm(abs(m)+1,:).').*exp(1i*m*phi_vec);
Ynm = reshape(Ynm_vec,[ang_num,ang_num]);

%draw figures
XX = cos(phi_mat).*sin(theta_mat);
YY = sin(phi_mat).*sin(theta_mat);
ZZ = cos(theta_mat);

XX = [XX, XX(:,1); XX(1,:) XX(ang_num,ang_num)];
YY = [YY, YY(:,1); YY(1,:) YY(ang_num,ang_num)];
ZZ = [ZZ, ZZ(:,1); ZZ(1,:) ZZ(ang_num,ang_num)];

figure(1);
surf(XX,YY,ZZ,real(Ynm));
axis equal;
colormap(flipud(pink));
% colorbar;
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');

Ynm_plt = abs(real([Ynm, Ynm(:,1); Ynm(1,:), Ynm(ang_num,ang_num)]));

figure(2);
surf(Ynm_plt.*XX,Ynm_plt.*YY,Ynm_plt.*ZZ,real(Ynm));
axis equal;
colormap(flipud(pink));
% colorbar;
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');