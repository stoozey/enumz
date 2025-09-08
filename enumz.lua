export type EnumzClass = {
	GetEnumItems: (self: EnumzClass) -> {[number]: string},
	GetRandom: (self: EnumzClass) -> number,
	GetName: (self: EnumzClass) -> string,
	GetTotalItems: (self: EnumzClass) -> number,
	Validate: (self: EnumzClass, valueOrIndex: string|number, doAssertion: boolean|nil) -> boolean,
	[string|number]: number|string
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
		elseif (key == "CreateTable") then
			return self.__createTable;
		elseif (key == "Validate") then
			return self.__validate;
		elseif (key == "First") then
			return self.__first;
		else
			local value;
			local keyType = typeof(key);
			if (keyType == "string") then
				value = self.__valuesNamed[key];
			elseif (keyType == "number") then
				value = self.__valuesIndexed[key];
			end

			assert((value ~= nil), ("enum \"%s\" does not have a value corresponding to %s!"):format(self:GetName(), tostring(key)));
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
	function self:__getEnumItems()
		return table.clone(self.__valuesIndexed);
	end
	
	function self:__getRandom()
		return self.__valuesNamed[self.__valuesIndexed[math.random(1, #self.__valuesIndexed)]];
	end
	
	function self:__getName()
		return self.__name;
	end
	
	function self:__getTotalItems()
		return #self.__valuesIndexed;
	end

	function self:__createTable(value: {}|((number) -> any)|any)
		local function GetValue(i)
			local valueType = typeof(value);
			if (valueType == "function") then
				return value(i);
			elseif (valueType == "table") then
				return table.clone(value);
			else
				return value;
			end
		end

		local tbl = { };
		for i = 1, #self.__valuesIndexed do
			tbl[i] = GetValue(i);
		end

		return tbl;
	end

	function self:__validate(valueOrIndex: string|number, doAssertion: boolean|nil)
		local valid;
		local valueType = typeof(valueOrIndex);
		if (valueType == "string") then
			valid = (self.__valuesNamed[valueOrIndex] ~= nil);
		elseif (valueType == "number") then
			valid = (self.__valuesIndexed[valueOrIndex] ~= nil);
		else
			error(("invalid %s:Validate value given, expected string|number, got %s"):format(self:__getName(), tostring(valueType)));
		end

		if (doAssertion) then
			assert(valid, ("value %s is not valid within %s enum!"):format(tostring(valueOrIndex), self:__getName()));
		end

		return valid;
	end

	function self:__first()
		return 1;
	end

	return setmetatable(self, mt);
end

return EnumzClass;
