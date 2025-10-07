typically stacks are organized separately on their functionality
- stateful like databases and buckets
- IAM roles, policies secrest
- foundational resources like VPCs and DNS
we may put resources in different stacks, but we may still need to refer them in other stacks
## Sharing data using Cloud Formation
we can do that by using ==`Fn.importValue()`==

anything we want to import that resources ARN must first be exported from where it was created Using CfnOutput

```ts
export class PhotosStack extends Stack {  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
        const bucket = new Bucket(this, "PhotosBucket");  
        new CfnOutput(this, photosBucketExportKey, {  
            value: bucket.bucketArn,  
			exportName: photosBucketExportKey
        })  
    }
}  
  
export const photosBucketExportKey = 'photos-bucket';
```

it can be imported and referenced like so
```ts
import {Fn, Stack, StackProps} from "aws-cdk-lib";  
import {Construct} from "constructs";  
import {Code, Function as Lambda, FunctionProps, Runtime} from "aws-cdk-lib/aws-lambda";  
import {photosBucketExportKey} from "./PhotosStack";


export class PhotosHandlerStack extends Stack {  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
  
        const targetBucket = Fn.importValue(photosBucketExportKey);  
  
        const LambdaProps: FunctionProps = {  
            runtime: Runtime.NODEJS_18_X,  
            handler: 'index.handler',  
            code: Code.fromInline(`  
                exports.handler = async(event) -> {                    
	                console.log("hello!: " + process.env.TARGET_BUCKET);           
	            };
			`),  
            environment :{  
                TARGET_BUCKET: targetBucket  
            }  
        };  
        new Lambda(  
            this,  
            'PhotosHandler',  
            LambdaProps  
        );  
    }
}
```

but in this case we cant deploy all the stacks simply with
> cdk deploy -all

because order matters so we can deploy one at a time, CDK by default takes the alphabetical order
> cdk deploy PhotosStack && cdk deploy PhotosHandlerStack
## Sharing data using CDK Better way
Use props to drill down values by overriding types in TypeScript

```ts
import {Stack, StackProps} from "aws-cdk-lib";  
import {Construct} from "constructs";  
import {Code, Function as Lambda, FunctionProps, Runtime} from "aws-cdk-lib/aws-lambda";  
  
interface PhotosHandlerStackProps extends StackProps {  
    targetBucketArn: string  
}  
  
export class PhotosHandlerStack extends Stack {  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
  
        const targetBucket = Fn.importValue(photosBucketExportKey);  
  
        const LambdaProps: FunctionProps = {  
            runtime: Runtime.NODEJS_18_X,  
            handler: 'index.handler',  
            code: Code.fromInline(`  
                exports.handler = async(event) -> {                    
	                console.log("hello!: " + process.env.TARGET_BUCKET);           
	            };
			`),  
            environment :{  
                TARGET_BUCKET: targetBucket  
            }  
        };  
        new Lambda(  
            this,  
            'PhotosHandler',  
            LambdaProps  
        );  
    }
}
```

the S3 stack remains the same, we dont need the CfnOutput
```ts
import {Stack, StackProps} from "aws-cdk-lib";  
import {Construct} from "constructs";  
import {Bucket} from "aws-cdk-lib/aws-s3";  
  
export class PhotosStack extends Stack {  
  
    public readonly bucketArn: string;  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
        const bucket = new Bucket(this, "PhotosBucket");  
        this.bucketArn = bucket.bucketArn  
    }  
}
```

only the way we initialize the Lambda stack changes
```ts
#!/usr/bin/env node  
import * as cdk from 'aws-cdk-lib';  
import {PhotosStack} from "../lib/PhotosStack";  
import {PhotosHandlerStack} from "../lib/PhotosHandlerStack";  
  
const app = new cdk.App();  
const photoStack = new PhotosStack(app, 'PhotosStack');  
new PhotosHandlerStack(
	app, 
	'PhotosHandlerStack',
	{targetBucketArn: photoStack.bucketArn}
);
```

with this setup we dont have to worry about the order of deployment
CDK is smart enough to understand that from the references

it essentially does the same thing as before and creates a CfnOutput that is being imported into the Lambda Stack

### deleting stacks
we cant delete a stack if it is being referenced in some other stack
need to take care of the topological ordering when deleting