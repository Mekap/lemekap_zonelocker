-- Scripts Cote client / Par Gaya

-- Liste des Jobs
local config = {}
local FrostKill = false

function KillPlayer()
	local _player = PlayerPedId()
	local coords = GetEntityCoords(_player)
	Citizen.InvokeNative(0x697157CED63F18D4, _player, 500,500,550,500)
	--TriggerEvent("Tierra:FrostKill")
end

function Start()
	local blip = nil
	config = Config
	local DistanceBlip = Config.Distance - 350.0
	--print(DistanceBlip)
	Citizen.CreateThread(function()
	
		local x,y,z = table.unpack(config.Zone)
		local DeathCt = Config.TimeBeforeKill
		 while true do
			local playerCoords = GetEntityCoords(PlayerPedId())
			-- print(Vdist(playerCoords, config.Zone))
			if Vdist(playerCoords, config.Zone) <= config.Distance then
				if blip ~= nil then
					RemoveBlip(blip)
					blip = nil
					--ExecuteCommand("weather " .. Config.WeatherBackup)
					TriggerEvent("vorp:TipBottom", Config.MessageReturnSafe, 5000)
				end
				if DeathCt < Config.TimeBeforeKill then
					DeathCt = DeathCt + 1
				end
			else
				if blip == nil then
					blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512,x, y, z, DistanceBlip)
					TriggerEvent("vorp:TipBottom", Config.MessageBeforeKill, 5000)
					--ExecuteCommand("weather " .. Config.WeatherChange)
				end
				DeathCt = DeathCt - 1
				TriggerEvent("vorp:TipRight", DeathCt,1000)
				if DeathCt <= 0 then
					KillPlayer()
					DeathCt = Config.TimeBeforeKill
				end
			end
			Citizen.Wait(1000) 	
			-- -- print(DeathCt)
		end 
	end)
end
RegisterNetEvent("LeMekap:StartZoneLocker")
AddEventHandler("LeMekap:StartZoneLocker", function()
	Start()
	--ExecuteCommand("reloadcloths")
end)


