close all;
clear variables;

set(0,'defaultAxesFontSize',16);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',16);
set(0,'defaultTextFontName','Times');

%Period [s]
T = 1;

%Sampling frequency for plot
Fs = 100;

%Duration [s]
t_len = 4*T;
t_num = floor(t_len*Fs);

%Angle [rad]
ang = linspace(0,2*pi,100);

%Order
k = [1,2,3,4];
k_mat = repmat(k,t_num,1);

fig(1)=figure(1);
fig_pos = [0, 800, 800, 800];
set(fig(1),'Position',fig_pos);

v = VideoWriter('ft.mp4','MPEG-4');
open(v);

for t0=0:399
    clf('reset');
    
    %Time [s]
    t = (t0:t0+t_num-1)'/Fs;
    t_mat = repmat(t,1,length(k));
    
    %Fourier coefficients
    c = -T./(pi*k).*cos(pi*k); %Saw wave
    
    %Fourier bases
    phi = 2*pi.*k_mat.*t_mat/T;
    circ = [c.*cos(phi(t_num,:)); c.*sin(phi(t_num,:))];
    
    %Signal
    sig = sum(repmat(c,t_num,1).*sin(phi),2);
    
    %Plot complex plane
    subplot('Position',[0.04,0.85,0.14,0.14]);
    hold on;
    plot(c(1)*cos(ang),c(1)*sin(ang),'k','LineWidth',1.5);
    plot(c(2)*cos(ang)+circ(1,1),c(2)*sin(ang)+circ(2,1),'k','LineWidth',1.5);
    plot(c(3)*cos(ang)+circ(1,1)+circ(1,2),c(3)*sin(ang)+circ(2,1)+circ(2,2),'k','LineWidth',1.5);
    plot(c(4)*cos(ang)+circ(1,1)+circ(1,2)+circ(1,3),c(4)*sin(ang)+circ(2,1)+circ(2,2)+circ(2,3),'k','LineWidth',1.5);
    plot([0,circ(1,1)],[0,circ(2,1)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,1),circ(1,2)+circ(1,1)],[circ(2,1),circ(2,2)+circ(2,1)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,2)+circ(1,1),circ(1,3)+circ(1,2)+circ(1,1)],[circ(2,2)+circ(2,1),circ(2,3)+circ(2,2)+circ(2,1)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,3)+circ(1,2)+circ(1,1),circ(1,4)+circ(1,3)+circ(1,2)+circ(1,1)],[circ(2,3)+circ(2,2)+circ(2,1),circ(2,4)+circ(2,3)+circ(2,2)+circ(2,1)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,4)+circ(1,3)+circ(1,2)+circ(1,1),0.6],[circ(2,4)+circ(2,3)+circ(2,2)+circ(2,1),circ(2,4)+circ(2,3)+circ(2,2)+circ(2,1)],':bo','MarkerSize',6,'MarkerFaceColor','b','LineWidth',1);
    hold off;
    axis equal;
    xlim([-0.6,0.6]); ylim([-0.6,0.6]);
    
    %Plot signal
    subplot('Position',[0.24,0.85,0.74,0.14]);
    plot(t,sig,'-b','LineWidth',1.5);
    axis tight;
    ylim([-0.6,0.6]);
    set(gca,'XDir','reverse');
    xlabel('Time (s)'); 

    %Plot complex plane k=1
    subplot('Position',[0.04,0.65,0.14,0.14]);
    hold on;
    plot(c(1)*cos(ang),c(1)*sin(ang),'k','LineWidth',1.5);
    plot([0,circ(1,1)],[0,circ(2,1)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,1),0.6],[circ(2,1),circ(2,1)],':bo','MarkerSize',6,'MarkerFaceColor','b','LineWidth',1);
    hold off;
    axis equal;
    xlim([-0.6,0.6]); ylim([-0.6,0.6]);

    %Plot signal k=1
    subplot('Position',[0.24,0.65,0.74,0.14]);
    plot(t,c(1)*sin(phi(:,1)),'-b','LineWidth',1.5);
    axis tight;
    ylim([-0.6,0.6]);
    set(gca,'XDir','reverse');
    xlabel('Time (s)'); 
    
    %Plot complex plane k=2
    subplot('Position',[0.04,0.45,0.14,0.14]);
    hold on;
    plot(c(2)*cos(ang),c(2)*sin(ang),'k','LineWidth',1.5);
    plot([0,circ(1,2)],[0,circ(2,2)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,2),0.6],[circ(2,2),circ(2,2)],':bo','MarkerSize',6,'MarkerFaceColor','b','LineWidth',1);
    hold off;
    axis equal;
    xlim([-0.6,0.6]); ylim([-0.6,0.6]);

    %Plot signal k=2
    subplot('Position',[0.24,0.45,0.74,0.14]);
    plot(t,c(2)*sin(phi(:,2)),'-b','LineWidth',1.5);
    axis tight;
    ylim([-0.6,0.6]);
    set(gca,'XDir','reverse');
    xlabel('Time (s)'); 
    
    %Plot complex plane k=3
    subplot('Position',[0.04,0.25,0.14,0.14]);
    hold on;
    plot(c(3)*cos(ang),c(3)*sin(ang),'k','LineWidth',1.5);
    plot([0,circ(1,3)],[0,circ(2,3)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,3),0.6],[circ(2,3),circ(2,3)],':bo','MarkerSize',6,'MarkerFaceColor','b','LineWidth',1);
    hold off;
    axis equal;
    xlim([-0.6,0.6]); ylim([-0.6,0.6]);

    %Plot signal k=3
    subplot('Position',[0.24,0.25,0.74,0.14]);
    plot(t,c(3)*sin(phi(:,3)),'-b','LineWidth',1.5);
    axis tight;
    ylim([-0.6,0.6]);
    set(gca,'XDir','reverse');
    xlabel('Time (s)'); 

    %Plot complex plane k=4
    subplot('Position',[0.04,0.05,0.14,0.14]);
    hold on;
    plot(c(4)*cos(ang),c(4)*sin(ang),'k','LineWidth',1.5);
    plot([0,circ(1,4)],[0,circ(2,4)],'-bo','MarkerSize',4,'MarkerFaceColor','b');
    plot([circ(1,4),0.6],[circ(2,4),circ(2,4)],':bo','MarkerSize',6,'MarkerFaceColor','b','LineWidth',1);
    hold off;
    axis equal;
    xlim([-0.6,0.6]); ylim([-0.6,0.6]);

    %Plot signal k=4
    subplot('Position',[0.24,0.05,0.74,0.14]);
    plot(t,c(4)*sin(phi(:,4)),'-b','LineWidth',1.5);
    axis tight;
    ylim([-0.6,0.6]);
    set(gca,'XDir','reverse');
    xlabel('Time (s)'); 
    
    drawnow;
    
    F = getframe(fig(1));
    writeVideo(v,F);
end

close(v);