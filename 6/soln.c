#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int time;
  int dist;
} race_t;

int calc_opt(long int time, long int dist) {
  double d = pow(time, 2) - 4 * dist;
  double d_sqrt = sqrt(d);

  double root_1 = (time - d_sqrt) / 2;
  double root_2 = (time + d_sqrt) / 2;

  return ceil(root_2) - floor(root_1) - 1;
}

int size_of_number(long int number) {
  int i = 1;
  while (number >= 10) {
    number /= 10;
    i++;
  }
  return i;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Usage: %s <filename>", argv[0]);
    return EXIT_FAILURE;
  }

  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Couldn't open file");
    return EXIT_FAILURE;
  }

  size_t size = 128;
  char *line = malloc(size);
  // int **numbers = malloc(sizeof(int *));
  long int *numbers = malloc(sizeof(int *));
  int line_pos = 0;
  int num_pos = 0;

  while (getline(&line, &size, fp) != EOF) {
    int i = 0;
    num_pos = 0;
    long int line_num =0;

    // numbers[line_pos] = malloc(sizeof(int *));
    while (line[i] != '\n' && line[i] != '\0') {
      if (line[i] >= '0' && line[i] <= '9') {
        long int number = 0;
        sscanf(line + i, "%ld", &number);
        i += size_of_number(number);
        // numbers[line_pos][num_pos++] = number;
        line_num *= powl(10, size_of_number(number)); 
        line_num += number;
      } else {
        i++;
      }
    }
    // line_pos++;
    numbers[line_pos++] = line_num;
  }

  /* int total = 1;

  int time, dist;
  for (int i = 0; i < num_pos; i++) {
    time = numbers[0][i];
    dist = numbers[1][i];
    printf("Calculating time=%d dist=%d opt=%d\n", time, dist,
           calc_opt(time, dist));
    total *= calc_opt(time, dist);
  }

  printf("Solution: %d", total); */

  long int time = numbers[0];
  long int dist = numbers[1];

  long int total = calc_opt(time, dist);

  printf("Solution: %ld", total);

  fclose(fp);
  free(line);
  free(numbers);
  return EXIT_SUCCESS;
}
