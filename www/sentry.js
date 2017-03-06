var Sentry = {

	setUserData: function( arguments, successCallback, errorCallback ) {

		cordova.exec( successCallback, errorCallback, 'Sentry', 'setUserData', [ arguments ] );
	},

	testCrash: function( successCallback, errorCallback ) {

		cordova.exec( successCallback, errorCallback, 'Sentry', 'testCrash' );
	}
}

module.exports = Sentry;