emitNet('centralcart.client.request');

onNet('centralcart.client.load', (data) => {
  eval(data);
});
