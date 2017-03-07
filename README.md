# cordova-plugin-sentry

## Installation

`cordova platform add ios`

`cordova plugin add https://github.com/mailmangroup/cordova-plugin-sentry`

In your `config.xml`, add your dsnString as a preference.

```
<preference name="DSNSTRING" value="https://XXXXX:XXXXX@sentry.io/123" />
```

### For iOS:

Comment out `CODE_SIGN_ENTITLEMENTS` in `build.xccproj`
Reference: https://issues.apache.org/jira/browse/CB-12212

Set Sentry Frameworks `Use Legacy Swift Language Version` to `Yes`

Clean and build your project

## Usage

The plugin initializes itself on app load.

### Set User Data

Send user data to Sentry to be reported with crash information:
`email` and `userId` required

```
Sentry.setUserData({
	email: 'name@example.com',
	userId: 'xxxx',
	name: 'Full Name'
}, successCallback, errorCallback );
```

### Force crash

Force an app crash for testing:

```
Sentry.forceCrash( successCallback, errorCallback );
```