//
// Remeber excerice xx with tagged unions. That was a lot more better
// but it's can bee perfect.
//
// With tagged unions, it gets EVEN BETTER! If you don't have a
// need for a separate enum, you can define an inferred enum with
// your union all in one place. Just use the 'enum' keyword in
// place of the tag type:
//
//     const Foo = union(enum) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Let's convert Insect. Doctor Zoraptera has already deleted the
// explicit InsectStat enum for you!
//
const std = @import("std");

const Ant = struct {
    still_alive: bool,

    pub fn print(self: Ant) void {
        std.debug.print("Ant is {s}.\n", .{if (self.still_alive) "alive" else "death"});
    }
};

const Bee = struct {
    flowers_visited: u16,

    pub fn print(self: Bee) void {
        std.debug.print("Bee visited {} flowers.\n", .{self.flowers_visited});
    }
};

const Grasshopper = struct {
    distance_hopped: u16,

    pub fn print(self: Grasshopper) void {
        std.debug.print("Grasshopper hopped {} m.\n", .{self.distance_hopped});
    }
};

const Insect = union(enum) {
    ant: Ant,
    bee: Bee,
    grasshopper: Grasshopper,

    pub fn print(self: Insect) void {
        switch (self) {
            inline else => |case| return case.print(),
        }
    }
};

pub fn main() !void {
    var my_insects = [_]Insect{ Insect{
        .ant = Ant{ .still_alive = true },
    }, Insect{
        .bee = Bee{ .flowers_visited = 17 },
    }, Insect{
        .grasshopper = Grasshopper{ .distance_hopped = 32 },
    } };

    try dailyReport(&my_insects);
}

fn dailyReport(insectReport: []Insect) !void {
    std.debug.print("Daily insect report:\n", .{});
    for (insectReport) |insect| {
        insect.print();
    }
}

// Inferred enums are neat, representing the tip of the iceberg
// in the relationship between enums and unions. You can actually
// coerce a union TO an enum (which gives you the active field
// from the union as an enum). What's even wilder is that you can
// coerce an enum to a union! But don't get too excited, that
// only works when the union type is one of those weird zero-bit
// types like void!
//
// Tagged unions, as with most ideas in computer science, have a
// long history going back to the 1960s. However, they're only
// recently becoming mainstream, particularly in system-level
// programming languages. You might have also seen them called
// "variants", "sum types", or even "enums"!
