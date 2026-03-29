#include "GL/freeglut_std.h"
#include "GL/glu.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <unistd.h>

const float Lmax = 4.0;
const int iTimeStep = 25;
float moveX = 0.0;

void update(const int iTime) {
  moveX += 0.05;
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}
void resizeHandler(const int width, const int height) {

  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-0.5 * Lmax, 0.5 * Lmax, -0.5 * Lmax * height / width,
             0.5 * Lmax * height / width);
}
void drawTriangle() {
  glClearColor(0.2, 0.2, 0.2, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(0.0, 0.0, 1.0);
  gluOrtho2D(-2.0, 2.0, -1.0, 1.0);

  glBegin(GL_TRIANGLES);
  glVertex2f(-0.8, -0.8);
  glVertex2f(0.8, -0.8);
  glVertex2f(0, 0.8);
  glEnd();

  glutSwapBuffers();
}

int main(int argc, char **argv) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE);
  glutInitWindowSize(400, 400);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("flashbang");
  glutDisplayFunc(drawTriangle);
  glutReshapeFunc(resizeHandler);
  // glutTimerFunc(iTimeStep, update, 0) glutMainLoop();
  glutMainLoop();

  return 0;
}
