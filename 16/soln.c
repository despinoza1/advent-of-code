#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 110
#define STACKSIZE 80

typedef struct {
  int x, y;
} coord_t;

bool is_inside(coord_t pos) {
  return pos.x >= 0 && pos.y >= 0 && pos.x < SIZE && pos.y < SIZE;
}

typedef struct {
  coord_t pos;
  char dir;
} beam_t;

int dir_enum(char dir) {
  switch (dir) {
  case 'N':
    return 0;
  case 'E':
    return 1;
  case 'S':
    return 2;
  case 'W':
    return 3;
  }

  return -1;
}

coord_t next_pos(beam_t beam) {
  switch (beam.dir) {
  case 'N':
    return (coord_t){beam.pos.x, beam.pos.y - 1};
  case 'E':
    return (coord_t){beam.pos.x + 1, beam.pos.y};
  case 'S':
    return (coord_t){beam.pos.x, beam.pos.y + 1};
  case 'W':
    return (coord_t){beam.pos.x - 1, beam.pos.y};
  }
  return beam.pos;
}

bool is_marked(beam_t beam, bool energized[SIZE][SIZE][4]) {
  return energized[beam.pos.y][beam.pos.x][dir_enum(beam.dir)];
}

void mark(beam_t beam, bool energized[SIZE][SIZE][4]) {
  energized[beam.pos.y][beam.pos.x][dir_enum(beam.dir)] = true;
}

typedef struct {
  beam_t stack[STACKSIZE];
  int index;
} stack_t;

bool push(stack_t *stack, beam_t beam, bool energized[SIZE][SIZE][4]) {
  if (is_marked(beam, energized))
    return false;

  mark(beam, energized);
  if (stack->index == STACKSIZE) {
    return false;
  }

  stack->stack[stack->index++] = beam;
  return true;
}

bool pop(stack_t *stack, beam_t *beam) {
  if (!stack->index)
    return false;

  *beam = stack->stack[--stack->index];
  return true;
}

int energize(stack_t *stack, char mirror[SIZE][SIZE + 2],
             bool energized[SIZE][SIZE][4]) {
  beam_t beam = (beam_t){{-1, 0}, 'E'};
  for (int i = 0; i < SIZE; ++i) {
    for (int j = 0; j < SIZE; ++j) {
      for (int k = 0; k < 4; ++k) {
        energized[i][j][k] = false;
      }
    }
  }

  stack->index = 0;
  stack->stack[stack->index++] = beam;
  while (pop(stack, &beam)) {
    coord_t next = next_pos(beam);

    if (is_inside(next)) {
      switch (beam.dir << 8 | mirror[next.y][next.x]) {
      case 'N.':
      case 'N|':
      case 'E.':
      case 'E-':
      case 'S.':
      case 'S|':
      case 'W.':
      case 'W-':
        push(stack, (beam_t){next, beam.dir}, energized);
        break;
      case 'N/':
      case 'S\\':
        push(stack, (beam_t){next, 'E'}, energized);
        break;
      case 'E/':
      case 'W\\':
        push(stack, (beam_t){next, 'N'}, energized);
        break;
      case 'S/':
      case 'N\\':
        push(stack, (beam_t){next, 'W'}, energized);
        break;
      case 'W/':
      case 'E\\':
        push(stack, (beam_t){next, 'S'}, energized);
        break;
      case 'N-':
      case 'S-':
        push(stack, (beam_t){next, 'E'}, energized);
        push(stack, (beam_t){next, 'W'}, energized);
        break;
      case 'E|':
      case 'W|':
        push(stack, (beam_t){next, 'N'}, energized);
        push(stack, (beam_t){next, 'S'}, energized);
        break;
      }
    }
  }

  int total = 0;
  for (int i = 0; i < SIZE; ++i) {
    for (int j = 0; j < SIZE; ++j) {
      total += (*(int *)energized[i][j] != 0);
    }
  }

  return total;
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

  char mirror[SIZE][SIZE + 2];
  bool energized[SIZE][SIZE][4];

  for (int i = 0; i < SIZE; ++i) {
    fgets(mirror[i], sizeof(*mirror), fp);
  }
  fclose(fp);

  stack_t stack = {};
  int total = energize(&stack, mirror, energized);

  printf("Solution: %d", total);
  return EXIT_SUCCESS;
}
