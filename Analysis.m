close all;clear;clc

%% SETTING CD,CL FACTORS AND DEFINING X AXIS (depending on number of timesteps recorded and separation
factor=-20;

%datatype 1: separation of 1 timestep, 12000 iterations
iter=1:12000;
x=iter*0.0005*10;

%datatype 2: separation of 50 timestep, 12000 iterations
iter2=50:50:12000;
x2=iter2*0.0005*10;

%datatype 3: separation of 1 timestep, 20000 iterations
iter3=1:20000;
x3=iter3*0.0005*10;

%% NUMBER OF PLOTS
num_plots = 2;
numeval=6660;
%% DATA
data1=readtable('Test_Strategies/21_06_22/11probes/OpenMLC_11probes.csv');
y1=data1{1:12000,6};
CD1=data1{1:12000,3};
CL1=data1{1:12000,4};
Rec_A1=data1{1:12000,5};
fprintf('DATA 1: \n')
fprintf('Mean Cd (last sheddind cycle)  : %.3f \n',mean(CD1(end-numeval:end))*factor)
fprintf('Mean Cl (last sheddind cycle)  : %.3f \n',mean(CL1(end-numeval:end))*factor)
fprintf('Cd reduction (percent)         : %.3f \n',-100*(mean(CD1(end-numeval:end))*factor-3.206428)/(mean(CD1(end-numeval:end))*factor))
fprintf('\n')

data2   = readtable('Test_Strategies/21_06_22/11probes/xMLC_11probes.csv');
y2      = data2{1:end,6};
CD2     = data2{1:end,3};
CL2     = data2{1:end,4};
Rec_A2  = data2{1:end,5};
fprintf('DATA 2: \n')
fprintf('Mean Cd (last sheddind cycle)  : %.3f \n',mean(CD2(end-numeval:end))*factor)
fprintf('Mean Cl (last sheddind cycle)  : %.3f \n',mean(CL2(end-numeval:end))*factor)
fprintf('Cd reduction (percent)         : %.3f \n',-100*(mean(CD2(end-numeval:end))*factor-3.206428)/(mean(CD2(end-numeval:end))*factor))
fprintf('\n')

data3   = readtable('Test_Strategies/21_06_22/11probes/Rabault_11probes_840.csv');
y3      = data3{1:end,6};
CD3     = data3{1:end,3};
CL3     = data3{1:end,4};
Rec_A3  = data3{1:end,5};
fprintf('DATA 3: \n')
fprintf('Mean Cd (last sheddind cycle)  : %.3f \n',mean(CD3(end-numeval:end))*factor)
fprintf('Mean Cl (last sheddind cycle)  : %.3f \n',mean(CL3(end-numeval:end))*factor)
fprintf('Cd reduction (percent)         : %.3f \n',-100*(mean(CD3(end-numeval:end))*factor-3.206428)/(mean(CD3(end-numeval:end))*factor))
fprintf('\n')

data4   = readtable('Test_Strategies/21_06_22/11probes/Rabault_11probes_840.csv');
y4      = data4{1:12000,6};
CD4     = data4{1:12000,3};
CL4     = data4{1:12000,4};
Rec_A4  = data4{1:12000,5};
fprintf('DATA 4: \n')
fprintf('Mean Cd (last sheddind cycle)  : %.3f \n',mean(CD4(end-numeval:end))*factor)
fprintf('Mean Cl (last sheddind cycle)  : %.3f \n',mean(CL4(end-numeval:end))*factor)
fprintf('Cd reduction (percent)         : %.3f \n',-100*(mean(CD4(end-numeval:end))*factor-3.206428)/(mean(CD4(end-numeval:end))*factor))
fprintf('\n')

data5   = readtable('Test_Strategies/21_06_22/151probes/Rabault_151probes.csv');
y5      = data5{1:12000,6};
CD5     = data5{1:12000,3};
CL5     = data5{1:12000,4};
Rec_A5  = data5{1:12000,5};
fprintf('DATA 5: \n')
fprintf('Mean Cd (last sheddind cycle)  : %.3f \n',mean(CD5(end-numeval:end))*factor)
fprintf('Mean Cl (last sheddind cycle)  : %.3f \n',mean(CL5(end-numeval:end))*factor)
fprintf('Cd reduction (percent)         : %.3f \n',-100*(mean(CD5(end-numeval:end))*factor-3.206428)/(mean(CD5(end-numeval:end))*factor))

figure(1)
% subplot(2,2,1)
plot(x,y1);
hold on
xlabel('Time [s]')
ylabel('MFR')
grid on
title('Jet Massflow')

figure(2)
% subplot(2,2,2)
plot(x,CD1*factor);
hold on
xlabel('Time [s]')
ylabel('Cd')
grid on
title('Drag Coefficient')
ylim([2.875,3.25])

figure(3)
% subplot(2,2,3)
plot(x,CL1*factor);
hold on
xlabel('Time [s]')
ylabel('Cl')
ylim([-1.5 1.5])
grid on
title('Lift Coefficient')

figure(4)
% subplot(2,2,4)
plot(x,Rec_A1);
hold on
xlabel('Time [s]')
ylabel('Recirculation Area')
grid on
title('Recirculation Area')

%2nd set of data
figure(1)
figure(1)
plot(x,y2);
figure(2)
plot(x,CD2*factor);
figure(3)
plot(x,CL2*factor);
figure(4)
plot(x,Rec_A2);

% 3rd set of data
figure(1)
figure(1)
plot(x,y3);
figure(2)
plot(x,CD3*factor);
legend('OpenMLC','xMLC','Rabault')
figure(3)
plot(x,CL3*factor);
figure(4)
plot(x,Rec_A3);

% 4th set of data
% figure(1)
% figure(1)
% plot(x,y4);
% figure(2)
% plot(x,CD4*factor);
% figure(3)
% plot(x,CL4*factor);
% figure(4)
% plot(x,Rec_A4);
% 
% % 5th set of data
% figure(1)
% figure(1)
% plot(x,y5);
% legend('MLC 5','Rabault 5','MLC 11','Rabault 11','Rabault 151')
% figure(2)
% plot(x,CD5*factor);
% legend('MLC 5','Rabault 5','MLC 11','Rabault 11','Rabault 151')
% figure(3)
% plot(x,CL5*factor);
% figure(4)
% plot(x,Rec_A5);

%% JFM paper plots
% CL_case=CL1;
% CD_case=CD1;
% 
% % Phase portrait (1/4 period)
% CL_notimedelay=CL_case(166:end);
% CL_timedelay=CL_case(1:end-165);
% 
% figure(2)
% subplot(2,2,1)
% plot(CL_notimedelay,CL_timedelay)
% xlabel('C_L(t)')
% ylabel('C_L(t-tau)')
% title('CL Phase Portrait(1/4T)')
% 
% % PSD
% Fs = 1/(x(2)-x(1));
% len=length(CL_case);
% xdft = fft(CL_case);
% xdft = xdft(1:len/2+1);
% xdft(2:end-1) = 2*xdft(2:end-1);
% psdest = 1/(len*Fs)*abs(xdft).^2;
% freq = 0:Fs/len:Fs/2;
% figure(2)
% subplot(2,2,2)
% plot(freq,10*log10(psdest));
% xlim([0,5])
% xlabel('St')
% ylabel('PSD')
% title('CL PSD')
% grid on;
% 
% % Phase portrait (1/4 period)
% CD_notimedelay=CD_case(85:end);
% CD_timedelay=CD_case(1:end-84);
% 
% figure(2)
% subplot(2,2,3)
% plot(CD_notimedelay,CD_timedelay)
% xlabel('C_D(t)')
% ylabel('C_D(t-tau)')
% title('CD Phase Portrait(1/4T)')
% 
% % PSD
% Fs = 1/(x(2)-x(1));
% len=length(CD_case);
% xdft = fft(CD_case);
% xdft = xdft(1:len/2+1);
% xdft(2:end-1) = 2*xdft(2:end-1);
% psdest = 1/(len*Fs)*abs(xdft).^2;
% freq = 0:Fs/len:Fs/2;
% figure(2)
% subplot(2,2,4)
% plot(freq,10*log10(psdest));
% xlim([0,5])
% xlabel('St')
% ylabel('PSD')
% title('CD PSD')
% grid on;

%% MFR,CL comparison
% data1=readtable('Test_strat/displaced/no_disp.csv');
% data2=readtable('Test_strat/displaced/no_smoothing.csv');
% MFR1=data1{1:12000,6};
% MFR2=data2{1:12000,6};
% MFR_unaffected=(0.04*data1{1:12000,4});
% 
% figure(2)
% plot(x,MFR1);
% hold on
% plot(x,MFR2);
% plot(x,MFR_unaffected);
% xlabel('Time [s]')
% grid on
% title('MFR')
% legend('MFR1','MFR2','MFR theoretical')


% J=[9.118e-1 8.773160e-01 8.773160e-01 8.758889e-01 8.698116e-01 ...
%     8.635542e-01 8.343189e-01 8.360570e-01 8.321474e-01 8.305240e-01...
%     8.236816e-01 8.194157e-01 8.139772e-01 8.093133e-01 8.093829e-01...
%     7.946011e-01 7.914860e-01 7.820960e-01 7.797976e-01 7.793218e-01];
% 
% gen=1:20;
% 
% figure(10)
% plot(gen,J)
% title('Cost function evolution')
% xlabel('Gen')
% ylabel('J')
% grid on