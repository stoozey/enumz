# Enumz
Enum system for Roblox
 
You can install this package using [wally](https://wally.run/package/stoozey/enumz?version=1.6.0)

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

### Functions
#### GetEnumItems()
`print(Enumz.PlayerRank:GetEnumItems())`
This code would print a table where each key is an enums index, and each value is it's name. Useful for key-value paired loops.

#### GetRandom()
`print(Enumz.PlayerRank:GetRandom())`
This code would print a random index of the enum.

#### GetName()
`print(Enumz.PlayerRank:GetName())`
This code would print `PlayerRank`.

#### GetTotalItems()
`print(Enumz.PlayerRank:GetTotalItems())`
This code would print `5`, self explanatory. Useful for `for i` loops, among other things.