#import <Cordova/CDVPlugin.h>

@interface CDVSentry : CDVPlugin

- (void)forceCrash:(CDVInvokedUrlCommand*)command;

- (void)setUserData:(CDVInvokedUrlCommand*)command;

@end
