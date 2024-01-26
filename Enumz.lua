export type EnumzClass = {
	GetEnumItems: (self: EnumzClass) -> {[number]: string},
	GetRandom: (self: EnumzClass) -> number,
	GetName: (self: EnumzClass) -> string,
	GetTotalItems: (self: EnumzClass) -> number,
};

local mt = {
	__index = function(self, key)
		if (key == "GetEnumItems") then
			return self.__getEnumItems;
		elseif (key == "GetRandom") then
			return self.__getRandom;
		elseif (key == "GetName") then
			return self.__getName;
		elseif (key == "GetTotalItems") then
			return self.__getTotalItems;
		else
			local value;
			local keyType = typeof(key);
			if (keyType == "string") then
				value = self.__valuesNamed[key];
			elseif (keyType == "number") then
				value = self.__valuesIndexed[key];
			end

			assert((value ~= nil), ("enum \"%s\" does not have a value corresponding to %s!"):format(self:GetName(), key));
			return value;
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
	for index, value in ipairs(values) do
		assert((typeof(value) == "string"), ("non-string key given to enum %s"):format(name));
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
	
	self.__getTotalItems = function()
		return #self.__valuesIndexed;
	end

	return setmetatable(self, mt);
end

return EnumzClass;