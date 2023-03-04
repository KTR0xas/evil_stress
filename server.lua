ESX = exports['es_extended']:getSharedObject()

local log = true -- poner en false si no quieres logs


RegisterServerEvent("stress:add")
AddEventHandler("stress:add", function (value)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playername = xPlayer.name

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "ambulance" then -- Si el player es policía gana la mitad de estrés
		TriggerClientEvent("esx_status:add", source, "stress", value / 10)
		if log then
			SaveLog("Stress added : "..value/10, playername)
		end
	else
		TriggerClientEvent("esx_status:add", source, "stress", value)
		if log then
			SaveLog("Stress added : "..value, playername)
		end
	end
end)

RegisterServerEvent("stress:remove") -- reducir estrés
AddEventHandler("stress:remove", function (value)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playername = xPlayer.name

	TriggerClientEvent("esx_status:remove", source, "stress", value)
	if log then
		SaveLog("Stress removed : "..value, playername)
	end
end)

function SaveLog(text, playername)
	local time = os.date("%d/%m/%Y %X")
	local name = playername
	local data = time .. ' : ' .. name .. ' - ' .. text

	local content = LoadResourceFile(GetCurrentResourceName(), "logs.txt")
	local newContent = content .. '\r\n' .. data

	SaveResourceFile(GetCurrentResourceName(), "logs.txt", newContent, -1)
end