import logging
import socket
import struct
import sys
import threading
import time

import gi

"""DO NOT TRY TO PUT IT INTO MULTIPLE FILES . I TRIED .... """
gi.require_version("Gtk", "3.0")
from gi.repository import GLib, Gtk

if len(sys.argv) > 1:
    CLIENT_IP = "127.0.0.1"
    CLIENT_PORT = int(sys.argv[1])
    SERVER_IP = "127.0.0.1"
    SERVER_PORT = int(sys.argv[2])
else:
    CLIENT_IP = input("client ip:")
    CLIENT_PORT = int(input("client port:"))
    SERVER_IP = input("peer ip:")
    SERVER_PORT = int(input("peer port:"))
# setting these variables to be global for linter errors
NAME = "Client" + ("1" if CLIENT_PORT < SERVER_PORT else "2")
OTHER_CLIENT_NAME = "Client" + ("1" if CLIENT_PORT > SERVER_PORT else "2")
client = None
logger = logging.getLogger()
logging.basicConfig(filename="test_files/logclient.log", level=logging.INFO)
# base packet length
# time for timeout packet to send itself
TIMEOUT_TIME = 30  # todo :change to 5


def log(message):
    print(message)
    logger.info(message)


class Client:
    def __init__(self, ip: str, port: int, server_ip: str, server_port: int) -> None:
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.bind((ip, port))
        self.server_ip = server_ip
        self.server_port = server_port
        self.read_thread = threading.Thread(
            target=self.recieve_loop,
        )
        """
        last_message holds last message recieved . It can be used to
        kcheck for ack pacets, nack , finish idk.

        print_message serves one purpose and that is to keep
        inside messages that are supposed to be printed on client.
        The window is constantly listeninng to messages on this variable
        """
        self.message_event = threading.Event()
        self.read_thread_running = True
        self.packet_size = 255
        self.package = []  # long message
        self.package_name = None
        self.package_time = None
        self.last_message = None  # last message recieved
        self.print_message = None  # message to be printed
        self.timeout = [time.time(), 0]  # a thing for timeout
        self.send_timeout = None
        self.read_thread.start()  # thread that's always listening
        self.handshake()  # what do u think ?
        self.chosen_filepath = False

    def send_message(
        self,
        message="",  # the actual message
        flag=4,  # flag that can be from 1 to 6 so far
        fragment_num=1,  # frag_num
        fragment_total=1,  # total num of fragments
        corrupt=False,
        wait_for_response=True,
    ):
        # todo: fix
        if message == "end" or message == "exit":
            flag = 5
        """the below is code i need to add + fix
        checksum = self.crc16(str.encode(message))
        if corrupt:
            checksum += 1
        I am using placeholder for flag==4 because
        it insists on there being a message
        """
        filename = None
        start = 1
        if flag != 4:
            message = "placeholder"
        else:
            """
            when sending long_message (package) if it's plain
            text we start from 1 else it's a file and we start
            from 0 where 0th fragment_num is filename
            """
            if isinstance(message, list):
                filename = message[0]
                message = message[1]
                start = 0
        if isinstance(message, str):
            message = message.encode()
        # -8 because header
        fragments = [
            message[i : i + self.packet_size - 8]
            for i in range(0, len(message), self.packet_size - 8)
        ]
        if filename:
            fragments.insert(0, filename.encode())
        fragment_total = len(fragments)

        for fragment_index, fragment_data in enumerate(fragments, start=start):
            expected_number = 0
            if fragment_total == 1:
                expected_number = len(message)
            else:
                """logic : we send first fragment with str fileanme
                if we're sending file else we send fragment num 0 bcs
                we're sending really long message?
                """
                expected_number = fragment_index
                fragment_num = fragment_index

            fragment = self.make_header(
                message=fragment_data,
                flag=flag,
                fragment_num=fragment_num,
                fragment_total=fragment_total,
                corrupt=corrupt,
            )
            # log("sending:" + str(fragment))
            # this part makes sure that data gets delivered

            if flag == 4 and wait_for_response:
                """
                log(
                    f"Odosielací uzol :{filename}; file/message size {len(message)}; fragment size:{len(fragment)}; fragment index:{fragment_index};"
                )
                """
                response = None
                while not response:
                    for i in range(3):
                        self.sock.sendto(fragment, (self.server_ip, self.server_port))
                        log(
                            f"Odosielací uzol :{filename}; file/message size {len(message)}; fragment size:{len(fragment)}; fragment index:{fragment_index};"
                        )
                        response = self.wait_for_response(
                            expected_number=expected_number
                        )
                        if response:
                            break
                    if not response:
                        self.quit()

                    # if the response is ACK we break out of the loop
                    if response and response == 3:
                        log("received ack packet")
                        break
                    elif response == 6:
                        # elif the response is NACK we rebuild the frame
                        log("redoing fragment")
                        fragment = self.make_header(
                            message=fragment_data,
                            flag=flag,
                            fragment_num=fragment_num,
                            fragment_total=fragment_total,
                            corrupt=False,
                        )
                        log("sending:" + str(fragment))
                        # make new message

                    response = None
            else:
                log("sending:" + str(fragment))
                try:
                    self.sock.sendto(fragment, (self.server_ip, self.server_port))
                except OSError as e:
                    log(str(e))

    def wait_for_response(self, expected_number, wait_time=5):
        self.message_event.clear()
        start_time = time.time()
        while time.time() - start_time < wait_time:
            # todo: huh ???
            if self.message_event.wait(timeout=wait_time - (time.time() - start_time)):
                if (
                    self.last_message
                    and self.last_message[0] in [3, 6]
                    and self.last_message[1] == expected_number
                ):
                    response_flag = self.last_message
                    self.last_message = None  # Clear message
                    return response_flag[0]
        return None

    def make_header(
        self, message: bytes, flag=4, fragment_num=1, fragment_total=1, corrupt=False
    ):
        """
        Makes header in very clear way with these flag options
        1=SYN
        2=SYN-ACK
        3=ACK
        4=PSH (data)
        5=FIN
        6=NACK
        """
        if flag != 4:
            message = "".encode()
        frame = struct.pack("!B", flag)
        frame += struct.pack("!H", fragment_num)
        frame += struct.pack("!H", fragment_total)
        frame += struct.pack("!B", len(message))
        frame += message
        checksum = self.crc16(frame)

        if corrupt:
            checksum += 1 if int(checksum) < 50000 else -1
        frame += struct.pack("!H", checksum)

        return frame

    def crc16(self, data):
        crc = 0xFFFF
        for byte in data:
            crc ^= byte << 8
            for _ in range(8):
                if crc & 0x8000:
                    crc = (crc << 1) ^ 0x1021
                else:
                    crc <<= 1

                crc &= 0xFFFF

        return crc

    def check_checksum(self, data):
        return self.crc16(data) == 0

    def unpack_header(self, data):
        """we unpack the message but if the flag is 4
        we make sure it gets delivered ( prob should
        have this on everything but whatevs uwu
        """
        flag = struct.unpack("!B", data[0:1])[0]
        fragment_num = struct.unpack("!H", data[1:3])[0]
        fragment_total = struct.unpack("!H", data[3:5])[0]
        length = struct.unpack("!B", data[5:6])[0]
        message = None
        if fragment_total != 1:
            message = data[6:-2]
        else:
            message = data[6:-2].decode()
            self.last_message = [flag, fragment_num, fragment_total, length, message]
        # unpacks the message and puts all the available data into last_message variable
        # log("{} {}".format(fragment_num, struct.unpack("!B", data[5:6])[0]))

        if flag == 4:
            """
            when sending message it expects ACK to somehow identify
            itself as to which packet it's acknowledging so I take
            the expected number ( length)  and use it as fragment_num.
            Problems might arrise in file transfer.
            """
            acceptance_code = length if fragment_total == 1 else fragment_num
            # if passeses we respond with ack else we ask for it again
            response_flag = 3 if self.check_checksum(data[:]) else 6
            log(
                f"Príjmací uzol: fragment num:{fragment_num}; is corrupt:{response_flag == 6}; "
            )
            self.send_message(
                message="", fragment_num=acceptance_code, flag=response_flag
            )

            if response_flag == 3 and fragment_total > 1:
                if fragment_num == fragment_total:
                    self.package.append(message)
                    self.print_message = b"".join(self.package).decode()
                    self.package = []
                    self.package_name = None
                elif (
                    fragment_num + 1 == fragment_total and self.package_name is not None
                ):
                    self.package.append(message)
                    # Open the file and write the accumulated package data
                    self.chosen_filepath = False

                    with open(self.package_name, "wb") as file:
                        data = b"".join(self.package)
                        file.write(data)
                    # log(data)
                    log("file saved: " + self.package_name)
                    # Clear the package list after writing
                    self.package = []
                    self.print_message = (
                        "You've received a file: "
                        + self.package_name
                        + "length: "
                        + str(len(message))
                        + "time to send :"
                        + str(time.time() - self.package_time)
                    )
                    self.package_name = None

                else:
                    if fragment_num == 0:
                        self.chosen_filepath = True
                        self.package_time = time.time()
                        self.package_name = "output" + message.decode().split("/")[-1]
                    else:
                        self.package.append(message)
            elif response_flag == 3:
                self.print_message = message
        elif flag == 5:  # This flag represents "end" or exit condition
            self.quit()
        else:
            log("received:" + str(data))
        self.message_event.set()
        return [message, flag]

    def quit(self):
        self.send_message("end")
        self.read_thread_running = False
        self.sock.close()
        log("Client closed " + NAME)
        GLib.idle_add(Gtk.main_quit)

    def recieve_loop(self):
        """
        receiver rool will unpack everything and then put it to last variable
        todo: make it thread safe
        """
        while self.read_thread_running:
            self.receive()

    def timeout_check(self):
        if self.timeout[0] + 5 < time.time():
            # log("{} , {}".format(self.timeout[0] + 5, time.time()))
            self.send_timeout = "timeout"
            self.timeout[0] = time.time()
            self.timeout[1] += 1
            if self.timeout[1] == 4:
                self.quit()

    def receive(self):
        try:
            data, _ = self.sock.recvfrom(self.packet_size)
            self.timeout = [time.time(), 0]
            return self.unpack_header(data)
        except BlockingIOError:
            return None, None
        except Exception:
            return None, None

    def handshake(self):
        """preferably don't touch , we are working on 2
        ports hence one has to be lower so we set one of
        them to be listener and the other to be sender .
        """
        received_data = None
        if CLIENT_PORT < SERVER_PORT:

            while received_data is None or received_data != 2:
                self.send_message("", 1)
                time.sleep(0.5)
                if self.last_message is not None:
                    received_data = self.last_message[0]
            log("Received SYN-ACK, sending ACK, connection initiated")
            self.send_message("", 3)

        else:
            while received_data is None or received_data != 1:
                if self.last_message is not None:
                    received_data = self.last_message[0]

            log("Received SYN, sending SYN-ACK")
            self.send_message("", 2)
            while received_data is None or received_data != 3:
                if self.last_message is not None:
                    received_data = self.last_message[0]

            log(
                "Received ACK, connection initiated\n----------------------------------"
            )


class Window(Gtk.Window):
    def __init__(self):
        super().__init__(title=NAME)
        self.init_interface()
        GLib.idle_add(self.read_messages)

    def check_loop(self):
        while client and self.check_data_thread:
            if client and client.print_message is not None:
                self.print_message(client.print_message, OTHER_CLIENT_NAME)
                client.print_message = None

    def init_interface(self):
        self.set_size_request(600, 800)
        # Main box
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)
        # Message Area
        self.scrolled_window = Gtk.ScrolledWindow()
        self.message_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.scrolled_window.add(self.message_box)

        # file select:
        self.filepicker = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.filename = Gtk.Label(label="No File")
        self.filepicker.set_size_request(500, 40)
        pick_file = Gtk.Button.new_with_label("File")
        pick_file.connect("clicked", self.select_file)
        self.filepicker.pack_start(self.filename, True, False, 0)
        self.filepicker.pack_start(pick_file, False, False, 0)
        # Text area
        self.action_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.entry = Gtk.TextView()
        self.entry.set_size_request(470, 40)
        self.entry.set_wrap_mode(1)
        adjustment = Gtk.Adjustment(
            value=255,
            lower=10,
            upper=255,
            step_increment=1,
            page_increment=5,
        )
        self.size_entry = Gtk.SpinButton(adjustment=adjustment)
        self.size_entry.set_range(10, 255)
        self.size_entry.set_size_request(30, 40)
        button_send = Gtk.Button.new_with_label("Send")
        button_send.connect("clicked", self.send_message)
        self.checkbox = Gtk.CheckButton(label="")
        self.action_box.pack_start(self.entry, True, True, 0)
        self.action_box.pack_start(button_send, False, False, 0)
        self.action_box.pack_start(self.checkbox, False, False, 0)
        self.action_box.pack_start(self.size_entry, False, False, 0)

        # put it all into main window (vbox)
        vbox.pack_start(self.filepicker, False, False, 10)
        vbox.pack_start(self.scrolled_window, True, True, 10)
        vbox.pack_start(self.action_box, False, False, 30)

        # GLib.timeout_add(1000, self.check_for_messages)  # Check every 100 ms

    def read_messages(self):
        if not client:
            log("client is None for some reason . EXITING")
            exit()
        message = client.print_message
        client.timeout_check()
        send_timeout = client.send_timeout
        if send_timeout:
            client.send_message(
                message=send_timeout, flag=4, fragment_total=0, wait_for_response=False
            )
            client.send_timeout = ""

        if message:
            self.print_message(message, OTHER_CLIENT_NAME)
            client.print_message = None
        if client.package_name and client.chosen_filepath:
            filepath = None
            filepath = self.select_file(0, called=True)
            if filepath:
                client.package_name = filepath + "/" + client.package_name
                client.chosen_filepath = False
                log(filepath)
        return True

    def select_file(self, _, called=False):
        action = (
            Gtk.FileChooserAction.SELECT_FOLDER
            if called
            else Gtk.FileChooserAction.OPEN
        )
        dialog = Gtk.FileChooserDialog(
            title="Please choose a folder" if called else "Please choose a file",
            parent=None,
            action=action,
            buttons=(
                Gtk.STOCK_CANCEL,
                Gtk.ResponseType.CANCEL,
                Gtk.STOCK_OPEN,
                Gtk.ResponseType.OK,
            ),
        )

        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            selected_path = dialog.get_filename()
            if called:
                log(selected_path)
                dialog.destroy()
                return selected_path
            else:
                self.filename.set_text(selected_path)
            log("Selected: " + selected_path)
        elif response == Gtk.ResponseType.CANCEL:
            log("Cancel clicked")

        dialog.destroy()
        if called:
            return None

    def print_message(self, text, name):
        mylabel = Gtk.Label()
        mylabel.set_text(text)
        self.message_box.pack_start(mylabel, False, False, 0)
        self.message_box.show_all()
        separator = Gtk.Label()
        separator.set_text(
            "---------------------------------------------------\nSender: " + name
        )
        self.message_box.pack_start(separator, False, False, 0)
        self.message_box.show_all()
        self.update_scrollbar()

    def send_message(self, _):
        buffer = self.entry.get_buffer()
        text = buffer.get_text(buffer.get_start_iter(), buffer.get_end_iter(), False)
        # setting the packet size
        packet_size = self.size_entry.get_value_as_int()
        client.packet_size = packet_size
        file = self.filename.get_text()
        if file == "No File":
            file = None

        if (text and not file) or (file and not text):
            if file:
                with open(file, "rb") as f:
                    file_content = f.read()
                # Create a list with filename and file content in binary form
                text = [file, file_content]
            client.send_message(
                message=text, flag=4, corrupt=self.checkbox.get_active()
            )
            self.print_message(text if file is None else file, NAME)
            buffer.set_text("")
            self.filename.set_text("No File")

    def update_scrollbar(self):
        vadjustment = self.scrolled_window.get_vadjustment()
        vadjustment.set_value(vadjustment.get_upper())  # Scroll to the bottom


# Create client instance
try:
    client = Client(CLIENT_IP, CLIENT_PORT, SERVER_IP, SERVER_PORT)
except Exception as e:
    log(f"Failed to create client: {e}")
    exit(1)


# Start the GTK application
if __name__ == "__main__":
    try:
        win = Window()
        win.connect("destroy", Gtk.main_quit)
        win.show_all()
        Gtk.main()
    except Exception as e:
        log(f"An error occurred while starting the GUI: {e}")
    finally:
        client.quit()  # Ensure the client socket is closed properly
