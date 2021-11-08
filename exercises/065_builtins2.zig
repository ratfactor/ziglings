//
// Zig has builtins for mathematical operations such as...
//
//      @sqrt        @sin          @cos
//      @exp         @log          @floor
//
// ...and lots of type casting operations such as...
//
//      @as          @intToError   @intToFloat
//      @intToPtr    @ptrToInt     @enumToInt
//
// Spending part of a rainy day skimming through the complete
// list of builtins in the official Zig documentation wouldn't be
// a bad use of your time. There are some seriously cool features
// in there. Check out @call, @compileLog, @embedFile, and @src!
//
//                            ...
//
// For now, we're going to complete our examination of builtins
// by exploring just THREE of Zig's MANY introspection abilities:
//
// 1. @This() type
//
// Returns the innermost struct, enum, or union that a function
// call is inside.
//
// 2. @typeInfo(comptime T: type) @import("std").builtin.TypeInfo
//
// Returns information about any type in a TypeInfo union which
// will contain different information depending on which type
// you're examining.
//
// 3. @TypeOf(...) type
//
// Returns the type common to all input parameters (each of which
// may be any expression). The type is resolved using the same
// "peer type resolution" process the compiler itself uses when
// inferring types.
//
// (Notice how the two functions which return types start with
// uppercase letters? This is a standard naming practice in Zig.)
//
const print = import(std).debug.print; // Oops!

const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined,

    fn fetchTheMostBeautifulType() type {
        return @This();
    }
};

pub fn main() void {
    var narcissus: Narcissus = Narcissus{};

    // Oops! We cannot leave the 'me' and 'myself' fields
    // undefined. Please set them here:
    ??? = &narcissus;
    ??? = &narcissus;

    // This determines a "peer type" from three separate
    // references (they just happen to all be the same object).
    const T1 = @TypeOf(narcissus, narcissus.me.*, narcissus.myself.*);

    // Oh dear, we seem to have done something wrong when calling
    // this function. It is namespaced to the struct, but doesn't
    // use the method syntax (there's no self parameter). Please
    // fix this call:
    const T2 = narcissus.fetchTheMostBeautifulType();

    print("A {} loves all {}es. ", .{ T1, T2 });

    //   His final words as he was looking in
    //   those waters he habitually watched
    //   were these:
    //       "Alas, my beloved boy, in vain!"
    //   The place gave every word back in reply.
    //   He cried:
    //            "Farewell."
    //   And Echo called:
    //                   "Farewell!"
    //
    //     --Ovid, The Metamorphoses
    //       translated by Ian Johnston

    print("He has room in his heart for:", .{});

    // A StructFields array
    const fields = @typeInfo(Narcissus).Struct.fields;

    // 'fields' is a slice of StructFields. Here's the declaration:
    //
    //     pub const StructField = struct {
    //         name: []const u8,
    //         field_type: type,
    //         default_value: anytype,
    //         is_comptime: bool,
    //         alignment: comptime_int,
    //     };
    //
    // Please complete these 'if' statements so that the field
    // name will not be printed if the field is of type 'void'
    // (which is a zero-bit type that takes up no space at all!):
    if (fields[0].??? != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[0].name});
    }

    if (fields[1].??? != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[1].name});
    }

    if (fields[2].??? != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[2].name});
    }

    // Yuck, look at all that repeated code above! I don't know
    // about you, but it makes me itchy.
    //
    // Alas, we can't use a regular 'for' loop here because
    // 'fields' can only be evaluated at compile time.  It seems
    // like we're overdue to learn about this "comptime" stuff,
    // isn't it? :-)

    print(".\n", .{});
}
