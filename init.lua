local Enumz = require(script:WaitForChild("Enumz"));

local EnumzManager = { };
local EnumzCache = { };

function EnumzManager.Create(name: string, values: {string}): Enumz
	assert((not EnumzManager.Exists(name)), ("Enum with name %s already exists"):format(name));

	local enumz = Enumz.new(name, values);
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