#include <iostream>
#include <vector>
#include <random>
#include <mutex>
#include <omp.h>

using namespace std;

long forest[100][100]; //Forest with Winnie.
volatile bool check = false; //Is Winnie found flag. 
int str; //Next string to search for Winnie.
int first_ans, second_ans; //Winnie coords.
int num_of_threads;

/// <summary>
/// Checking for Winnie in 1 row.
/// </summary>
/// <param name="line">Num of row to search.</param>
/// <param name="num">Number of Hive.</param>
/// <returns>Dark void.</returns>
void* searching_func() {

    bool complete = false; //Hive didnt stop searching for Winnie here.
    while (!check) { //If Winnie is found.
        for (int i = 0; i < 100; ++i) {
            if (forest[str][i] == 1) {
                //If Winnie was found in this row.
                check = true;
                complete = true;
                #pragma omp critical (cout)    
                {
                    cout << endl << "Sector: " << str << " Winnie was found and executed here by Hive: " << omp_get_thread_num() << endl;
                }
                second_ans = str;
                first_ans = i;
            }
        }
        if (!complete) { //If Winnie wasnt found in this row.
            #pragma omp critical (cout)     
            cout << "Sector: " << str << " Winnie was not found here        Hive: " << omp_get_thread_num() << " goes home" << endl;
        }
        #pragma omp critical
        str++;
    }
    return 0;
}

int main()
{
    // Random seed.
    srand(time(0));
    int n = 100;

    // Number of Hives input.
    cout << "Enter number of Hives" << endl;
    cin >> num_of_threads;
    if (num_of_threads > n || num_of_threads < 1)
    {
        cout << "Wrong humber of Hives" << endl;
        exit(0);
    }

    // Filling forest.
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            forest[i][j] = 0;
        }
    }
    //Winnie's coords.
    int x = rand() % (n + 1);
    int y = rand() % (n + 1);

    //Winnie's coords output.
    forest[x][y] = 1;
    cout << "Winnie is here :" << x << " " << y << endl;
    chrono::steady_clock::time_point start = chrono::steady_clock::now();

    omp_set_num_threads(num_of_threads);
    #pragma omp parallel
    {
        //#pragma omp critical
        searching_func();
    }

    chrono::duration<double> elapsed_seconds = chrono::steady_clock::now() - start;
    cout << "Elapsed time: " << elapsed_seconds.count() << "s\n";
    return 0;
}




