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
  float y;
  float xspeed;
  float yspeed;
  float lead;
  float edgeSize;
  void (*drawFunction)(float, float, float);
} Shapes;

float currentTime = 0.0;
float ymax = 0.0;
const float Lmax = 4.0;
const int iTimeStep = 25;
// const int shapeCount = 1;
const float g = 9.80665;
const float dt = 0.01;
FILE *fptr;
float m_a = 0;

void resizeHandler(int width, int height) {
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  float screenHeight = ymax + m_a + 0.5 * m_a;
  float screenWidth = screenHeight / ((float)height / (float)width);
  if (screenWidth < 3 * m_a)
    screenWidth = 3 * m_a;

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
Shapes myShapes[1] = {{0.0f, 0.0f, 0.0f, 0.0f, 0, 0, drawSquare}};

void update(const int iTime) {
  currentTime += dt;
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}
void displayShapes() {
  glClearColor(0.8, 0.8, 0.8, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);

  glLoadIdentity();
  glColor3f(0.5, 0.5, 0.1);

  float position = myShapes[0].y + myShapes[0].yspeed * currentTime -
                   0.5 * g * currentTime * currentTime;
  float x0;
  if (position <= 0) {
    position = 0;
    // x0 = x0;
  } else {
    x0 = myShapes[0].x + myShapes[0].xspeed * currentTime;
  }

  float vy = myShapes[0].yspeed - g * currentTime;
  fprintf(fptr, "%f\t%f\t%f\t%f\n", currentTime, position, vy, x0);
  glTranslatef(-4, 0.0, 0.0);
  glTranslatef(x0, position, 0.0);
  glBegin(GL_POLYGON);
  myShapes[0].drawFunction(myShapes[0].x, myShapes[0].y, myShapes[0].edgeSize);
  glEnd();

  glutSwapBuffers();
}

int main(int argc, char **argv) {
  if (argc != 5) {
    printf("argc !=5");
    exit(0);
  }
  myShapes[0].y = atof(argv[1]);              // y0
  myShapes[0].xspeed = atof(argv[4]);         // v0y
  myShapes[0].yspeed = atof(argv[2]);         // v0y
  m_a = myShapes[0].edgeSize = atof(argv[3]); // a

  if (myShapes[0].y < 0 || m_a <= 0) {
    printf("Vstupne y0 musi byt nulova alebo kladna hodnota, dlzka strany a "
           "musi byt kladna hodnota");
  }
  fptr = fopen("data.txt", "w");

  fprintf(fptr, "t(s)\tysur(m)\tvy(m/s)\n");
  if (myShapes[0].yspeed > 0)
    ymax = myShapes[0].y + (myShapes[0].yspeed * myShapes[0].yspeed) / (2 * g);
  else
    ymax = myShapes[0].y;

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE);
  glutInitWindowSize(700, 1000);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("window");
  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);
  glutMainLoop();
  fclose(fptr);

  return 0;
}
