local Enumz = { };

local EnumzTypes = require(script.Parent:WaitForChild("enumz_types"));

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
		return function(): EnumzTypes.SerializedEnumz
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

function Enumz.new(name: string, values: {string}): EnumzTypes.Enumz
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

return Enumz;