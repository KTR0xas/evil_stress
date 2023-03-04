ESX = exports['es_extended']:getSharedObject()

AddEventHandler('esx_status:loaded', function(status)
    TriggerEvent('esx_status:registerStatus', 'stress', 1000000, '#cadfff', function(status)
        return false
    end, function(status)
        status.add(1)
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()

            TriggerEvent('esx_status:getStatus', 'stress', function(status)
                StrssVal = status.val
            end)

            if StressVal == 1000000 then -- StressVal máximo
                SetTimecycleModifier("WATER_silty") -- Añadimos un poco de blur y reducimos la distancia de visión
                SetTimecycleModifierStrength(1)
            else
                ClearExtraTimecycleModifier()
            end
            
            if StressVal >= 900000 then
                local veh = GetVehiclePedIsUsing(ped)
                if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then -- Si el player está en un coche
                    Citizen.Wait(1000)
                    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15) -- Vibración de la cámara
                    TaskVehicleTempAction(ped, veh, 7, 250) -- Gira el coche levemente a la izquierda
                    Citizen.Wait(500)
                    TaskVehicleTempAction(ped, veh, 8, 250) -- Gira el coche levemente a la derecha
                    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
                    Citizen.Wait(500)
                    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
                else
                    Citizen.Wait(1500)
                    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
                end
			elseif StressVal >= 800000 then
				local veh = GetVehiclePedIsUsing(ped)
			  	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
					Citizen.Wait(1000)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
					TaskVehicleTempAction(ped, veh, 7, 150)
					Citizen.Wait(500)
					TaskVehicleTempAction(ped, veh, 8, 150)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
					Citizen.Wait(500)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
			  	else
					Citizen.Wait(1500)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
			  	end
            elseif StressVal >= 700000 then
				local veh = GetVehiclePedIsUsing(ped)
			  	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
					Citizen.Wait(1000)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
					TaskVehicleTempAction(ped, veh, 7, 100)
					Citizen.Wait(500)
					TaskVehicleTempAction(ped, veh, 8, 100)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
					Citizen.Wait(500)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			  	else
					Citizen.Wait(2000)
					ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			  	end
            elseif StressVal >= 600000 then -- Por debajo de 60% de estrés no hay problemas al conducir
				Citizen.Wait(2500) -- frecuencia
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07) -- efecto de vibración de la cámara
			elseif StressVal >= 500000 then
				Citizen.Wait(3500)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			elseif StressVal >= 350000 then
				Citizen.Wait(5500)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
			elseif StressVal >= 200000 then
				Citizen.Wait(6500)
                ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.03)
            else
                Citizen.Wait(3000)
            end
        end
    end)
end)

Citizen.CreateThread(function() -- Apuntando con el arma
    while true do
        local ped = PlayerPedId()
        local status = GetPedConfigFlag(ped, 78, 1)

        if status then
            TriggerServerEvent("stress:add", 10000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Cuando tengas un arma en la mano (a excepción de armas cuerpo a cuerpo o explosivos)
    while true do
        local ped = PlayerPedId()
        local status = IsPedArmed(ped, 4)

        if status then
            TriggerServerEvent("stress:add", 10000)
            Citizen.Wait(15000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Mientras dispara
    while true do
        local ped = PlayerPedId()
        local status = IsPedShooting(ped)
        local silenced = IsPedCurrentWeaponSilenced(ped)

        if status and not silenced then
            TriggerServerEvent("stress:add", 200000)
            Citizen.Wait(2000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Escuchando disparos, golpes cuerpo a cuerpo o simplemente agitación de los NPCs
    while true do
        local ped = PlayerPedId()
        local status = GetPedAlertness(ped)

        if status == 1 then
            TriggerServerEvent("stress:add", 10000)
            Citizen.Wait(10000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Apuntando, sujetando o golpeando cuerpo a cuerpo
    while true do
        local ped = PlayerPedId()
        local status = IsPedInMeleeCombat(ped)

        if status then
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(1)
        end
    end
end)


Citizen.CreateThread(function() -- Mientras la barra de vida está a la mitad o menos
    while true do
        local ped = PlayerPedId()
        local amount = (GetEntityHealth(ped)-100)

        if amount <= 50 then
            TriggerServerEvent("stress:add", 100000)
            --exports['mythic_notify']:SendAlert("error", "TEXTO") -- Ejemplo mythic notify
            Citizen.Wait(60000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Esperando o caminando
    while true do
        local ped = PlayerPedId()
        local status = IsPedStill(ped)
        local status_w = IsPedArmed(ped, 4)
        local status2 = IsPedWalking(ped)
		local status_v = IsPedInAnyVehicle(ped, false)

        if status and not status_w and not status_v and not GetPedStealthMovement(ped) then -- Esperando
            Citizen.Wait(15000)
            TriggerServerEvent("stress:remove", 30000)
            Citizen.Wait(15000)
        elseif status2 and not status_w and not GetPedStealthMovement(ped) then -- Caminando
            Citizen.Wait(15000)
            TriggerServerEvent("stress:remove", 10000)
            Citizen.Wait(15000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- En paracaídas
    while true do
        local ped = PlayerPedId()
        local status = GetPedParachuteState(ped)

        if status == 0 then -- Cayendo (con el paracaídas equipado)
            TriggerServerEvent("stress:add", 60000)
            Citizen.Wait(5000)
        elseif status == 1 or status == 2 then -- Paracaídas abierto
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(5000) -- El wait es muy rápido porque no suele ser muy común estas experiencias en rol
        end
    end
end)

Citizen.CreateThread(function() -- Modo sigilo
    while true do
        local ped = PlayerPedId()
        local status = GetPedStealthMovement(ped)

        if status then
            TriggerServerEvent("stress:add", 10000)
            Citizen.Wait(8000)
        else
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function() -- Animación de dormir || Usar este ejemplo por si queremos hacer que una animación nos dé o nos quite estrés
    while true do
        local ped = PlayerPedId()
        local status = IsEntityPlayingAnim(ped, "timetable@tracy@sleep@", "idle_c", 3)

        if status then
            Citizen.Wait(20000)
            TriggerServerEvent("stress:remove", 200000)
        else
            Citizen.Wait(1)
        end
    end
end)


function AddStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:add", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:add", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end

function RemoveStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:remove", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:remove", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end

--[[DEBUG]]
RegisterCommand('estres', function()
    TriggerClientEvent('esx_status:add', source, 'stress', 100000)
end)