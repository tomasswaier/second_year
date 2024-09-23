import random
import copy


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


class Kitten:
    def __init__(self, start_positions=[], steps=None):
        # specific steps kitten will take
        if steps is None:
            self.steps = random.choices(["l", "r", "u", "d"], k=number_of_steps)
        else:
            self.steps = steps
            for i in range(5):
                x = random.randint(0, number_of_steps - 1)
                self.steps[x] = random.choice(["l", "r", "u", "d"])
        # start_positions where the kitten will spawn afeter it leaves the field
        # if we recieve positions as class arguent then we remove duplicates and append new positions

        self.start_positions = [
            list(t) for t in set(tuple(pos) for pos in start_positions)
        ]

        i = len(self.start_positions)

        # add the thing
        while i < number_of_positions:
            x = self.random_position()
            while x in self.start_positions:
                x = self.random_position()
            self.start_positions.append(x)
            i += 1
        self.start_positions_index = 0
        self.score = 0
        self.mapc = copy.deepcopy(mapy)
        self.last_instruction = ""
        # current position
        self.position = []
        self.number = 0

        # current index of kitten in start_positions
        self.i = 0
        # start fella

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
                    if positions[0] == 0:
                        self.last_instruction = "d"
                    elif (positions[0] == 0 or positions[0] == mapy_shape[0] - 1) and (
                        positions[0] == 0 or positions[0] == mapy_shape[0] - 1
                    ):  # checks if im in the corner
                        self.last_instruction == ""
                    elif positions[0] == mapy_shape[0] - 1:
                        self.last_instruction = "u"
                    elif positions[1] == 0:
                        self.last_instruction = "r"
                    elif positions[1] == mapy_shape[1] - 1:
                        self.last_instruction = "l"
                    self.score += 1
                    return positions[0], positions[1]
                else:
                    self.start_positions_index += 1

            return None, None

        # variable to check if the kitten is out of the field or no
        while self.i < number_of_steps:
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
                while self.i < number_of_steps:
                    if (
                        self.steps[self.i] == "u"
                        and self.last_instruction != "d"
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
                        self.i += 1
                        break
                    elif (
                        self.steps[self.i] == "d"
                        and self.last_instruction != "u"
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
                        self.i += 1
                        break
                    elif (
                        self.steps[self.i] == "l"
                        and self.last_instruction != "r"
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
                        self.i += 1
                        break
                    elif (
                        self.steps[self.i] == "r"
                        and self.last_instruction != "l"
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
                        self.i += 1
                        break
                    self.i += 1
                # step

    def start(self):

        self.move()
        return [self.score, self.start_positions, self.steps]

    def print_map(self):
        for row in self.mapc:
            mystring = ""
            for c in row:
                mystring += " " + str(c) + " "
            print(mystring + "\n")


if __name__ == "__main__":
    mapy_shape = [len(mapy), len(mapy[0])]
    # defining starting parameters
    number_of_positions = 30
    number_of_steps = 300
    kitten_score_sum = []
    number_of_generations = 200
    # kittens_kitens_count **2 has to be bigger or = to number of kittens
    top_kitten_count = 10
    number_of_kittens = 100
    # variable that i will use to invoke functions that are in kitten
    mutant = Kitten()
    kittens = [Kitten() for _ in range(number_of_kittens)]
    for _ in range(number_of_generations):
        print(len(kittens))
        kitten_result_array = []
        kitten_score_average = []
        for kitten in kittens:
            kitten_data = kitten.start()
            kitten_result_array.append(kitten_data)
            kitten_score_average.append(kitten_data[0])
        kitten_score_sum.append(sum(kitten_score_average))
        kitten_result_array = list(reversed(sorted(kitten_result_array)))
        top_kittens = kitten_result_array[:top_kitten_count]
        kittens.clear()

        print("top scores:")
        # I think this is the genetic thingy ? no random is present tho
        # mutation1
        for top_kitten_i in top_kittens:
            print(top_kitten_i[0])
            for top_kitten_j in top_kittens:
                if top_kitten_j != top_kitten_i:
                    # creating new kitten
                    x = random.randint(0, number_of_positions - 1)
                    newpositions = (
                        top_kitten_i[1][0:x]
                        + top_kitten_j[1][x : number_of_positions - 1]
                    )
                    x = int((x / number_of_positions) * number_of_steps)
                    newsteps = top_kitten_i[2][0:x] + top_kitten_j[2][x:number_of_steps]
                    # here we mutate the kittens
                    mutate_position = random.randint(0, number_of_positions)
                    kittens.append(Kitten(newpositions, newsteps))
                    if len(kittens) == number_of_kittens:
                        break
        # print(kitten_score_sum)
