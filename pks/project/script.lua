local my_protocol = Proto("myprotocol", "My Custom Protocol")

local f_flag = ProtoField.uint8("myprotocol.flag", "Flag", base.DEC, {
    [1] = "SYN",
    [2] = "SYN-ACK",
    [3] = "ACK",
    [4] = "PSH (Data)",
    [5] = "FIN",
    [6] = "NACK"
})
local f_fragment_num = ProtoField.uint16("myprotocol.fragment_num", "Fragment Number", base.DEC)
local f_fragment_total = ProtoField.uint16("myprotocol.fragment_total", "Fragment Total", base.DEC)
local f_message_len = ProtoField.uint8("myprotocol.message_len", "Message Length", base.DEC)
local f_message = ProtoField.string("myprotocol.message", "Message")
local f_checksum = ProtoField.uint16("myprotocol.checksum", "Checksum", base.HEX)

my_protocol.fields = {f_flag, f_fragment_num, f_fragment_total, f_message_len, f_message, f_checksum}

local udp_ports = {12345, 12346}

function my_protocol.dissector(buffer, pinfo, tree)
    if buffer:len() < 7 then return end 

    pinfo.cols.protocol = my_protocol.name

    local subtree = tree:add(my_protocol, buffer(), "My Protocol Data")

    local flag = buffer(0, 1):uint()
    subtree:add(f_flag, buffer(0, 1))

    local fragment_num = buffer(1, 2):uint()
    subtree:add(f_fragment_num, buffer(1, 2))

    local fragment_total = buffer(3, 2):uint()
    subtree:add(f_fragment_total, buffer(3, 2))

    local message_len = buffer(5, 1):uint()
    subtree:add(f_message_len, buffer(5, 1))

    local message = buffer(6, message_len):string()
    subtree:add(f_message, buffer(6, message_len))

    local checksum_offset = 6 + message_len
    local checksum = buffer(checksum_offset, 2):uint()
    subtree:add(f_checksum, buffer(checksum_offset, 2))

    if flag == 4 then
        pinfo.cols.info:set("Data Message")
        pinfo.cols.info:append(" (Len: " .. message_len .. ")")
        subtree:set_text("Data Message")
    else
        pinfo.cols.info:set("Overhead Message")
        subtree:set_text("Overhead Message")
    end
end

local udp_table = DissectorTable.get("udp.port")
for _, port in ipairs(udp_ports) do
    udp_table:add(port, my_protocol)
end

