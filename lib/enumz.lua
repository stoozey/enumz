export type Enumz = {
	["Iterator"]: {[number]: string},
	["Count"]: number,
	["Random"]: string,
	["Name"]: string,
	["ClassType"]: string,
	["ClassName"]: string,
	["Serialize"]: () -> {},
	["Exists"]: (value: string) -> boolean
};

local Enumz = { };

Enumz.__index = function(self, key)
	if (key == "Iterator") then
		return self.__valuesIndexed;
	elseif (key == "Count") then
		return #self.__valuesIndexed;
	elseif (key == "Random") then
		local count = #self.__valuesIndexed;
		if (count == 1) then return self.__valuesIndexed[1] end;
		
		return self.__valuesIndexed[math.random(1, count)];
	elseif (key == "Name") then
		return self.__name;
	elseif (typeof(key) == "number") then
		return self.__valuesIndexed[key];
	elseif (key == "ClassType") then
		return "Enumz";
	elseif (key == "ClassName") then
		return self.__name;
	elseif (key == "Serialized") then
		return function()
			return {
				["_CT"] = "Enumz",
				["_CN"] = self.__name
			};
		end
	elseif (key == "Exists") then
		return function(value: string)
			return (table.find(self.__valuesIndexed, value) ~= nil);
		end
	end

	local value = self.__valuesNamed[key];
	if (not value) then error(("Enum %s does not have a value named %s"):format(string(self.__name), string(key))) end;

	return value;
end

function Enumz.new(name, values): Enumz
	local self = setmetatable({ }, Enumz);

	self.__name = name;
	self.__valuesIndexed = { };
	self.__valuesNamed = { };
	for i, value in pairs(values) do
		self.__valuesIndexed[i] = value;
		self.__valuesNamed[value] = value;
	end

	return self;
end

return Enumz;