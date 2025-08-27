local EnumzClass = require(script:WaitForChild("enumz"));

export type EnumzClass = EnumzClass.EnumzClass;

local function EnumExists(self, keyToCheck: string): boolean
	local enum = self.__classes[keyToCheck];
	return (enum ~= nil);
end

local mt = {
	__index = function(self, key: string): {[any]: EnumzClass.EnumzClass}
		if (key == "Exists") then
			return EnumExists;
		end
		
		local enum = self.__classes[key];
		assert(enum, `enum {key} does not exist`);

		return enum;
	end,
	
	__newindex = function(self, key: string, values: {string})
		assert((typeof(key) == "string"), "enum name is not a string");
		assert((key ~= ""), "enum name cannot be empty");
		assert((not self.__classes[key]), "enum already exists");
		assert((typeof(values) == "table"), "value is not a table");
		
		local enum = EnumzClass.new(key, values);
		self.__classes[key] = enum;
	end,
};

local Enumz: { [string]: EnumzClass.EnumzClass } = {
	__classes = { }
};

return setmetatable(Enumz, mt);