package com.rockwellits.rw_plugins.rw_movie

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class RwMoviePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    lateinit var activity: Activity

    companion object {
        val CHANNEL = "com.rockwellits.rw_plugins/rw_movie"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL)
            val plugin = RwMoviePlugin()

            plugin.activity = registrar.activity()
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), CHANNEL)

        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "playFile" -> try {
                call.argument<String>("fileName")?.let { playFile(it) }
                result.success(null)
            } catch (e: Error) {
                result.error(RwMoviePlugin::class.java.canonicalName, "Unable to play file", e.localizedMessage)
            }
            "playUrl" ->
                try {
                    call.argument<String>("url")?.let { playUrl(it) }
                    result.success(null)
                } catch (e: Error) {
                    result.error(RwMoviePlugin::class.java.canonicalName, "Unable to play URL", e.localizedMessage)
                }
            else ->
                result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    fun playFile(fileName: String) {
        val contentUri = FileProvider.getUriForFile(this.activity.applicationContext,
                this.activity.applicationContext.packageName + ".fileprovider", File(fileName))

        playUri(contentUri)
    }

    fun playUrl(url: String) {
        val contentUri = Uri.parse(url)

        playUri(contentUri)
    }

    fun playUri(contentUri: Uri) {
        val viewIntent = Intent(Intent.ACTION_VIEW)

        viewIntent.addCategory(Intent.CATEGORY_DEFAULT)
        viewIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        viewIntent.setDataAndType(contentUri, "video/mp4")
        viewIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        this.activity.startActivity(viewIntent)
    }
}
