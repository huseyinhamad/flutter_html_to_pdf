package com.originoss.flutter_html_to_pdf_plus

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterHtmlToPdfPlugin */
class FlutterHtmlToPdfPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_html_to_pdf_plus")
    channel.setMethodCallHandler(this)

    applicationContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "convertHtmlToPdf") {
      convertHtmlToPdf(call, result)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun convertHtmlToPdf(call: MethodCall, result: Result) {
    val htmlFilePath = call.argument<String>("htmlFilePath")
    val printSize = call.argument<String>("printSize")
    val orientation = call.argument<String>("orientation")
    val margins = call.argument<List<Int>>("margins")
    val width = call.argument<Int>("width")
    val height = call.argument<Int>("height")

    if (htmlFilePath == null) {
      result.error("INVALID_ARGUMENT", "htmlFilePath cannot be null", null)
      return
    }

    val converter = HtmlToPdfConverter()
    val callback = object : HtmlToPdfConverter.Callback {
      override fun onSuccess(filePath: String) {
        result.success(filePath)
      }

      override fun onFailure() {
        result.error("ERROR", "Unable to convert html to pdf document!", "")
      }
    }
    
    // Pass width and height for custom size
    converter.convert(
      htmlFilePath,
      applicationContext,
      printSize ?: "A4",
      orientation ?: "PORTRAIT",
      margins ?: listOf(50, 50, 50, 50),
      callback,
      width,
      height
    )
  }
}
