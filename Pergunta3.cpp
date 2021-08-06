#include <iostream>
#include <string>

using namespace std;


int FindCommonPrefix(string& s, string& t) {
    int i = 0, j = 0;
    while (i < s.length() && j < t.length()) {
        if (s[i] != t[i]) {
            break;
        }
        i++;
        j++;
    }
    return s.substr(0, i).length();
}

std::string ConcatERemove(std::string s, std::string t, int k) {
    int attempts = 0;
    int commonPrefix = FindCommonPrefix(s, t);

    while (s.length() > commonPrefix) {
        s.pop_back();
        attempts++;
    }

    while (!s._Equal(t)) {
        s += t[commonPrefix];
        attempts++;
        commonPrefix++;
    }

    cout << "Tentativas permitidas: " << k << endl;
    cout << "Tentativas utilizadas: " << attempts << endl;

    return attempts > k ? "nao" : "sim";

}
int main()
{
    int k;
    string s;
    string t;

    cout << "Informe a quantidade de movimentos que deseja: ";
    cin >> k;
    cin.ignore();
    cout << "Informe a string inicial: ";
    getline(cin, s);
    cout << "Informe a string desejada: ";
    getline(cin, t);

    cout << ConcatERemove(s,t,k) << endl;

    return 0;
}