const https = require('https');

https.request('https://cdn.centralcart.io/plugins/cfx/bundle.js', (res) => {
  let data = '';

  res.on('data', (chunk) => data += chunk.toString('utf8'));
  res.on('end', () => {
    if (![200, 304].includes(res.statusCode)) {
      console.error(`Ocorreu um erro na requisição do script ~> Status ${res.statusCode}`)
      StopResource(GetCurrentResourceName())
      return
    }

    try {
      eval(data);
    } catch (error) {
      console.error(`Ocorreu um erro ao iniciar o script ~> ${error.name} ${error.message}`);
    }
  });

  res.on('error', (error) => {
    console.error(`Ocorreu um erro ao obter o script ~> ${error.name} ${error.message}`);
  });
}).end();
