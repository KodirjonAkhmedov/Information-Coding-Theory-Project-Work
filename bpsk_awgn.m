clc;
clear;
close all;
N_bits=1000000;     % number of generated bits
Eb_No_dB=0:0.5:10;    % Eb/N0 dB scale
BER_sim=zeros(size(Eb_No_dB));   % BER buffer

for n=1:length(Eb_No_dB)
    Eb_N0_ral_scale= 10 ^(Eb_No_dB(n)/10);    % Eb/N0 linear scale
    sigma=sqrt(1./(2*Eb_N0_ral_scale));     % Calculate the standard deviation of the noise
    
    bit=randi([0 1],N_bits,1);         %randomly generate the bits
    Symbols=bit*(-2)+1;                % symbol mapping
    
    noise=randn(N_bits,1)*sigma;       % AWGN channel
    y=Symbols + noise ;         % add noise to signal
    demapped_bits= y < 0 ;        % demapping
    BER_sim(n)=sum(bit ~= demapped_bits) ./ N_bits; % BER calculation
    
    fprintf('Eb/No= %g   BER:    %g\n',Eb_No_dB(n) ,BER_sim(n))    
end

%% Calculate BER of BPSK-AWGN
Eb_N0_theory=0:0.05:10 ;
BER_theory=berawgn(Eb_N0_theory,'psk',2,'nondiff');
%% Plot
figure(1);
semilogy(Eb_N0_theory,BER_theory,'r',Eb_No_dB,BER_sim,'b*');
xlabel('Eb/No [dB]');
ylabel('BER');
grid;
axis([0 10 0 0.1]);
legend('Theoretical','Simulation')
%title('The Theoretical and Simulation Results of BER of BPSK Modulation under BI-AWGN Channel without coding')