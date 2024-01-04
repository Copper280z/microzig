const std = @import("std");
const rp2040 = @import("rp2040");

const available_examples = [_]Example{
    .{ .name = "pico_adc", .target = rp2040.boards.raspberry_pi.pico, .file = "src/adc.zig" },
    .{ .name = "pico_blinky", .target = rp2040.boards.raspberry_pi.pico, .file = "src/blinky.zig" },
    // TODO: Fix multicore hal! .{ .name = "pico", .target = rp2040.boards.raspberry_pi.pico , .file = "src/blinky_core1.zig" },
    .{ .name = "pico_flash-program", .target = rp2040.boards.raspberry_pi.pico, .file = "src/flash_program.zig" },
    .{ .name = "pico_gpio-clk", .target = rp2040.boards.raspberry_pi.pico, .file = "src/gpio_clk.zig" },
    .{ .name = "pico_i2c-bus-scan", .target = rp2040.boards.raspberry_pi.pico, .file = "src/i2c_bus_scan.zig" },
    .{ .name = "pico_pwm", .target = rp2040.boards.raspberry_pi.pico, .file = "src/pwm.zig" },
    .{ .name = "pico_random", .target = rp2040.boards.raspberry_pi.pico, .file = "src/random.zig" },
    .{ .name = "pico_spi-master", .target = rp2040.boards.raspberry_pi.pico, .file = "src/spi_master.zig" },
    .{ .name = "pico_squarewave", .target = rp2040.boards.raspberry_pi.pico, .file = "src/squarewave.zig" },
    .{ .name = "pico_uart", .target = rp2040.boards.raspberry_pi.pico, .file = "src/uart.zig" },
    .{ .name = "pico_usb-device", .target = rp2040.boards.raspberry_pi.pico, .file = "src/usb_device.zig" },
    .{ .name = "pico_usb-hid", .target = rp2040.boards.raspberry_pi.pico, .file = "src/usb_hid.zig" },
    .{ .name = "pico_ws2812", .target = rp2040.boards.raspberry_pi.pico, .file = "src/ws2812.zig" },

    .{ .name = "rp2040-matrix_tiles", .target = rp2040.boards.waveshare.rp2040_matrix, .file = "src/tiles.zig" },

    //     .{ .name = "rp2040-eth", .target = rp2040.boards.waveshare.rp2040_eth },
    //     .{ .name = "rp2040-plus-4m", .target = rp2040.boards.waveshare.rp2040_plus_4m },
    //     .{ .name = "rp2040-plus-16m", .target = rp2040.boards.waveshare.rp2040_plus_16m },
};

pub fn build(b: *std.Build) void {
    const microzig = @import("microzig").init(b, "microzig");
    const optimize = b.standardOptimizeOption(.{});

    for (available_examples) |example| {
        // `addFirmware` basically works like addExecutable, but takes a
        // `microzig.Target` for target instead of a `std.zig.CrossTarget`.
        //
        // The target will convey all necessary information on the chip,
        // cpu and potentially the board as well.
        const firmware = microzig.addFirmware(b, .{
            .name = example.name,
            .target = example.target,
            .optimize = optimize,
            .source_file = .{ .path = example.file },
        });

        // `installFirmware()` is the MicroZig pendant to `Build.installArtifact()`
        // and allows installing the firmware as a typical firmware file.
        //
        // This will also install into `$prefix/firmware` instead of `$prefix/bin`.
        microzig.installFirmware(b, firmware, .{});

        // For debugging, we also always install the firmware as an ELF file
        microzig.installFirmware(b, firmware, .{ .format = .elf });
    }
}

const Example = struct {
    target: @import("microzig").Target,
    name: []const u8,
    file: []const u8,
};
