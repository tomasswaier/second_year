#include "GL/freeglut_std.h"
#include "GL/glu.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct {
  float x;
  float y0;
  float v0y;
  float lead;
  float edgeSize;
  void (*drawFunction)(float, float, float);
} Shapes;

float currentTime = 0.0;
float ymax = 0.0;
const float g = 9.80665;
const float dt = 0.01;
const int iTimeStep = 25;

FILE *fptr;
float a = 0;

void resizeHandler(int width, int height) {

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  float screenHeight = ymax + a + 0.5 * a;
  float screenWidth = screenHeight / ((float)height / (float)width);

  if (screenWidth < 3 * a)
    screenWidth = 3 * a;

  glViewport(0, 0, width, height);
  gluOrtho2D(-0.5 * screenWidth, 0.5 * screenWidth, 0, screenHeight);

  glMatrixMode(GL_MODELVIEW);
}

void drawSquare(float x, float y, float a) {

  glVertex2d(a / 2, a);
  glVertex2d(a / 2, 0);
  glVertex2d(-a / 2, 0);
  glVertex2d(-a / 2, a);
}

Shapes myShapes[1] = {{0.0f, 0.0f, 0.0f, 0, 0, drawSquare}};

void update(const int iTime) {

  currentTime += (float)iTimeStep / 1000;

  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}

void displayShapes() {

  glClearColor(0.8, 0.8, 0.8, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);

  glLoadIdentity();
  glColor3f(0.5, 0.5, 0.1);

  /*
     ysur(t) = y0 + v0y * t - 0.5 * g * t^2
     vy(t)   = v0y - g * t
  */

  float ysur = myShapes[0].y0 + myShapes[0].v0y * currentTime -
               0.5 * g * currentTime * currentTime;

  if (ysur < 0)
    ysur = 0;

  float vy = myShapes[0].v0y - g * currentTime;

  fprintf(fptr, "%f\t%f\t%f\n", currentTime, ysur, vy);
  fflush(fptr);

  glTranslatef(0.0, ysur, 0.0);

  glBegin(GL_POLYGON);
  myShapes[0].drawFunction(myShapes[0].x, 0, myShapes[0].edgeSize);
  glEnd();

  glutSwapBuffers();
}

int main(int argc, char **argv) {

  if (argc != 4) {
    printf("argc!=4\n");
    exit(0);
  }

  myShapes[0].y0 = atof(argv[1]);           // y0
  myShapes[0].v0y = atof(argv[2]);          // v0y
  a = myShapes[0].edgeSize = atof(argv[3]); // a

  if (myShapes[0].y0 < 0 || a <= 0) {
    printf("y0 must be >=0 and a must be >0\n");
    exit(0);
  }

  if (myShapes[0].v0y > 0)
    ymax = myShapes[0].y0 + (myShapes[0].v0y * myShapes[0].v0y) / (2 * g);
  else
    ymax = myShapes[0].y0;

  fptr = fopen("data.txt", "w");

  fprintf(fptr, "#y0 = %f m; v0y = %f m/s; a = %f m; ymax = %f m\n",
          myShapes[0].y0, myShapes[0].v0y, a, ymax);

  fprintf(fptr, "#t(s)\tysur(m)\tvy(m/s)\n");

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE);
  glutInitWindowSize(700, 1000);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("Vertical motion");

  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);

  glutMainLoop();

  fclose(fptr);
  return 0;
}
