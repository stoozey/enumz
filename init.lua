export type Enumz = {
	["Iterator"]: {[number]: string},
	["Count"]: number,
	["Random"]: string,
	["Name"]: string,
	["ClassName"]: string,
	["Serialize"]: () -> {},
	["Exists"]: (value: string) -> boolean
};

type SerializedEnumz = {
	["_CN"]: "Enumz",
	["_EN"]: string
}

local Enumz = { };

Enumz.__index = function(self, key)
	if (key == "Iterate") then
		return function()
			return self.__valuesIndexed;
		end
	elseif (key == "Count") then
		return #self.__valuesIndexed;
	elseif (key == "Random") then
		local count = #self.__valuesIndexed;
		local index = ((count == 1) and 1 or math.random(1, count));
		return self.__valuesIndexed[index];
	elseif (key == "Name") then
		return self.__name;
	elseif (key == "ClassType") then
		return "Enumz";
	elseif (key == "ClassName") then
		return self.__name;
	elseif (key == "Serialized") then
		return function(): SerializedEnumz
			return {
				["_CN"] = "Enumz",
				["_EN"] = self.__name
			};
		end
	elseif (key == "Exists") then
		return function(value: string|number)
			local valueType = typeof(value);
			assert(((valueType == "string") or (valueType == "number")), ("Invalid value type \"%s\""):format(valueType));

			if (valueType == "string") then
				return (self.__valuesNamed[value] ~= nil);
			elseif (valueType == "number") then
				return (self.__valuesIndexed[value] ~= nil);
			end

			return false;
		end
	end

	local value;
	if (typeof(key) == "number") then
		value = self.__valuesIndexed[key];
	else
		value = self.__valuesNamed[key];
	end

	assert(value, ("Enum %s does not have a value matching %s"):format(string(self.__name), string(key)));
	return value;
end

function Enumz.new(name: string, values: {string}): Enumz
	local self = setmetatable({ }, Enumz);

	self.__name = name;
	self.__valuesIndexed = { };
	self.__valuesNamed = { };
	for i, value in pairs(values) do
		self.__valuesIndexed[i] = value;
		self.__valuesNamed[value] = i;
	end

	return self;
end

local EnumzManager = { };
local EnumzCache = { };

function EnumzManager.Create(name: string, values: {string}): Enumz
	assert((not EnumzManager.Exists(name)), ("Enum with name %s already exists"):format(name));

	local enumz = Enum.new(name, values);
	EnumzCache[name] = enumz;

	return enumz;
end

function EnumzManager.Get(name: string): Enumz
	local enum = EnumzCache[name];
	assert((enum ~= nil), ("Enum %s does not exist"):format(name));

	return enum;
end

function EnumzManager.GetFromSerialized(serializedEnumz: SerializedEnumz): Enumz
	local className = serializedEnumz["_CN"];
	assert(className == "Enumz", "Invalid SerializedEnumz class name");

	local enumName = serializedEnumz["_EN"];
	return EnumzManager.Get(enumName);
end

function EnumzManager.Exists(name: string): boolean
	return (EnumzCache[name] ~= nil);
end

return EnumzManager;