% 1. Завантаження зображення
img_raw = imread('cameraman.png');

% Автоматичне перетворення в градації сірого (захист від помилок RGB)
if size(img_raw, 3) == 3
    img = rgb2gray(img_raw);
else
    img = img_raw;
end

% 2. Відображення вихідного зображення
figure;
imshow(img);
title('1. Вихідне зображення');

% 3 & 4. Перекручення зображення (змазання внаслідок руху)
LEN = 30;     % Величина зсуву в пікселях (можна змінювати)
THETA = 15;   % Кут руху в градусах (можна змінювати)
PSF = fspecial('motion', LEN, THETA); % Створення функції розсіювання точки (PSF)
blurred = imfilter(img, PSF, 'conv', 'circular'); % Моделювання змазання

figure;
imshow(blurred);
title('2. Змазане зображення (без шуму)');

% 5 & 6. Відновлення зображення за відсутності шуму
% Третій параметр (NSR) дорівнює 0, що реалізує ідеальний інверсний фільтр
restored_clean = deconvwnr(blurred, PSF, 0);

figure;
imshow(restored_clean);
title('3. Відновлене зображення (без шуму)');

% 7. Моделювання перекручення разом із зашумленням
noise_var = 0.002; % Дисперсія гаусівського шуму
blurred_noisy = imnoise(blurred, 'gaussian', 0, noise_var);

figure;
imshow(blurred_noisy);
title('4. Змазане + зашумлене зображення');

% Спроба відновлення зашумленого зображення БЕЗ врахування шуму (NSR = 0)
% Побачимо ефект посилення шуму зворотним фільтром
restored_noisy_naive = deconvwnr(blurred_noisy, PSF, 0);

figure;
imshow(restored_noisy_naive);
title('5. Невдале відновлення з NSR=0 (інверсний фільтр)');

% Правильне відновлення зашумленого зображення за допомогою фільтра Вінера
% Обчислюємо приблизне відношення шум/сигнал (NSR)
img_double = im2double(img);
nsr = noise_var / var(img_double(:)); 
restored_noisy_wiener = deconvwnr(blurred_noisy, PSF, nsr);

figure;
imshow(restored_noisy_wiener);
title('6. Правильне відновлення з NSR (Вінерівський фільтр)');