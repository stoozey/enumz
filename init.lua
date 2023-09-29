local RunService = game:GetService("RunService");

local Promise = require(script.Parent.promise);

local Enumz = require(script:WaitForChild("enumz"));
local EnumzTypes = require(script:WaitForChild("enumz_types"));

local EnumzManager = { };
local EnumzCache = { };

function EnumzManager.Create(name: string, values: {string}): EnumzTypes.Enumz
	assert((not EnumzManager.Exists(name)), ("Enum with name %s already exists"):format(name));

	local enumz = Enumz.new(name, values);
	EnumzCache[name] = enumz;

	return enumz;
end

function EnumzManager.Get(name: string): EnumzTypes.Enumz
	local enum = EnumzCache[name];
	assert((enum ~= nil), ("Enum %s does not exist"):format(name));

	return enum;
end

function EnumzManager.GetFromSerialized(serializedEnumz: EnumzTypes.SerializedEnumz): EnumzTypes.Enumz
	local className = serializedEnumz["_CN"];
	assert(className == "Enumz", "Invalid SerializedEnumz class name");

	local enumName = serializedEnumz["_EN"];
	return EnumzManager.Get(enumName);
end

function EnumzManager.Exists(name: string): boolean
	return (EnumzCache[name] ~= nil);
end

function EnumzManager.EnumzFolderInitServer(enumzFolder: Folder): nil
	assert(RunService:IsServer(), "ModulesFolderInitServer should be ran on the server only");

	local children = enumzFolder:GetChildren();
	for _, child in pairs(children) do
		if (child:IsA("ModuleScript")) then
			require(child);
		end
	end

	enumzFolder:SetAttribute("TotalChildren", #children);
end

function EnumzManager.EnumzFolderInitClient(enumzFolder: Folder): Promise<nil>
	return Promise.new(function(resolve, reject)
		if (RunService:IsServer()) then return reject("ModulesFolderInitClient should be ran on the client only") end;

		local totalChildren = enumzFolder:GetAttribute("TotalChildren");
		while (not totalChildren) do
			task.wait();
			totalChildren = enumzFolder:GetAttribute("TotalChildren");
		end

		local children = enumzFolder:GetChildren();
		while (#children < totalChildren) do
			task.wait();
			children = enumzFolder:GetChildren();
		end

		for _, child in pairs(children) do
			if (child:IsA("ModuleScript")) then
				require(child);
			end
		end

		resolve();
	end);
end

return EnumzManager;