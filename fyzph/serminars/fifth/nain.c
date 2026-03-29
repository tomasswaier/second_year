#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>

const float Lmax = 40.0;

void obsluhaResize(int sirka, int vyska) {
  glViewport(0, 0, sirka, vyska);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  if (sirka == 0)
    sirka++;
  const float pomstr = ((float)vyska) / sirka;
  // doplniť
  glOrtho(-0.5 * Lmax, 0.5 * Lmax, -0.5 * Lmax * pomstr, 0.5 * Lmax * pomstr,
          -1, 0.1);
}

void kresliRovnobezky3D() {
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glColor3f(0.0, 0.0, 0.0);

  // doplniť
  glBegin(GL_LINES);
  glVertex3f(-4, 8, -10);
  glVertex3f(4, -8, -12);
  glVertex3f(4, 8, -10);
  glVertex3f(4, -8, -12);
  // glVertex3f(...);
  // glVertex3f(...);
  glEnd();
  glutSwapBuffers();
}

int main(int argc, char **argv) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE);
  glutInitWindowSize(640, 640);
  glutInitWindowPosition(200, 150);
  glutCreateWindow("OpenGL: rovnobezky");
  glutDisplayFunc(kresliRovnobezky3D);
  glutReshapeFunc(obsluhaResize);
  glClearColor(1.0, 1.0, 1.0, 0);
  glutMainLoop();
  return 0;
}
