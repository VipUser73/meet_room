Колесников Евгений

Тестовое задание Mobile (Flutter)

В приложении используется архитектура BLoC с помощью библиотеки flutter_bloc 8.0.1.

После запуска приложения, открывается страница авторизации (список пользователей сохранём локально).
"Test1": "12345",
"Test2": "abcde",
"Test3": "123abcd"
На основной странице приложения (HomePage) выводится месячный календарь, можно добавить событие нажав на кнопку снизу(+), если не выбрана комната, выводятся события во всех комнатах. При добавлении события так же можно убрать участников из списка свайпом влево. Под числами календаря точками выводятся добавленные события(...). При длительном нажатии на число в календаре всплывает почасовая шкала представления выбранного дня с входящими в этот день событиями(если события в этот день имеются). При нажатии на событие, осуществляется переход на страницу детального просмотра события с возможностью удаления этого события.
Переключения комнат осуществляется нажатием на название комнаты в верхнем меню приложения, удалить комнату можно свайпом влево, при этом удаляются все события в этой комнате за всё время.

Приложение тестировалось на эмуляторе Pixel 3 XL.
