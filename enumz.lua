export type EnumzClass = {
	GetEnumItems: (self: EnumzClass) -> {[number]: string},
	Pairs: (self: EnumzClass) -> {[number]: string},
	GetRandom: (self: EnumzClass, random: Random|nil) -> number,
	GetName: (self: EnumzClass) -> string,
	GetTotalItems: (self: EnumzClass) -> number,
	Count: (self: EnumzClass) -> number,
	Last: (self: EnumzClass) -> number,
	CreateTable: (self: EnumzClass, value: {}|((number) -> any)|any) -> {any},
	Validate: (self: EnumzClass, valueOrIndex: string|number, doAssertion: boolean|nil) -> boolean,
	[string|number]: number|string,
	First: (self: EnumzClass) -> number,
};

local function GetEnumItems(self)
	return table.clone(self.__valuesIndexed);
end

local function GetRandom(self, random: Random|nil)
	local values = self.__valuesIndexed;
	local count = #values;
	local index = if (random) then random:NextInteger(1, count) else math.random(1, count);
	return self.__valuesNamed[values[index]];
end

local function GetName(self)
	return self.__name;
end

local function GetTotalItems(self)
	return #self.__valuesIndexed;
end

local function CreateTable(self, value: {}|((number) -> any)|any)
	local count = #self.__valuesIndexed;
	local valueType = type(value);
	if (valueType == "function") then
		local tbl = table.create(count);
		for i = 1, count do
			tbl[i] = value(i);
		end
		return tbl;
	elseif (valueType == "table") then
		local tbl = table.create(count);
		for i = 1, count do
			tbl[i] = table.clone(value);
		end
		return tbl;
	end

	return table.create(count, value);
end

local function Validate(self, valueOrIndex: string|number, doAssertion: boolean|nil)
	local valid;
	local valueType = type(valueOrIndex);
	if (valueType == "string") then
		valid = (self.__valuesNamed[valueOrIndex] ~= nil);
	elseif (valueType == "number") then
		valid = (self.__valuesIndexed[valueOrIndex] ~= nil);
	else
		valid = false;
	end

	if ((doAssertion) and (not valid)) then
		error(("value %s is not valid within %s enum!"):format(tostring(valueOrIndex), self.__name));
	end

	return valid;
end

local function First()
	return 1;
end

local function ReadOnly()
	error("enumz is a read-only value");
end

local METHODS = {
	GetEnumItems = GetEnumItems,
	Pairs = GetEnumItems,
	GetRandom = GetRandom,
	GetName = GetName,
	GetTotalItems = GetTotalItems,
	Count = GetTotalItems,
	Last = GetTotalItems,
	CreateTable = CreateTable,
	Validate = Validate,
	First = First,
};


local EnumzClass = { };

function EnumzClass.new(name: string, values: {string}): EnumzClass
	local valuesNamed = { };
	local lookup = table.clone(METHODS);
	table.move(values, 1, #values, 1, lookup);
	for index, value in ipairs(values) do
		if (type(value) ~= "string") then
			error(("non-string key given to enum %s"):format(name));
		end

		valuesNamed[value] = index;

		if (METHODS[value] == nil) then
			lookup[value] = index;
		end
	end

	local self = {
		__name = name,
		__valuesIndexed = values,
		__valuesNamed = valuesNamed,
		__getEnumItems = GetEnumItems,
		__getRandom = GetRandom,
		__getName = GetName,
		__getTotalItems = GetTotalItems,
		__createTable = CreateTable,
		__validate = Validate,
		__first = First,
	};

	setmetatable(lookup, {
		__index = function(_, key)
			local keyType = type(key);
			local value;
			if (keyType == "string") then
				value = self.__valuesNamed[key];
			elseif (keyType == "number") then
				value = self.__valuesIndexed[key];
			end
			if (value ~= nil) then
				return value;
			end

			error(("enum \"%s\" does not have a value corresponding to %s!"):format(self.__name, tostring(key)));
		end,
	});

	return setmetatable(self, {
		__index = lookup,
		__newindex = ReadOnly,
	});
end

return EnumzClass;
