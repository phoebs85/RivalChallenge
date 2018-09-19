var current_aws_environment = "AWS";                                                    //This is just in case we want to specify multiple AWS definitions within Prod/Sandbox config.  Right now we only have 'AWS'

//------------------------------------------------------------------------------
var Production = {
  SPARQ: {}
};


//------------------------------------------------------------------------------
//Sandbox Value Override
var Sandbox = JSON.parse(JSON.stringify(Production));

//------------------------------------------------------------------------------
var config = {
  "Production": Production,
  "Sandbox": Sandbox
};
module.exports = function(current_sparq_environment) {
  return {
    settings: config[current_sparq_environment],
    awsenv: config[current_sparq_environment][current_aws_environment]
  };
};
