# cordova-plugin-sentry

## Installation

`cordova platform add ios`

`cordova plugin add https://github.com/mailmangroup/cordova-plugin-sentry`

In your `config.xml`, add your dsnString as a preference.

```
<preference name="DSNSTRING" value="https://XXXXX:XXXXX@sentry.io/123" />
```

Depending on the order of the plugin being added and the platform being created, you might have to specify to `use_frameworks!` in your `Podfile`:

```
platform :ios, '8.0'
use_frameworks!
```

Note: the plugin adding a pod dependency can conflict with other plugins. Take note of what Pod targets your Podfile already contains and make sure to re-instate any that are overwriten. As such, it is recommended that you add pod tags for each Pod dependency other plugins depend upon in your `config.xml`. i.e.

```
<platform name="ios">
	<pods-config ios-min-version="8.0" use-frameworks="true" />
	<pod name="Sentry" />
	<pod name="GoogleCloudMessaging" />
	<pod name="GGLInstanceID" />
</platform>
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