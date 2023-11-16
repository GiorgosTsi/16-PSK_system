clear all;
close all;
clc;

%%1
%%Create random bits:
N=100;
bit_seq = (sign(randn(4*N, 1)) + 1)/2;

%%2
%%Map these bits to 16 psk with gray encoding:
    % 0000 -> 0 radians      X0
    % 0001 -> π/8 radians    X1
    % 0011 -> π/4 radians    X2
    % 0010 -> 3π/8 radians   X3
    % 0110 -> π/2 radians    X4
    % 0111 -> 5π/8 radians   X5
    % 0101 -> 3π/4 radians   X6
    % 0100 -> 7π/8 radians   X7
    % 1010 -> π radians      X8
    % 1011 -> 9π/8 radians   X9
    % 1001 -> 5π/4 radians   X10
    % 1000 -> 11π/8 radians  X11
    % 1100 -> 3π/2 radians   X12
    % 1101 -> 13π/8 radians  X13
    % 1111 -> 7π/4 radians   X14
    % 1110 -> 15π/8 radians  X15

X = bitsTo16PSK(bit_seq); % 2X100 vector

%%3
%%Plot the output of srrc filters with inputs Xi = X(1,:) , Xq = X(2,:)

T = 10^-2; %%symbol period
over = 10;
Ts = T/over;%%sampling period
A = 4;
a = 0.5;
%%create the srrc filter :
[fi,t] = srrc_pulse(T, over, A, a);

Xi_delta = 1/Ts * upsample(X(1,:) , over);
Xq_delta = 1/Ts * upsample(X(2,:),over);

%time for X_delta signals:
t_X= 0 : Ts : N*T - Ts;

%time for the output of the filters:
t_conv = min(t)+min(t_X) : Ts : max(t)+max(t_X);

%output of the up filter
Xi_t = conv(fi,Xi_delta)*Ts;


%output of the down filter
Xq_t = conv(fi,Xq_delta)*Ts;

%Plot the outputs:
figure(1);
plot(t_conv,Xi_t);
grid on;
title('XI');
figure(2);
plot(t_conv,Xq_t);
grid on;
title('XQ');

%%Compute and plot the periodograms of XI , XQ:

Fs = 1/Ts;

Nf = 2048; % number of samples for the fourier signal

DT = Fs / Nf;

%create F axis
F = -Fs/2 : DT : (Fs/2) - DT;

%fourier transform of XI
FXi = fftshift(fft(Xi_t,Nf))*Ts;

Ttotal =  t_conv(end) - t_conv(1);
%PxI
PXin= (abs(FXi).^2) / Ttotal;
figure(3);
plot(F,PXin);
grid on;
title('periodogram of XI');


%fourier transform of XQ
FXq=fftshift(fft(Xq_t,Nf))*Ts;
%PxQ,n(F)
PXqn= (abs(FXq).^2) / Ttotal;
figure(4);
plot(F,PXqn);
grid on;
title('periodogram of XQ');


%%4
%%multiply the output of the filters with the carrier

F0 = 200 ; %carrier

%Multiply with the carrier:

Xi_cos = 2 * Xi_t.* cos(2*pi*F0*t_conv);
Xq_sin = Xq_t*(-2).* sin(2*pi*F0*t_conv);

%%Plot the the signals:

figure(5);
plot(t_conv,Xi_cos);
grid on;
title('Xi(t)*2cos(2πF0t)');


figure(6);
plot(t_conv,Xq_sin);
grid on;
title('Xq(t)*-2sin(2πF0t)');


%%Plot the periodograms of these signals:

FXi_cos = fftshift(fft(Xi_cos,Nf)) * Ts;

%PxIcos
%same Ttotal as Xi without cos
PXi_cos= (abs(FXi_cos).^2) / Ttotal;
figure(7);
plot(F,PXi_cos);
grid on;
title('periodogram of Xicos');


FXq_sin = fftshift(fft(Xq_sin,Nf)) * Ts;

%PxQsin

PXq_sin= (abs(FXq_sin).^2) / Ttotal;
figure(8);
plot(F,PXq_sin);
grid on;
title('periodogram of Xqsin');


%%5

%Plot the input of the channel, X(t) and it's periodogram

X_t = Xi_cos + Xq_sin;

figure(9);
plot(t_conv,X_t);
grid on;
title('X(t)');

FX_t = fftshift(fft(X_t,Nf)) * Ts;
%PxQ
PX_t= (abs(FX_t).^2) / Ttotal;
figure(10);
plot(F,PX_t);
grid on;
title('periodogram of X(t)');

%%7
%%Add gaussian noise to X(t):

SNRdB = 10;
%σw^2
sigmaw = 1/(Ts * 10 ^(SNRdB/10));
%σN^2
sigman = Ts * sigmaw/2; 

%W(t)
%W(t) is gaussian with mean = 0 and sigma = sigmaw
W_t = sqrt(sigmaw) * randn(1,length(X_t));

%Y(t)
Y_t = X_t + W_t;

%%8

Y1_t = Y_t.* cos(2*pi*F0.*t_conv);
Y2_t = Y_t.* -sin(2*pi*F0.*t_conv);

figure(11);
plot(t_conv,Y1_t);
grid on;
title('Y(t)*cos(2πF0t) = Y1(t)');

figure(12);
plot(t_conv,Y2_t);
grid on;
title('Y(t)*-sin(2πF0t) = Y2(t)');

FY1_t = fftshift(fft(Y1_t,Nf)) * Ts;
%again we have same Ttotal

%PYI
PY1_t= (abs(FY1_t).^2)/Ttotal;
figure(13);
plot(F,PY1_t);
grid on;
title('periodogram of Y1(t)');
FY2_t = fftshift(fft(Y2_t,Nf)) * Ts;

%PYQ
PY2_t= (abs(FY2_t).^2) / Ttotal;
figure(14);
plot(F,PY2_t);
grid on;
title('periodogram of Y2(t)');

%%9
%plot the output of the srrc filters:

Y1_tafterFilter = conv(Y1_t,fi) * Ts;
Y2_tafterFilter = conv(Y2_t,fi) * Ts;

t_convfiltered = min(t) + min(t_conv): Ts : max(t) + max(t_conv);
figure(15);
plot(t_convfiltered,Y1_tafterFilter);
grid on;
title('filterd Y1(t)');

figure(16);
plot(t_convfiltered,Y2_tafterFilter);
grid on;
title('filtered Y2(t)');

%Plot their periodograms:

FfY1_t = fftshift(fft(Y1_tafterFilter,Nf)) * Ts;

PfY1_t = (abs(FfY1_t).^2) / Ttotal;
figure(17);
plot(F,PfY1_t);
grid on;
title('periodogram of filtered Y1(t)');
FfY2_t = fftshift(fft(Y2_tafterFilter,Nf)) * Ts;

PfY2_t = (abs(FfY2_t).^2) / Ttotal;
figure(18);
plot(F,PfY2_t);
grid on;
title('periodogram of filtered Y2(t)');

%%10
i=1;
for j=2*A*over+1:over:length(t_convfiltered)-2*A*over
   Y(i,1)=Y1_tafterFilter(j);
   Y(i,2)=Y2_tafterFilter(j);
   i=i+1;
end

scatterplot(Y);
grid on;
title('samples on the output');

%11
%reverse gray encoding:
[est_X, est_bit_seq] = detect_PSK_16_gray(Y);

%12
%number of symbol errors:
num_of_symbol_errors = symbol_errors(est_X,X)

%13
%number of bit errors:
num_of_bit_errors =  bit_errors(est_bit_seq,bit_seq)


%%2o meros:

SNRdB = -2:2:24;

M = 16;

Pf_symbol = zeros(size(SNRdB));
Pf_bit = zeros(size(SNRdB));

for j = 1:length(SNRdB)
    sum_num_symbol_errors = 0;
    sum_num_bit_errors = 0;
    for K = 1:1000
        N = 100;
        bit_seq = (sign(randn(4 * N, 1)) + 1) / 2;
        X = bitsTo16PSK(bit_seq);
        T = 10^-2;
        over = 10;
        Ts = T / over;
        A = 4;
        a = 0.5;
        Fs = 1 / Ts;
        Nf = 2048;
        DT = Fs / Nf;
        [phi, t] = srrc_pulse(T, over, A, a);
        Xi_delta = 1 / Ts * upsample(X(1, :), over);
        Xq_delta = 1 / Ts * upsample(X(2, :), over);
        Xi_t = conv(phi, Xi_delta) * Ts;
        Xq_t = conv(phi, Xq_delta) * Ts;

        F0 = 200;
        Xi_cos = 2 * Xi_t .* cos(2 * pi * F0 * t_conv);
        Xq_sin = 2 * Xq_t .* -sin(2 * pi * F0 * t_conv);
        X_t = Xi_cos + Xq_sin;
        sigmaw = 1 /(Ts*(10^(SNRdB(j)/10)));
        sigmansq = Ts*((sigmaw))/ 2;
        % W(t)
        W_t = sqrt(sigmaw)*randn(1, length(X_t));
        Y_t = X_t + W_t;
        Y1_t = Y_t .* cos(2 * pi * F0*t_conv);
        Y2_t = Y_t .* -sin(2 * pi * F0 * t_conv);
        filteredY1_t = conv(Y1_t, phi) * Ts;
        filteredY2_t = conv(Y2_t, phi) * Ts;
        l = 1;
        for k=2*A*over+1:over:length(filteredY1_t)-2*A*over
           Y(l,1)=filteredY1_t(k);
           Y(l,2)=filteredY2_t(k);
           l=l+1;
        end

        [est_X, est_bit_seq] = detect_PSK_16_gray(Y);
        num_of_symbol_errors1 = symbol_errors(est_X, X);
        num_of_bit_errors1 = bit_errors(est_bit_seq, bit_seq);
        sum_num_symbol_errors = sum_num_symbol_errors + num_of_symbol_errors1;
        sum_num_bit_errors = sum_num_bit_errors + num_of_bit_errors1;
    end
    % Calculate average symbol error probability
    PEsymbol(j) = sum_num_symbol_errors / (N * K);

    % Calculate average bit error probability
    PEbit(j) = sum_num_bit_errors / (4 * N * K);

    % Calculate theoretical symbol error probability for 16-PSK modulation
    Pf_symbol(j) = 2*qfunc(1*sin(pi/M)/sqrt(sigmansq));
    % Calculate theoretical bit error probability
    Pf_bit(j) = Pf_symbol(j)./log2(M);
end

    
%2
figure();
semilogy(SNRdB,PEsymbol,'LineWidth',1.5);
hold on;
semilogy(SNRdB,Pf_symbol,'r','LineWidth',1.5);
grid on;
title('Symbol Error Probability');
xlabel('SNR (dB)');
ylabel('P_s');
legend('Experimental','Theoretical');

%3
figure();
semilogy(SNRdB,PEbit,'LineWidth',1.5);
hold on;
semilogy(SNRdB,Pf_bit,'r','LineWidth',1.5);
grid on;
title('Bit Error Probability');
xlabel('SNR (dB)');
ylabel('P_b');
legend('Experimental','Theoretical');

