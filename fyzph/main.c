#include <GL/gl.h>
#include <GL/glut.h>
void nasa_procedura() {
  glClear(GL_COLOR_BUFFER_BIT);
  glutSwapBuffers();
}
int main(int argc, char **argv) {
  glutInit(&argc, argv);
  glutCreateWindow("OpenGL: okno v systeme");
  glutDisplayFunc(nasa_procedura);
  glutMainLoop();
  return 0;
}
