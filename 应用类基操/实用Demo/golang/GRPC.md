## 创建proto文件  

vim calculator.proto  
```
syntax = "proto3";

package calculator;

// 重要
option go_package = "your-username/calculator";

service CalculatorService {
    rpc Add(AddRequest) returns (AddResponse) {}
}

message AddRequest {
    int32 num1 = 1;
    int32 num2 = 2;
}

message AddResponse {
    int32 result = 1;
}

```

## 生成grpc相关的go代码  
`protoc --go_out=. --go_opt=paths=source_relative     --go-grpc_out=. --go-grpc_opt=paths=source_relative     calculator/calculator.proto`

