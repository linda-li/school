load DesignProject1;

%% Predetermined variables
f_s = 8192;
q_bits = 6;
mu = 255;
r = 0.25;
cost = 0.01;
SNR = 5.62;
%% Converting the signal from Analog to Digital
x = Analog2Digital(Original, f_s, q_bits, 1, mu, 65536);

%% BPSK without GrayCoding
k = 1;
x_PM = PhaseMod(x, k, 0);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 0);
g = Digital2Analog(x_PMND, q_bits, 1, 255);

subplot(1,1,1)
plot(real(x_PM), imag(x_PM))
subplot(2,1,1)
plot(real(x_PMN), imag(x_PMN))
CalculateBandwidth(y, f_s, 0.999)
%% BPSK with GrayCoding
k = 1;
x_PM = PhaseMod(x, k, 1);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 1);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

BPSKGC_BWCalculateBandwidth(y, f_s, 0.999)
%% QPSK without GrayCoding
k = 2;
x_PM = PhaseMod(x, k, 0);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 0);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

QPSK_BW = CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% QPSK with GrayCoding
k = 2;
x_PM = PhaseMod(x, k, 1);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 1);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% 8-PSK without GrayCoding
k = 3;
x_PM = PhaseMod(x, k, 0);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 0);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

plot(real(y), imag(y))
PSK8_BW = CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% 8-PSK with GrayCoding
k = 3;
x_PM = PhaseMod(x, k, 1);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 1);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

PSK8GC_BW = CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% 16-PSK without GrayCoding
k = 4;
x_PM = PhaseMod(x, k, 0);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 0);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

PSK16_BW = CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% 16-PSK with GrayCoding
k = 4;
x_PM = PhaseMod(x, k, 1);
x_PMN = AddNoise(x_PM, SNR, k);
x_PMND = PhaseDemod(x_PMN, k, 1);
y = Digital2Analog(x_PMND, q_bits, 1, 255);

PSK16GC_BW = CalculateBandwidth(y, f_s, 0.999)
sound(y,f_s)
%% 16-QAM

