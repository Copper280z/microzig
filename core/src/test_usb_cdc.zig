const std = @import("std");
const usb = @import("core/usb.zig");

const EpNum = usb.types.Endpoint.Num;
const CdcClassDriver = usb.drivers.cdc.CdcClassDriver;
const TestCdcDriver = CdcClassDriver(.{ .max_packet_size = 64 });

fn usb_cdc_write(serial: *TestCdcDriver, comptime fmt: []const u8, args: anytype) void {
    var usb_tx_buff: [1024]u8 = undefined;
    const text = std.fmt.bufPrint(&usb_tx_buff, fmt, args) catch &.{};

    var write_buff = text;
    while (write_buff.len > 0) {
        write_buff = serial.write(write_buff);
        // usb_dev.poll(); // our test interface does this automagically
    }
    // Short messages are not sent right away; instead, they accumulate in a buffer, so we have to force a flush to send them
    _ = serial.write_flush();
    // usb_dev.poll(); // our test interface does this automagically
}

test "cdc" {
    const device_descriptor = TestCdcDriver.Descriptor.create(1, 1, 6, 7);

    const TestInterface = struct {
        const vtable: usb.DeviceInterface.VTable = .{
            .start_tx = start_tx,
            .start_rx = start_rx,
            .set_address = set_address,
            .endpoint_open = endpoint_open,
        };
        host_rx_buf: [1024]u8 = undefined,
        host_rx_idx: usize = 0,
        interface: usb.DeviceInterface = .{ .vtable = &vtable },

        fn start_tx(itf: *usb.DeviceInterface, ep_num: EpNum, buffer: []const u8) void {
            _ = ep_num;
            const self: *@This() = @fieldParentPtr("interface", itf);
            const start = self.host_rx_idx;
            const end = start + buffer.len;
            @memcpy(self.host_rx_buf[start..end], buffer);
            self.host_rx_idx += buffer.len;
        }
        fn start_rx(itf: *usb.DeviceInterface, ep_num: EpNum, len: usize) void {
            _ = itf;
            _ = ep_num;
            _ = len;
        }
        fn endpoint_open(itf: *usb.DeviceInterface, desc: *const usb.descriptor.Endpoint) void {
            _ = itf;
            _ = desc;
        }
        fn set_address(itf: *usb.DeviceInterface, addr: u7) void {
            _ = itf;
            _ = addr;
        }
    };

    var test_itf: TestInterface = .{};
    // var itf = test_itf.interface();
    var cdc = TestCdcDriver.init(&device_descriptor, &test_itf.interface);
    _ = cdc.write_flush();
    const str = "This is very very long text sent from RP Pico by USB CDC to your device: 42\r\n";
    usb_cdc_write(&cdc, str, .{});
    try std.testing.expectEqualStrings(str, test_itf.host_rx_buf[0..str.len]);
}
