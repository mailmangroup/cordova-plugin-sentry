#!/usr/bin/env node

var fs = require( 'fs' );
var path = require( 'path' );
var Podfile = fs.readFileSync( 'platforms/ios/Podfile', 'utf-8' );
var appendData = `post_install do |installer|
  installer.pods_project.targets.each do |target|
    installer.pods_project.build_configurations.each do |config|
      # Configure Pod targets for Xcode 8 compatibility
      config.build_settings['SWIFT_VERSION'] = '2.3'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
    end
  end
end`;

// Podfile not already modified with build_settings › append necessary build_settings
if ( Podfile.indexOf( 'config.build_settings[\'SWIFT_VERSION\']' ) < 0 ) {

	console.log( 'Podfile doesn\'t contain necessary SWIFT_VERSION settings. Write to Podfile.' );

	fs.appendFile( 'platforms/ios/Podfile', '\n\n' + appendData, function ( err ) {

		console.log( 'Podfile hook error.', JSON.stringify( err ) );
	});

// Else › Podfile already modified › continue
} else console.log( 'Podfile already modified.' );
