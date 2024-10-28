import socket
import gi
import sys
import struct
import threading

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib  # type:ignore

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

NAME = "Client" + ("1" if CLIENT_PORT < SERVER_PORT else "2")
OTHER_CLIENT_NAME = "Client" + ("1" if CLIENT_PORT > SERVER_PORT else "2")

client = None


class Client:
    def __init__(self, ip, port, server_ip, server_port) -> None:
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.bind((ip, port))
        self.server_ip = server_ip
        self.server_port = server_port
        self.read_thread = threading.Thread(
            target=self.recieve_loop,
        )
        self.last_message = None
        self.print_message = None
        self.read_messages = True
        self.read_thread.start()
        self.handshake()

    def recieve_loop(self):
        while self.read_messages:
            self.receive()

    def receive(self):
        try:
            data, _ = self.sock.recvfrom(512)
            return self.unpack_header(data)
        except BlockingIOError:
            return None, None
        except Exception:
            return None, None

    def send_message(
        self, message, flag=4, sequence_num=1, fragment_num=1, length=1, corrupt=False
    ):
        # dummymessage
        if corrupt == True:
            print("Corrupting")
        if message == "end":
            flag = 5
        # dummychecksum
        checksum = 0
        fragment = self.make_header(
            message, flag, sequence_num, fragment_num, length, checksum
        )
        print("sending:" + str(fragment))
        self.sock.sendto(fragment, (self.server_ip, self.server_port))

    def quit(self):
        self.sock.close()
        print("Client closed..")

    def make_header(
        self, message, flag=4, sequence_num=1, fragment_num=1, length=1, checksum=1
    ):
        """
        1=SYN
        2=SYN-ACK
        3=ACK
        4=PSH (data)
        5=FIN
        """
        frame = struct.pack("!B", flag)
        frame += struct.pack("!H", sequence_num)
        frame += struct.pack("!H", fragment_num)
        frame += struct.pack("!B", length)
        frame += struct.pack("!H", checksum)
        frame += message.encode("utf-8")

        return frame

    def unpack_header(self, data):
        flag = struct.unpack("!B", data[0:1])[0]
        sequence = struct.unpack("!H", data[1:3])[0]
        fragment_num = struct.unpack("!H", data[3:5])[0]
        length = struct.unpack("!B", data[5:6])[0]
        checksum = struct.unpack("!H", data[6:8])[0]
        message = data[8:].decode("utf-8")
        self.last_message = [flag, sequence, fragment_num, length, checksum, message]
        print("received:" + str(data))
        if flag == 4:
            self.send_message(message="ACK", flag=3)
            self.print_message = message
        elif flag == 5:
            self.send_message("end")
            self.quit()
        return [message, flag]

    def handshake(self):
        received_data = None

        if CLIENT_PORT < SERVER_PORT:
            self.send_message("SYN", 1)
            while received_data is None or received_data != 2:
                if self.last_message is not None:
                    received_data = self.last_message[0]
            print("Received SYN-ACK, sending ACK, connection initiated")
            self.send_message("ACK", 3)

        else:
            while received_data is None or received_data != 1:
                if self.last_message is not None:
                    received_data = self.last_message[0]

            print("Received SYN, sending SYN-ACK")
            self.send_message("SYN-ACK", 2)
            while received_data is None or received_data != 3:
                if self.last_message is not None:
                    received_data = self.last_message[0]

            print(
                "Received ACK, connection initiated\n-----------------------------------"
            )


class Window(Gtk.Window):
    def __init__(self):
        super().__init__(title=NAME)
        self.init_interface()
        GLib.idle_add(self.read_messages)

    def check_loop(self):
        while client and self.check_data_thread:
            client.receive()
            if client and client.print_message != None:
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
        self.entry.set_size_request(500, 40)
        self.entry.set_wrap_mode(1)
        button_send = Gtk.Button.new_with_label("Send")
        button_send.connect("clicked", self.send_message)
        self.checkbox = Gtk.CheckButton(label="")
        self.action_box.pack_start(self.entry, False, False, 0)
        self.action_box.pack_start(button_send, True, True, 0)
        self.action_box.pack_start(self.checkbox, True, True, 0)

        # put it all into main window (vbox)
        vbox.pack_start(self.filepicker, False, False, 10)
        vbox.pack_start(self.scrolled_window, True, True, 10)
        vbox.pack_start(self.action_box, False, False, 30)

        # GLib.timeout_add(1000, self.check_for_messages)  # Check every 100 ms

    def read_messages(self):
        if not client:
            print("client is None for some reason . EXITING")
            exit()
        message = client.print_message
        if message:
            self.print_message(message, OTHER_CLIENT_NAME)
            client.print_message = None
        return True

    def select_file(self, _):
        dialog = Gtk.FileChooserDialog(
            title="Please choose a file",
            parent=None,
            action=Gtk.FileChooserAction.OPEN,
            buttons=(
                Gtk.STOCK_CANCEL,
                Gtk.ResponseType.CANCEL,
                Gtk.STOCK_OPEN,
                Gtk.ResponseType.OK,
            ),
        )

        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            file_path = dialog.get_filename()
            # todo:finish this
            self.filename.set_text(file_path)
            print(file_path)
        elif response == Gtk.ResponseType.CANCEL:
            print("Cancel clicked")

        dialog.destroy()

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
        if text:
            client.send_message(text, 4, self.checkbox.get_active())  # type: ignore
            self.print_message(text, NAME)
            buffer.set_text("")

    def update_scrollbar(self):
        vadjustment = self.scrolled_window.get_vadjustment()
        vadjustment.set_value(vadjustment.get_upper())  # Scroll to the bottom


# Create client instance
try:
    client = Client(CLIENT_IP, CLIENT_PORT, SERVER_IP, SERVER_PORT)
except Exception as e:
    print(f"Failed to create client: {e}")
    exit(1)

# Start the GTK application
if __name__ == "__main__":
    try:
        win = Window()
        win.connect("destroy", Gtk.main_quit)
        win.show_all()
        Gtk.main()
    except Exception as e:
        print(f"An error occurred while starting the GUI: {e}")
    finally:
        client.quit()  # Ensure the client socket is closed properly
