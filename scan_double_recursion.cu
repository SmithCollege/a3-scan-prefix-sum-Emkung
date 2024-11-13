#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>

#define SIZE 3000
#define BLOCK_SIZE 1024
__global__ void double_recursion_scan(int *in, int *out) {
  int cur_index = blockIdx.x * blockDim.x + threadIdx.x;  // allocate memory
  for (int stride = 1; stride/2 <= SIZE; stride *= 2  ){
      __syncthreads();
      if (cur_index < stride){
      	 out[cur_index] = in[cur_index];
      }else{
         out[cur_index] = in[cur_index] + in[cur_index - stride];
         int* temp = out;
         out = in;
	 in = temp;
       }
   }
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

   int block_num;
   if (SIZE % BLOCK_SIZE != 0){
       block_num = SIZE/BLOCK_SIZE + 1;
   }
   clock_t a = clock();
   double_recursion_scan<<<block_num, BLOCK_SIZE>>>(input, output);
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