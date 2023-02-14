//
// Remeber excerices 55-57 with tagged unions.
//
// (story/explanation from Dave)
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

    // The daily situation report, what's going on in the garden
    try dailyReport("what is here the right parameter?");
}

// Through the interface we can keep a list of various objects
// (in this case the insects of our garden) and even pass them
// to a function without having to know the specific properties
// of each or the object itself. This is really cool!
fn dailyReport(insectReport: []Insect) !void {
    std.debug.print("Daily insect report:\n", .{});
    for (insectReport) |insect| {
        insect.print();
    }
}

// Interfaces... (explanation from Dave)
