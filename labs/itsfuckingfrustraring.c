#include "stdio.h"

int main(int argc, char** argv){
    long double a = 0.1;
    long double b = 0.2;
    printf("%.17Lf", a + b);
}