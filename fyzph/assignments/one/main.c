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
  int movementType;
  void (*drawFunction)(float, float);
} Shapes;

const float Lmax = 4.0;
const int iTimeStep = 25;
const int shapeCount = 2;

void resizeHandler(const int width, const int height) {

  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  /*gluOrtho2D(-0.5 * Lmax, 0.5 * Lmax, -0.5 * Lmax * height / width,
             0.5 * Lmax * height / width);
             */
}
void drawHexagon(float x, float y) {
  for (int i = 0; i < 6; ++i) {
    glVertex2d((sin(i / 6.0 * 2 * M_PI) / 10) + x,
               ((cos(i / 6.0 * 2 * M_PI) + 0.4) / 10) + y);
  }
}
void drawSquare(float x, float y) {
  glVertex2d(x + 0.2, y + 0.1);
  glVertex2d(x + 0.2, y - 0.1);
  glVertex2d(x - 0.2, y - 0.1);
  glVertex2d(x - 0.2, y + 0.1);
}

Shapes myShapes[2] = {{0.0f, 0.4f, 0.0025f, 0, drawHexagon},
                      {0.0f, -0.8f, 0.0050f, 1, drawSquare}};
void update(const int iTime) {
  for (int i = 0; i < shapeCount; i++) {

    if (myShapes[i].movementType == 0) {
      myShapes[i].x += myShapes[i].speed;
      myShapes[i].x = fmod(myShapes[i].x, 1.4f);
    } else if (myShapes[i].movementType == 1) {
      myShapes[i].x += myShapes[i].speed;
      myShapes[i].y += myShapes[i].speed;
      if (myShapes[i].y >= 1) {
        myShapes[i].y = -0.8;
        myShapes[i].x = 0;
      }
    }
  }
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}
void displayShapes() {
  glClearColor(0.8, 0.8, 0.8, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(0.0, 0.0, 1.0);

  for (int i = 0; i < shapeCount; i++) {
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
