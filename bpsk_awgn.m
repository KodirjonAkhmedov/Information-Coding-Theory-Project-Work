close all;
clear all;
samples = 500000;

N=10;
x=[0:N];
for SNR_dB =0:1: N; %in dB
    totalerror=0;
    totalerror1=0;
    snr = 10^(SNR_dB/10);
    Eb = 1;
    N0 = Eb/snr;
    
    sent=randn(1,samples); %signal generation
    modsent=sent*2-1; %bpsk modulation
    noise=sqrt(N0/2)*( randn(size(sent)) + j*randn(size(sent)) ); %creating AWGN
    received=modsent + noise;  %transmission and receive
 
    demoreceived=received>0;  %demodulation
    noe=sum(abs(sent-demoreceived));  %check error
    totalerror=totalerror+noe;  %bit error rate
    ber1(SNR_dB+1)=totalerror/samples;  %calculate avg ber
    pb1(SNR_dB+1)=0.5*erfc(sqrt(10.^(SNR_dB/10)));  %ideal error probability    
    
    ii=1:length(SNR_dB)
    n=1/sqrt(2)*[randn(1,samples)+j*randn(1,samples)];
    h=1/sqrt(2)*[randn(1,samples)+j*randn(1,samples)];
    y=h.*modsent+10^(-SNR_dB(ii)/20)*n;
    yHat=y./h;
 
    derayleigh=yHat>0;
    noe1=sum(abs(sent-derayleigh));
    totalerror1=totalerror1+noe1;
    ber2(SNR_dB+1)=totalerror1/samples;  %calculate avg ber
    EbN0Lin = 10.^(SNR_dB/10);
    per2(SNR_dB+1) = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));
end

figure;
semilogy(x,pb1,'b');axis([1 10 0.0001 1]); 
grid on;
hold on;
semilogy(x,ber1,'r^');
hold on;
semilogy(x,ber2,'r*');
hold on;
semilogy(x,per2,'mx-');
legend('ideal error probability','AWGN','rayleigh-simulation','rayleigh-theory');
title('BPSK调制方式AWGN信道的理论误码率、仿真误码率以及瑞利信道下的理论值和仿真误码率');
xlabel('E_b/N0(dB)');ylabel('Pb');
