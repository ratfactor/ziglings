//
// Loop bodies are blocks, which are also expressions. We've seen
// how they can be used to evaluate and return values. To further
// expand on this concept, it turns out we can also give names to
// blocks by applying a 'label':
//
//     my_label: { ... }
//
// Once you give a block a label, you can use 'break' to exit
// from that block.
//
//     outer_block: {           // outer block
//         while (true) {       // inner block
//             break :outer_block;
//         }
//         unreachable;
//     }
//
// As we've just learned, you can return a value using a break
// statement. Does that mean you can return a value from any
// labeled block? Yes it does!
//
//     const foo = make_five: {
//         const five = 1 + 1 + 1 + 1 + 1;
//         break :make_five five;
//     };
//
// Labels can also be used with loops. Being able to break out of
// nested loops at a specific level is one of those things that
// you won't use every day, but when the time comes, it's
// incredibly convenient. Being able to return a value from an
// inner loop is sometimes so handy, it almost feels like cheating
// (and can help you avoid creating a lot of temporary variables).
//
//     const bar: u8 = two_loop: while (true) {
//         while (true) {
//             break :two_loop 2;
//         }
//     } else 0;
//
// In the above example, the break exits from the outer loop
// labeled "two_loop" and returns the value 2. The else clause is
// attached to the outer two_loop and would be evaluated if the
// loop somehow ended without the break having been called.
//
// Finally, you can also use block labels with the 'continue'
// statement:
//
//     my_while: while (true) {
//         continue :my_while;
//     }
//
const print = @import("std").debug.print;

// As mentioned before, we'll soon understand why these two
// numbers don't need explicit types. Hang in there!
const ingredients = 4;
const foods = 4;

const Food = struct {
    name: []const u8,
    requires: [ingredients]bool,
};

//                 Chili  Macaroni  Tomato Sauce  Cheese
// ------------------------------------------------------
//  Mac & Cheese              x                     x
//  Chili Mac        x        x
//  Pasta                     x          x
//  Cheesy Chili     x                              x
// ------------------------------------------------------

const menu: [foods]Food = [_]Food{
    Food{
        .name = "Mac & Cheese",
        .requires = [ingredients]bool{ false, true, false, true },
    },
    Food{
        .name = "Chili Mac",
        .requires = [ingredients]bool{ true, true, false, false },
    },
    Food{
        .name = "Pasta",
        .requires = [ingredients]bool{ false, true, true, false },
    },
    Food{
        .name = "Cheesy Chili",
        .requires = [ingredients]bool{ true, false, false, true },
    },
};

pub fn main() void {
    // Welcome to Cafeteria USA! Choose your favorite ingredients
    // and we'll produce a delicious meal.
    //
    // Cafeteria Customer Note: Not all ingredient combinations
    // make a meal. The default meal is macaroni and cheese.
    //
    // Software Developer Note: Hard-coding the ingredient
    // numbers (based on array position) will be fine for our
    // tiny example, but it would be downright criminal in a real
    // application!
    const wanted_ingredients = [_]u8{ 0, 3 }; // Chili, Cheese

    // Look at each Food on the menu...
    const meal = food_loop: for (menu) |food| {

        // Now look at each required ingredient for the Food...
        for (food.requires, 0..) |required, required_ingredient| {

            // This ingredient isn't required, so skip it.
            if (!required) continue;

            // See if the customer wanted this ingredient.
            // (Remember that want_it will be the index number of
            // the ingredient based on its position in the
            // required ingredient list for each food.)
            const found = for (wanted_ingredients) |want_it| {
                if (required_ingredient == want_it) break true;
            } else false;

            // We did not find this required ingredient, so we
            // can't make this Food. Continue the outer loop.
            if (!found) continue :food_loop;
        }

        // If we get this far, the required ingredients were all
        // wanted for this Food.
        //
        // Please return this Food from the loop.
        break;
    };
    // ^ Oops! We forgot to return Mac & Cheese as the default
    // Food when the requested ingredients aren't found.

    print("Enjoy your {s}!\n", .{meal.name});
}

// Challenge: You can also do away with the 'found' variable in
// the inner loop. See if you can figure out how to do that!
