var Sentry = {

	setUserData: function( arguments, successCallback, errorCallback ) {

		cordova.exec( successCallback, errorCallback, 'Sentry', 'setUserData', [ arguments ] );
	}
}

module.exports = Sentry;