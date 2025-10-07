built in functions to help manage stacks

we can create a topological ordering of resources when creating them
we can use intrinsic functions to do it
### CloudFormation Functions
1. Ref - allows us to reference information around from our cloud formation template - most used
	1. used when we provide duration using parameters in [[03 parameters]]
2. Base64
3. Cidr
4. FindInMap
5. GetAtt
6. GetAZs
7. ImportValue
8. Length
9. Select
10. Split
11. Sub
12. ToJsonString
13. Transform
14. If

## making resource names unique using the stacks ID and functions
```ts
class PhotosStack extends Stack {  
	
    private stackSuffix: string;  
	
    private initializeSuffix(){  
        // stack id looks like arn/stackname/stackid  
        const shortStackId = Fn.select(2,Fn.split('/', this.stackId));  
        this.stackSuffix = Fn.select(4, Fn.split('-', shortStackId));  
    }  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
        this.initializeSuffix();  
        new Bucket(this, "PhotosBucket2", {  
            bucketName: "photosbucket-"+this.stackSuffix  
        });  
    }
}
```
