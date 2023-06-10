local Main = {
    blipstatus = false,
    blips = {},
    majoba = false,
    mafure = false,
    wtym = false
}
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout',function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob',function(job)
	ESX.PlayerData.job = job
end)
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Markers.base.x, Config.Markers.base.y, Config.Markers.base.z)

    SetBlipSprite (blip, 67)

    SetBlipDisplay(blip, 4)

    SetBlipScale  (blip, 0.7)

    SetBlipColour (blip, 17)

    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentString(Locales[Config.lang]['company_base'])

    EndTextCommandSetBlipName(blip)
end)
Citizen.CreateThread(function() 
    while true do
        Wait(0)
        if ESX.PlayerData.job.name then 
            if (ESX.PlayerData.job.name == Config.jobname) then 

                Main.majoba = true
                if Main.blipstatus then 
                    Wait(9000)
                else
                    local blip = AddBlipForCoord(Config.Markers.get_car.x, Config.Markers.get_car.y, Config.Markers.get_car.z)
        
                    SetBlipSprite (blip, 477)
                
                    SetBlipDisplay(blip, 4)
                
                    SetBlipScale  (blip, 0.7)
                
                    SetBlipColour (blip, 17)
                
                    SetBlipAsShortRange(blip, true)
                
                    BeginTextCommandSetBlipName("STRING")
                
                    AddTextComponentString(Locales[Config.lang]['scrap_car_garage'])
                
                    EndTextCommandSetBlipName(blip)
                    table.insert(Main.blips, blip)

                    local blip2 = AddBlipForCoord(Config.Markers.collect.x, Config.Markers.collect.y, Config.Markers.collect.z)
        
                    SetBlipSprite (blip2, 477)
                
                    SetBlipDisplay(blip2, 4)
                
                    SetBlipScale  (blip2, 0.7)
                
                    SetBlipColour (blip2, 17)
                
                    SetBlipAsShortRange(blip2, true)
                
                    BeginTextCommandSetBlipName("STRING")
                
                    AddTextComponentString(Locales[Config.lang]['scrap_collection'])
                
                    EndTextCommandSetBlipName(blip2)
                    table.insert(Main.blips, blip2)
                    local blip3 = AddBlipForCoord(Config.Markers.sellscrap.x, Config.Markers.sellscrap.y, Config.Markers.sellscrap.z)
        
                    SetBlipSprite (blip3, 477)
                
                    SetBlipDisplay(blip3, 4)
                
                    SetBlipScale  (blip3, 0.7)
                
                    SetBlipColour (blip3, 17)
                
                    SetBlipAsShortRange(blip3, true)
                
                    BeginTextCommandSetBlipName("STRING")
                
                    AddTextComponentString(Locales[Config.lang]['scrap_sell'])
                
                    EndTextCommandSetBlipName(blip3)
                    table.insert(Main.blips, blip3)
                    local blip3 = AddBlipForCoord(Config.Markers.sell_ticket.x, Config.Markers.sell_ticket.y, Config.Markers.sell_ticket.z)
        
                    SetBlipSprite (blip3, 477)
                
                    SetBlipDisplay(blip3, 4)
                
                    SetBlipScale  (blip3, 0.7)
                
                    SetBlipColour (blip3, 17)
                
                    SetBlipAsShortRange(blip3, true)
                
                    BeginTextCommandSetBlipName("STRING")
                
                    AddTextComponentString(Locales[Config.lang]['sell_ticket'])
                
                    EndTextCommandSetBlipName(blip3)
                    table.insert(Main.blips, blip3)
                    Main.blipstatus = true
                end
                Wait(1600)
            else 
                Main.majoba = false
                if Main.blipstatus then 
                    Main.blipstatus = false
                    Main.deleteBlips()
                end
                Wait(1200)
            end 
        else 
            Wait(200)
        end
    end
end)
Main.deleteBlips = function()
    if Main.blips[1] ~= nil then
		for i=1, #Main.blips, 1 do
			RemoveBlip(Main.blips[i])
			Main.blips[i] = nil
		end
	end
end
Main.wyciaganie = function()
    local spawnCoords = vector3(Config.respcar.x, Config.respcar.y, Config.respcar.z)
    local randomPlate = math.random(100, 999)
    RequestModel(Config.car) 
    while not HasModelLoaded(Config.car) do
        Wait(1)
    end

    local vehicle = CreateVehicle(Config.car, spawnCoords, 0.0, true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)

    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
    ESX.ShowNotification(Locales[Config.lang]['go_for_collect'])
    TriggerServerEvent('jhn_zlomiarz:wyciaganie', GetVehicleNumberPlateText(vehicle))
    Main.mafure = true
end
Main.zbieranie = function()
    if Main.mafure then 
        FreezeEntityPosition(PlayerPedId(), true)
        ESX.ShowNotification(Locales[Config.lang]['start_collection'])
        Wait(Config.collect_scrap_time)
        FreezeEntityPosition(PlayerPedId(), false)
        ESX.ShowNotification(Locales[Config.lang]['collected'])
        TriggerServerEvent('jhn_zlomiarz:zebrane')
    else 
        ESX.ShowNotification(Locales[Config.lang]['car_official'])
    end
end
Main.pobieranie = function()
    ESX.TriggerServerCallback('jhn_zlomiarz:kaucja', function(ma)
        if ma then 
            Main.wyciaganie()
        else 
            ESX.ShowNotification(Locales[Config.lang]['havent_money'])
        end
    end)
end
Main.sprzedawanie = function()
    ESX.TriggerServerCallback('jhn_zlomiarz:sell', function(zlomma)
        if zlomma then 
            FreezeEntityPosition(PlayerPedId(), true)
            ESX.ShowNotification(Locales[Config.lang]['start_sell_scrap'])
            Wait(Config.sell_scrap_time)
            FreezeEntityPosition(PlayerPedId(), false)
        else 
            ESX.ShowNotification(Locales[Config.lang]['havent_scrap'])
        end
    end)
end
Main.chowaj = function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then 
        Main.pojazd = GetVehiclePedIsIn(PlayerPedId(), false)
        Main.model = GetEntityModel(Main.pojazd)
        if GetDisplayNameFromVehicleModel(Main.model) == Config.car then 
            ESX.TriggerServerCallback('jhn_zlomiarz:chowanie', function(git)
                if git then 
                    ESX.ShowNotification(Locales[Config.lang]['recovered_deposit'])
                    DeleteEntity(Main.pojazd)
                else 
                    ESX.ShowNotification(Locales[Config.lang]['not_recovered_deposit'])
                    DeleteEntity(Main.pojazd)
                end

            end, GetVehicleNumberPlateText(Main.pojazd))
        else
            ESX.ShowNotification(Locales[Config.lang]['not_in_official']) 
        end
    else 
        ESX.ShowNotification(Locales[Config.lang]['not_in_official'])
    end
end
Main.sprzedawaniekwitku = function() 
    ESX.TriggerServerCallback('jhn_zlomiarz:sell_ticket', function(kwitekma)
        if  kwitekma then 
            FreezeEntityPosition(PlayerPedId(), true)
            ESX.ShowNotification(Locales[Config.lang]['start_sell_ticket'])
            Wait(Config.sell_ticket_time)
            FreezeEntityPosition(PlayerPedId(), false)
        else 
            ESX.ShowNotification(Locales[Configlang]['not_ticket'])
        end
    end)
end
Citizen.CreateThread(function()
    while true do
        if Main.majoba then 
            Wait(0)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Markers.get_car.x,Config.Markers.get_car.y,Config.Markers.get_car.z))
            local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Markers.collect.x,Config.Markers.collect.y,Config.Markers.collect.z))
            local distance3 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Markers.sellscrap.x,Config.Markers.sellscrap.y,Config.Markers.sellscrap.z))
            local distance4 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Markers.sell_ticket.x,Config.Markers.sell_ticket.y,Config.Markers.sell_ticket.z))
            local distance5 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(Config.Markers.car_delete.x,Config.Markers.car_delete.y,Config.Markers.car_delete.z))
            if (distance < 4) then
                if Main.wtym == false then
                    Main.wtym = true
                    ESX.ShowNotification(Locales[Config.lang]['car_interaction'])
                end
                DrawMarker(21,Config.Markers.get_car.x,Config.Markers.get_car.y,Config.Markers.get_car.z,0,0,0,0,0,0,1.0,1.0,1.0,255,0,0,255,false,false,2,false,nil,nil,false)
                if IsControlJustReleased(0,38) then
                    Main.pobieranie()
                end
            elseif (distance2 < 4) then 
                if Main.wtym == false then
                    Main.wtym = true
                    ESX.ShowNotification(Locales[Config.lang]['scrap_collect_interaction'])
                end
                DrawMarker(21,Config.Markers.collect.x,Config.Markers.collect.y,Config.Markers.collect.z,0,0,0,0,0,0,1.0,1.0,1.0,255,0,0,255,false,false,2,false,nil,nil,false)
                if IsControlJustReleased(0,38) then
                    Main.zbieranie()
                end
            elseif (distance3 < 4) then
                if Main.wtym == false then
                    Main.wtym = true
                    ESX.ShowNotification(Locales[Config.lang]['sell_scrap_interaction'])
                end
                DrawMarker(21,Config.Markers.sellscrap.x,Config.Markers.sellscrap.y,Config.Markers.sellscrap.z,0,0,0,0,0,0,1.0,1.0,1.0,255,0,0,255,false,false,2,false,nil,nil,false)
                if IsControlJustReleased(0,38) then
                    Main.sprzedawanie()
                end
            elseif (distance4 < 4) then
                if Main.wtym == false then
                    Main.wtym = true
                    ESX.ShowNotification(Locales[Config.lang]['sell_ticket_interaction'])
                end
                DrawMarker(21,Config.Markers.sell_ticket.x,Config.Markers.sell_ticket.y,Config.Markers.sell_ticket.z,0,0,0,0,0,0,1.0,1.0,1.0,255,0,0,255,false,false,2,false,nil,nil,false)
                if IsControlJustReleased(0,38) then
                    Main.sprzedawaniekwitku()
                end
            elseif (distance5 < 4) then
                if Main.wtym == false then
                    Main.wtym = true
                    ESX.ShowNotification(Locales[Config.lang]['car_dv_interaction'])
                end
                DrawMarker(21,Config.Markers.car_delete.x,Config.Markers.car_delete.y,Config.Markers.car_delete.z,0,0,0,0,0,0,1.0,1.0,1.0,255,0,0,255,false,false,2,false,nil,nil,false)
                if IsControlJustReleased(0,38) then
                    Main.chowaj()
                end
            else 
                Main.wtym = false
                Wait(200)
            end
        else 
            Wait(400)
        end
    end
end)