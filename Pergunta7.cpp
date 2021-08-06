#include <string>
#include <iostream>

using namespace std;

int main() {
	int strLen = 0;
	string strEntrada;
	char c;
	
	cout << "Informe a String desejada: ";
	getline(cin, strEntrada);
	
	while (true) {
		c = strEntrada[strLen];

		if (c == '\n' || c == '\0') {
			break;
		}

		strLen++;
	}

	cout << "Tamanho da string: " << strLen << endl;


	return 0;
}