# Release builds are shrunk with R8 (see build.gradle). Capacitor's own consumer rules keep every
# Plugin subclass and its @PluginMethod methods; these rules make sure nothing in the app's
# package (MainActivity, the AppUpdater plugin) is renamed or removed either, because Capacitor
# finds plugins and their methods by name at runtime.
-keep class com.thepateyy.kinevet.** { *; }

# The WebView bridge calls these by name from JavaScript
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep line numbers so crash reports stay readable
-keepattributes SourceFile,LineNumberTable,*Annotation*
