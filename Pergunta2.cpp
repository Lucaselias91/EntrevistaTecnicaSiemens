#include <iostream>


int main()
{
    for (int i = 1; i <= 100; i++) {
        
        if (i % 3 == 0 && i % 5 == 0) {
            std::cout << "FooBaa" << std::endl;
        }
        else if (i % 3 == 0) {
            std::cout << "Foo" << std::endl;
        }
        else if (i % 5 == 0) {
            std::cout << "Baa" << std::endl;
        }
        else {
            std::cout << i << std::endl;
        }
    }

    return 0;
}