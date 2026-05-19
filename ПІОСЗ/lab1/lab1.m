% --- 1. Завантаження та відображення зображень з бібліотеки MATLAB ---
img1 = imread('cameraman.png'); % Півтонове зображення
img2 = imread('peppers.jpg');   % Кольорове зображення
imshow(img1);
title('Зображення з бібліотеки: cameraman.tif');
figure, imshow(img2);
title('Зображення з бібліотеки: peppers.png');

% --- 2. Завантаження зображення з довільного каталогу ---
img_custom = imread('products.jpeg'); 
figure, imshow(img_custom);
title('Моє власне зображення');

% --- 3. Інформація про завантажені зображення ---
% Команда whos виведе в командне вікно розмір, тип та об'єм пам'яті масивів
disp('Інформація про зображення:');
whos img1 img2 img_custom

% --- 4. Збереження зображень у заданий каталог ---
imwrite(img1, 'saved_cameraman.jpg', 'jpg');

% --- 5. Гістограми розподілу яскравостей ---
figure, imhist(img1);
title('Гістограма вихідного зображення (cameraman)');

% --- 6. Контрастування кольорового зображення (RGB) ---
img_low_contrast = imread('pout.jpg'); 

% stretchlim знаходить оптимальні межі для кожного каналу
img_contrasted = imadjust(img_low_contrast, stretchlim(img_low_contrast), []);

% Перевіряємо результат
figure;
subplot(1,2,1), imshow(img_low_contrast), title('Оригінал RGB');
subplot(1,2,2), imshow(img_contrasted), title('Контрастоване RGB');

% --- 7. Відображення зображення з підвищеною контрастністю ---
figure;
subplot(1,2,1), imshow(img_low_contrast), title('Низький контраст');
subplot(1,2,2), imshow(img_contrasted), title('Підвищений контраст');

% Відображення зміни гістограми після контрастування
figure;
subplot(1,2,1), imhist(img_low_contrast), title('Гістограма (до)');
subplot(1,2,2), imhist(img_contrasted), title('Гістограма (після)');

% --- 8. Отримання та відображення негативу зображення ---
% Інвертуємо вхідні значення [0 1] у вихідні [1 0]
img_negative = imadjust(img1, [0 1], [1 0]);
figure, imshow(img_negative);
title('Негатив зображення');