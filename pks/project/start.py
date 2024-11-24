import os
from multiprocessing import Pool
from random import randint

"""this code is used to start the program twice on the same machine """


# port1 = str(randint(20000, 52000))
port1 = "12345"
port2 = str(int(port1) + 1)

processes = ([port1, port2], [port2, port1])


def run_process(ports):
    os.system("python3 client.py {} {}".format(ports[0], ports[1]))


pool = Pool(processes=2)
pool.map(run_process, processes)
