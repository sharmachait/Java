![[Pasted image 20250907230458.png]]api gateway can integrate with cognito for authentication purposes as well
integrates with cloud watch for monitoring and logging(centralized)
we can even implement some caching strategy for the api requests
has built in cloudFront(cdn) for static content delivery
also helps do canary deployments by regulating the traffic
we can create stateful websocket apis as well as stateless rest apis

in an API on API gateway we can configure 4 things
1. Method Request - 
	1. allows us to configure validation of the http request for parameters, headers and structure of the request body.
	2. allows us to define the public interface for the API
	3. we can make the API require authorization here, through aws IAM
	4. we can define if the api key is required or not to hit this api here
	5. allows us to define http request validators
		1. body only
		2. body, query parameters and headers
		3. parameters and headers
	6. we can use URL query string parameters to define a list of all the parameters supported by this api and mark some as optional as well
	7. we can use HTTP request headers to define all the headers supported by our api
	8. in the request body we can provide the structure required for the request
	9. to validate request body we need to use models which is json schema with datatypes
2. Integration Request - 
	1. allows us to transform the http request into another form before reaching the target backend
	2. allows us to configure the target backend
	3. instead of providing a url for the target backend we can choose a lambda function as target backend as well
	4. we can use mapping templates to change the structure of the request to the one required by the target backend
	5. we can also transform url path parameters url query parameters and http headers
3. Integration Response - 
	1. allows us to modify the response of the target backend before returning to the client
	2. useful when we dont want the errors to propagate to the client
	3. status codes and errors have sensitive information about out application we dont want it exposed
	4. we can prohibit some responses with certain status codes to not pass through
	5. we can transform the response using a mapping template
4. Method Response - 
	1. used to configure and validate the final look and shape off the http response before returning to the client
	2. we can define headers and content types
	3. we can define all the possible response status codes
	4. the headers in defined in this stage are allowed to pass through to the client
	5. we can define what response body can be in response with certain status codes, which method response will validate
all of this is good practice because it allows auto generated clients and SDKs

## Mock APIs
![[Pasted image 20250909003901.png]]

we can mock api response at the api gateway level to mock response from lambda function, without being processed my the lambda
the response is hardcoded at the APIGateway level

and we can define mock requests to the lambda to do integration testing of the lambda

we can read path parameters at the api gateway level in the mapping templates using the following syntax
```json
{
    "userId": "$input.params('userid')"
}
```

the $input is an api gateway level object

similarly we can read query string parameters as well /users?count=1
`"$input.params('count')"`

