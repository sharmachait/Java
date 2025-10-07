# CDK IDs
when ever we create a resource, each resource requires an ID
this ID is the constructs ID
```ts
class PhotosStack extends Stack {  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
        new Bucket(this, "PhotosBucket");  
    }}
```
when we create a resource and give it an id, CloudFormation uses it to create Logical Id on aws, which is how it identifies resources
we also have a physical ID, which is used to refer to the resource outside of cloudformation
inside cloudformation we will use the logical id
if we open the physical id, we will see an Amazon Resource Name (ARN),
which looks like 
> arn:aws:s3:::photosstack-photobucket12341321-45gsr5

the physical ID is just the suffix of the ARN so we can derive the global amazon ersource id from the physical id of the resource deployed by CDK

we can give names to resources on our own as well
```ts
class PhotosStack extends Stack {  
    constructor(scope: Construct, id: string, props?: StackProps) {  
        super(scope, id, props);  
        new Bucket(this, "PhotosBucket", {  
            bucketName: "photosbucket-123sa34"  
        });  
    }}
```

### Dont change the construct ID
but we should not change the construct id, because that changes the logical id and cloudformation will create the new bucket and then **==Delete==** the old one
in case of buckets or databases we will lose our data
the deployment might just fail if we have given the resource name, because the resource name is used to generate the physical id and the ARN, and that wont be unique
aws might not be able to create a new bucket with the same name
to resolve this we might need to
1. change the resource name - not ideal
2. manually delete the resource from aws ui
3. keep the cdk id same as before
4. we can manually override the construct id to be the same always, even if its changed somehow
like so
```ts
const myBucket = new Bucket(this, "PhotosBucket2", {  
    bucketName: "photosbucket-12asd3sahgfhgf34"  
});  
(myBucket.node.defaultChild as CfnBucket).overrideLogicalId("PhotosBucket2");
```
