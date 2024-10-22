from sklearn.neighbors import KNeighborsClassifier
import matplotlib.pyplot as plt
import random

red = [
    [[-4500, -4400], [-4100, -3000], [-1800, -2400], [-2500, -3400], [-2000, -1400]],
    "#ff0000",
]
green = [
    [[+4500, -4400], [+4100, -3000], [+1800, -2400], [+2500, -3400], [+2000, -1400]],
    "#00ff00",
]
blue = [
    [[-4500, +4400], [-4100, +3000], [-1800, +2400], [-2500, +3400], [-2000, +1400]],
    "#0000ff",
]
pink = [
    [[+4500, +4400], [+4100, +3000], [+1800, +2400], [+2500, +3400], [+2000, +1400]],
    "#000000",
]
x = []
y = []
classes = []
for array in [red, green, blue, pink]:
    for i in range(len(array[0])):
        x.append(array[0][i][0])
        y.append(array[0][i][1])
        classes.append(array[1])
# useless/*
data = list(zip(x, y))
knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(data, classes)
# uselesse*/
for i in range(2000):
    newx = random.randint(-5000, 5000)
    newy = random.randint(-5000, 5000)
    if (newx, newy) in data:
        continue
    knn.fit(data, classes)
    prediction = knn.predict([(newx, newy)])
    classes.append(prediction[0])
    data.append((newx, newy))
x, y = list(zip(*data))


plt.scatter(x, y, c=classes)
plt.show()
data = list(zip(x, y))
