var Sentry = {

	setUserData: function( arguments, successCallback, errorCallback ) {

		cordova.exec( successCallback, errorCallback, 'Sentry', 'setUserData', [ arguments ] );
	},

	forceCrash: function( successCallback, errorCallback ) {

		cordova.exec( successCallback, errorCallback, 'Sentry', 'forceCrash' );
	}
}

module.exports = Sentry;