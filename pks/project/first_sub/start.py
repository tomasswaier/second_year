import os
from multiprocessing import Pool

"""this code is used to start the program twice on the same machine """

port1 = "50602"
port2 = "50601"

processes = ([port1, port2], [port2, port1])


def run_process(ports):
    os.system("python3 client.py {} {}".format(ports[0], ports[1]))


pool = Pool(processes=2)
pool.map(run_process, processes)
