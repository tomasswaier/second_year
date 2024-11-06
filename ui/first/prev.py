import random
import copy
import matplotlib.pyplot as plt


# 12 x 10
mapy = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, "K", 0, 0, 0, 0, 0, 0],
    [0, "K", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, "K", 0, 0, 0, 0, 0, 0, 0],
    [0, 0, "K", 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, "K", "K", 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
]
mapy_shape = [len(mapy), len(mapy[0])]


class Kitten:
    def __init__(self, start_positions=[]):
        # specific steps kitten will take
        self.steps = ["l", "u", "r", "d"]
        self.start_positions = [
            list(t) for t in set(tuple(pos) for pos in start_positions)
        ]

        i = len(self.start_positions)

        # add the thing
        while i < number_of_positions:
            self.start_positions.append(self.get_position())
            i += 1

        if start_positions != []:
            for i in range(mutation_positions):
                position = random.randint(0, number_of_positions - 1)
                self.start_positions[position] = self.get_position()
            # mutate
        self.start_positions_index = 0
        self.score = 0
        self.mapc = copy.deepcopy(mapy)
        self.direction = ""
        self.prev_move = ""

        # current position
        self.position = []
        self.number = 0

        # current index of kitten in start_positions
        # start fella

    def get_position(self):
        position = self.random_position()
        while position in self.start_positions:
            position = self.random_position()
        return position

    def random_position(self):
        # this boolean determines where its on the horizontal{0} or vertical{1} edge
        side = bool(random.getrandbits(1))
        opposite_side = not side
        result = None
        if side:
            result = [
                random.randint(0, mapy_shape[opposite_side] - 1),
                0 if random.getrandbits(1) else (mapy_shape[side] - 1),
            ]
        else:
            result = [
                0 if random.getrandbits(1) else (mapy_shape[side] - 1),
                random.randint(0, mapy_shape[opposite_side] - 1),
            ]
        return result

    def move(self):
        def out_of_bounds_check(self):
            if (
                not self.position
                or self.position[0] is None
                or self.position[1] is None
            ):
                return True
            if (
                self.position[0] >= 0
                and self.position[0] < mapy_shape[0]
                and self.position[1] >= 0
                and self.position[1] < mapy_shape[1]
            ):
                return False
            return True

        # finds if the position my kitten is trying to access is available
        def find_empty_start_position(self):
            while self.start_positions_index < number_of_positions:
                positions = self.start_positions[self.start_positions_index]
                if self.mapc[positions[0]][positions[1]] == 0:
                    self.start_positions_index += 1
                    # if statements to make sure he doesnt go to one space and then right back
                    if (positions[0] == 0 or positions[0] == mapy_shape[0] - 1) and (
                        positions[1] == 0 or positions[1] == mapy_shape[1] - 1
                    ):
                        if positions[1] == 0:
                            self.direction = "r"
                            self.prev_move = "r"
                        else:
                            self.direction = "l"
                            self.prev_move = "l"
                        self.prev_move = ""
                    elif positions[0] == 0:
                        self.direction = "d"
                        self.prev_move = "d"
                    elif positions[0] == mapy_shape[0] - 1:
                        self.direction = "u"
                        self.prev_move = "u"
                    elif positions[1] == 0:
                        self.direction = "r"
                        self.prev_move = "r"
                    elif positions[1] == mapy_shape[1] - 1:
                        self.direction = "l"
                        self.prev_move = "l"
                    self.score += 1
                    return positions[0], positions[1]
                else:
                    self.start_positions_index += 1

            return None, None

        # variable to check if the kitten is out of the field or no
        while self.start_positions_index < len(self.start_positions):
            # longass error to keep python from displaying annoying errors that arent errors ! >:[
            if (
                not self.position
                or self.position[0] is None
                or self.position[1] is None
                or out_of_bounds_check(self)
            ):
                y, x = find_empty_start_position(self)
                if x == None and y == None:
                    break
                else:
                    self.position = [y, x]
                    self.number += 1
                    # gets rid of error
                    self.mapc[self.position[0]][self.position[1]] = self.number  # type: ignore
            else:
                # todo fix this shit
                result = self.walk()
                if result:
                    break
                # ste/p

    def walk(self):
        stuck = 0
        while self.position and self.position[0] != None and self.position[1] != None:
            # print(self.number, self.prev_move, self.direction, self.position)
            flag = False
            if (
                self.direction == "u"
                and self.prev_move != "d"
                and (
                    self.position[0] - 1 < 0
                    or self.mapc[self.position[0] - 1][self.position[1]] == 0
                )
            ):
                if self.position[0] - 1 < 0:
                    self.position = []
                else:
                    self.position = [self.position[0] - 1, self.position[1]]
                    self.mapc[self.position[0]][self.position[1]] = self.number
                    self.score += 1
                    self.prev_move = "u"
                flag = True
            elif (
                self.direction == "d"
                and self.prev_move != "u"
                and (
                    self.position[0] + 1 >= mapy_shape[0]
                    or self.mapc[self.position[0] + 1][self.position[1]] == 0
                )
            ):
                if self.position[0] + 1 >= mapy_shape[0]:
                    self.position = []
                else:
                    self.position = [self.position[0] + 1, self.position[1]]
                    self.mapc[self.position[0]][self.position[1]] = self.number
                    self.score += 1
                    self.prev_move = "d"
                flag = True
            elif (
                self.direction == "l"
                and self.prev_move != "r"
                and (
                    self.position[1] - 1 < 0
                    or self.mapc[self.position[0]][self.position[1] - 1] == 0
                )
            ):
                if self.position[1] - 1 < 0:
                    self.position = []
                else:
                    self.position = [self.position[0], self.position[1] - 1]
                    self.mapc[self.position[0]][self.position[1]] = self.number
                    self.score += 1
                    self.prev_move = "l"
                flag = True
            elif (
                self.direction == "r"
                and self.prev_move != "l"
                and (
                    self.position[1] + 1 >= mapy_shape[1]
                    or self.mapc[self.position[0]][self.position[1] + 1] == 0
                )
            ):
                if self.position[1] + 1 >= mapy_shape[1]:
                    self.position = []
                else:
                    self.position = [self.position[0], self.position[1] + 1]
                    self.mapc[self.position[0]][self.position[1]] = self.number
                    self.score += 1
                    self.prev_move = "r"
                flag = True
            if flag:
                stuck = 0
            else:
                stuck += 1
                if stuck == 5:
                    self.score -= 5
                    return True

                if self.direction == "":
                    self.direction = random.choice(self.steps)
                self.direction = self.steps[
                    (self.steps.index(str(self.direction)) + 1) % 4
                ]
        return False

    def start(self):

        self.move()
        if flag == 1 or self.score == 114:
            self.print_map()
        return [self.score, self.start_positions, self.steps]

    def print_map(self):
        print("------------------------------")
        for row in self.mapc:
            mystring = ""
            for char in row:
                if len(str(char)) == 1:
                    mystring += "  " + str(char) + ","
                else:
                    mystring += " " + str(char) + ","
            print(mystring + "\n")
        print(self.score)


flag = 0
if __name__ == "__main__":
    # defining starting parameters
    number_of_positions = 28
    kitten_score_top = []
    kitten_score_avg = []
    number_of_generations = 10000
    number_of_steps = 300
    # number of kittens has to be bigger or = to top_kitten_count**2
    top_kitten_count = 20
    number_of_kittens = 400
    mutation_positions = 1
    kittens = [Kitten() for _ in range(number_of_kittens)]
    for i in range(number_of_generations):
        if i == number_of_generations - 1:
            flag = 1
        kitten_result_array = []
        kitten_score_average = 0
        for kitten in kittens:
            kitten_data = kitten.start()
            kitten_result_array.append(kitten_data)
            kitten_score_average += kitten_data[0]
        kitten_score_average = kitten_score_average / number_of_kittens
        kitten_score_avg.append(kitten_score_average)

        kitten_result_array = list(reversed(sorted(kitten_result_array)))
        top_kittens = kitten_result_array[:top_kitten_count]
        kitten_score_top.append(top_kittens[0][0])
        kittens.clear()

        # I think this is the genetic thingy ? no random is present tho
        # mutation1
        print(top_kittens[0][0])
        if top_kittens[0][0] == 114:
            break
        for top_kitten_i in top_kittens:
            for top_kitten_j in top_kittens:
                # if top_kitten_j != top_kitten_i:
                # creating new kitten
                x = random.randint(0, number_of_positions - 1)
                newpositions = (
                    top_kitten_i[1][0:x] + top_kitten_j[1][x : number_of_positions - 1]
                )
                kittens.append(Kitten(newpositions))

                if len(kittens) == number_of_kittens:
                    break
    plt.plot(kitten_score_top, label="top performer")
    # plt.plot(kitten_score_avg, label="average performance")
    plt.legend(loc="lower right")
    plt.show()
