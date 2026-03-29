#include "GL/freeglut_std.h"
#include "GL/glu.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>
#include <stdio.h>
#include <unistd.h>

typedef struct {
  float x;
  float y;
  float speed;
  float lead;
  void (*drawFunction)(float, float);
} Shapes;

float currentTime = 0.0;
const float Lmax = 4.0;
const int iTimeStep = 25;
const int shapeCount = 2;

void resizeHandler(const int width, const int height) {

  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
}

void drawHexagon(float x, float y) {
  for (int i = 0; i < 6; ++i) {
    glVertex2d((sin(i / 6.0 * 2 * M_PI) / 10) + x,
               ((cos(i / 6.0 * 2 * M_PI) + 0.4) / 10) + y);
  }
}

void drawSquare(float x, float y) {
  glVertex2d(x + 0.05, y + 0.1);
  glVertex2d(x + 0.05, y - 0.1);
  glVertex2d(x - 0.05, y - 0.1);
  glVertex2d(x - 0.05, y + 0.1);
}

Shapes myShapes[2] = {
    {0.0f, 0.0f, 0.0025f, 0.3, drawHexagon}, // turtle
    {0.0f, 0.0f, 0.0050f, 0, drawSquare}     // Achilles
};

void update(const int iTime) {
  currentTime += (float)iTimeStep / 100;
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}

void displayShapes() {

  glClearColor(0.8, 0.8, 0.8, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);

  /*
     výpočty polôh podľa vzťahu:

     x(t) = x0 + v * t
  */

  float xK =
      myShapes[0].lead + myShapes[0].speed * currentTime; // turtle position
  float xA =
      myShapes[1].lead + myShapes[1].speed * currentTime; // Achilles position

  for (int i = 0; i < shapeCount; i++) {

    glLoadIdentity();
    glScalef(1.1, 1.1, 1.1);

    glColor3f(0.0 + 1 * (xA < xK), 0.5 - ((i + 0.5) / 2), 0.0 + i);

    float xsuradnica = myShapes[i].lead + myShapes[i].speed * currentTime;

    glTranslatef(xsuradnica, 0.0, 0.0);

    glBegin(GL_POLYGON);
    myShapes[i].drawFunction(myShapes[i].x - 0.8, myShapes[i].y);
    glEnd();
  }

  glutSwapBuffers();
}

int main(int argc, char **argv) {

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
  glutInitWindowSize(1000, 1000);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("meowzer");

  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);

  glutMainLoop();

  return 0;
}
