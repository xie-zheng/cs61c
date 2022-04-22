int source[] = {3, 1, 4, 1, 5, 9, 0};
int dest[10];

int fun(int x)
{
    return -x * (x + 1); // result in a0
}

int main()
{
    int k;                           // s0
    int sum = 0;                     // t0
    for (k = 0; source[k] != 0; k++) // s3 = k * 4, shift
    {
        dest[k] = fun(source[k]); // source[k] in t2
        sum += dest[k];           // dest[k] in t2 too
    }
    return sum;
}