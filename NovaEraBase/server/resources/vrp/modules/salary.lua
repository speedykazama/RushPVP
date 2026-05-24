-----------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------
local Salary = {}
-----------------------------------------------------------------------------------------------------------------
-- SALARYNOTIFICATION
-----------------------------------------------------------------------------------------------------------------
function SalaryNotification(Passport, SalaryAmount, Work)
    local source = vRP.Source(Passport)
    if source then
        local mensagem = ""
        if Groups["Premium"] and Groups["Premium"]["Parent"] and Groups["Premium"]["Parent"][Work] then
            mensagem = SalaryVIPTextNotification:gsub("{salary}", SalaryAmount):gsub("{work}", Work)
        else
            mensagem = SalaryWorkTextNotification:gsub("{salary}", SalaryAmount):gsub("{work}", Work)
        end
        if ShowNotificationSalary then
            TriggerClientEvent("Notify", source, "salario2", mensagem, 10000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------
-- SALARY:ADD
-----------------------------------------------------------------------------------------------------------------
AddEventHandler("Salary:Add", function(Passport, Permission)
    if not Salary[Permission] then
        Salary[Permission] = {}
    end
    if not Salary[Permission][Passport] then
        Salary[Permission][Passport] = os.time() + SalarySeconds
    end
end)
-----------------------------------------------------------------------------------------------------------------
-- SALARY:REMOVE
-----------------------------------------------------------------------------------------------------------------
AddEventHandler("Salary:Remove", function(Passport, Permission)
    if Permission then
        if Salary[Permission] and Salary[Permission][Passport] then
            Salary[Permission][Passport] = nil
        end
    else
        for k, v in pairs(Salary) do
            if Salary[k][Passport] then
                Salary[k][Passport] = nil
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(SalarySeconds * 1000)
        for k, v in pairs(Salary) do
            for Passport, sources in pairs(Salary[k]) do
                local id, level = vRP.GetHierarquia(Passport, k)
                Salary[k][Passport] = os.time() + SalarySeconds
                if vRP.HasGroup(Passport, k, level) then
                    if Groups[k] and Groups[k]["Salary"] and Groups[k]["Salary"][level] and vRP.HasService(Passport, k) then
                        local Salary = Groups[k]["Salary"][level]
                        vRP.GiveBank(Passport, Salary)
                        SalaryNotification(Passport, Salary, k)
                    else
                        Salary[k][Passport] = nil
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
    for k, v in pairs(Salary) do
        if Salary[k][Passport] then
            Salary[k][Passport] = nil
        end
    end
end)