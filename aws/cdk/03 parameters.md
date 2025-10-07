we can provide deployment parameters, like env variables for example log level using CfnParameters

a very contrived example for duration

```ts
const duration = new CfnParameter(
	this,  
	"duration",  
	{          
		default: 6,  
		minValue: 1,  
		maxValue: 10,  
		type: 'Number' // can also be 'String'  
	}
);  
const L2BucketProps: cdk.aws_s3.BucketProps = {  
	lifecycleRules: [  
		{      
			expiration: cdk.Duration.days(duration.valueAsNumber),  
		},  
	],
};  
  
const bucket = new Bucket(this, s3BucketUniqueId + "L2", L2BucketProps);
```

this allows us to override and change the value of duration without changing the code, by simply providing runtime parameters

> cdk deploy --parameters duration=7

this will throw an error if the parameter value provided is outside of the range specified

we can provide other validations as well like that apply to String
1. maxLength
2. minLength
![[Pasted image 20250923004028.png]]

