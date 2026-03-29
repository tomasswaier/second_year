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
  creature achilles = {0, 0.50};
  creature turtle = {3, 0.25};
  float ts = turtle.position / (achilles.speed - turtle.speed);
  float xs = achilles.speed * ts;

  FILE *fptr;

  fptr = fopen("race_out.txt", "w");
  fprintf(fptr, "#vA= %f m/s\n", achilles.speed);
  fprintf(fptr, "#vK= %f m/s\n", turtle.speed);
  fprintf(fptr, "#L0= %f m\n", turtle.position);
  fprintf(fptr, "#tS= %f s\n", ts);
  fprintf(fptr, "#xS= %f m\n", xs);
  fprintf(fptr, "# t(s)\txAchiles(m)\txKorytnacka(m)\n");
  for (int i = 0; achilles.position + achilles.speed * time <
                  turtle.position + turtle.speed * time + 15;
       i++) {
    fprintf(fptr, "%f %f %f\n", time, achilles.position + achilles.speed * time,
            turtle.position + turtle.speed * time);
    printf("%f %f %f\n", time, achilles.position + achilles.speed * time,
           turtle.position + turtle.speed * time);
    time += 0.1;
  }
  return 0;
}
