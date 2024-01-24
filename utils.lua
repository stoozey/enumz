local EnumzUtil = { };

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Packages = ReplicatedStorage:WaitForChild("Packages");
local Promise = require(Packages:WaitForChild("promise"));

function EnumzUtil.EnumzFolderInitServer(enumzFolder: Folder): nil
	assert(RunService:IsServer(), "ModulesFolderInitServer should be ran on the server only");

	local children = enumzFolder:GetChildren();
	for _, child in pairs(children) do
		if (child:IsA("ModuleScript")) then
			require(child);
		end
	end

	enumzFolder:SetAttribute("TotalChildren", #children);
end

function EnumzUtil.EnumzFolderInitClient(enumzFolder: Folder): Promise<nil>
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

return EnumzUtil;