package com.originoss.flutter_html_to_pdf_plus

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.print.PdfPrinter
import android.print.PrintAttributes
import android.webkit.WebView
import android.webkit.WebViewClient

import java.io.File


class HtmlToPdfConverter {

    interface Callback {
        fun onSuccess(filePath: String)
        fun onFailure()
    }

    @SuppressLint("SetJavaScriptEnabled")
    fun convert(
        filePath: String,
        applicationContext: Context,
        printSize: String,
        orientation: String,
        margins: List<Int>,
        callback: Callback,
        width: Int?,
        height: Int?
    ) {
        val webView = WebView(applicationContext)
        val htmlContent = File(filePath).readText(Charsets.UTF_8)
        webView.settings.javaScriptEnabled = true
        webView.settings.javaScriptCanOpenWindowsAutomatically = true
        webView.settings.allowFileAccess = true
        webView.loadDataWithBaseURL(null, htmlContent, "text/HTML", "UTF-8", null)
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView, url: String) {
                super.onPageFinished(view, url)
                createPdfFromWebView(webView, applicationContext, printSize, orientation, margins, callback, width, height)
            }
        }
    }

    fun createPdfFromWebView(
        webView: WebView,
        applicationContext: Context,
        printSize: String,
        orientation: String,
        margins: List<Int>,
        callback: Callback,
        width: Int? = null,
        height: Int? = null
    ) {
        val path = applicationContext.filesDir
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            var mediaSize = PrintAttributes.MediaSize.ISO_A4

            // Handle custom size if provided
            if (printSize == "CUSTOM" && width != null && height != null) {
                val widthMils = (width * 1000.0 / 72.0).toInt()
                val heightMils = (height * 1000.0 / 72.0).toInt()
                mediaSize = PrintAttributes.MediaSize("CUSTOM", "Custom Size", widthMils, heightMils)
            } else {
                when (printSize) {
                    "A0" -> mediaSize = PrintAttributes.MediaSize.ISO_A0
                    "A1" -> mediaSize = PrintAttributes.MediaSize.ISO_A1
                    "A2" -> mediaSize = PrintAttributes.MediaSize.ISO_A2
                    "A3" -> mediaSize = PrintAttributes.MediaSize.ISO_A3
                    "A4" -> mediaSize = PrintAttributes.MediaSize.ISO_A4
                    "A5" -> mediaSize = PrintAttributes.MediaSize.ISO_A5
                    "A6" -> mediaSize = PrintAttributes.MediaSize.ISO_A6
                    "A7" -> mediaSize = PrintAttributes.MediaSize.ISO_A7
                    "A8" -> mediaSize = PrintAttributes.MediaSize.ISO_A8
                    "A9" -> mediaSize = PrintAttributes.MediaSize.ISO_A9
                    "A10" -> mediaSize = PrintAttributes.MediaSize.ISO_A10
                }
            }

            when (orientation) {
                "LANDSCAPE" -> mediaSize = mediaSize.asLandscape()
                "PORTRAIT" -> mediaSize = mediaSize.asPortrait()
            }

            val marginList = if (margins.size >= 4) margins else listOf(50, 50, 50, 50)
            val attributes = PrintAttributes.Builder()
                .setMediaSize(mediaSize)
                .setResolution(PrintAttributes.Resolution("pdf", "pdf", 600, 600))
                .setMinMargins(PrintAttributes.Margins(marginList[0], marginList[1], marginList[2], marginList[3])).build()

            val printer = PdfPrinter(attributes)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val adapter = webView.createPrintDocumentAdapter(temporaryDocumentName)

                printer.print(adapter, path, temporaryFileName, object : PdfPrinter.Callback {
                    override fun onSuccess(filePath: String) {
                        callback.onSuccess(filePath)
                    }

                    override fun onFailure() {
                        callback.onFailure()
                    }
                })
            }
        }
    }

    companion object {
        const val temporaryDocumentName = "TemporaryDocumentName"
        const val temporaryFileName = "TemporaryDocumentFile.pdf"
    }
}
