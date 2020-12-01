# ACM
Architecture of computing systems
Русаков Иван БПИ194

Task 03

Вариант 22.

1.	Текст задания.
Первая задача о Винни-Пухе, или неправильные пчелы.
Неправильные пчелы, подсчитав в конце месяца убытки от наличия в лесу
Винни-Пуха, решили разыскать его и наказать в назидание всем другим
любителям сладкого. Для поисков медведя они поделили лес на участки,
каждый из которых прочесывает одна стая неправильных пчел. В случае
нахождения медведя на своем участке стая проводит показательное
наказание и возвращается в улей. Если участок прочесан, а Винни-Пух на нем не обнаружен, стая также возвращается в улей. Требуется создать многопоточное приложение, моделирующее действия пчел. При решении использовать парадигму портфеля задач.

2.	Парадигма.
Взаимодействующие равные – модель, в которой исключен не занимающийся непосредственными вычислениями управляющий поток. Распределение работ в таком приложении либо фиксировано заранее, либо динамически определяется во время выполнения. Одним из распространенных способов динамического распределения работ является «портфель задач». Портфель задач, как правило, реализуется с помощью разделяемой переменной, доступ к которой в один момент времени имеет только один процесс.


3.	Алгоритм.
Пользователь через консоль вводит количество роев пчел. Инициализируется нужное количество потоков и для каждого потока запускается метод поиска пчел в лесу. В самом методе отдельный поток занимает свою строку матрицы леса. После неуспешного поиска рой пчел возвращается домой и начинает поиск в следующей не занятой строке матрицы. 

4.	Источники.

https://pro-prof.com/archives/4335 - Учебник по OpenMP

http://www.softcraft.ru/edu/comparch/tasks/t04/ - Изучить применение OpenMP для разработки многопоточных приложений. 

5.	Приложения.

Текст программы находится в ACM/task04/Application/Application/Application.cpp 

Скриншоты с тестами находятся в ACM/task04/Test/

Скриншоты частей программы находятся ACM/task04/Docs/ 

Отчет находится в ACM/task04/Docs/
