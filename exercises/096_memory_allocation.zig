//
// In most of the examples so far, the inputs are known at compile
// time, thus the amount of memory used by the program is fixed.
// However, if responding to input whose size is not known at compile
// time, such as:
//  - user input via command-line arguments
//  - inputs from another program
//
// You'll need to request memory for your program to be allocated by
// your operating system at runtime.
//
// Zig provides several different allocators. In the Zig
// documentation, it recommends the Arena allocator for simple
// programs which allocate once and then exit:
//
//     const std = @import("std");
//
//     // memory allocation can fail, so the return type is !void
//     pub fn main() !void {
//
//         var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//         defer arena.deinit();
//
//         const allocator = arena.allocator();
//
//         const ptr = try allocator.create(i32);
//         std.debug.print("ptr={*}\n", .{ptr});
//
//         const slice_ptr = try allocator.alloc(f64, 5);
//         std.debug.print("slice_ptr={*}\n", .{slice_ptr});
//     }

// Instead of a simple integer or a constant sized slice, this
// program requires a slice to be allocated that is the same size as
// an input array.

// Given a series of numbers, take the running average. In other
// words, each item N should contain the average of the last N
// elements.

const std = @import("std");

fn runningAverage(arr: []const f64, avg: []f64) void {
    var sum: f64 = 0;

    for (0.., arr) |index, val| {
        sum += val;
        const f_index: f64 = @floatFromInt(index + 1);
        avg[index] = sum / f_index;
    }
}

pub fn main() !void {
    // pretend this was defined by reading in user input
    var arr: []const f64 = &[_]f64{ 0.3, 0.2, 0.1, 0.1, 0.4 };

    // initialize the allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    // free the memory on exit
    defer arena.deinit();

    // initialize the allocator
    const allocator = arena.allocator();

    // allocate memory for this array
    var avg: []f64 = try allocator.alloc(f64, arr.len);

    runningAverage(arr, avg);
    std.debug.print("Running Average: ", .{});
    for (avg) |val| {
        std.debug.print("{d:.2} ", .{val});
    }
    std.debug.print("\n", .{});
}

// For more details on memory allocation and the different types of
// memory allocators, see https://www.youtube.com/watch?v=vHWiDx_l4V0
