clear; clc; close all;
%load music files
[data1,fs] = audioread("music1.wav");    %78 BPM   fLow = 200; fHigh = 340;
[data2,fs] = audioread("music2.wav");    %113 BPM  fLow = 320; fHigh = 630;
[data3,fs] = audioread("music3.wav");    %140 BPM  fLow = 320; fHigh = 630;
[data4,fs] = audioread("music4.wav");    %149 BPM  fLow = 600; fHigh = 650;

data1 = data1(:,1);
data2 = data2(:,1);
data3 = data3(:,1);
data4 = data4(:,1);

data = data1;
fLow = 200; fHigh = 340;
%fLow = 320; fHigh = 630;
%fLow = 320; fHigh = 630;
%fLow = 600; fHigh = 650;

fnyquist = fs/2;
N = length(data);   %numero total de pontos do sinal
f1 = fs/(N - 1);    %frequencia fundamental
f = (0:N-1) * f1;   %vetor de frequencias
t = (0:N-1)/fs;

%sinal do dominio do tempo
figure(1)
plot(t, data);
xlabel('Tempo (s)')
ylabel('Amplitude')
title('Sinal no dominio do tempo')
axis([0 t(end) -1.5 1.5]);

%espectograma
figure(2)
spectrogram(data, 1024, 512, 1024, fs, 'yaxis');
title('Espectrograma do sinal')


% %calcular FFT Transformada rápida de fourier
% Xf = fft(data, N);
% figure()
% subplot(211)
% plot(f(1:end/2), Xf(1:end/2))
% %calcular a magnitude
% subplot(212)
% Mf = abs(Xf);
% plot(Mf(1:end/2));
% [y x] = max(Mf);
% freq = round(f(x))
% fLow = freq - 50;
% fHigh = freq + 50;

%power spectrum
[PS, f, t] = stft(data, fs/15, fs/30, fs/15);
figure();
mesh(f,t,PS);
xlabel("Frequencia(Hz)");
ylabel("Tempo(s)");
zlabel("Power spectrum(Hz)");

%filtro eliptico
[b,a] = ellip(4, 3, 30, [fLow fHigh]/fnyquist, 'bandpass');
coeffs = mfcc(data, fs);

%encontrar o maior coeficiente
y_max = 0;
for i=1:14
    [y x] = max(coeffs(:,i));
    if (y > y_max)
        y_max = y;
        coef = i;
    end
end

%filtrar sinal
A = filter(b, a, coeffs(:, coef));
figure(4);
plot(A);
xlabel('Tempo (ms)')
ylabel('Amplitude')
title('Sinal filtrado')

%auto correlação
[rxx, lags] = axcor(A);
[pks, locs] = findpeaks(rxx, lags);
figure(5);
plot(lags, rxx);
hold on
plot(locs, pks, 'o');
plot([lags(1) lags(end)],[0 0]);
title('Autocorrelacao do sinal')
axis([min(lags) max(lags) -1.5 1.5]);
hold off

%calcular bpm
bpm = 2 * numel(findpeaks(rxx, fs));
fprintf('bpm: %d\n', bpm);