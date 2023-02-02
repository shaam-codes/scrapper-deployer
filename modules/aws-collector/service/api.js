module.exports.handler = async (event) => {
  console.log('Event: ', event);
  
  const greeting = 'Hello there, welcome to Scrapper!!'

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: greeting,
    }),
  }
}

