clc;
close all;
clear all;
tx_height = 90;
rx_height = 5;
freq = 200*10^6;
pathlossExp = 3.5;
std_db = 7;
d = 1500:1000:100000;
D0 = 2000;
lambda = physconst('LightSpeed')/freq;

%free_space_path_loss------------------------------------------------------
received_power_D = fspl(20,lambda)
free_space_path_loss = 20*log10(4*pi*d./lambda);

%log_distance_path_loss_model----------------------------------------------
log_distance_path_loss = fspl(D0,lambda) + pathlossExp*10*log10(d./D0);

%Log-Normal Shadowing Model------------------------------------------------
log_Normal_Shadowing_model_path_loss = log_distance_path_loss + 10*log10(random('Lognormal', 0, std_db));

%okumura model-------------------------------------------------------------
Amu = 1;
GHte = 20*log10(tx_height/200)
GHre = 20*log10(rx_height/3) 
okumura_modal_median_path_loss = free_space_path_loss + Amu - GHre - GHte - 5;

%Hata model----------------------------------------------------------------
%a_hre = 0.8+(1.1*log10(freq)-0.7)*rx_height - 1.56*log10(freq)
a_hre = 8.29*pow2(log10(1.54*rx_height))-1.1 ;%for large city 
loss_urbun_hata = 69.55+26.16*log10(freq)-13.82*log10(tx_height)-a_hre+(44.9-6.55*log10(tx_height))*log10(d);
loss_suburbun_hata_model = loss_urbun_hata - 2*pow2(log10(freq/28))-5.4;

%Two ray pathloss model----------------------------------------------------
Ar = 1;
Gt = 4*pi*Ar/pow2(lambda)
Gr = 4*pi*Ar/pow2(lambda);
G = Gt*Gr;
two_ray_path_loss = 40*log10(d)-10*log10(G*(rx_height*tx_height)^2);

%PLOTTING
figure(1);
plot(d,free_space_path_loss,Marker="+");
hold on;
plot(d,log_distance_path_loss,Marker="o");
hold on;
plot(d,log_Normal_Shadowing_model_path_loss,Marker="*");
hold on
plot(d,okumura_modal_median_path_loss,Marker=".");
hold on
plot(d,loss_suburbun_hata_model,Marker="x");
hold on
plot(d,two_ray_path_loss,Marker="square");
legend(["free space path loss","Log distance path loss","log Normal Shadowing model path loss","okumura modal median path loss","loss suburbun hata model","two ray path loss"])
title("different path loss models");
xlabel("distance in m")
ylabel("path loss in dB")

