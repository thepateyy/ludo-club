package com.thepateyy.kinevet;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.net.Uri;
import android.os.Build;
import androidx.core.content.FileProvider;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Lets the game update itself outside the Play Store: reports the installed version, downloads a
 * newer APK (from GitHub Releases) into the app's cache, and hands it to Android's package installer.
 * Android always asks the user to confirm the install.
 */
@CapacitorPlugin(name = "AppUpdater")
public class AppUpdaterPlugin extends Plugin {

    @PluginMethod
    public void getVersion(PluginCall call) {
        try {
            PackageInfo info = getContext().getPackageManager().getPackageInfo(getContext().getPackageName(), 0);
            JSObject ret = new JSObject();
            ret.put("versionName", info.versionName);
            ret.put("versionCode", Build.VERSION.SDK_INT >= 28 ? info.getLongVersionCode() : info.versionCode);
            call.resolve(ret);
        } catch (Exception e) {
            call.reject("Could not read the app version", e);
        }
    }

    @PluginMethod
    public void downloadAndInstall(PluginCall call) {
        String url = call.getString("url");
        if (url == null || !url.startsWith("https://")) {
            call.reject("An https download URL is required");
            return;
        }
        new Thread(() -> {
            File dir = new File(getContext().getCacheDir(), "updates");
            File apk = new File(dir, "update.apk");
            HttpURLConnection conn = null;
            try {
                if (!dir.exists() && !dir.mkdirs()) throw new IOException("Could not create " + dir);
                conn = (HttpURLConnection) new URL(url).openConnection();
                conn.setInstanceFollowRedirects(true); // GitHub release assets redirect to a download host
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(30000);
                conn.connect();
                if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) throw new IOException("HTTP " + conn.getResponseCode());
                long total = conn.getContentLengthLong();
                try (InputStream in = new BufferedInputStream(conn.getInputStream()); OutputStream out = new FileOutputStream(apk)) {
                    byte[] buf = new byte[64 * 1024];
                    long done = 0;
                    int n, lastPercent = -1;
                    while ((n = in.read(buf)) != -1) {
                        out.write(buf, 0, n);
                        done += n;
                        if (total > 0) {
                            int percent = (int) (done * 100 / total);
                            if (percent != lastPercent) {
                                lastPercent = percent;
                                JSObject progress = new JSObject();
                                progress.put("percent", percent);
                                notifyListeners("downloadProgress", progress);
                            }
                        }
                    }
                }
                Uri uri = FileProvider.getUriForFile(getContext(), getContext().getPackageName() + ".fileprovider", apk);
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(uri, "application/vnd.android.package-archive");
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);
                getContext().startActivity(intent);
                call.resolve();
            } catch (Exception e) {
                call.reject("Download failed", e);
            } finally {
                if (conn != null) conn.disconnect();
            }
        }).start();
    }
}
