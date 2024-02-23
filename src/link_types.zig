pub const LinkType = enum(u16) {
    NULL = 0, // BSD loopback encapsulation
    ETHERNET = 1, // IEEE 802.3 Ethernet
    EXP_ETHERNET = 2, // Xerox experimental 3Mb Ethernet
    AX25 = 3, // AX.25 packet
    PRONET = 4, // Reserved for PRONET
    CHAOS = 5, // Reserved for MIT CHAOSNET
    IEEE802_5 = 6, // IEEE 802.5 Token Ring
    ARCNET_BSD = 7, // ARCNET Data Packets with BSD encapsulation
    SLIP = 8, // SLIP, w/SLIP header.
    PPP = 9, // PPP, as per RFC 1661/RFC 1662
    FDDI = 10, // FDDI: per ANSI INCITS 239-1994.
    //not to be used 11-49 Do not use these values
    PPP_HDLC = 50, // PPP in HDLC-like framing, as per RFC 1662
    PPP_ETHER = 51, // PPPoE; per RFC 2516
    //not to be used 52-98 Do not use these values
    SYMANTEC_FIREWALL = 99, // Reserved for Symantec Enterprise Firewall
    ATM_RFC1483 = 100, // RFC 1483 LLC/SNAP-encapsulated ATM
    RAW = 101, // Raw IP; begins with an IPv4 or IPv6 header
    SLIP_BSDOS = 102, // Reserved for BSD/OS SLIP BPF header
    PPP_BSDOS = 103, // Reserved for BSD/OS PPP BPF header
    C_HDLC = 104, // Cisco PPP with HDLC framing, as per section 4.3.1 of RFC 1547
    IEEE802_11 = 105, // IEEE 802.11 wireless LAN.
    ATM_CLIP = 106, // ATM Classical IP, with no header preceding IP
    FRELAY = 107, // Frame Relay LAPF frames
    LOOP = 108, // OpenBSD loopback encapsulation
    ENC = 109, // Reserved for OpenBSD IPSEC encapsulation
    LANE8023 = 110, // Reserved for ATM LANE + 802.3
    HIPPI = 111, // Reserved for NetBSD HIPPI
    HDLC = 112, // Reserved for NetBSD HDLC framing
    LINUX_SLL = 113, // Linux "cooked" capture encapsulation
    LTALK = 114, // Apple LocalTalk
    ECONET = 115, // Reserved for Acorn Econet
    IPFILTER = 116, // Reserved for OpenBSD ipfilter
    PFLOG = 117, // OpenBSD pflog; "struct pfloghdr" structure
    CISCO_IOS = 118, // Reserved for Cisco-internal use
    IEEE802_11_PRISM = 119, // Prism monitor mode
    IEEE802_11_AIRONET = 120, // Reserved for 802.11 + FreeFreeBSD Aironet radio metadata
    HHDLC = 121, // Reserved for Siemens HiPath HDLC
    IP_OVER_FC = 122, // RFC 2625 IP-over-Fibre Channel
    SUNATM = 123, // ATM traffic, / per SunATM devices
    RIO = 124, // Reserved for RapidIO
    PCI_EXP = 125, // Reserved for PCI Express
    AURORA = 126, // Reserved for Xilinx Aurora link layer
    IEEE802_11_RADIOTAP = 127, // Radiotap header[Radiotap], followed by an 802.11 header
    TZSP = 128, // Reserved for Tazmen Sniffer Protocol
    ARCNET_LINUX = 129, // ARCNET Data Packets, per RFC 1051 frames w/variations
    JUNIPER_MLPPP = 130, // Reserved for Juniper Networks
    JUNIPER_MLFR = 131, // Reserved for Juniper Networks
    JUNIPER_ES = 132, // Reserved for Juniper Networks
    JUNIPER_GGSN = 133, // Reserved for Juniper Networks
    JUNIPER_MFR = 134, // Reserved for Juniper Networks
    JUNIPER_ATM2 = 135, // Reserved for Juniper Networks
    JUNIPER_SERVICES = 136, // Reserved for Juniper Networks
    JUNIPER_ATM1 = 137, // Reserved for Juniper Networks
    APPLE_IP_OVER_IEEE1394 = 138, // Apple IP-over-IEEE 1394 cooked header
    MTP2_WITH_PHDR = 139, // Signaling System 7 (SS7) Message Transfer Part Level ITU-T Q.703
    MTP2 = 140, // SS7 Level 2, Q.703
    MTP3 = 141, // SS7 Level 3, Q.704
    SCCP = 142, // SS7 Control Part, ITU-T Q.711/Q.712/Q.713/Q.714
    DOCSIS = 143, // DOCSIS MAC frames, DOCSIS 3.1
    LINUX_IRDA = 144, // Linux-IrDA packets w/LINUX_IRDA header
    IBM_SP = 145, // Reserved for IBM SP switch
    IBM_SN = 146, // Reserved for IBM Next Federation switch
    RESERVED_01 = 147, // For private use
    RESERVED_02 = 148, // For private use
    RESERVED_03 = 149, // For private use
    RESERVED_04 = 150, // For private use
    RESERVED_05 = 151, // For private use
    RESERVED_06 = 152, // For private use
    RESERVED_07 = 153, // For private use
    RESERVED_08 = 154, // For private use
    RESERVED_09 = 155, // For private use
    RESERVED_10 = 156, // For private use
    RESERVED_11 = 157, // For private use
    RESERVED_12 = 158, // For private use
    RESERVED_13 = 159, // For private use
    RESERVED_14 = 160, // For private use
    RESERVED_15 = 161, // For private use
    RESERVED_16 = 162, // For private use
    IEEE802_11_AVS = 163, // AVS header[AVS], followed by an 802.11 header
    JUNIPER_MONITOR = 164, // Reserved for Juniper Networks
    BACNET_MS_TP = 165, // BACnet MS/TP frames, per 9.3 MS/TP Frame Format ANSI 135
    PPP_PPPD = 166, // PPP in HDLC-like encapsulation, like PPP_HDLC, different stuffing
    JUNIPER_PPPOE = 167, // Reserved for Juniper Networks
    JUNIPER_PPPOE_ATM = 168, // Reserved for Juniper Networks
    GPRS_LLC = 169, // General Packet Radio Service Logical Link Control, as per 3GPP TS 04.64
    GPF_T = 170, // Transparent-mapped generic framing procedure, as specified by ITU-T Recommendation G.7041/Y.1303
    GPF_F = 171, // Frame-mapped generic framing procedure, as specified by ITU-T Recommendation G.7041/Y.1303
    GCOM_T1E1 = 172, // Reserved for Gcom T1/E1 line monitoring equipment
    GCOM_SERIAL = 173, // Reserved for Gcom T1/E1 line monitoring equipment
    JUNIPER_PIC_PEER = 174, // Reserved for Juniper Networks
    ERF_ETH = 175, // Endace ERF header followed by 802.3 Ethernet
    ERF_POS = 176, // Endace ERF header followed by Packet-over-SONET
    LINUX_LAPD = 177, // Link Access Procedures on the D Channel (LAPD) frames, as specified by ITU-T Recommendation Q.920 and ITU-T Recommendation Q.921 , captured via vISDN, with a LINUX_LAPD header , followed by the Q.921 frame, starting with the address field.
    JUNIPER_ETHER = 178, // Reserved for Juniper Networks
    JUNIPER_PPP = 179, // Reserved for Juniper Networks
    JUNIPER_FRELAY = 180, // Reserved for Juniper Networks
    JUNIPER_CHDLC = 181, // Reserved for Juniper Networks
    MFR = 182, // FRF.16.1 Multi-Link Frame Relay frames, beginning with an FRF.12 Interface fragmentation format fragmentation header.
    // JUNIPER_VP = 182, // Reserved for Juniper Networks. Duplicate code for some reason?
    A653_ICM = 185, // Reserved for Arinc 653 Interpartition Communication messages
    USB_FREEBSD = 186, // USB packets, beginning with a FreeBSD USB header
    BLUETOOTH_HCI_H4 = 187, // Bluetooth HCI UART transport layer; the frame contains an HCI packet indicator byte, as specified by the UART Transport Layer portion of the most recent Bluetooth Core specification , followed by an HCI packet of the specified packet type, as specified by the Host Controller Interface Functional Specification portion of the most recent Bluetooth Core Specification.
    IEEE802_16_MAC_CPS = 188, // Reserved for IEEE 802.16 MAC Common Part Sublayer
    USB_LINUX = 189, // USB packets, beginning with a Linux USB header, as specified by the struct usbmon_packet in the Documentation/usb/usbmon.txt file in the Linux source tree. Only the first 48 bytes of that header are present. All fields in the header are in host byte order. When performing a live capture, the host byte order is the byte order of the machine on which the packets are captured. When reading a pcap file, the byte order is the byte order for the file, as specified by the file's magic number; when reading a pcapng file, the byte order is the byte order for the section of the pcapng file, as specified by the Section Header Block.
    CAN20B = 190, // Reserved for Controller Area Network (CAN) v. 2.0B packets
    IEEE802_15_4_LINUX = 191, // IEEE 802.15.4, with address fields padded, as is done by Linux drivers
    PPI = 192, // Per-Packet Information information, as specified by the Per-Packet Information Header Specification , followed by a packet with the value specified by the pph_dlt field of that header.
    IEEE802_16_MAC_CPS_RADIO = 193, // Reserved for 802.16 MAC Common Part Sublayer plus radio header
    JUNIPER_ISM = 194, // Reserved for Juniper Networks
    IEEE802_15_4_WITHFCS = 195, // IEEE 802.15.4 Low-Rate Wireless Networks, with each packet having the FCS at the end of the frame.
    SITA = 196, // Various link-layer types, with a pseudo-header , for SITA
    ERF = 197, // Various link-layer types, with a pseudo-header, for Endace DAG cards; encapsulates Endace ERF records.
    RAIF1 = 198, // Reserved for Ethernet packets captured from a u10 Networks board
    IPMB_KONTRON = 199, // Reserved for IPMB packet for IPMI, with a 2-byte header
    JUNIPER_ST = 200, // Reserved for Juniper Networks
    BLUETOOTH_HCI_H4_WITH_PHDR = 201, // Bluetooth HCI UART transport layer; the frame contains a 4-byte direction field, in network byte order (big-endian), the low-order bit of which is set if the frame was sent from the host to the controller and clear if the frame was received by the host from the controller, followed by an HCI packet indicator byte, as specified by the UART Transport Layer portion of the most recent Bluetooth Core specification , followed by an HCI packet of the specified packet type, as specified by the Host Controller Interface Functional Specification portion of the most recent Bluetooth Core Specification.
    AX25_KISS = 202, // AX.25 packet, with a 1-byte KISS header containing a type indicator.
    LAPD = 203, // Link Access Procedures on the D Channel (LAPD) frames, as specified by ITU-T Recommendation Q.920 and ITU-T Recommendation Q.921 , starting with the address field, with no pseudo-header.
    PPP_WITH_DIR = 204, // PPP, as per RFC 1661 and RFC 1662 , preceded with a one-byte pseudo-header with a zero value meaning received by this host and a non-zero value meaning sent by this host; if the first 2 bytes are 0xff and 0x03, it's PPP in HDLC-like framing, with the PPP header following those two bytes, otherwise it's PPP without framing, and the packet begins with the PPP header. The data in the frame is not octet-stuffed or bit-stuffed.
    C_HDLC_WITH_DIR = 205, // Cisco PPP with HDLC framing, as per section 4.3.1 of RFC 1547 , preceded with a one-byte pseudo-header with a zero value meaning received by this host and a non-zero value meaning sent by this host.
    FRELAY_WITH_DIR = 206, // Frame Relay LAPF frames, beginning with a one-byte pseudo-header with a zero value meaning received by this host (DCE->DTE) and a non-zero value meaning sent by this host (DTE->DCE), followed by an ITU-T Recommendation Q.922 LAPF header starting with the address field, and without an FCS at the end of the frame.
    LAPB_WITH_DIR = 207, // Link Access Procedure, Balanced (LAPB), as specified by ITU-T Recommendation X.25 , preceded with a one-byte pseudo-header with a zero value meaning received by this host (DCE->DTE) and a non-zero value meaning sent by this host (DTE->DCE).
    Reserved = 208, // Reserved for an unspecified link-layer type
    IPMB_LINUX = 209, // IPMB over an I2C circuit, with a Linux-specific pseudo-header
    FLEXRAY = 210, // Reserved for FlexRay automotive bus
    MOST = 211, // Reserved for Media Oriented Systems Transport (MOST) bus
    LIN = 212, // Reserved for Local Interconnect Network (LIN) bus for vehicle networks
    X2E_SERIAL = 213, // Reserved for X2E serial line captures
    X2E_XORAYA = 214, // Reserved for X2E Xoraya data loggers
    IEEE802_15_4_NONASK_PHY = 215, // IEEE 802.15.4 Low-Rate Wireless Networks, with each packet having the FCS at the end of the frame, and with the PHY-level data for the O-QPSK, BPSK, GFSK, MSK, and RCC DSS BPSK PHYs (4 octets of 0 as preamble, one octet of SFD, one octet of frame length + reserved bit) preceding the MAC-layer data (starting with the frame control field).
    LINUX_EVDEV = 216, // Reserved for Linux evdev messages
    GSMTAP_UM = 217, // Reserved for GSM Um interface, with gsmtap header
    GSMTAP_ABIS = 218, // Reserved for GSM Abis interface, with gsmtap header
    MPLS = 219, // MPLS packets with MPLS label as the header
    USB_LINUX_MMAPPED = 220, // USB packets, beginning with a Linux USB header, as specified by the struct usbmon_packet in the Documentation/usb/usbmon.txt file in the Linux source tree. All 64 bytes of the header are present. All fields in the header are in host byte order. When performing a live capture, the host byte order is the byte order of the machine on which the packets are captured. When reading a pcap file, the byte order is the byte order for the file, as specified by the file's magic number; when reading a pcapng file, the byte order is the byte order for the section of the pcapng file, as specified by the Section Header Block. For isochronous transfers, the ndesc field specifies the number of isochronous descriptors that follow.
    DECT = 221, // Reserved for DECT packets, with a pseudo-header
    AOS = 222, // Reserved for OS Space Data Link Protocol
    WIHART = 223, // Reserved for Wireless HART (Highway Addressable Remote Transducer)
    FC_2 = 224, // Fibre Channel FC-2 frames, beginning with a Frame_Header.
    FC_2_WITH_FRAME_DELIMS = 225, // Fibre Channel FC-2 frames, beginning an encoding of the SOF, followed by a Frame_Header, and ending with an encoding of the SOF. The encodings represent the frame delimiters as 4-byte sequences representing the corresponding ordered sets, with K28.5 represented as 0xBC, and the D symbols as the corresponding byte values; for example, SOFi2, which is K28.5 - D21.5 - D1.2 - D21.2, is represented as 0xBC 0xB5 0x55 0x55.
    IPNET = 226, // Solaris ipnet pseudo-header , followed by an IPv4 or IPv6 datagram.
    CAN_SOCKETCAN = 227, // CAN (Controller Area Network) frames, with a pseudo-header followed by the frame payload.
    IPV4 = 228, // Raw IPv4; the packet begins with an IPv4 header.
    IPV6 = 229, // Raw IPv6; the packet begins with an IPv6 header.
    IEEE802_15_4_NOFCS = 230, // IEEE 802.15.4 Low-Rate Wireless Network, without the FCS at the end of the frame.
    DBUS = 231, // Raw D-Bus messages , starting with the endianness flag, followed by the message type, etc., but without the authentication handshake before the message sequence.
    JUNIPER_VS = 232, // Reserved for Juniper Networks
    JUNIPER_SRX_E2E = 233, // Reserved for Juniper Networks
    JUNIPER_FIBRECHANNEL = 234, // Reserved for Juniper Networks
    DVB_CI = 235, // DVB-CI (DVB Common Interface for communication between a PC Card module and a DVB receiver), with the message format specified by the PCAP format for DVB-CI specification
    MUX27010 = 236, // Variant of 3GPP TS 27.010 multiplexing protocol (similar to, but not the same as, 27.010).
    STANAG_5066_D_PDU = 237, // D_PDUs as described by NATO standard STANAG 5066, starting with the synchronization sequence, and including both header and data CRCs. The current version of STANAG 5066 is backwards-compatible with the 1.0.2 version , although newer versions are classified.
    JUNIPER_ATM_CEMIC = 238, // Reserved for Juniper Networks
    NFLOG = 239, // Linux netlink NETLINK NFLOG socket log messages.
    NETANALYZER = 240, // Pseudo-header for Hilscher Gesellschaft fuer Systemautomation mbH netANALYZER devices , followed by an Ethernet frame, beginning with the MAC header and ending with the FCS.
    NETANALYZER_TRANSPARENT = 241, // Pseudo-header for Hilscher Gesellschaft fuer Systemautomation mbH netANALYZER devices , followed by an Ethernet frame, beginning with the preamble, SFD, and MAC header, and ending with the FCS.
    IPOIB = 242, // IP-over-InfiniBand, as specified by RFC 4391 section 6
    MPEG_2_TS = 243, // MPEG-2 Transport Stream transport packets, as specified by ISO 13818-1/ ITU-T Recommendation H.222.0 (see table 2-2 of section 2.4.3.2 Transport Stream packet layer).
    NG40 = 244, // Pseudo-header for ng4T GmbH's UMTS Iub/Iur-over-ATM and Iub/Iur-over-IP format as used by their ng40 protocol tester , followed by frames for the Frame Protocol as specified by 3GPP TS 25.427 for dedicated channels and 3GPP TS 25.435 for common/shared channels in the case of ATM AAL2 or UDP traffic, by SSCOP packets as specified by ITU-T Recommendation Q.2110 for ATM AAL5 traffic, and by NBAP packets for SCTP traffic.
    NFC_LLCP = 245, // Pseudo-header for NFC LLCP packet captures , followed by frame data for the LLCP Protocol as specified by NFCForum-TS-LLCP_1.1
    PFSYNC = 246, // Reserved for pfsync output
    INFINIBAND = 247, // Raw InfiniBand frames, starting with the Local Routing Header, as specified in Chapter 5 Data packet format of InfiniBand[TM] Architectural Specification Release 1.2.1 Volume 1 - General Specifications
    SCTP = 248, // SCTP packets, as defined by RFC 4960 , with no lower-level protocols such as IPv4 or IPv6.
    USBPCAP = 249, // USB packets, beginning with a USBPcap header
    RTAC_SERIAL = 250, // Serial-line packet header for the Schweitzer Engineering Laboratories RTAC product , followed by a payload for one of a number of industrial control protocols.
    BLUETOOTH_LE_LL = 251, // Bluetooth Low Energy air interface Link Layer packets, in the format described in section 2.1 PACKET FORMAT of volume 6 of the Bluetooth Specification Version 4.0 (see PDF page 2200), but without the Preamble.
    WIRESHARK_UPPER_PDU = 252, // Reserved for Wireshark
    NETLINK = 253, // Linux Netlink capture encapsulation
    BLUETOOTH_LINUX_MONITOR = 254, // Bluetooth Linux Monitor encapsulation of traffic for the BlueZ stack
    BLUETOOTH_BREDR_BB = 255, // Bluetooth Basic Rate and Enhanced Data Rate baseband packets
    BLUETOOTH_LE_LL_WITH_PHDR = 256, // Bluetooth Low Energy link-layer packets
    PROFIBUS_DL = 257, // PROFIBUS data link layer packets, as specified by IEC standard 61158-4-3, beginning with the start delimiter, ending with the end delimiter, and including all octets between them.
    PKTAP = 258, // Apple PKTAP capture encapsulation
    EPON = 259, // Ethernet-over-passive-optical-network packets, starting with the last 6 octets of the modified preamble as specified by 65.1.3.2 Transmit in Clause 65 of Section 5 of IEEE 802.3 , followed immediately by an Ethernet frame.
    IPMI_HPM_2 = 260, // IPMI trace packets, as specified by Table 3-20 Trace Data Block Format in the PICMG HPM.2 specification The time stamps for packets in this format must match the time stamps in the Trace Data Blocks.
    ZWAVE_R1_R2 = 261, // Z-Wave RF profile R1 and R2 packets , as specified by ITU-T Recommendation G.9959 , with some MAC layer fields moved.
    ZWAVE_R3 = 262, // Z-Wave RF profile R3 packets , as specified by ITU-T Recommendation G.9959 , with some MAC layer fields moved.
    WATTSTOPPER_DLM = 263, // Formats for WattStopper Digital Lighting Management (DLM) and Legrand Nitoo Open protocol common packet structure captures.
    ISO_14443 = 264, // Messages between ISO 14443 contactless smartcards (Proximity Integrated Circuit Card, PICC) and card readers (Proximity Coupling Device, PCD), with the message format specified by the PCAP format for ISO14443 specification
    RDS = 265, // Radio data system (RDS) groups, as per IEC 62106, encapsulated in this form
    USB_DARWIN = 266, // USB packets, beginning with a Darwin (macOS, etc.) USB header
    OPENFLOW = 267, // Reserved for OpenBSD DLT_OPENFLOW
    SDLC = 268, // SDLC packets, as specified by Chapter 1, DLC Links, section Synchronous Data Link Control (SDLC) of Systems Network Architecture Formats, GA27-3136-20 , without the flag fields, zero-bit insertion, or Frame Check Sequence field, containing SNA path information units (PIUs) as the payload.
    TI_LLN_SNIFFER = 269, // Reserved for Texas Instruments protocol sniffer
    LORATAP = 270, // LoRaTap pseudo-header , followed by the payload, which is typically the PHYPayload from the LoRaWan specification
    VSOCK = 271, // Protocol for communication between host and guest machines in VMware and KVM hypervisors.
    NORDIC_BLE = 272, // Messages to and from a Nordic Semiconductor nRF Sniffer for Bluetooth LE packets, beginning with a pseudo-header
    DOCSIS31_XRA31 = 273, // DOCSIS packets and bursts, preceded by a pseudo-header giving metadata about the packet
    ETHERNET_MPACKET = 274, // mPackets, as specified by IEEE 802.3br Figure 99-4, starting with the preamble and always ending with a CRC field.
    DISPLAYPORT_AUX = 275, // DisplayPort AUX channel monitoring data as specified by VESA DisplayPort(DP) Standard preceded by a pseudo-header
    LINUX_SLL2 = 276, // Linux cooked capture encapsulation v2
    SERCOS_MONITOR = 277, // Reserved for Sercos Monitor
    OPENVIZSLA = 278, // Openvizsla FPGA-based USB sniffer
    EBHSCR = 279, // Elektrobit High Speed Capture and Replay (EBHSCR) format
    VPP_DISPATCH = 280, // Records in traces from the http://fd.io VPP graph dispatch tracer, in the the graph dispatcher trace format
    DSA_TAG_BRCM = 281, // Ethernet frames, with a switch tag inserted between the source address field and the type/length field in the Ethernet header.
    DSA_TAG_BRCM_PREPEND = 282, // Ethernet frames, with a switch tag inserted before the destination address in the Ethernet header.
    IEEE802_15_4_TAP = 283, // IEEE 802.15.4 Low-Rate Wireless Networks, with a pseudo-header containing TLVs with metadata preceding the 802.15.4 header.
    DSA_TAG_DSA = 284, // Ethernet frames, with a switch tag inserted between the source address field and the type/length field in the Ethernet header.
    DSA_TAG_EDSA = 285, // Ethernet frames, with a programmable Ethernet type switch tag inserted between the source address field and the type/length field in the Ethernet header.
    ELEE = 286, // Payload of lawful intercept packets using the ELEE protocol The packet begins with the ELEE header; it does not include any transport-layer or lower-layer headers for protcols used to transport ELEE packets.
    Z_WAVE_SERIAL = 287, // Serial frames transmitted between a host and a Z-Wave chip over an RS-232 or USB serial connection, as described in section 5 of the Z-Wave Serial API Host Application Programming Guide
    USB_2_0 = 288, // USB 2.0, 1.1, or 1.0 packet, beginning with a PID, as described by Chapter 8 Protocol Layer of the the Universal Serial Bus Specification Revision 2.0
    ATSC_ALP = 289, // ATSC Link-Layer Protocol frames, as described in section 5 of the A/330 Link-Layer Protocol specification, found at the ATSC 3.0 standards page , beginning with a Base Header
};
