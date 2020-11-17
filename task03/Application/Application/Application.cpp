#include <iostream>
#include <vector>
#include <random>
#include <thread>
#include <mutex>

using namespace std;

long forest[100][100]; //Лес с Винни.
volatile bool check = false; //Найден ли Винни.
int str; //Номер строки для следующего поиска Винни.
int first_ans, second_ans; //Координаты найденного Винни.
int num_of_threads;
mutex mut;

/// <summary>
/// Метод для поиска Винни в одной строке леса.
/// </summary>
/// <param name="line">Номер строки для поиска.</param>
/// <param name="num">Номер роя.</param>
/// <returns>Темную пустоту.</returns>
void* searching_func(void* line, int num) {

    bool complete = false; //Пчелы не закончили поиск в этом секторе.
    while (!check) { //Если Винни уже был найден.
        mut.lock();
        for (int i = 0; i < 100; ++i) {
            if (forest[str][i] == 1) {
                // Если Винни был найден в этом секторе.
                check = true;
                complete = true;
                cout << endl << "Sector: " << str << " Winnie was found here by Hive: " << num << endl;
                second_ans = str;
                first_ans = i;
            }
        }
        if (!complete) { //Если не готовы значит этот отряд пчел не нашел
            cout << "Sector: " << str << " Winnie was not found here        Hive: " << num << " goes home" << endl;
        }
        str++;
        mut.unlock();
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    return 0;
}

int main()
{
    // Сид для рандома.
    srand(time(0));
    int n = 100;

    // Ввод числа роев.
    cout << "Enter number of Hives" << endl;
    cin >> num_of_threads;
    if (num_of_threads > n || num_of_threads < 1)
    {
        cout << "Wrong humber of Hives" << endl;
        exit(0);
    }

    // Заполнение леса.
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            forest[i][j] = 0;
        }
    }
    int x = rand() % (n + 1); //Координата Винни в лесу.
    int y = rand() % (n + 1); //Координата Винни в лесу.
    // Сектор в котором прячется Винни.
    forest[x][y] = 1;
    cout << "Winnie is here :" << x << " " << y << endl;

    chrono::steady_clock::time_point start = chrono::steady_clock::now();
    vector<thread> threads;

    for (int i = 0; i < num_of_threads; i++) {
        threads.push_back(thread(searching_func, (void*)str, i));
    }
    for (size_t i = 0; i < num_of_threads; i++)
    {
        threads[i].join();
    }
    chrono::duration<double> elapsed_seconds = chrono::steady_clock::now() - start;
    cout << "Elapsed time: " << elapsed_seconds.count() << "s\n";
    return 0;
}




