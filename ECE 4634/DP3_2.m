load DesignProject1;
fs = 8192;
numBits = 6;
mu = 255;

%% Pulse Shaping

Ns = 10;
N = 10;
t = 1:210;
x = zeros(210,1);

rf = 0.25;
samp_sig = Analog2Digital(Original, fs, numBits, 1, mu);
BPSK = PhaseMod(samp_sig, 1, 0);

% Square Pulse
[sq, sqpulse, sqEs] = PulseShape(BPSK, 'SQAR', Ns, 0);
sqp = transpose(sq.*sqrt(sqEs));
sqt = sqp(1:210);
for i = 1:10:210;
    x(i) = sqt(i);
end
plot(t, sqt)
hold on
stem(t, x);
hold off
axis([0 210 -1.5 1.5])
title('Pulse Shape: Square')
xlabel('Time');
ylabel('Amplitude');
figure

% Sinc Pulse
[snc, sncpulse, sncEs] = PulseShape(BPSK, 'SINC', Ns, N);
sncp = transpose(snc.*sqrt(sncEs));
snct = sncp(51:260);

for i = 1:10:210
    x(i) = snct(i);
end

plot(t, snct);
hold on
stem(t, x);
hold off
axis([0 210 -1.5 1.5])
title('Pulse Shape: Sinc');
xlabel('Time');
ylabel('Amplitude');
figure


% Raised Cosine
[raco, racopulse, racoEs] = PulseShape(BPSK, 'RaCo', Ns, N, rf);
racop = transpose(snc.*sqrt(racoEs));
racot = racop(51:260);

for i = 1:10:210
    x(i) = racot(i);
end

plot(t, racot);
hold on
stem(t, x);
hold off
axis([0 210 -1.5 1.5])
title('Pulse Shape: Raised Cosine');
xlabel('Time');
ylabel('Amplitude');
figure


% Square Root Raised Cosine
[srrc, srrcpulse, srrcEs] = PulseShape(BPSK, 'SRRC', Ns, N, rf);
srrcp = transpose(srrc.*sqrt(srrcEs));
srrct = srrcp(51:260);

for i = 1:10:210
    x(i) = srrct(i);
end

plot(t, srrct);
hold on
stem(t, x);
hold off
axis([0 210 -1.5 1.5])
title('Pulse Shape: Square Root Raised Cosine');
xlabel('Time');
ylabel('Amplitude');z

%% Energy Spectral Density Non Log Plot
EnergySpectralDensity([sqpulse, zeros(1,1000)], fs);
title('Square Pulse, Ns = 10')
EnergySpectralDensity([sncpulse, zeros(1,1000)],fs);
title('Sinc Pulse, Ns = 10, N = 10')
EnergySpectralDensity([racopulse, zeros(1,1000)], fs);
title('Raised Cosine Pulse, Ns = 10, N = 10, r = 0.25')
EnergySpectralDensity([srrcpulse, zeros(1,1000)], fs);
title('Square Root Raised Cosine Pulse, Ns = 10, N = 10, r = 0.25')

%% Energy Spectral Density Log Plot

EnergySpectralDensity([sqpulse, zeros(1,1000)], fs, [-4000 4000, -50, 0], 1);
title('Square Pulse, Ns = 10')
EnergySpectralDensity([sncpulse, zeros(1,1000)],fs,[-4000 4000, -50, 0], 1);
title('Sinc Pulse, Ns = 10, N = 10')
EnergySpectralDensity([racopulse, zeros(1,1000)], fs,[-4000 4000, -75, 0], 1);
title('Raised Cosine Pulse, Ns = 10, N = 10, r = 0.25')
EnergySpectralDensity([srrcpulse, zeros(1,1000)], fs,[-4000 4000, -75, 0], 1);
title('Square Root Raised Cosine Pulse, Ns = 10, N = 10, r = 0.25')

%% Pulse Shaping Pt. 2
% RaCo, Ns = 5, r = 0.25, r = 0.75
N5 = 5;
N10 = 10;
N100 = 100;
r25 = 0.25;
r75 = 0.75;

[raco1075, racopulse1075, racoEs1075] = PulseShape(BPSK, 'RaCo', Ns, N10, r75);
[raco525, racopulse525, racoEs525] = PulseShape(BPSK, 'RaCo', Ns, N5, r25);
[raco575, racopulse575, racoEs575] = PulseShape(BPSK, 'RaCo', Ns, N5, r75);
[raco10025, racopulse10025, racoEs10025] = PulseShape(BPSK, 'RaCo', Ns, N100, r25);

%% Pt 2 Non Log Plot
EnergySpectralDensity([racopulse1075, zeros(1,1000)], fs);
title('N = 10, r = 0.75')
EnergySpectralDensity([racopulse10025, zeros(1,1000)], fs);
title('N = 100, r = 0.25')
EnergySpectralDensity([racopulse525, zeros(1,1000)], fs);
title('N = 5, r = 0.25')
EnergySpectralDensity([racopulse575, zeros(1,1000)], fs);
title('N = 5, r = 0.75')

%% Pt 2 Log Plot
EnergySpectralDensity([racopulse1075, zeros(1,1000)], fs,[-4000 4000, -120, 0], 1);
title('N = 10, r = 0.75')
EnergySpectralDensity([racopulse10025, zeros(1,1000)], fs,[-4000 4000, -120, 0], 1);
title('N = 100, r = 0.25')
EnergySpectralDensity([racopulse525, zeros(1,1000)], fs,[-4000 4000, -120, 0], 1);
title('N = 5, r = 0.25')
EnergySpectralDensity([racopulse575, zeros(1,1000)], fs,[-4000 4000, -120, 0], 1);
title('N = 5, r = 0.75')

%% Matched Filtering

% Square Pulse
MF_sq = transpose(conv(sq, sqpulse));
MF_sqt = MF_sq(10:219);
for i = 1:10:210
    x(i) = MF_sqt(i);
end
plot(t, MF_sqt);
hold on
stem(t, x);
hold off
title('Matched Filter: Square Pulse')
xlabel('Time');
ylabel('Amplitude');
axis([0 210 -2 2]);
figure

% Sinc Pulse
MF_snc = transpose(conv(snc, sncpulse));
MF_snct = MF_snc(101:310);
for i = 1:10:210
    x(i) = MF_snct(i);
end
plot(t, MF_snct);
hold on
stem(t, x);
hold off
title('Matched Filter: Sinc Pulse')
xlabel('Time');
ylabel('Amplitude');
axis([0 210 -2 2]);
figure

% Raised Cosine Pulse
MF_raco = transpose(conv(raco, racopulse));
MF_racot = MF_raco(101:310);
for i = 1:10:210
    x(i) = MF_racot(i);
end
plot(t, MF_racot);
hold on
stem(t, x);
hold off
title('Matched Filter: Raised Cosine Pulse');
xlabel('Time');
ylabel('Amplitude');
axis([0 210 -2 2]);
figure

% Square Root Raised Cosine Pulse
MF_srrc = transpose(conv(srrc, srrcpulse));
MF_srrct = MF_srrc(101:310);
for i = 1:10:210
    x(i) = MF_srrct(i);
end
plot(t, MF_srrct);
hold on
stem(t, x);
hold off
title('Matched Filter: Square Root Raised Cosine Pulse');
xlabel('Time');
ylabel('Amplitude');
axis([0 210 -2 2]);

%% Matched Filtering with Added Noise
SNR = 5.62;

% Square Pulse
N_sq = AddNoise(sq, SNR, 1);
MF_sq = transpose(conv(N_sq, sqpulse));
MF_sqt = MF_sq(1:210);
for i = 1:10:210
    x(i) = MF_sqt(i);
end
plot(t, MF_sqt);
hold on
stem(t, x);
hold off
title('Matched Filter + Noise: Square')
axis([0 210 -2 2]);
axis([0 210 -2 2]);
figure

% RS_sq = 

% Sinc Pulse
N_snc = AddNoise(snc, SNR, 1);
MF_snc = transpose(conv(N_snc, sncpulse));
MF_snct = MF_snc(101:310);
for i = 1:10:210
    x(i) = MF_snct(i);
end
plot(t, MF_snct);
hold on
stem(t, x);
hold off
title('Matched Filter + Noise: Sinc Pulse')
axis([0 210 -2 2]);
figure

% Raised Cosine Pulse
N_raco = AddNoise(raco, SNR, 1);
MF_raco = transpose(conv(N_raco, racopulse));
MF_racot = MF_raco(101:310);
for i = 1:10:210
    x(i) = MF_racot(i);
end
plot(t, MF_racot);
hold on
stem(t, x);
hold off
title('Matched Filter + Noise: Raised Cosine Pulse');
axis([0 210 -2 2]);
figure

% Square Root Raised Cosine Pulse
N_srrc = AddNoise(srrc, SNR, 1);
MF_srrc = transpose(conv(N_srrc, srrcpulse));
MF_srrct = MF_srrc(101:310);
for i = 1:10:210
    x(i) = MF_srrct(i);
end
plot(t, MF_srrct);
hold on
stem(t, x);
hold off
title('Matched Filter: Square Root Raised Cosine Pulse');
axis([0 210 -2 2]);

%% Fading

% Square Pulse
NF_sq = transpose(N_sq);
DM_sq = transpose(PhaseDemod(NF_sq, 1));
DA_sq = Digital2Analog(DM_sq, numBits, 1, mu);

% Sinc Pulse
NF_snc = transpose(N_snc);

% Raised Cosine Pulse
NF_raco = transpose(N_raco);

% Square Root Raised Cosine Pulse
NF_srrc = transpose(N_srrc);
