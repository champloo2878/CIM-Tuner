#ifndef TENSOR_STACK_H
#define TENSOR_STACK_H

#include <stddef.h> // For size_t

// 定义TensorStack结构体
typedef struct {
    int* stack;  // 假设栈中存储的都是整数
    size_t element_width;  // 元素的宽度，这里用于演示，实际上并未使用
    size_t max_size;  // 记录栈拥有过的最多元素数量
    size_t size;  // 当前栈的大小
} TensorStack;

void InitTensorStack(TensorStack* ts, size_t element_width);
void PushTensorStack(TensorStack* ts, int new_element);
int PopTensorStack(TensorStack* ts);
int Is_emptyTensorStack(const TensorStack* ts);
size_t SizeTensorStack(const TensorStack* ts);
size_t MaxSizeReachedTensorStack(const TensorStack* ts);

#endif // TENSOR_STACK_H
