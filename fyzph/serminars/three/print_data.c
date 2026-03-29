#include "GL/freeglut_std.h"
#include "GL/glu.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>
#include <stdio.h>
#include <unistd.h>

typedef struct {
  float position;
  float speed;
} creature;

int main(int argc, char **argv) {
  float time = 0;
  creature achilles = {0, 20};
  creature turtle = {100, 15};
  FILE *fptr;
  float ap, tp = 1;
  fptr = fopen("data.txt", "w");
  for (int i = 0; i < 100; i++) {
    float ap = achilles.position + achilles.speed * time;
    float tp = turtle.position - turtle.speed * time - time * time;
    fprintf(fptr, "%f %f %f\n", time, ap, tp);
    printf("%f %f %f\n", time, ap, tp);
    time += 0.1;
  }
  return 0;
}
