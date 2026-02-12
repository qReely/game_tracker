-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

-keepclassmembers class * {
  @remote @local *;
}