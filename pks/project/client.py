import socket
import gi
import sys
import struct
import threading

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib

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


client = None


class Client:
    def __init__(self, ip, port, server_ip, server_port) -> None:
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.bind((ip, port))
        self.server_ip = server_ip
        self.server_port = server_port
        self.sock.settimeout(0.00000001)
        self.handshake()
        self.print_message = None

    def receive(self):
        try:
            data, _ = self.sock.recvfrom(511)
            return self.unpack_header(data)
        except BlockingIOError:
            return None, None
        except Exception:
            return None, None

    def send_message(self, message, flag, corrupt=False):
        # dummymessage
        if corrupt == True:
            print("Corrupting")
        fragment = self.make_header(message, flag=flag)
        print(fragment)
        self.sock.sendto(fragment, (self.server_ip, self.server_port))

    def send_response(self):
        self.sock.sendto(b"Message Received", (self.server_ip, self.server_port))

    def quit(self):
        self.sock.close()
        print("Client closed..")

    def handshake(self):
        received_data = None
        while True:
            self.send_message("SYN", 1)
            received_data = self.receive()
            if received_data and received_data[1] == 1:
                print("Recieved SYN ,sending SYN-ACK")
                self.send_message("SYN-ACK", 2)
                received_data = None
                while not received_data or received_data and received_data[1] != 3:
                    received_data = self.receive()

                print("Recieved ACK ,connection initiated")
                break
            elif received_data and received_data[1] == 2:
                print("received SYN-ACK , sendgin ACK , conversationg initiated")
                self.send_message("ACK", 3)
                break

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
        prefix_byte = struct.unpack("!B", data[0:1])[0]
        sequence = struct.unpack("!H", data[1:3])[0]
        fragment_num = struct.unpack("!H", data[3:5])[0]
        length = struct.unpack("!B", data[5:6])[0]
        checksum = struct.unpack("!H", data[6:8])[0]
        message = data[8:].decode("utf-8")
        if prefix_byte == 4:
            self.print_message = message
            print(message)
        return [message, prefix_byte]


class Window(Gtk.Window):
    def __init__(self):
        super().__init__(title="Client")
        self.init_interface()
        self.name = "Client"
        self.check_data_thread = True
        self.check_thread = threading.Thread(
            target=self.check_loop,
        )
        self.check_thread.start()

    def check_loop(self):
        while client and self.check_data_thread:
            client.receive()
            if client and client.print_message != None:
                self.print_message(client.print_message, "Client2")
                client.print_message = None

    def init_interface(self):
        self.set_size_request(600, 800)
        # Main box
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)

        # file select:
        self.filepicker = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.filename = Gtk.Label(label="No File")
        self.filepicker.set_size_request(500, 40)
        pick_file = Gtk.Button.new_with_label("File")
        pick_file.connect("clicked", self.select_file)
        self.filepicker.pack_start(self.filename, True, True, 0)
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

        # This is where messages will go
        self.scrolled_window = Gtk.ScrolledWindow()
        self.message_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.scrolled_window.add_with_viewport(self.message_box)
        # put it all into main window (vbox)
        vbox.pack_start(self.filepicker, True, True, 10)
        vbox.pack_start(self.scrolled_window, True, True, 10)
        vbox.pack_start(self.action_box, False, False, 30)

        # GLib.timeout_add(1000, self.check_for_messages)  # Check every 100 ms

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
            self.print_message(text, self.name)
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
