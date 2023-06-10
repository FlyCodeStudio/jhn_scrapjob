local Main = {
    auta = {}
}
ESX.RegisterServerCallback('jhn_zlomiarz:kaucja', function(source, cb, rejestracja)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.deposit_for_car then 
        xPlayer.removeMoney(Config.deposit_for_car)
        cb(true)
    else
        cb(false)
    end
end)
Main.zebrane = function() 
    Main.jakisrandom = math.random(1, 100)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
        if xPlayer.job.name == Config.jobname then
            if Main.jakisrandom < 95 then 
                xPlayer.addInventoryItem(Config.good_scrap_item_name, 1)
                xPlayer.showNotification(Locales[Config.lang]['get_good_scrap'])
            else 
                xPlayer.addInventoryItem(Config.bad_scrap_item_name, 1)
                xPlayer.showNotification(Locales[Config.lang]['get_bad_scrap'])
            end
        else 
            xPlayer.showNotification('hacker')
        end
    end
end
Main.wyciaganie = function(rejestracja)
    Main.auta[source] = rejestracja
end
ESX.RegisterServerCallback('jhn_zlomiarz:chowanie', function(source, cb, rejestracja)
    if Main.auta[source] == rejestracja then 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(Config.deposit_for_car)
        cb(true)
    else 
        cb(false)
    end
end)
RegisterServerEvent('jhn_zlomiarz:wyciaganie', Main.wyciaganie)
RegisterServerEvent('jhn_zlomiarz:zebrane', Main.zebrane)
ESX.RegisterServerCallback('jhn_zlomiarz:sell', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
        if xPlayer.job.name == Config.jobname then
            if xPlayer.getInventoryItem(Config.good_scrap_item_name).count ~= 0 or xPlayer.getInventoryItem(Config.bad_scrap_item_name).count ~= 0 then 
                cb(true)
                Wait(5000)
                if xPlayer.getInventoryItem(Config.good_scrap_item_name).count ~= 0 then 
                    local ilosc = xPlayer.getInventoryItem(Config.good_scrap_item_name).count
                    xPlayer.removeInventoryItem(Config.good_scrap_item_name, ilosc)
                    xPlayer.addInventoryItem(Config.ticket_scrap_item_name, 5)
                elseif xPlayer.getInventoryItem(Config.bad_scrap_item_name).count ~= 0 then
                    local ilosc = xPlayer.getInventoryItem(Config.bad_scrap_item_name).count
                    xPlayer.removeInventoryItem(Config.bad_scrap_item_name, ilosc)
                    xPlayer.addInventoryItem(Config.ticket_scrap_item_name, 1) 
                end
            else 
                cb(false)
            end
        else 
            xPlayer.showNotification('hakier')
        end
    end
end)
ESX.RegisterServerCallback('jhn_zlomiarz:sell_ticket', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
        if xPlayer.getInventoryItem(Config.ticket_scrap_item_name).count ~= 0 then 
            cb(true)
            Wait(5000)
                local ilosc = xPlayer.getInventoryItem(Config.ticket_scrap_item_name).count
                xPlayer.removeInventoryItem(Config.ticket_scrap_item_name, ilosc)
                xPlayer.addMoney(ilosc *200)
        else 
            cb(false)
        end
    end
end)
