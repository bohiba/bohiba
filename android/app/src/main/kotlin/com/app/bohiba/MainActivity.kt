package com.app.bohiba

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.app.bohiba/file_saver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveToDownloads") {
                    val bytes = call.argument<ByteArray>("bytes")
                    val fileName = call.argument<String>("fileName") ?: "report.pdf"
                    val mimeType = call.argument<String>("mimeType") ?: "application/pdf"

                    if (bytes == null) {
                        result.error("INVALID_ARGS", "bytes must not be null", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val savedPath = saveToDownloads(bytes, fileName, mimeType)
                        result.success(savedPath)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun saveToDownloads(bytes: ByteArray, fileName: String, mimeType: String): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // Android 10+ (API 29+): scoped storage — must use MediaStore.Downloads.
            // Direct filesystem writes to public dirs are blocked; MediaStore is the
            // only compliant path and does not require WRITE_EXTERNAL_STORAGE permission.
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val resolver = contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw Exception("MediaStore insert returned null URI")

            resolver.openOutputStream(uri)?.use { it.write(bytes) }
                ?: throw Exception("Failed to open output stream for URI $uri")

            // Clear IS_PENDING so the Downloads app shows the file immediately.
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)

            uri.toString()
        } else {
            // Android 9 and below: scoped storage not enforced; write directly.
            // WRITE_EXTERNAL_STORAGE permission is declared in the manifest for these versions.
            val downloadsDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS
            )
            downloadsDir.mkdirs()
            val file = File(downloadsDir, fileName)
            FileOutputStream(file).use { it.write(bytes) }
            file.absolutePath
        }
    }
}
