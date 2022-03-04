#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (!head) {
        return 0;
    }

    struct node *tortoise = head;
    struct node *hare     = head->next;
    while (tortoise != hare) {
        if (!hare) {
            return 0;
        }

        hare = hare->next;
  
        if (!hare) {
            return 0;
        }
  
        hare = hare->next;
        tortoise = tortoise->next;
    }

    return 1;
}
