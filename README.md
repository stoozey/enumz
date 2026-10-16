# Enumz
Enum system for Roblox
 
You can install this package using [wally](https://wally.run/package/stoozey/enumz)

**3.0.0 is a drop-in, faster rewrite: every read resolves through a plain table instead of a function, and nothing a 2.x project does needs to change.**

## Usage Guide
Enumz is very simple to use--require the module and create your enum as you would a regular table:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Packages = ReplicatedStorage:WaitForChild("Packages");
local Enumz = require(Packages:WaitForChild("enumz"));

Enumz.PlayerRank = {
    "Guest",
    "Member",
    "Vip",
    "Moderator",
    "Admin"
};
```

**Note that you can ONLY define an enum like this, it must be a table with no special keys, and all values must be unique strings.**

### Initialization
When an enum is created, it is cached into the module so it can be accessed from anywhere else in your codebase.
The way I reccomend initializng your enums is by using the `utils.lua` file.
Create a folder anywhere in ReplicatedStorage which holds modules that define your enumz.
When your server initializes, call `EnumzUtil.EnumzFolderInitServer(folder)` on the folder.
When your client initializes, call `EnumzUtil.EnumzFolderInitClient(folder)` on the folder. *The client initialization function is a promise, so make sure that any code using enumz is called after this resolves!*

---
An enum isn't just a table of strings, it is it's own unique class with different ways to access it's data.
Using the example `PlayerRank` enum, here are ways you can do so:

### Members
#### Key Accessing 
`print(Enumz.PlayerRank.Moderator)`
This code would print `4`, as it's the index of that key in the definition table.

#### Index Accessing
`print(Enumz.PlayerRank[4])`
This code would print `Moderator`, as it's the name of that index in the definition table.

Enums are read-only: assigning to a member of one raises an error.

### Functions
#### GetEnumItems() / Pairs()
`print(Enumz.PlayerRank:GetEnumItems())`
This code would print a table where each key is an enums index, and each value is it's name. Useful for key-value paired loops. The table is a copy, so you can change it freely.

#### GetRandom(random?)
`print(Enumz.PlayerRank:GetRandom())`
This code would print a random index of the enum.
Pass a `Random` to roll with it instead of `math.random`, so a seeded `Random` gives the same index every time: `Enumz.PlayerRank:GetRandom(Random.new(seed))`.

#### GetName()
`print(Enumz.PlayerRank:GetName())`
This code would print `PlayerRank`.

#### GetTotalItems() / Count() / Last()
`print(Enumz.PlayerRank:GetTotalItems())`
This code would print `5`, self explanatory. Useful for `for i` loops, among other things.

#### First()
`print(Enumz.PlayerRank:First())`
This code would print `1`, so `for i = enum:First(), enum:Last()` reads as a range.

#### Validate(valueOrIndex, doAssertion?)
`print(Enumz.PlayerRank:Validate("Vip"), Enumz.PlayerRank:Validate(9))`
This code would print `true false`: whether a name or an index belongs to the enum. Pass `true` as the second argument to raise an error instead of returning `false`.

#### CreateTable(value)
`print(Enumz.PlayerRank:CreateTable(0))`
This code would print a table with one entry per enum index, each set to `value`. A function is called with each index and its result stored; a table is cloned for each entry; anything else is stored as is.

### Enumz:Exists(name)
`print(Enumz:Exists("PlayerRank"))`
This code would print `true`. Reading an enum that was never defined raises an error, so check this first when the name is dynamic.
