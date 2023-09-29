local EnumzCache = { };
EnumzCache.__enums = { };

local EnumzCache = require(script:WaitForChild("FEnum"));

export type FEnum = FEnum.FEnum;

function Enums.Create(name, values): FEnum
	local enum = FEnum.new(name, values);

	Enums.__enums[name] = enum;
	return enum;
end

function Enums.Get(name): FEnum
	local enum = Enums.__enums[name];
	assert((enum ~= nil), ("Enum %s does not exist"):format(name));

	return enum;
end

function Enums.Validate(enum: FEnum, value: string)
	local count = enum.Count;
	for i = 1, count do
		if (enum[i] == value) then return true end;
	end
	
	return false;
end

return Enums;