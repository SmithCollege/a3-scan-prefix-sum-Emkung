#define SIZE 128

int main() {#define SIZE 128

int main() {#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#define SIZE 128

int main() {
  // allocate memory
  int* input = malloc(sizeof(int) * SIZE);
  int* output = malloc(sizeof(int) * SIZE);

  // initialize inputs
  for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }

  // do the scan
  clock_t a = clock();
  for (int i = 0; i < SIZE; i++) {
   int value = 0;
   for (int j = 0; j <= i; j++) {
     value += input[j];
   }
    output[i] = value;
  }
  clock_t b = clock() - a;

  printf("time: %f ", (float) b/CLOCKS_PER_SEC);

  // check results
  for (int i = 0; i < SIZE; i++) {
    printf("%d ", output[i]);
  }
  printf("\n");

  // free mem
  free(input);
  free(output);

  return 0;
}
