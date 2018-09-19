var AWS 		= require('aws-sdk');
var _ 			= require('underscore');
var Promise 	= require('bluebird');

var envvars 		= process.env;
var env 			= (_.has(envvars, "environment") ? envvars.environment : "Sandbox");
var settings 		= require('./settings')(env).settings;

exports.handler = (event, context, callback) => {
	console.log(JSON.stringify(_.omit(event, "data")));  //Exclude any data in logs.

	console.log("File Name" + event.Records[0].s3.object.key);
	callback(null, "COMPLETED");
};