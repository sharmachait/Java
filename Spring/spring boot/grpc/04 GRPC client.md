we need the same protobuf file to be able to set up client as well

```java
@Service  
public class BillingServiceGrpcClient {  
    private static final Logger log = LoggerFactory.getLogger(BillingServiceGrpcClient.class);  
    private final BillingServiceGrpc.BillingServiceBlockingStub blockingStub;// synchronous calls  
  
    public BillingServiceGrpcClient(  
            @Value("${billing.service.address:localhost}") String serverAddress,  
            @Value("${billing.service.grpc.port:9001}") int serverPort  
    ) {  
        log.info("Connecting to Billing Service GRPC server at " + serverAddress +":" + serverPort);  
        ManagedChannel channel = ManagedChannelBuilder.forAddress(serverAddress, serverPort)  
                .usePlaintext().build();  
        blockingStub = BillingServiceGrpc.newBlockingStub(channel);  
    }  
  
     public BillingResponse createBillingAccount(String patientId, String name, String email) {  
        BillingRequest request = BillingRequest.newBuilder()  
                .setPatientId(patientId)  
                .setName(name)  
                .setEmail(email)  
                .build();  
        return blockingStub.createBillingAccount(request);  
     }  
}
```  