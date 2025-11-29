#include <stdio.h>
#include <stdarg.h>

int add(int a, int b) {
  return a + b;
}

int multiply(int a, int b) {
  return a * b;
}

int negate(int a) {
  return a * -1;
}

int var_add(int count, ...) {
  va_list args;
  int sum = 0;
  va_start(args, count);
  for (int i = 0; i < count; i++) {
    sum += va_arg(args, int);
  }
  va_end(args);
  return sum;
}