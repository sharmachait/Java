even if we delete our stack with
> cdk destroy CdkStarterStack

our stack will be deleted but not the underlying resource
because cdk has something known as the removal policy
by default the s3 bucket is orphaned when we delete the stack, so we should specify this value when creating the stack

the value possible for removal policy are
![[Pasted image 20250923005812.png]]

use it like so
```ts
const L2BucketProps: cdk.aws_s3.BucketProps = {  
    removalPolicy: RemovalPolicy.DESTROY,  
    lifecycleRules: [  
        {            
	        expiration: cdk.Duration.days(duration.valueAsNumber),        
        },  
    ],
};
```

this is not the default behaviour for cloudformation construct, but is for cdk l2 constructs