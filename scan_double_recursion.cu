#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define SIZE 128
#define BLOCK_SIZE 128
__global__ void prefix_sum(int *in, int *out) {
  int cur_index = blockIdx.x * blockDim.x + threadIdx.x;  // allocate memory
  int res = 0;
  __syncthreads();
  for (int i = 0; i <= cur_index; i++){
      res += in[i];
  }
  out[cur_index] = res;
}

int main() {
   // allocate memory
   int *input, *output;
   cudaMallocManaged(&input, sizeof(int) * SIZE);
   cudaMallocManaged(&output, sizeof(int) * SIZE);

   // initialize inputs
   for (int i = 0; i < SIZE; i++) {
       input[i] = 1;
   }

   clock_t a = clock();
   prefix_sum<<<SIZE/BLOCK_SIZE, BLOCK_SIZE>>>(input, output);
   cudaDeviceSynchronize();
   clock_t b = clock() - a;
   printf("time: %f ", (float) b/CLOCKS_PER_SEC);
   for (int i = 0; i < SIZE; i++) {
       printf("%d ", output[i]);
   }
   printf("\n");

   printf("%s\n", cudaGetErrorString(cudaGetLastError()));
   cudaFree(input);
   cudaFree(output);
   return 0;
}