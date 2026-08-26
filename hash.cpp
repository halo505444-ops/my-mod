#include <stdio.h>
#include <stdlib.h>

// `M × N × O` matrix
#define M 2
#define N 3
#define O 4

// Dynamically allocate memory for 3D Array
int hash()
{
	int*** A = (int***)malloc(M * sizeof(int**));

	if (A == NULL)
	{
		fprintf(stderr, "Out of memory");
		exit(0);
	}

	for (int i = 0; i < M; i++)
	{
		A[i] = (int**)malloc(N * sizeof(int*));

		if (A[i] == NULL)
		{
			fprintf(stderr, "Out of memory");
			exit(0);
		}

		for (int j = 0; j < N; j++)
		{
			A[i][j] = (int*)malloc(O * sizeof(int));
			if (A[i][j] == NULL)
			{
				fprintf(stderr, "Out of memory");
				exit(0);
			}
		}
	}

	// assign values to the allocated memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				A[i][j][k] = rand() % 100;
			}
		}
	}

	// print the 3D array
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				printf("%d ", A[i][j][k]);
			}
			printf("\n");
		}
		printf("\n");
	}

	// deallocate memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++) {
			free(A[i][j]);
		}
		free(A[i]);
	}
	free(A);

	return 0;
}