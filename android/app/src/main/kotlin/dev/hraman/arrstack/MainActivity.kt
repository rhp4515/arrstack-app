package dev.hraman.arrstack

import android.content.ActivityNotFoundException
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "launchPackage" -> {
                        val packageName = call.argument<String>("package")
                        if (packageName.isNullOrEmpty()) {
                            result.error(
                                "invalid_argument",
                                "A non-empty 'package' is required.",
                                null,
                            )
                        } else {
                            result.success(launchPackage(packageName))
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Opens [packageName]'s launcher activity, the same way the home screen
     * would. Used for the Tailscale app, which has no URL scheme that opens
     * it: its `tailscale://` filter requires the host `navigate` and only
     * routes within the app, and there is no iOS scheme at all.
     *
     * Returns false when the app isn't installed. Note that on Android 11+
     * this also returns false for an installed app that isn't declared in
     * AndroidManifest.xml's `<queries>` — package visibility makes
     * `getLaunchIntentForPackage` return null rather than fail loudly.
     */
    private fun launchPackage(packageName: String): Boolean {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
            ?: return false
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return try {
            startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    private companion object {
        const val CHANNEL = "dev.hraman.arrstack/app_launcher"
    }
}
