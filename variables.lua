if UnitClass("player") == "Warrior" then
	local version = 2.2
	local defaultFont = "Myriad-Pro"

	function WHUD_Variables_Init()
		WHUD_RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		WHUD_UPDATE_SPELLINFO()
	end

	WHUD_DEFAULT_VARS = {
		VERSION = version,
		DefaultFont = defaultFont,
		Ragebar = {
			enabled = true,
			X = 600,
			Y = -400,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			fontsize = 25,
			texture = "mpowa_ragebar",
			font = "homespun"
		},
		Cooldowns = {
			enabled = true,
			X = 650,
			Y = -350,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			flashtime = 2,
			fading = true,
			fadetime = 2,
			trinkets = true,
			racials = true
		},
		Overpower = {
			enabled = true,
			X = 585,
			Y = -300,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			MSG = "USE OVERPOWER NOW",
			mode = "text",
			pve = true,
			font = defaultFont,
			timerfont = defaultFont
		},
		Alerts = {
			enabled = true,
			X = 540,
			Y = -200,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			fontsize = 33,
			font = defaultFont,
			-- MODE
			["Battleshout"] = true,
			["Weightstone"] = true,
			["Salvation"] = true,
			["Execute"] = true
		},
		Glow = {
			["Overpower"] = true,
			["Execute"] = true,
			["Battleshout"] = true
		},
		Options = {
			X = 100,
			Y = -200
		}
	}
	WHUD_IMPORTANTSPELLS = {
		"Bloodthirst",
		"Whirlwind",
		"Intercept",
		"Charge",
		"Disarm",
		"Mocking Blow",
		"Bloodrage",
		"Retaliation",
		"Shield Wall",
		"Recklessness",
		"Death Wish",
		"Shield Block",
		"Berserker Rage",
		"Intimidating Shout",
		"Challenging Shout",
		"Taunt",
		"Mortal Strike",
		"Shield Slam",
		-- RACIALS
		"War Stomp",
		"Blood Fury",
		"Will of the Forsaken",
		"Berserking",
		"Escape Artist",
		"Shadowmeld",
		"Stone Form",
		-- ALERT
		"Battle Shout"
	}
	WHUD_RACIALS = {
		"War Stomp",
		"Blood Fury",
		"Will of the Forsaken",
		"Berserking",
		"Escape Artist",
		"Shadowmeld",
		"Stone Form"
	}
	WHUD_SPELLINFO = {}
	WHUD_SPELLS = {}
	for i = 1, table.getn(WHUD_IMPORTANTSPELLS) do
		WHUD_SPELLINFO[WHUD_IMPORTANTSPELLS[i]] = {1, 0, 0} -- default value for the important spells
		WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = WHUD_IMPORTANTSPELLS[i]
		if i == table.getn(WHUD_IMPORTANTSPELLS) then
			WHUD_SPELLINFO["Trinket1"] = {0, 0, 0}
			WHUD_SPELLINFO["Trinket2"] = {0, 0, 0} -- default values for the trinkets
			WHUD_SPELLINFO["Overpower"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "Overpower"
			WHUD_SPELLINFO["Revenge"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "Revenge"
			WHUD_SPELLINFO["Pummel"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "Pummel"
			WHUD_SPELLINFO["Shield Bash"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "Shield Bash"
			WHUD_SPELLINFO["Execute"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "Execute"
		end
	end

	-- Upgrade old versions, adding new added parameters
	function WHUD_Variables_Update()
		if WHUD_VARS.VERSION < version then
			if WHUD_VARS.VERSION < 1.5 then
				if WHUD_VARS.Overpower.mode == nil then
					WHUD_VARS.Overpower.mode = "text"
				end
			end
			if WHUD_VARS.VERSION < 1.6 then
				if WHUD_VARS.Cooldowns.trinkets == nil then
					WHUD_VARS.Cooldowns.trinkets = true
				end
			end
			if WHUD_VARS.VERSION < 1.7 then
				if WHUD_VARS.Cooldowns.fadeout then
					WHUD_VARS.Cooldowns.fadeout = nil
				end
				if WHUD_VARS.Cooldowns.fading == nil then
					WHUD_VARS.Cooldowns.fading = true
					WHUD_VARS.Cooldowns.fadetime = 2
				end
				if WHUD_VARS.Alerts == nil then
					WHUD_VARS.Alerts = {
						X = 0,
						Y = 100,
						scale = 1,
						strata = "HIGH",
						fontsize = 35,
						["Battleshout"] = true,
						["Weightstone"] = true,
						["Salvation"] = true
					}
				end
			end
			if WHUD_VARS.VERSION < 2.0 then
				WHUD_VARS.Glow = {
					["Overpower"] = true,
					["Execute"] = true,
					["Battleshout"] = true
				}
				WHUD_VARS.Alerts["Execute"] = true
				WHUD_VARS.Alerts.transparency = 1
				WHUD_VARS.Alerts.enabled = true
				WHUD_VARS.Alerts.font = defaultFont
				WHUD_VARS.Overpower.font = defaultFont
				WHUD_VARS.Overpower.timerfont = defaultFont
				WHUD_VARS.Overpower.pve = true
				WHUD_VARS.Overpower.transparency = 1
				WHUD_VARS.Ragebar.texture = "ragebar1"
				WHUD_VARS.Ragebar.font = defaultFont
				WHUD_VARS.Options = {
					X = 0,
					Y = 400
				}
				if WHUD_VARS.VERSION < 2.1 then
					WHUD_VARS.Cooldowns.racials = true
				end
			end
			WHUD_VARS.VERSION = version
		end
	end

	function WHUD_UPDATE_SPELLINFO()
		
		local function _createSet(list)
			local set = {}
			for _, l in ipairs(list) do set[l] = true end
			return set
		end

		-- updating the spellinfos, if the actionbar has been modified
		for i = 1, 100 do
			local name = GetSpellName(i, "player")
			if name == nil then
				return
			end

			for check = 1, table.getn(WHUD_IMPORTANTSPELLS) do
				if name == WHUD_IMPORTANTSPELLS[check] then
					-- slotID,startTime,endTime
					WHUD_SPELLINFO[name] = {i, 0, 0}
				end
			end

			-- Overpower/Revenge/Shield Bash/Pummel are no longer in the list and need to be checked extra ; Execute is also extra, for the glow
			local extras = _createSet{"Overpower", "Revenge", "Pummel", "Shield Bash", "Execute"}
			if extras[name] then
				WHUD_SPELLINFO[name] = {i, 0, 0}
			end
		end
	end

	function WHUD_Variables_Reset()
		WHUD_VARS = nil
		WHUD_VARS = WHUD_DEFAULT_VARS
		WHUD_Ragebar_VarUpdate()
		WHUD_Overpower_VarUpdate()
		WHUD_Cooldowns_VarUpdate()
		WHUD_Alerts_VarUpdate()
		DEFAULT_CHAT_FRAME:AddMessage(" >> |cff8f4108WarriorHUD|r reset complete. Loaded default settings.")
	end
end
