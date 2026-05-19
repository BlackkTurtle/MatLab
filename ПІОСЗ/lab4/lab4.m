% --- 1. Завантаження зображення ---
img_raw = imread('cameraman.png');

% Перетворення в градації сірого, якщо зображення кольорові (RGB)
if size(img_raw, 3) == 3
    img = rgb2gray(img_raw);
else
    img = img_raw;
end

[M, N] = size(img); % Отримуємо реальні розміри зображення

figure;
imshow(img);
title('1. Вихідне зображення');

% --- 2. Обчислення ДПФ та відображення спектра ---
F = fft2(double(img)); % Пряме ДПФ
S = abs(F);            % Модуль спектра (амплітудний спектр)
Slog = log(1 + S);     % Логарифмічний масштаб для візуалізації

figure;
imshow(Slog, []);
title('2. Спектр (нуль у лівому верхньому куті)');

% --- 3. Центрування спектра (fftshift) ---
Fc = fftshift(F);      % Зсув нульової частоти в центр
Sclog = log(1 + abs(Fc));

figure;
imshow(Sclog, []);
title('3. Центрований спектр (нуль у центрі)');

% --- 4. Відновлення зображення за його спектром (ifft2) ---
% Варіант А: Відновлення з нецентрованого спектра
img_res1 = ifft2(F);

% Варіант Б: Відновлення з центрованого спектра (потрібен зворотний зсув!)
F_unshifted = ifftshift(Fc);
img_res2 = ifft2(F_unshifted);

figure;
subplot(1,2,1), imshow(abs(img_res1), []), title('Відновлено з F');
subplot(1,2,2), imshow(abs(img_res2), []), title('Відновлено з Fc -> ifftshift');

% --- 5 & 6. Створення фільтра Гаусса з sigma = 2 ---
sigma1 = 2;
% Створюємо фільтр, розмір якого ТОЧНО збігається з розміром зображення [M N]
h1 = fspecial('gaussian', [M N], sigma1); 

figure;
imshow(h1, []); % Відображення вікна фільтра в просторовій області
title('5. Вікно фільтра Гаусса (просторова область)');

H1 = fft2(h1); % Частотна характеристика фільтра (ЧХ)
H1_shift = fftshift(abs(H1));

figure;
imshow(log(1 + H1_shift), []);
title('6. АЧХ фільтра Гаусса (sigma = 2)');

% --- 7. Зміна параметра sigma (наприклад, sigma = 15) ---
sigma2 = 15;
h2 = fspecial('gaussian', [M N], sigma2);
H2 = fft2(h2);
H2_shift = fftshift(abs(H2));

figure;
subplot(1,2,1), imshow(h2, []), title('Вікно фільтра (sigma = 15)');
subplot(1,2,2), imshow(log(1 + H2_shift), []), title('АЧХ фільтра (sigma = 15)');

% --- 8. Фільтрація зображення у частотній області ---
% Поелементне множення спектра зображення на ЧХ фільтра
IF1 = F .* H1; % для sigma = 2 (вузьке вікно в просторі = широка АЧХ)
IF2 = F .* H2; % для sigma = 15 (широке вікно в просторі = вузька АЧХ)

% Зворотне перетворення для отримання відфільтрованих зображень
img_filtered_freq1 = abs(ifft2(IF1));
img_filtered_freq2 = abs(ifft2(IF2));

figure;
subplot(1,2,1), imshow(img_filtered_freq1, []), title('Частотна фільтрація (sigma=2)');
subplot(1,2,2), imshow(img_filtered_freq2, []), title('Частотна фільтрація (sigma=15)');

% --- 9. Фільтрація в просторовій області через imfilter ---
img_filtered_spatial = imfilter(double(img), h2, 'conv', 'circular');

figure;
subplot(1,2,1), imshow(img_filtered_freq2, []), title('Фільтрація в частотній області');
subplot(1,2,2), imshow(img_filtered_spatial, []), title('Фільтрація в просторовій області');