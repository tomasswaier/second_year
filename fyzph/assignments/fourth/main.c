#include "GL/freeglut_std.h"
#include "GL/glu.h"
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
// const int shapeCount = 1;
const float g = 9.80665;
const float dt = 0.01;
FILE *fptr;

float m_a_v0 = 0;
float m_a_x = 0;
float m_a_y0 = 0;
float m_a_alfa = 0;
float m_a_a = 0;

float m_b_d = 0;
float m_b_beta = 0;
float vx0, vy0;
float bx, by0;
float xmax, tD, tmax;

void resizeHandler(int width, int height) {

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  float worldAspect = (xmax + 2 * m_a_a) / (ymax + 2 * m_a_a);
  float windowAspect = (float)width / height;

  int viewportWidth, viewportHeight;
  int viewportX = 0;
  int viewportY = 0;

  if (windowAspect > worldAspect) {
    // window too wide
    viewportHeight = height;
    viewportWidth = height * worldAspect;
    viewportX = (width - viewportWidth) / 2;
  } else {
    // window too tall
    viewportWidth = width;
    viewportHeight = width / worldAspect;
    viewportY = (height - viewportHeight) / 2;
  }

  glViewport(viewportX, viewportY, viewportWidth, viewportHeight);

  gluOrtho2D(-m_a_a, xmax + m_a_a, -m_a_a, ymax + m_a_a);

  glMatrixMode(GL_MODELVIEW);
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
void displayShapes() {
  glClearColor(0.8, 0.8, 0.8, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);

  glLoadIdentity();

  glBegin(GL_LINES);

  glColor3f(1, 0, 0);
  glVertex2f(0, 0);
  glVertex2f(xmax, 0);

  glColor3f(0, 1, 0);
  glVertex2f(0, 0);
  glVertex2f(0, ymax);

  glEnd();
  float x = vx0 * currentTime;
  float y = m_a_y0 + vy0 * currentTime - 0.5 * g * currentTime * currentTime;

  if (y < 0)
    y = 0;
  float vx = vx0;
  float vy = vy0 - g * currentTime;
  float v = sqrt(vx * vx + vy * vy);

  float by = by0 - 0.5 * g * currentTime * currentTime;

  if (by < 0)
    by = 0;
  fprintf(fptr, "%f\t%f\t%f\t%f\t%f\t%f\n", currentTime, x, y, vx, vy, v);

  glLoadIdentity();
  glTranslatef(x, y, 0);

  glColor3f(1, 0, 0);
  glBegin(GL_POLYGON);
  drawSquare(m_a_a);
  glEnd();

  glLoadIdentity();
  glTranslatef(bx, by, 0);

  glColor3f(0, 0, 1);
  glBegin(GL_POLYGON);
  drawSquare(m_a_a);
  glEnd();
  glutSwapBuffers();
}

int main(int argc, char **argv) {
  if (argc != 7) {
    printf("argc !=7");
    exit(0);
  }
  m_a_y0 = atof(argv[1]);   // a height
  m_a_v0 = atof(argv[2]);   // a speed
  m_a_alfa = atof(argv[3]); // a angle alfa
  m_b_d = atof(argv[4]);    // b x
  m_b_beta = atof(argv[5]); // a angle or sum ?
  m_a_a = atof(argv[6]);    // a size
  if (y0 < 0 || m_a_a <= 0 || (0 > m_a_alfa || 90 < m_a_alfa)) {
    printf("Vstupne y0 musi byt nulova alebo kladna hodnota, dlzka strany a "
           "musi byt kladna hodnota a (0 <= alfa || 90 >= alfa)");
  }
  fptr = fopen("data.txt", "w");
  float alfaRad = m_a_alfa * M_PI / 180.0;
  float betaRad = m_b_beta * M_PI / 180.0;

  vx0 = m_a_v0 * cos(alfaRad);
  vy0 = m_a_v0 * sin(alfaRad);

  ymax = m_a_y0 + (vy0 * vy0) / (2 * g);
  bx = m_b_d * cos(betaRad);
  by0 = m_b_d * sin(betaRad);
  if (by0 > ymax)
    ymax = by0;

  tmax = vy0 / g;
  tD = (vy0 + sqrt(vy0 * vy0 + 2 * g * m_a_y0)) / g;
  xmax = vx0 * tD;

  fprintf(fptr, "# y0=%f v0=%f alfa=%f a=%f\n", m_a_y0, m_a_v0, m_a_alfa,
          m_a_a);
  fprintf(fptr, "# tD=%f xmax=%f tmax=%f ymax=%f\n", tD, xmax, tmax, ymax);
  fprintf(fptr, "t(s)\txsur(m)\tysur(m)\tvx(m/s)\tvy(m/s)\tv(m/s)\n");

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE);
  glutInitWindowSize(800, 800);
  glutInitWindowPosition(0, 0);
  glutCreateWindow("window");
  glutDisplayFunc(displayShapes);
  glutReshapeFunc(resizeHandler);
  glutTimerFunc(iTimeStep, update, 0);
  glutMainLoop();
  fclose(fptr);

  return 0;
}
