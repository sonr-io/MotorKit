// MotorKitBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MotorKit, NSObject)

RCT_EXTERN_METHOD(init)
RCT_EXTERN_METHOD(getAddress)
RCT_EXTERN_METHOD(getBalance)
RCT_EXTERN_METHOD(createAccount: (NSString *)password)
@end
