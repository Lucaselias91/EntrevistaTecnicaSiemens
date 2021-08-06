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

void unitTestConcatERemove(string s, string t, int k, string expectedResult) {
    string result;
    string passed;

    cout << "------------------------" << endl;
    cout << "Testando ConcatERemove(" << s << "," << t << "," << k << ")" << endl;
    cout << "Resultado esperado: " << expectedResult << endl;
    result = ConcatERemove(s, t, k);
    cout << "Resultado obtido: " << result << endl;
    passed = result == expectedResult ? "Passed" : "Not Passed";
    cout << "Passed: " << passed << endl << endl;
}

int main() {
    
    unitTestConcatERemove("blablablabla", "blablabcde", 8, "sim");
    unitTestConcatERemove("aba", "aba", 7, "sim");
    unitTestConcatERemove("ashley", "ash", 2, "nao");

    return 0;
}