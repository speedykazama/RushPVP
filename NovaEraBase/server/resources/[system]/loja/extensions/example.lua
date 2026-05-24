AddEventHandler("centralcart.ready", function()
  local CentralCart = exports[GetCurrentResourceName()]

  CentralCart:registerCommand("examplelua", function()
    print("Comando de exemplo em lua")

    return "OK"
  end)
end)