on("centralcart.ready", () => {
  const CentralCart = exports[GetCurrentResourceName()]

  CentralCart.registerCommand("examplejs", () => {
    console.log("Comando de exemplo em javascript")

    return "OK"
  })
})