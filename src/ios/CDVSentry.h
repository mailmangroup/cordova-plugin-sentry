#import <Cordova/CDVPlugin.h>

@interface CDVSentry : CDVPlugin

- (void)testCrash:(CDVInvokedUrlCommand*)command;

- (void)setUserData:(CDVInvokedUrlCommand*)command;

@end
