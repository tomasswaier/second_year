#include "GL/freeglut_std.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

float currentTime = 0.0;
const int iTimeStep = 25;
const float dt = 0.01;

float theta, phi, l, rho, r, omega;

float cx, cy, cz;

void rotateZ(float angle, float *x, float *y, float *z) {
  float x_new = (*x) * cos(angle) - (*y) * sin(angle);
  float y_new = (*x) * sin(angle) + (*y) * cos(angle);
  *x = x_new;
  *y = y_new;
}

void rotateY(float angle, float *x, float *y, float *z) {
  float x_new = (*x) * cos(angle) + (*z) * sin(angle);
  float z_new = -(*x) * sin(angle) + (*z) * cos(angle);
  *x = x_new;
  *z = z_new;
}
void drawAxes() {
  glBegin(GL_LINES);

  glColor3f(1, 0, 0);
  glVertex3f(0, 0, 0);
  glVertex3f(5, 0, 0);

  glColor3f(0, 1, 0);
  glVertex3f(0, 0, 0);
  glVertex3f(0, 5, 0);

  glColor3f(0, 0, 1);
  glVertex3f(0, 0, 0);
  glVertex3f(0, 0, 5);

  glEnd();
}

void displayShapes() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();

  // Kamera
  gluLookAt(6, 6, 6, 0, 0, 0, 0, 0, 1);

  drawAxes();

  float ax = 0, ay = 0, az = l;

  rotateY(theta, &ax, &ay, &az);
  rotateZ(phi, &ax, &ay, &az);

  glColor3f(1, 1, 1);
  glBegin(GL_LINES);
  glVertex3f(0, 0, 0);
  glVertex3f(ax, ay, az);
  glEnd();

  cx = ax;
  cy = ay;
  cz = az;

  float angle = omega * currentTime;

  float bx = rho * cos(angle);
  float by = rho * sin(angle);
  float bz = 0;

  rotateY(theta, &bx, &by, &bz);
  rotateZ(phi, &bx, &by, &bz);

  bx += cx;
  by += cy;
  bz += cz;

  glColor3f(1, 1, 0);
  glBegin(GL_LINES);
  glVertex3f(cx, cy, cz);
  glVertex3f(bx, by, bz);
  glEnd();

  glPushMatrix();
  glTranslatef(bx, by, bz); // iba kreslim
  glColor3f(1, 0, 1);
  glutSolidSphere(r, 20, 20);
  glPopMatrix();

  glColor3f(0, 1, 1);
  glBegin(GL_LINE_LOOP);
  for (int i = 0; i < 100; i++) {
    float a = 2 * M_PI * i / 100;
    float x = rho * cos(a);
    float y = rho * sin(a);
    float z = 0;

    rotateY(theta, &x, &y, &z);
    rotateZ(phi, &x, &y, &z);

    glVertex3f(cx + x, cy + y, cz + z);
  }
  glEnd();

  glutSwapBuffers();
}

void resizeHandler(int w, int h) {
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  gluPerspective(60, (float)w / h, 0.1, 100);

  glMatrixMode(GL_MODELVIEW);
}

void update(int val) {
  currentTime += dt;
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, 0);
}

int main(int argc, char **argv) {

  if (argc != 7) {
    printf("Usage: theta phi l rho r omega\n");
    return 0;
  }

  theta = atof(argv[1]) * M_PI / 180.0;
  phi = atof(argv[2]) * M_PI / 180.0;
  l = atof(argv[3]);
  rho = atof(argv[4]);
  r = atof(argv[5]);
  omega = atof(argv[6]);

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH);
  glutInitWindowSize(800, 800);

  glEnable(GL_DEPTH_TEST);

  glutCreateWindow("Kolotoc");

  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);

  glutMainLoop();
  return 0;
}
