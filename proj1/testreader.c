#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint8_t applyrule(uint8_t old, int neighbor, uint32_t rule)
{
    uint8_t res = 0;
    for (int i = 0; i < 8; i++)
    {
        int least = old % 2;
        int near = neighbor % 10;
        uint8_t bit;
        if (least)
        {
            // live
            bit = (rule >> (9 + near)) % 2;
        }
        else
        {
            bit = (rule >> near) % 2;
        }
        old = old >> 1;
        neighbor = neighbor / 10;
        res = res + (bit << i);
    }

    return res;
}

int main(void)
{
    uint8_t src, res, dst;
    uint32_t rule = 0x1808;
    src = 0b00000000;
    dst = 0b00000100;
    int near = 76543210;
    res = applyrule(src, near, rule);
    printf("expect %u, get %u", dst, res);
    return 0;
}
