'use strict';
const { getMessage } = require("../helper")
module.exports.hello = async (event) => {

  console.log(getMessage())
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `Go Serverless v1.0! Your function executed successfully!-${process.env.name}`,
        input: event,
      },
      null,
      2
    ),
  };

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
