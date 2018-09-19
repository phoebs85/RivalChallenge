var AWS 		= require('aws-sdk');
var _ 			= require('underscore');
var Promise 	= require('bluebird');

var envvars 		= process.env;
var env 			= (_.has(envvars, "environment") ? envvars.environment : "Sandbox");
var settings 		= require('./settings')(env).settings;

function getProxyResponse(msg, isError = false, statusCode) {
	if (!_.isString(statusCode)) statusCode = parseInt(statusCode);

	let m = (_.isObject(msg) ? JSON.stringify(msg) : msg);
	let resp = {
		"statusCode": (isError ? statusCode : 200),
		"headers": {
			"Access-Control-Allow-Origin" : "*",
			"Access-Control-Allow-Credentials" : true // Required for cookies, authorization headers with HTTPS
		},
		"body": m
	};
	if (_.isObject(msg)) resp.headers["Content-Type"] = "application/json";
	return resp;
}

exports.handler = (event, context, callback) => {
	console.log(JSON.stringify(_.omit(event, "data")));  //Exclude any data in logs.

	let AWS_S3 = new AWS.S3({
		apiVersion: '2006-03-01'
	});
	return new Promise((resolve, reject) => {
		try {
			AWS_S3.putObject({
				Bucket 	: envvars.S3_BUCKET,
				Key 	: envvars.S3_KEY,
				Body 	: Buffer.from("This is a Test File", 'utf8')
			}, function(err, data) {
				if (err) {
					console.log(err, err.stack); // an error occurred
					throw err;
				}
				else {
					console.log("Save " + envvars.S3_KEY);   // successful response
					resolve();
				}
			});
		} catch (err) {
			console.error(err);
			reject(err);
		}
	})
	.then(() => callback(null, getProxyResponse("COMPLETE")))
	.catch((err) => callback(getProxyResponse({"error" : err}, true, 500)))
};