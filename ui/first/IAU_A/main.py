import random
import copy
import matplotlib.pyplot as plt


# mapa pohybu monka  (kitten)
mapy = []


def make_map(shape, rocks):
    for i in range(shape[0]):
        row = []
        for j in range(shape[1]):
            if [i, j] in rocks:
                row.append("K")
            else:
                row.append(0)
        mapy.append(copy.deepcopy(row))


def print_map(mapc):
    print("------------------------------")
    for row in mapc:
        mystring = ""
        for char in row:
            if len(str(char)) == 1:
                mystring += "  " + str(char) + ","
            else:
                mystring += " " + str(char) + ","
        print(mystring + "\n")


"""
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
"""
rocks = [[1, 5], [2, 1], [3, 4], [4, 2], [6, 7], [6, 8]]


mapy_shape = [10, 12]
make_map(mapy_shape, rocks)
# print_map(mapy)


class Kitten:
    def __init__(self, start_positions=[], dont_evolve=False):
        # definovanie kam su bude mmonk hýbať pri náraze na stenu alebo kedykoľvek potrebuje random direction

        # randomná zmena génu 2
        self.i = 0
        # vymazanie každej duplicitnej hodnoty v gene s pohybmi
        self.start_positions = [
            list(t) for t in set(tuple(pos) for pos in start_positions)
        ]

        i = len(self.start_positions)

        # pridanie start positions kým ich nieje 28
        while i < number_of_positions:
            self.start_positions.append(self.get_position())
            i += 1

        # evolucia
        if start_positions != [] and dont_evolve == False:
            for i in range(mutation_positions):
                position = random.randint(0, number_of_positions - 1)
                self.start_positions[position] = self.get_position()
        self.start_positions_index = 0
        self.score = 0
        self.mapc = copy.deepcopy(mapy)
        self.direction = ""
        self.prev_move = ""

        # current position
        self.position = []
        self.number = 0

    def get_position(self):
        # variable used to get random positions
        position = self.random_position()
        while position in self.start_positions:
            position = self.random_position()
        return position

    def random_position(self):

        # vygenerujem si radonom boolean a ten bude slúžiť na determinovanie či generujem vertikálnu pozíciu alebo horizontálnu

        side = bool(random.getrandbits(1))
        opposite_side = not side
        result = None

        # pomocou ďaľích dvoch random výberov nám returnne kompletne random pozíciu
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

    # v tejto premennej prebieha celý pohyb
    def move(self):
        # self explenatory
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

        # very much self explenatory
        def find_empty_start_position(self):
            while self.start_positions_index < number_of_positions:
                positions = self.start_positions[self.start_positions_index]
                if self.mapc[positions[0]][positions[1]] == 0:
                    self.start_positions_index += 1

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
                    # ked nájde pozíciu tak si nastavý svoj smer chodu a predchodzí pohyb(ako vliezla do pola)
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

        # pre každú start%position sa pokúsi urobiť čo najviac krokov
        while self.start_positions_index < len(self.start_positions):
            # ak je mimo pola tak si nájde novú pozíciu
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
                # ak je v poli tak ide kráčať
                result = self.walk()
                if result:
                    break

    # tuto prebieha celé chodenie
    def walk(self):
        stuck = 0
        while self.position and self.position[0] != None and self.position[1] != None:
            # print(self.number, self.prev_move, self.direction, self.position)
            # pozrie sa či je možné ísť na nejakú pozíciu
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
            # ak sa  monk nemá kam pohnúť tak sa mu odpočítajú body
            if not flag:
                if self.direction in ["l", "r"]:
                    up = self.can_move([self.position[0] - 1, self.position[1]])
                    down = self.can_move([self.position[0] + 1, self.position[1]])
                    if up and down:
                        self.direction = random.choice(["u", "d"])
                    elif not up and not down:
                        self.score -= 10
                        self.position = []
                        return True  # Stuck, return out of loop
                    elif up:
                        self.direction = "u"
                    else:
                        self.direction = "d"
                elif self.direction in ["u", "d"]:
                    left = self.can_move([self.position[0], self.position[1] - 1])
                    right = self.can_move([self.position[0], self.position[1] + 1])
                    if right and left:
                        self.direction = random.choice(["l", "r"])
                    elif not left and not right:
                        self.score -= 10
                        self.position = []
                        return True  # Stuck, return out of loop
                    elif left:
                        self.direction = "l"
                    else:
                        self.direction = "r"

                        return False

    def can_move(self, position):
        row, col = position

        if row < 0 or col < 0 or row >= len(self.mapc) or col >= len(self.mapc[0]):
            return True

        if self.mapc[row][col] == 0:
            return True

        return False

    def start(self):
        self.move()
        if flag == 1 or self.score == 114:
            print_map(self.mapc)
        return [self.score, self.start_positions]


flag = 0
if __name__ == "__main__":
    # defining starting parameters
    number_of_positions = 28
    kitten_score_top = []
    kitten_score_avg = []
    number_of_generations = 1000
    # number of kittens has to be bigger or = to top_kitten_count**2
    top_kitten_count = 20
    number_of_kittens = 400
    mutation_positions = 2
    mutation_steps = 1
    pick = 1
    kittens = [Kitten() for _ in range(number_of_kittens)]
    dummy_array = []
    if pick == 2:
        for i in reversed(range(number_of_kittens)):
            ([dummy_array.append(i) for _ in range(number_of_kittens - i)])
        print(dummy_array)
    # začiatok evolucie
    for i in range(number_of_generations):
        if i == number_of_generations - 1:
            flag = 1
        # tu sa zapisujú výsledky
        kitten_result_array = []
        kitten_score_average = 0
        for kitten in kittens:
            kitten_data = kitten.start()
            kitten_result_array.append(kitten_data)
            kitten_score_average += kitten_data[0]

        # kitten_score_average = kitten_score_average / number_of_kittens

        # kitten_score_avg.append(kitten_score_average)

        # získame najlepších jedincov

        kitten_result_array = list(reversed(sorted(kitten_result_array)))
        top_kittens = kitten_result_array[:top_kitten_count]
        # ak chceme ruletovy vyber tak vyberieme náhodne z predpripravenej dummy array
        if pick == 2:
            top_kittens.clear()
            for i in range(top_kitten_count):
                top_kittens.append(kitten_result_array[random.choice(dummy_array)])

        kitten_score_top.append(top_kittens[0][0])

        kittens.clear()

        print(top_kittens[0][0])
        if top_kittens[0][0] == 114:
            break
        # vygenerujeme nových jedincov
        for i in range(len(top_kittens)):
            for j in range(len(top_kittens)):

                x = random.randint(0, number_of_positions - 1)
                # skombinujeme pozície dvoch jedincov
                newpositions = (
                    top_kittens[i][1][0:x]
                    + top_kittens[j][1][x : number_of_positions - 1]
                )
                # skombinujeme ich rozhodnutia
                # ak by sme chceli používať systém ponechania najlepšieho jedinca tak by sme toto odkomentovali
                dont_evolve = False
                """
                if i == j:
                    newsteps = top_kittens[i][2]
                    newpositions = top_kittens[i][1]
                    dont_evolve = True
                    """
                # vytvorím nového jedinca
                kittens.append(Kitten(newpositions, dont_evolve))

                if len(kittens) == number_of_kittens:
                    break
    # vytvorenie grafu
    plt.plot(kitten_score_top, label="top performer")
    # plt.plot(kitten_score_avg, label="average performance")
    plt.legend(loc="lower right")
    plt.show()
