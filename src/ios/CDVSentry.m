#import "CDVSentry.h"
#import <Cordova/CDVPlugin.h>
@import Sentry;

@implementation CDVSentry

- (void)pluginInitialize {

    printf( "CDVSentry Initialize" );

    NSString *dsnString = [self getConfigForKey:@"dsnString"];

    if ( !dsnString.length || [dsnString isEqual: @"$DSNSTRING"] ) {
        NSException* invalidSettingException = [NSException
            exceptionWithName:@"invalidSettingException"
                reason:@"Please set \"dsnString\" with a preference tag in config.xml"
                userInfo:nil];
        @throw invalidSettingException;
    }

    [SentryClient setShared:[[SentryClient alloc] initWithDsnString:dsnString]];
    [[SentryClient shared] startCrashHandler];
}

- (NSString *)getConfigForKey:(NSString *)key {
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

- (void)setUserData:(CDVInvokedUrlCommand*)command {

    NSDictionary* attributes = command.arguments[0];
    NSString* userId = attributes[@"userId"];
    NSString* userEmail = attributes[@"email"];
    NSString* userName = attributes[@"userName"];
    NSMutableDictionary* extraData = [[NSMutableDictionary alloc] init];

    [extraData setObject:userEmail forKey:@"Email"];

    if (attributes[@"extraData"]) [extraData setObject:attributes[@"extraData"] forKey:@"Data"];

    if ( userId.length > 0 && userEmail.length > 0 ) {
        [SentryClient shared].user = [[SentryUser alloc] initWithId:userId email:userEmail username:userName extra:@{@"is_admin": @NO}];
    } else {
        NSLog(@"[CDVSentry] ERROR - No user registered. You must supply an email and a userId");
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    }
}

- (void)sendSuccess:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
