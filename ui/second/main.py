"""
point is to compare how successful is the result compare to original or sumshit 
"""

import matplotlib.pyplot as plt
import numpy as np
from collections import Counter
import copy

colormap = {0: "#ff0000", 1: "#00ff00", 2: "#0000ff", 3: "#ee66ee"}
MAX = 5000
NUM_OF_POINTS = 40000
red = [
    [[-4500, -4400], [-4100, -3000], [-1800, -2400], [-2500, -3400], [-2000, -1400]],
    0,
    [500, 500],
]
green = [
    [[+4500, -4400], [+4100, -3000], [+1800, -2400], [+2500, -3400], [+2000, -1400]],
    1,
    [-500, 500],
]
blue = [
    [[-4500, +4400], [-4100, +3000], [-1800, +2400], [-2500, +3400], [-2000, +1400]],
    2,
    [500, -500],
]
pink = [
    [[+4500, +4400], [+4100, +3000], [+1800, +2400], [+2500, +3400], [+2000, +1400]],
    3,
    [-500, -500],
]
x = np.empty(NUM_OF_POINTS + len(red[0]) * 4, dtype=np.int64)
y = np.empty(NUM_OF_POINTS + len(red[0]) * 4, dtype=np.int64)
classes = np.empty(NUM_OF_POINTS + len(red[0]) * 4, dtype=np.int64)
# we assume that all arrays have the same number of elements
index = 0
for i in range(len(red[0])):
    for color in [red, green, blue, pink]:
        x[index] = np.int64(color[0][i][0])
        y[index] = np.int64(color[0][i][1])
        classes[index] = np.int64(color[1])
        index += 1


def gen_random_point(x, y):
    point = np.random.randint(100)
    if point == 0:
        return np.random.randint(low=-MAX, high=MAX), np.random.randint(
            low=-MAX, high=MAX
        )
    else:
        x = [-MAX, x] if x > 0 else [x, MAX]
        y = [-MAX, y] if y > 0 else [y, MAX]
        return np.random.randint(low=x[0], high=x[1]), np.random.randint(
            low=y[0], high=y[1]
        )


class Knn:
    def __init__(self, nearest_num, x, y, classes):
        self.nn = nearest_num
        self.x = x.copy()
        self.y = y.copy()
        # color
        self.c = classes.copy()

    def add_point(self, x, y, i):
        self.x[i] = x
        self.y[i] = y
        self.c[i] = self.classify(x, y, i)

    def classify(self, x, y, limit_index):
        # Only consider points from 0 to limit_index
        limited_x = self.x[:limit_index]
        limited_y = self.y[:limit_index]
        limited_classes = self.c[:limit_index]

        distances = np.sqrt((limited_x - x) ** 2 + (limited_y - y) ** 2)

        nearest_indices = np.argsort(distances)[: self.nn]

        nearest_classes = limited_classes[nearest_indices]

        most_common_class = Counter(nearest_classes).most_common(1)[0][0]

        return most_common_class

    def return_points(self):
        return self.x, self.y, self.c


array1 = Knn(1, x, y, classes)
array3 = Knn(3, x, y, classes)
array7 = Knn(7, x, y, classes)
array15 = Knn(15, x, y, classes)
# add random points
for i in range(5, int(NUM_OF_POINTS / 4) + 5):
    for color in [red, green, blue, pink]:
        point = gen_random_point(*color[2])
        x[index] = point[0]
        y[index] = point[1]
        classes[index] = color[1]
        # append it to my knn
        array1.add_point(point[0], point[1], index)
        array3.add_point(point[0], point[1], index)
        array7.add_point(point[0], point[1], index)
        array15.add_point(point[0], point[1], index)
        index += 1
plt.figure(figsize=(12, 18))


def displaygraphs(x, y, classes, num):
    plt.subplot(3, 2, num)
    classes = [colormap[label] for label in classes]
    plt.scatter(x, y, s=10, c=classes)


displaygraphs(x, y, classes, 1)
x, y, classes = array1.return_points()
displaygraphs(x, y, classes, 2)
x, y, classes = array3.return_points()
displaygraphs(x, y, classes, 3)
x, y, classes = array7.return_points()
displaygraphs(x, y, classes, 4)
x, y, classes = array15.return_points()
displaygraphs(x, y, classes, 5)
plt.show()
data = list(zip(x, y))
