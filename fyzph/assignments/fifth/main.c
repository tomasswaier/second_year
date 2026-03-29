#include "GL/freeglut_std.h"
#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

float currentTime = 0.0;
float ymax = 0.0;
const float Lmax = 4.0;
const int iTimeStep = 25;
const float g = 9.80665;
const float dt = 0.01;
FILE *fptr;

float m_a_v0 = 0;
float m_a_x = 0;

float m_z0 = 0;
float m_alfa = 0;
float m_phi = 0;
float m_r = 0;
float xmid;
float ymid;
float zmid;

float v0x, v0y, v0z;

float xmax, tD, tmax, ymax, zmax;
float x_min, y_min, z_min;
float x_max, y_max, z_max;
void resizeHandler(int width, int height) {
  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  float aspect = (float)width / height;

  float xRange = x_max - x_min;
  float yRange = y_max - y_min;
  float zRange = z_max - z_min;

  float maxRange = fmaxf(fmaxf(xRange, yRange), zRange);

  float xCenter = (x_max + x_min) / 2.0f;
  float yCenter = (y_max + y_min) / 2.0f;
  float zCenter = (z_max + z_min) / 2.0f;

  float pad = 1.5f * maxRange;

  glOrtho(-pad + xCenter, pad + xCenter, -pad + yCenter, pad + yCenter,
          -pad + zCenter, pad + zCenter);

  glMatrixMode(GL_MODELVIEW);
}

void displayShapes() {
  glClearColor(0.8f, 0.8f, 0.8f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glRotatef(20, 1, 0, 0);
  glRotatef(-30, 0, 1, 0);

  // Draw axes (X_cam=red, Y_cam=green, Z_cam=blue)
  glBegin(GL_LINES);

  // Red axis (X_cam = world Y)
  glColor3f(1, 0, 0);
  glVertex3f(0, 0, 0);
  glVertex3f(y_max, 0, 0);

  // Green axis (Y_cam = world Z)
  glColor3f(0, 1, 0);
  glVertex3f(0, 0, 0);
  glVertex3f(0, z_max, 0);

  // Blue axis (Z_cam = world X)
  glColor3f(0, 0, 1);
  glVertex3f(0, 0, 0);
  glVertex3f(0, 0, x_max);

  glEnd();

  // Compute current position of the sphere
  float x = v0x * currentTime;
  float y = v0y * currentTime;
  float z = m_z0 + v0z * currentTime - 0.5f * g * currentTime * currentTime;
  if (z < 0)
    z = 0;

  float vx = v0x;
  float vz = v0z - g * currentTime;
  float v = sqrt(v0x * v0x + v0y * v0y + vz * vz);
  fprintf(fptr, "%f\t%f\t%f\t%f\t%f\t%f\n", currentTime, x, y, vx, vz, v);

  // Draw the sphere at mapped coordinates
  glPushMatrix();
  glTranslatef(y, z, x); // X_cam=Y, Y_cam=Z, Z_cam=X
  glColor3f(1, 0, 0);
  glutWireSphere(m_r, 20, 20);
  glPopMatrix();

  glutSwapBuffers();
}
void drawSquare(float a) {

  glVertex2d(a / 2, a);
  glVertex2d(a / 2, 0);
  glVertex2d(-a / 2, 0);
  glVertex2d(-a / 2, a);
}

void update(const int iTime) {
  currentTime += dt;
  if (currentTime > tD)
    return;
  glutPostRedisplay();
  glutTimerFunc(iTimeStep, update, iTime + 1);
}
int main(int argc, char **argv) {
  if (argc != 6) {
    printf("argc !=6");
    exit(0);
  }

  m_z0 = atof(argv[1]);
  m_a_v0 = atof(argv[2]);
  m_alfa = atof(argv[3]);
  m_phi = atof(argv[4]);
  m_r = atof(argv[5]); //
  fptr = fopen("data.txt", "w");
  float alfaRad = m_alfa * M_PI / 180.0;
  float phiRad = m_phi * M_PI / 180.0;

  v0x = m_a_v0 * cos(alfaRad) * cos(phiRad);
  v0y = m_a_v0 * cos(alfaRad) * sin(phiRad);
  v0z = m_a_v0 * sin(alfaRad);

  tD = (v0z + sqrt(v0z * v0z + 2 * g * m_z0)) / g;
  zmax = m_z0 + (v0z * v0z) / (2 * g);
  xmax = v0x * tD;
  ymax = v0y * tD;
  tmax = v0z / g;
  xmid = xmax / 2.0;
  ymid = ymax / 2.0;
  zmid = zmax / 2.0;
  x_min = 0;
  x_max = v0x * tD;
  y_min = 0;
  y_max = v0y * tD;
  z_min = 0;
  z_max = m_z0 + (v0z * v0z) / (2 * g);
  x_min -= m_r;
  x_max += m_r;
  y_min -= m_r;
  y_max += m_r;
  z_min -= m_r;
  z_max += m_r;
  printf("tD=%f xmax=%f ymax=%f zmax=%f\n", tD, xmax, ymax, zmax);
  fprintf(fptr, "# tD=%f xmax=%f tmax=%f ymax=%f\n", tD, xmax, tmax, ymax);
  fprintf(fptr, "t(s)\txsur(m)\tysur(m)\tvx(m/s)\tvy(m/s)\tv(m/s)\n");

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH);
  glutInitWindowSize(800, 800);
  glEnable(GL_DEPTH_TEST);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("window");
  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);
  glutMainLoop();
  fclose(fptr);

  return 0;
}
