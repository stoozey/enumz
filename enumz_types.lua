local EnumzTypes = { };

export type Enumz = {
	["Iterator"]: {[number]: string},
	["Count"]: number,
	["Random"]: string,
	["Name"]: string,
	["ClassName"]: string,
	["Serialize"]: () -> {},
	["Exists"]: (value: string) -> boolean
};

export type SerializedEnumz = {
	["_CN"]: "Enumz",
	["_EN"]: string
}

return EnumzTypes;