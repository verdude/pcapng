const std = @import("std");

const Direction = enum(u2) { na, inbound, outbound, _ };
const ReceptionType = enum(u3) {
    unspecified,
    unicast,
    multicast,
    broadcast,
    promiscuous,
    _,
};
const LinkErrors = enum(u16) {
    symbol = 31,
    preamble = 30,
    start_frame = 29,
    unaligned_frame = 28,
    wrong_inter_frame_gap = 27,
    packet_too_short = 26,
    packet_too_long = 25,
    crc = 24,
    _,
};
