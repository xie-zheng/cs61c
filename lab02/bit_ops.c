#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n)
{
    return (x & (1 << n)) >> n;
}

// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned *x,
             unsigned n,
             unsigned v)
{
    unsigned bit = get_bit(*x, n);
    if (bit == v)
    {
        return;
    }
    flip_bit(x, n);
}

// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned *x,
              unsigned n)
{
    unsigned bit = get_bit(*x, n);
    if (bit == 0)
    {
        *x = *x | (1 << n);
    }
    else
    {
        *x = *x ^ (1 << n);
    }
}
