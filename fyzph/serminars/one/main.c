#include "GL/freeglut_std.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <unistd.h>
void init() {
  glClearColor(1.0, 1.0, 1.0, 0.1);
  glClear(GL_COLOR_BUFFER_BIT);
  glutSwapBuffers();
}

int main(int argc, char **argv) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(1920, 1080);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("flashbang");
  glutDisplayFunc(init);
  glutMainLoop();

  return 0;
}
