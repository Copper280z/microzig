// Filters with a constant sample time assume calc will be called
// on a consistent interval.

// Interface for constant sample time low pass filters
// or filters which do their own timekeeping
pub const LPF = struct {
    ptr: *anyopaque,
    calcFn: *const fn (ptr: *anyopaque, input: f32) f32,
    setLpfFn: *const fn (ptr: *anyopaque, frequency: f32) f32,

    pub fn calc(L: *@This(), input: f32) f32 {
        return L.calcFn(L.ptr, input);
    }
    pub fn set_lpf(L: *@This(), frequency: f32) void {
        return L.setLpfFn(L.ptr, frequency);
    }
};

// Exponentially Weighted Moving Average filter
pub fn EWMA_const_Ts(comptime Ts: f32) type {
    return struct {
        lpf_coeff: f32 = 0.99,
        prev_output: f32 = 0.0,
        pub fn calc(L: *@This(), input: f32) f32 {
            return L.prev_output + (L.lpf_coeff * (input - L.prev_output));
        }

        pub fn set_lpf(L: *@This(), frequency: f32) void {
            const y = @tan((frequency * Ts) / 2);
            L.lpf_coeff = 2 * y / (y + 1);
        }

        pub fn lpf(L: *@This()) LPF {
            return .{
                .ptr = L,
                .calcFn = &L.calc,
                .setLpfFn = &L.set_lpf,
            };
        }
    };
}
