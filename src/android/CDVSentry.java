package com.kawo.cordova.sentry;

import com.joshdholtz.sentry.Sentry;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CDVSentry extends CordovaPlugin {

    private static final String TAG = "Sentry";
    private static final String ACTION_SET_USER_DATA = "setUserData";
    private static final String ACTION_TEST_CRASH = "forceCrash";

    private static JSONObject USER = new JSONObject();

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        LOG.d(TAG, "Plugin initialized");

        Sentry.setCaptureListener(new Sentry.SentryEventCaptureListener() {

            @Override
            public Sentry.SentryEventBuilder beforeCapture(Sentry.SentryEventBuilder builder) {

                LOG.d(TAG, "beforeCapture" + USER);
                return builder.setUser(USER);
            }
        });

        String dsnString = preferences.getString("DSNSTRING", "");

        if (dsnString == null || dsnString.equals("") || dsnString.equals("$DSNSTRING")) {
            LOG.e(TAG, " Error: dsnString unset");
        } else {
            Sentry.init(cordova.getActivity().getApplicationContext(), dsnString);
        }
    }

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (ACTION_TEST_CRASH.equals(action)) {
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    forceCrashAction(callbackContext, args);
                }
            });
            return true;
        } else if (ACTION_SET_USER_DATA.equals(action)) {
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    setUserDataAction(callbackContext, args);
                }
            });
            return true;
        }
        return false;
    }

    private void setUserDataAction(CallbackContext callbackContext, JSONArray arguments) {

        LOG.d(TAG, "setUserDataAction", arguments);

        try {
            USER = arguments.getJSONObject(0);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject returnObj = new JSONObject();
        addProperty( returnObj, ACTION_SET_USER_DATA, arguments );
        callbackContext.success(returnObj);
    }

    private void forceCrashAction(CallbackContext callbackContext, JSONArray arguments) {

        JSONObject returnObj = new JSONObject();
        addProperty( returnObj, ACTION_TEST_CRASH, true );
        callbackContext.success(returnObj);

        throw new RuntimeException( "Force crash" );
    }

    private void addProperty(JSONObject obj, String key, Object value) {
        try {
            if (value == null) {
                obj.put(key, JSONObject.NULL);
            } else {
                obj.put(key, value);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}