//
// We've absorbed a lot of information about the variations of types
// we can use in Zig. Roughly, in order we have:
//
//                          u8  single item
//                         *u8  single-item pointer
//                        []u8  slice (size known at runtime)
//                       [5]u8  array of 5 u8s
//                       [*]u8  many-item pointer (zero or more)
//                 enum {a, b}  set of unique values a and b
//                error {e, f}  set of unique error values e and f
//      struct {y: u8, z: i32}  group of values y and z
// union(enum) {a: u8, b: i32}  single value either u8 or i32
//
// Values of any of the above types can be assigned as "var" or "const"
// to allow or disallow changes (mutability) via the assigned name:
//
//     const a: u8 = 5; // immutable
//       var b: u8 = 5; //   mutable
//
// We can also make error unions or optional types from any of
// the above:
//
//     var a: E!u8 = 5; // can be u8 or error from set E
//     var b: ?u8 = 5;  // can be u8 or null
//
// Knowing all of this, maybe we can help out a local hermit. He made
// a little Zig program to help him plan his trips through the woods,
// but it has some mistakes.
//
// *************************************************************
// *                A NOTE ABOUT THIS EXERCISE                 *
// *                                                           *
// * You do NOT have to read and understand every bit of this  *
// * program. This is a very big example. Feel free to skim    *
// * through it and then just focus on the few parts that are  *
// * actually broken!                                          *
// *                                                           *
// *************************************************************
//
const print = @import("std").debug.print;

// The grue is a nod to Zork.
const TripError = error{ Unreachable, EatenByAGrue };

// Let's start with the Places on the map. Each has a name and a
// distance or difficulty of travel (as judged by the hermit).
//
// Note that we declare the places as mutable (var) because we need to
// assign the paths later. And why is that? Because paths contain
// pointers to places and assigning them now would create a dependency
// loop!
const Place = struct {
    name: []const u8,
    paths: []const Path = undefined,
};

var a = Place{ .name = "Archer's Point" };
var b = Place{ .name = "Bridge" };
var c = Place{ .name = "Cottage" };
var d = Place{ .name = "Dogwood Grove" };
var e = Place{ .name = "East Pond" };
var f = Place{ .name = "Fox Pond" };

//           The hermit's hand-drawn ASCII map
//  +---------------------------------------------------+
//  |         * Archer's Point                ~~~~      |
//  | ~~~                              ~~~~~~~~         |
//  |   ~~~| |~~~~~~~~~~~~      ~~~~~~~                 |
//  |         Bridge     ~~~~~~~~                       |
//  |  ^             ^                           ^      |
//  |     ^ ^                      / \                  |
//  |    ^     ^  ^       ^        |_| Cottage          |
//  |   Dogwood Grove                                   |
//  |                  ^     <boat>                     |
//  |  ^  ^  ^  ^          ~~~~~~~~~~~~~    ^   ^       |
//  |      ^             ~~ East Pond ~~~               |
//  |    ^    ^   ^       ~~~~~~~~~~~~~~                |
//  |                           ~~          ^           |
//  |           ^            ~~~ <-- short waterfall    |
//  |   ^                 ~~~~~                         |
//  |            ~~~~~~~~~~~~~~~~~                      |
//  |          ~~~~ Fox Pond ~~~~~~~    ^         ^     |
//  |      ^     ~~~~~~~~~~~~~~~           ^ ^          |
//  |                ~~~~~                              |
//  +---------------------------------------------------+
//
// We'll be reserving memory in our program based on the number of
// places on the map. Note that we do not have to specify the type of
// this value because we don't actually use it in our program once
// it's compiled! (Don't worry if this doesn't make sense yet.)
const place_count = 6;

// Now let's create all of the paths between sites. A path goes from
// one place to another and has a distance.
const Path = struct {
    from: *const Place,
    to: *const Place,
    dist: u8,
};

// By the way, if the following code seems like a lot of tedious
// manual labor, you're right! One of Zig's killer features is letting
// us write code that runs at compile time to "automate" repetitive
// code (much like macros in other languages), but we haven't learned
// how to do that yet!
const a_paths = [_]Path{
    Path{
        .from = &a, // from: Archer's Point
        .to = &b, //   to: Bridge
        .dist = 2,
    },
};

const b_paths = [_]Path{
    Path{
        .from = &b, // from: Bridge
        .to = &a, //   to: Archer's Point
        .dist = 2,
    },
    Path{
        .from = &b, // from: Bridge
        .to = &d, //   to: Dogwood Grove
        .dist = 1,
    },
};

const c_paths = [_]Path{
    Path{
        .from = &c, // from: Cottage
        .to = &d, //   to: Dogwood Grove
        .dist = 3,
    },
    Path{
        .from = &c, // from: Cottage
        .to = &e, //   to: East Pond
        .dist = 2,
    },
};

const d_paths = [_]Path{
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &b, //   to: Bridge
        .dist = 1,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &c, //   to: Cottage
        .dist = 3,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &f, //   to: Fox Pond
        .dist = 7,
    },
};

const e_paths = [_]Path{
    Path{
        .from = &e, // from: East Pond
        .to = &c, //   to: Cottage
        .dist = 2,
    },
    Path{
        .from = &e, // from: East Pond
        .to = &f, //   to: Fox Pond
        .dist = 1, // (one-way down a short waterfall!)
    },
};

const f_paths = [_]Path{
    Path{
        .from = &f, // from: Fox Pond
        .to = &d, //   to: Dogwood Grove
        .dist = 7,
    },
};

// Once we've plotted the best course through the woods, we'll make a
// "trip" out of it. A trip is a series of Places connected by Paths.
// We use a TripItem union to allow both Places and Paths to be in the
// same array.
const TripItem = union(enum) {
    place: *const Place,
    path: *const Path,

    // This is a little helper function to print the two different
    // types of item correctly.
    fn printMe(self: TripItem) void {
        switch (self) {
            // Oops! The hermit forgot how to capture the union values
            // in a switch statement. Please capture both values as
            // 'p' so the print statements work!
            .place => print("{s}", .{p.name}),
            .path => print("--{}->", .{p.dist}),
        }
    }
};

// The Hermit's Notebook is where all the magic happens. A notebook
// entry is a Place discovered on the map along with the Path taken to
// get there and the distance to reach it from the start point. If we
// find a better Path to reach a Place (shorter distance), we update the
// entry. Entries also serve as a "todo" list which is how we keep
// track of which paths to explore next.
const NotebookEntry = struct {
    place: *const Place,
    coming_from: ?*const Place,
    via_path: ?*const Path,
    dist_to_reach: u16,
};

// +------------------------------------------------+
// |              ~ Hermit's Notebook ~             |
// +---+----------------+----------------+----------+
// |   |      Place     |      From      | Distance |
// +---+----------------+----------------+----------+
// | 0 | Archer's Point | null           |        0 |
// | 1 | Bridge         | Archer's Point |        2 | < next_entry
// | 2 | Dogwood Grove  | Bridge         |        1 |
// | 3 |                |                |          | < end_of_entries
// |                      ...                       |
// +---+----------------+----------------+----------+
//
const HermitsNotebook = struct {
    // Remember the array repetition operator `**`? It is no mere
    // novelty, it's also a great way to assign multiple items in an
    // array without having to list them one by one. Here we use it to
    // initialize an array with null values.
    entries: [place_count]?NotebookEntry = .{null} ** place_count,

    // The next entry keeps track of where we are in our "todo" list.
    next_entry: u8 = 0,

    // Mark the start of empty space in the notebook.
    end_of_entries: u8 = 0,

    // We'll often want to find an entry by Place. If one is not
    // found, we return null.
    fn getEntry(self: *HermitsNotebook, place: *const Place) ?*NotebookEntry {
        for (&self.entries, 0..) |*entry, i| {
            if (i >= self.end_of_entries) break;

            // Here's where the hermit got stuck. We need to return
            // an optional pointer to a NotebookEntry.
            //
            // What we have with "entry" is the opposite: a pointer to
            // an optional NotebookEntry!
            //
            // To get one from the other, we need to dereference
            // "entry" (with .*) and get the non-null value from the
            // optional (with .?) and return the address of that. The
            // if statement provides some clues about how the
            // dereference and optional value "unwrapping" look
            // together. Remember that you return the address with the
            // "&" operator.
            if (place == entry.*.?.place) return entry;
            // Try to make your answer this long:__________;
        }
        return null;
    }

    // The checkNote() method is the beating heart of the magical
    // notebook. Given a new note in the form of a NotebookEntry
    // struct, we check to see if we already have an entry for the
    // note's Place.
    //
    // If we DON'T, we'll add the entry to the end of the notebook
    // along with the Path taken and distance.
    //
    // If we DO, we check to see if the path is "better" (shorter
    // distance) than the one we'd noted before. If it is, we
    // overwrite the old entry with the new one.
    fn checkNote(self: *HermitsNotebook, note: NotebookEntry) void {
        var existing_entry = self.getEntry(note.place);

        if (existing_entry == null) {
            self.entries[self.end_of_entries] = note;
            self.end_of_entries += 1;
        } else if (note.dist_to_reach < existing_entry.?.dist_to_reach) {
            existing_entry.?.* = note;
        }
    }

    // The next two methods allow us to use the notebook as a "todo"
    // list.
    fn hasNextEntry(self: *HermitsNotebook) bool {
        return self.next_entry < self.end_of_entries;
    }

    fn getNextEntry(self: *HermitsNotebook) *const NotebookEntry {
        defer self.next_entry += 1; // Increment after getting entry
        return &self.entries[self.next_entry].?;
    }

    // After we've completed our search of the map, we'll have
    // computed the shortest Path to every Place. To collect the
    // complete trip from the start to the destination, we need to
    // walk backwards from the destination's notebook entry, following
    // the coming_from pointers back to the start. What we end up with
    // is an array of TripItems with our trip in reverse order.
    //
    // We need to take the trip array as a parameter because we want
    // the main() function to "own" the array memory. What do you
    // suppose could happen if we allocated the array in this
    // function's stack frame (the space allocated for a function's
    // "local" data) and returned a pointer or slice to it?
    //
    // Looks like the hermit forgot something in the return value of
    // this function. What could that be?
    fn getTripTo(self: *HermitsNotebook, trip: []?TripItem, dest: *Place) void {
        // We start at the destination entry.
        const destination_entry = self.getEntry(dest);

        // This function needs to return an error if the requested
        // destination was never reached. (This can't actually happen
        // in our map since every Place is reachable by every other
        // Place.)
        if (destination_entry == null) {
            return TripError.Unreachable;
        }

        // Variables hold the entry we're currently examining and an
        // index to keep track of where we're appending trip items.
        var current_entry = destination_entry.?;
        var i: u8 = 0;

        // At the end of each looping, a continue expression increments
        // our index. Can you see why we need to increment by two?
        while (true) : (i += 2) {
            trip[i] = TripItem{ .place = current_entry.place };

            // An entry "coming from" nowhere means we've reached the
            // start, so we're done.
            if (current_entry.coming_from == null) break;

            // Otherwise, entries have a path.
            trip[i + 1] = TripItem{ .path = current_entry.via_path.? };

            // Now we follow the entry we're "coming from".  If we
            // aren't able to find the entry we're "coming from" by
            // Place, something has gone horribly wrong with our
            // program! (This really shouldn't ever happen. Have you
            // checked for grues?)
            // Note: you do not need to fix anything here.
            const previous_entry = self.getEntry(current_entry.coming_from.?);
            if (previous_entry == null) return TripError.EatenByAGrue;
            current_entry = previous_entry.?;
        }
    }
};

pub fn main() void {
    // Here's where the hermit decides where he would like to go. Once
    // you get the program working, try some different Places on the
    // map!
    const start = &a; // Archer's Point
    const destination = &f; // Fox Pond

    // Store each Path array as a slice in each Place. As mentioned
    // above, we needed to delay making these references to avoid
    // creating a dependency loop when the compiler is trying to
    // figure out how to allocate space for each item.
    a.paths = a_paths[0..];
    b.paths = b_paths[0..];
    c.paths = c_paths[0..];
    d.paths = d_paths[0..];
    e.paths = e_paths[0..];
    f.paths = f_paths[0..];

    // Now we create an instance of the notebook and add the first
    // "start" entry. Note the null values. Read the comments for the
    // checkNote() method above to see how this entry gets added to
    // the notebook.
    var notebook = HermitsNotebook{};
    var working_note = NotebookEntry{
        .place = start,
        .coming_from = null,
        .via_path = null,
        .dist_to_reach = 0,
    };
    notebook.checkNote(working_note);

    // Get the next entry from the notebook (the first being the
    // "start" entry we just added) until we run out, at which point
    // we'll have checked every reachable Place.
    while (notebook.hasNextEntry()) {
        var place_entry = notebook.getNextEntry();

        // For every Path that leads FROM the current Place, create a
        // new note (in the form of a NotebookEntry) with the
        // destination Place and the total distance from the start to
        // reach that place. Again, read the comments for the
        // checkNote() method to see how this works.
        for (place_entry.place.paths) |*path| {
            working_note = NotebookEntry{
                .place = path.to,
                .coming_from = place_entry.place,
                .via_path = path,
                .dist_to_reach = place_entry.dist_to_reach + path.dist,
            };
            notebook.checkNote(working_note);
        }
    }

    // Once the loop above is complete, we've calculated the shortest
    // path to every reachable Place! What we need to do now is set
    // aside memory for the trip and have the hermit's notebook fill
    // in the trip from the destination back to the path. Note that
    // this is the first time we've actually used the destination!
    var trip = [_]?TripItem{null} ** (place_count * 2);

    notebook.getTripTo(trip[0..], destination) catch |err| {
        print("Oh no! {}\n", .{err});
        return;
    };

    // Print the trip with a little helper function below.
    printTrip(trip[0..]);
}

// Remember that trips will be a series of alternating TripItems
// containing a Place or Path from the destination back to the start.
// The remaining space in the trip array will contain null values, so
// we need to loop through the items in reverse, skipping nulls, until
// we reach the destination at the front of the array.
fn printTrip(trip: []?TripItem) void {
    // We convert the usize length to a u8 with @intCast(), a
    // builtin function just like @import().  We'll learn about
    // these properly in a later exercise.
    var i: u8 = @intCast(trip.len);

    while (i > 0) {
        i -= 1;
        if (trip[i] == null) continue;
        trip[i].?.printMe();
    }

    print("\n", .{});
}

// Going deeper:
//
// In computer science terms, our map places are "nodes" or "vertices" and
// the paths are "edges". Together, they form a "weighted, directed
// graph". It is "weighted" because each path has a distance (also
// known as a "cost"). It is "directed" because each path goes FROM
// one place TO another place (undirected graphs allow you to travel
// on an edge in either direction).
//
// Since we append new notebook entries at the end of the list and
// then explore each sequentially from the beginning (like a "todo"
// list), we are treating the notebook as a "First In, First Out"
// (FIFO) queue.
//
// Since we examine all closest paths first before trying further ones
// (thanks to the "todo" queue), we are performing a "Breadth-First
// Search" (BFS).
//
// By tracking "lowest cost" paths, we can also say that we're
// performing a "least-cost search".
//
// Even more specifically, the Hermit's Notebook most closely
// resembles the Shortest Path Faster Algorithm (SPFA), attributed to
// Edward F. Moore. By replacing our simple FIFO queue with a
// "priority queue", we would basically have Dijkstra's algorithm. A
// priority queue retrieves items sorted by "weight" (in our case, it
// would keep the paths with the shortest distance at the front of the
// queue). Dijkstra's algorithm is more efficient because longer paths
// can be eliminated more quickly. (Work it out on paper to see why!)
