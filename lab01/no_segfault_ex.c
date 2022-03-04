#include <stdio.h>
int main() {
    int a[5] = {1, 2, 3, 4, 5};
    unsigned total = 0;
    for (int j = 0; j < sizeof(a); j++) {
        total += a[j];
    }
    printf("last(%dth) element in array should be 5, get: %d", sizeof(a), a[sizeof(a)-1]);
    printf("sum of array is %d\n", total);
}
