export type EnumzClass = {
	GetEnumItems: (self: EnumzClass) -> {[number]: string},
	GetRandom: (self: EnumzClass) -> number,
	GetName: (self: EnumzClass) -> string
};

local mt = {
	__index = function(self, key)
		if (key == "GetEnumItems") then
			return self.__getEnumItems;
		elseif (key == "GetRandom") then
			return self.__getRandom;
		elseif (key == "GetName") then
			return self.__getName;
		else
			local keyType = typeof(key);
			if (keyType == "string") then
				return self.__valuesNamed[key];
			elseif (keyType == "number") then
				return self.__valuesIndexed[key];
			end
		end
		
		error("invalid enumz index");
	end,
	
	__newindex = function(self, key, value)
		error("enumz is a read-only value");
	end,
};


local EnumzClass = { };

function EnumzClass.new(name: string, values: {string}): EnumzClass
	local self = { };
	
	-- setup values
	self.__name = name;
	self.__valuesIndexed = values;
	
	local valuesNamed = { };
	for index, value in pairs(values) do
		valuesNamed[value] = index;
	end
	
	self.__valuesNamed = valuesNamed;
	
	-- define functions
	self.__getEnumItems = function()
		return table.clone(self.__valuesIndexed);
	end
	
	self.__getRandom = function()
		return self.__valuesIndexed[math.random(1, #self.__valuesIndexed)];
	end
	
	self.__getName = function()
		return self.__name;
	end
	
	return setmetatable(self, mt);
end

return EnumzClass;