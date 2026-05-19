% --- 1 & 2. Завантаження та перетворення в градації сірого ---
img_raw = imread('cameraman.png');

if size(img_raw, 3) == 3
    img = rgb2gray(img_raw);
else
    img = img_raw;
end

figure; imshow(img); 
title('1. Вихідне півтонове зображення');

% --- 3. Двовимірне дискретне косинусне перетворення (ДКП) ---
J = dct2(double(img));

figure; imshow(log(1 + abs(J)), []); colorbar;
title('2. Повний ДКП-спектр (логарифмічний масштаб)');

% --- 4. Ідеальне відновлення зображення без втрат ---
img_perfect = idct2(J);
figure; imshow(uint8(img_perfect)); 
title('3. Відновлене зображення (без втрат)');

% --- 5 & 6. Квантування ДКП-коефіцієнтів з різними кроками N ---
% Виконаємо квантування для помірного (N=15) та сильного (N=60) стиснення
N1 = 15; 
J_quant1 = round(J / N1) * N1; 
img_restored1 = idct2(J_quant1);

N2 = 60; 
J_quant2 = round(J / N2) * N2; 
img_restored2 = idct2(J_quant2);

% Відображення квантованих спектрів
figure;
subplot(1,2,1), imshow(log(1 + abs(J_quant1)), []), title(['Спектр ДКП (Крок N=' num2str(N1) ')']);
subplot(1,2,2), imshow(log(1 + abs(J_quant2)), []), title(['Спектр ДКП (Крок N=' num2str(N2) ')']);

% --- 7. Відображення відновлених зображень після стиснення ---
figure;
subplot(1,2,1), imshow(img_restored1, [0 255]), title(['Стиснення ДКП (Крок N=' num2str(N1) ')']);
subplot(1,2,2), imshow(img_restored2, [0 255]), title(['Стиснення ДКП (Крок N=' num2str(N2) ')']);
% --- 9. Порівняльне квантування у просторовій області ---
n_spatial = 30; % Крок квантування яскравості
img_spatial_quant = round(double(img) / n_spatial) * n_spatial;

figure;
imshow(img_spatial_quant, [0 255]);
title(['Квантування у просторовій області (n=' num2str(n_spatial) ')']);