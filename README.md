Project name: Delivery App
Programming language: Dart & framework Flutter)

## how to build & run project
Якщо є можливість протестувати на Android смартфоні, то apk файл для встановлення додатку знаходиться за шляхом:
"food_delivery_app\build\app\outputs\flutter-apk\app-release.apk"
Для того щоб запустити проект на комп'ютері треба встановити Flutter SDK версії не нижче 2.5.2 і VS Code. У VS Code встановити розшрення Flutter, Dart. 
Також треба встановити емулятор Android (наприклад Genymotion). Стягнути проект з репозиторія, відкрити його у VS Code, 
обрати потрібний нам пристрій з емулятора та запустити проект.


## Food Delivery App v 1.0 description
Авторизація відбувається через Email/Password Firebase Authentication.
Для реєстрації треба заповнити поля Email та Password;
Для логінування треба ввести коректні поля Email та Password.
Ввійшовши в систему ви опинитесь на сторінці, яка складається з 3 вкладок:
1) вкладка homeTab (відкривається за замовчування), де побачите список доступної для замовлення їжі, при натисканні на певну позицію відкриється сторінка з деталями,
де можна обрати кількість продукту та додати його в кошик. При додаванні продукту в кошик справа зверху на кнопці буде відображатись значення кількості продуктів в кошику.
Якщо натиснути на цю кнопку то потрапимо на сторінку кошика, де можна видаляти продукти з кошика, а також зробити замовлення (для цього треба ввести адресу) на суму товарів 
в кошику. Після натискання конпки "замовити" видаляться всі товари з кошика та з'явиться відповідний чек (там вказано id, сума та адреса замовлення) замовлення на вкладці 
збережених замовлень.
2) вкладка searchTab, де можна знайти продукти по назві (якщо назва продукту 2 або більше слова, то пошук за першим словом)
3) вкладка savedTab, де зберігаються замовлення які робив користувач
З правої сторони від іконки вкладки savedTab знаходиться іконка-кнопка для виходу з системи. 
