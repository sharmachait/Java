to intercept the GRPC call to work with metadata which are equivalent to headers in http

We can intercept at the client side to add our api key
```java
@Slf4j  
@GrpcGlobalClientInterceptor  
public class ApiKeyAuthInterceptor implements ClientInterceptor {  
    @Override  
    public <ReqT, RespT> ClientCall<ReqT, RespT> interceptCall(  
            MethodDescriptor<ReqT, RespT> methodDescriptor,  
            CallOptions callOptions,  
            Channel channel) {  
        log.info("Client interceptor {}", methodDescriptor.getFullMethodName());  
        return new ForwardingClientCall  
                .SimpleForwardingClientCall<>(channel.newCall(methodDescriptor, callOptions)){  
            @Override  
            public void start(Listener<RespT> respTListener, Metadata headers){  
                headers.put(Metadata.Key.of("x-api-key", Metadata.ASCII_STRING_MARSHALLER), "myapikey");  
                super.start(respTListener, headers);  
            }  
        };  
    }  
}
```

and then intercept at the server side to verify the api key
```java
@Slf4j  
@GrpcGlobalServerInterceptor  
public class ApiKeyAuthInterceptor implements ServerInterceptor {  
    @Override  
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(  
            ServerCall<ReqT, RespT> serverCall,  
            Metadata metadata,  
            ServerCallHandler<ReqT, RespT> serverCallHandler) {  
        log.info("Server interceptor {}", serverCall.getMethodDescriptor());  
        Metadata.Key<String> apiKeyMetadata = Metadata.Key.of("x-api-key", Metadata.ASCII_STRING_MARSHALLER);  
        String apiKey = metadata.get(apiKeyMetadata);  
        log.info("API key received {}", apiKey);  
        if(Objects.nonNull(apiKey) && apiKey.equals("myapikey")){  
            return serverCallHandler.startCall(serverCall, metadata);  
        }  
        Status status = Status.UNAUTHENTICATED.withDescription("Invalid api-key");  
        serverCall.close(status, metadata);  
        return new ServerCall.Listener<>(){};  
    }  
}
```