#include <stdio.h>
#include <stdlib.h>

// `M × N × O` matrix
#define M 2
#define N 3
#define O 4

// Dynamically allocate memory for 3D Array
int I7AMOD()
{
	// dynamically allocate memory of size `M × N × O`
	int* A = (int*)malloc(M * N * O * sizeof(int));

	if (A == NULL)
	{
		fprintf(stderr, "Out of memory");
		exit(0);
	}

	// assign values to the allocated memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				*(A + i*N*O + j*O + k) = rand() % 100;
			}
		}
	}

	// print the 3D array
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				printf("%d ", *(A + i*N*O + j*O + k));
			}

			printf("\n");
		}
		printf("\n");
	}

	// deallocate memory
	free(A);

	return 0;
}