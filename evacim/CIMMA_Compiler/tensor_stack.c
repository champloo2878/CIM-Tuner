#include "tensor_stack.h"
#include <stdlib.h> // For malloc, realloc, free

void InitTensorStack(TensorStack* ts, size_t element_width) {
    ts->stack = NULL;
    ts->element_width = element_width;
    ts->max_size = 0;
    ts->size = 0;
}

void PushTensorStack(TensorStack* ts, int new_element) {
    int* temp = realloc(ts->stack, (ts->size + 1) * sizeof(int));
    if (temp != NULL) {
        ts->stack = temp;
        ts->stack[ts->size] = new_element;
        ts->size++;
        if (ts->size > ts->max_size) {
            ts->max_size = ts->size;
        }
    }
    // 如果realloc失败，这里不处理错误。在实际应用中，应该添加错误处理。
}

int PopTensorStack(TensorStack* ts) {
    if (Is_emptyTensorStack(ts)) {
        return -1; // 如果栈为空，则返回-1，代表错误
    }
    int popped_element = ts->stack[ts->size - 1];
    ts->size--;
    // 不缩小栈的空间，因为可能很快会再次push。在实际应用中，可以考虑在某些条件下缩小栈的空间。
    return popped_element;
}

int Is_emptyTensorStack(const TensorStack* ts) {
    return ts->size == 0;
}

size_t SizeTensorStack(const TensorStack* ts) {
    return ts->size;
}

size_t MaxSizeReachedTensorStack(const TensorStack* ts) {
    return ts->max_size;
}
