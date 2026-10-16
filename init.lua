local EnumzClass = require(script:WaitForChild("enumz"));

export type EnumzClass = EnumzClass.EnumzClass;

local function EnumExists(self, keyToCheck: string): boolean
	local enum = self.__classes[keyToCheck];
	return (enum ~= nil);
end

local lookup = setmetatable({ Exists = EnumExists }, {
	__index = function(_, key: string)
		error(`enum {key} does not exist`);
	end,
});

local Enumz: { [string]: EnumzClass.EnumzClass } = {
	__classes = { }
};

return setmetatable(Enumz, {
	__index = lookup,

	__newindex = function(self, key: string, values: {string})
		if (type(key) ~= "string") then error("enum name is not a string"); end
		if (key == "") then error("enum name cannot be empty"); end
		if (self.__classes[key]) then error("enum already exists"); end
		if (type(values) ~= "table") then error("value is not a table"); end

		local enum = EnumzClass.new(key, values);
		self.__classes[key] = enum;

		if (key ~= "Exists") then
			lookup[key] = enum;
		end
	end,
});
