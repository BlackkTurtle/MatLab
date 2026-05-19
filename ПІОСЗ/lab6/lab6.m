% --- 1 & 2. Завантаження та підготовка зображення ---
img_raw = imread('cameraman.png');

if size(img_raw, 3) == 3
    img = rgb2gray(img_raw);
else
    img = img_raw;
end

% Переведення у формат double (значення від 0 до 1) для ДКП обчислень
I = im2double(img);

figure; imshow(I);
title('1. Вихідне півтонове зображення');

% --- 3. Поблочне ДКП (розмір блоку 8х8) ---
T = dctmtx(8); % Базова матриця ДКП 8х8
dct_func = @(block_struct) T * block_struct.data * T';
B = blockproc(I, [8 8], dct_func);

% --- 4. Відображення поблочного спектра ---
figure; imshow(log(1 + abs(B)), []);
title('2. Поблочний ДКП-спектр усього зображення');

% --- 5. Відновлення зображення за ДКП-спектром без втрат ---
invdct_func = @(block_struct) T' * block_struct.data * T;
I_perfect = blockproc(B, [8 8], invdct_func);

figure; imshow(I_perfect);
title('3. Ідеально відновлене зображення (без втрат)');

% --- 6. Однорідне квантування (з рівномірним кроком, наприклад q = 0.1) ---
q = 0.1; 
B_uniform_quant = q * round(B / q);
I_uniform = blockproc(B_uniform_quant, [8 8], invdct_func);

% --- 7. Матричне (JPEG) квантування з використанням реальної матриці ---
% Стандартна матриця яскравості JPEG (відповідно до методики)
Q_matrix = [16 11 10 16 24  40  51  61;
    12 12 14 19 26  58  60  55;
    14 13 16 24 40  57  69  56;
    14 17 22 29 51  87  80  62;
    18 22 37 56 68  109 103 77;
    24 35 55 64 81  104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

% Нормалізуємо матрицю квантування, оскільки дані типу double лежать в [0, 1],
% а оригінальна матриця JPEG розрахована на діапазон яскравості [0, 255].
% Коефіцієнт якості Quality_Factor регулює ступінь стиснення
Quality_Factor = 1.0; 
Q_normalized = (Q_matrix / 255) * Quality_Factor;

% Функція для поблочного квантування (ділення на матрицю Q)
quant_func = @(block_struct) Q_normalized .* round(block_struct.data ./ Q_normalized);
B_jpeg_quant = blockproc(B, [8 8], quant_func);

% --- 8. Відновлення зображення після JPEG-квантування ---
I_jpeg = blockproc(B_jpeg_quant, [8 8], invdct_func);

% Порівняльне відображення спектрів після квантування
figure;
subplot(1,2,1), imshow(log(1 + abs(B_uniform_quant)), []), title('Однорідний квантований спектр');
subplot(1,2,2), imshow(log(1 + abs(B_jpeg_quant)), []), title('JPEG-квантований спектр');

% Порівняльне відображення результатів відновлення
figure;
subplot(1,2,1), imshow(I_uniform), title('Відновлено після однорідного квантування');
subplot(1,2,2), imshow(I_jpeg), title('Відновлено після JPEG-квантування');