#import "CDVSentry.h"
#import <Cordova/CDVPlugin.h>
#import <Sentry/Sentry.h>

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

    NSError *error = nil;
    SentryClient *client = [[SentryClient alloc] initWithDsn:dsnString didFailWithError:&error];
    SentryClient.sharedClient = client;
    [SentryClient.sharedClient startCrashHandlerWithError:&error];
    if (nil != error) {
        NSLog(@"%@", error);
    }
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
        SentryClient.sharedClient.user = [[SentryUser alloc] initWithUserId:userId];
        SentryClient.sharedClient.user.email = userEmail;
        SentryClient.sharedClient.user.username = userName;
        SentryClient.sharedClient.user.extra = extraData;
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
