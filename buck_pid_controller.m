% ---------- 参数与传函定义 ----------
s = tf('s');

% Plant G0(s)
G0 = 42 / (1.551e-8*s^2 + 5.5e-5*s + 1);

% Compensator (without k)
a = 2.5523e-4;
b = 3.184e-6;
C0 = (1 + a*s)^2 / ( s*(1 + b*s) );

% 目标交叉频率
fc = 10e3; wc = 2*pi*fc;

% 计算k：使 |k * G0(jwc) * C0(jwc)| = 1
G0jw = freqresp(G0, wc);
C0jw = freqresp(C0, wc);
k = 1 / ( abs(G0jw) * abs(C0jw) );
fprintf('Computed k = %.6f\n', k);

% 最终补偿器
C = k * C0;

% 显示传递函数
disp('Compensator C(s):'); C

% 画Bode并标注Margin
figure;
margin(G0); hold on;
margin(C*G0);
grid on;
title('Plant (blue) and Compensated Open-loop (orange)');
legend('Plant','Compensated Open-loop');

% 计算并显示相位裕度
[GM,PM,Wgm,Wpm] = margin(C*G0);
fprintf('Phase margin = %.2f deg at f = %.2f Hz\n', PM, Wpm/(2*pi));
fprintf('Gain margin (dB) = %.2f at W = %.2f rad/s\n', 20*log10(GM), Wgm);
