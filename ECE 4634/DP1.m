load DesignProject1

%% #5

EnergySpectralDensity(Original, 65536);
% We are using ESD because the signal being sampled is finite in time.
plot(time, Original);
title('Original Voice Signal')
xlabel('Time (s)')
ylabel('Amplitude')
OriginalBW = CalculateBandwidth(Original, 65536, 0.999)
% The BW of the signal is 3.686 kHz

%% #6

EnergySpectralDensity(Original, 65536);
title('ESD of the Original Signal')

x1 = MyResample(Original, 2048);
EnergySpectralDensity(x1, 2048);
title('ESD of the Original Signal Sampled at f_s = 2048')

x2 = MyResample(Original, 4096);
EnergySpectralDensity(x2, 4096);
title('ESD of the Original Signal Smapled at f_s = 4096')

x3 = MyResample(Original, 8192);
EnergySpectralDensity(x3, 8192);
title('ESD of the Original Signal Sampled at f_s = 8192')

x4 = MyResample(Original, 16384);
EnergySpectralDensity(x4, 16384);
title('ESD of the Original Signal Sampled at f_s = 16384')

%% #8

% The lower you make the sampling rate, the sound quality begins to go
% down. There is a decrease in sharpness and clarity.

% The sound quality begins to suffer around 4096. It starts to sound
% drowned out and less clear. At 2048, the quality is very low and the
% voice sounds like it is coming from a very bad old radio.

% The absolute bandwidth of this signal is about 3,686 Hz. The point where
% the quality starts to suffer is about 4096 Hz (or anything under 8192 Hz). Compared to the
% theoretical minimum of 7372 Hz (given by the Nyquist Rate Fs >= 2B, B = 3,686 Hz ->
% Fs = 7372), the Fs of when it starts to suffer is about 55.6% of that.
% This makes sense because if the sampling rate is not twice the bandwidth,
% then aliasing occurs.

% SNR Value:

% At 8192 Hz
x3_1 = interp(x3, 8);

% SNR of 8192 Hz sampling rate is 233.1 dB
R3 = snr(Original, Original - x3_1)

%% #9 Impact of Quantization

% Using the 8192 Hz interpolated signal
y1 = UniformQuantize(x3_1, 2);
y2 = UniformQuantize(x3_1, 4);
y3 = UniformQuantize(x3_1, 8);
y4 = UniformQuantize(x3_1, 16);
y5 = UniformQuantize(x3_1, 32);
y6 = UniformQuantize(x3_1, 64);
y7 = UniformQuantize(x3_1, 128);
% y8 (256) is where the voice signal starts to break down. So at least 8
% bits are needed to quantize the signal. I chose 8 bits as the minimum
% because the signal is still audible and only crackles at very specific
% parts.
y8 = UniformQuantize(x3_1, 256);
y9 = UniformQuantize(x3_1, 512);
y10 = UniformQuantize(x3_1, 1024);

%%

subplot(1,3,1)
plot(time, Original)
title('Original Signal')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(1,3,2)
plot(time, y8);
title('Quantized Signal at 8 bits')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(1,3,3)
plot(time, y4);
title('Quantized Signal at 4 bits')
xlabel('Time (s)')
ylabel('Amplitude')
%%
e8 = x3_1 - y8;
EnergySpectralDensity(e8, 65536);
title('ESD of Error of 8-bit Quantized Signal');

% SNR: y1 = -13.3539, y2 = -6.7786, y3 = -0.0701, y4 = 6.6959, y5 =
% 13.3540, y6 = 19.9113, y7 = 26.1555, y8 = 31.6665, y9 = 38.1261, y10 =
% 44.3737

%% Impact of Amplifier Gain Control

a = MyResample(Original, 8192);
% sound(a, 8192)
b = UniformQuantize(a, 16);
% sound(b, 8192)
% The signal sounds staticky and grainy
c = 2*UniformQuantize(0.5*a, 16);
% sound(c, 8192)
% This sounds like a louder version of b, but also slightly clearer

EnergySpectralDensity(a-b, 8192);
title('Error ESD of 16-bit Quantized Signal')
EnergySpectralDensity(a-c, 8192);
title('Error ESD of Modified 16-bit Quantized Signal')

d = 0.2*UniformQuantize(5*a, 16);
% sound(d, 8192)
% Sounds a good amount clearer, but also a little quieter than the orignal
% quantized signal.

EnergySpectralDensity(a-d, 8192);
title('Error ESD of 2^{nd} Modified 16-bit Quantized Signal')

%% Impact of Non-Linear Quantization
k = MyResample(Original, 8192);
l = Compress(Original, 255);
kq = UniformQuantize(k, 16);
lq = UniformQuantize(l, 16);
m = Expand(lq, 255);

% Had to interpolate the answer so I could find the ESD of both the
% signals. 
kqi = interp(kq, 8);
ki = interp(k, 8);
% sound(kq, 8192);
% sound(m, 65536);

EnergySpectralDensity(ki-kqi, 65536);
title('Error ESD of Uniform Quantizer');
EnergySpectralDensity(ki-m, 65536);
title('Error ESD of Non-Linear Quantizer');