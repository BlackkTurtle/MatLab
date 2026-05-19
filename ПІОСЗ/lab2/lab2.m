% Очищення робочого простору
clear, close all

% 1. Завантаження зображень
img1_raw = imread('cameraman.png');
img2_raw = imread('peppers.jpg');

% Автоматична конвертація в градації сірого (якщо зображення кольорові)
if size(img1_raw, 3) == 3
    img1 = rgb2gray(img1_raw);
else
    img1 = img1_raw;
end

if size(img2_raw, 3) == 3
    img2 = rgb2gray(img2_raw);
else
    img2 = img2_raw;
end

% --- 2. Відображення вихідних (вже сірих) зображень ---
figure;
subplot(1,2,1), imshow(img1), title('Оригінал 1 (Півтоновий)');
subplot(1,2,2), imshow(img2), title('Оригінал 2 (Півтоновий)');

% --- 3 & 4. Зашумлення зображень (Гаусівський та Імпульсний шуми) ---
% Додаємо гаусівський (білий) шум із дисперсією 0.01
img_noise_gauss = imnoise(img1, 'gaussian', 0, 0.01); 

% Додаємо імпульсний шум ("сіль і перець") із щільністю 0.05
img_noise_sp = imnoise(img2, 'salt & pepper', 0.05);

figure;
subplot(1,2,1), imshow(img_noise_gauss), title('Гаусівський шум');
subplot(1,2,2), imshow(img_noise_sp), title('Шум "Сіль і перець"');

% --- 5, 6 & 7. Лінійна фільтрація (ФНЧ і ФВЧ) ---
% Створюємо маски фільтрів
h_low = ones(3,3) / 9; % Низькочастотний фільтр (усереднення)
h_high = [-1 -1 -1; -1 9 -1; -1 -1 -1]; % Високочастотний фільтр (підкреслення різкості)

% Фільтруємо зашумлені та чисті зображення
img_lf_gauss = imfilter(img_noise_gauss, h_low); % ФНЧ для Гаусівського шуму
img_lf_sp = imfilter(img_noise_sp, h_low);       % ФНЧ для Імпульсного шуму
img_hf_orig = imfilter(img1, h_high);            % ФВЧ для оригінального зображення

figure;
subplot(1,3,1), imshow(img_lf_gauss), title('ФНЧ: Гаусівський шум');
subplot(1,3,2), imshow(img_lf_sp), title('ФНЧ: Імпульсний шум');
subplot(1,3,3), imshow(img_hf_orig), title('ФВЧ: Оригінал (різкість)');

% --- 8. Адаптивна вінерівська фільтрація ---
% Застосовуємо вінерівську фільтрацію вікном 5х5 до гаусівського шуму
img_wien_gauss = wiener2(img_noise_gauss, [5 5]);

figure;
subplot(1,2,1), imshow(img_noise_gauss), title('До: Гаусівський шум');
subplot(1,2,2), imshow(img_wien_gauss), title('Після: Вінерівський фільтр');

% --- 9. Медіанна фільтрація (Нелінійна) ---
% Застосовуємо медіанний фільтр до обох типів шумів
img_med_sp = medfilt2(img_noise_sp);
img_med_gauss = medfilt2(img_noise_gauss);

figure;
subplot(1,2,1), imshow(img_med_sp), title('Медіанний: "Сіль і перець"');
subplot(1,2,2), imshow(img_med_gauss), title('Медіанний: Гаусівський шум');