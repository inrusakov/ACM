#include <iostream>
#include <vector>
#include <random>
#include <thread>
#include <mutex>

using namespace std;

long forest[100][100]; //��� � �����.
volatile bool check = false; //������ �� �����.
int str; //����� ������ ��� ���������� ������ �����.
int first_ans, second_ans; //���������� ���������� �����.
int num_of_threads;
mutex mut;

/// <summary>
/// ����� ��� ������ ����� � ����� ������ ����.
/// </summary>
/// <param name="line">����� ������ ��� ������.</param>
/// <param name="num">����� ���.</param>
/// <returns>������ �������.</returns>
void* searching_func(void* line, int num) {

    bool complete = false; //����� �� ��������� ����� � ���� �������.
    while (!check) { //���� ����� ��� ��� ������.
        mut.lock();
        for (int i = 0; i < 100; ++i) {
            if (forest[str][i] == 1) {
                // ���� ����� ��� ������ � ���� �������.
                check = true;
                complete = true;
                cout << endl << "Sector: " << str << " Winnie was found here by Hive: " << num << endl;
                second_ans = str;
                first_ans = i;
            }
        }
        if (!complete) { //���� �� ������ ������ ���� ����� ���� �� �����
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
    // ��� ��� �������.
    srand(time(0));
    int n = 100;

    // ���� ����� ����.
    cout << "Enter number of Hives" << endl;
    cin >> num_of_threads;
    if (num_of_threads > n || num_of_threads < 1)
    {
        cout << "Wrong humber of Hives" << endl;
        exit(0);
    }

    // ���������� ����.
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            forest[i][j] = 0;
        }
    }
    int x = rand() % (n + 1); //���������� ����� � ����.
    int y = rand() % (n + 1); //���������� ����� � ����.
    // ������ � ������� �������� �����.
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




