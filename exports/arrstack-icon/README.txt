ArrStack Companion — app icon (design 3d: home cinema)

play_store_icon_512.png      Play Console "App icon" (512x512, 32-bit PNG, no rounded corners — Play masks it)
ic_launcher_foreground_432   Adaptive icon foreground layer, 108dp @ xxxhdpi (glyph inside the 66dp safe zone)
ic_launcher_background_432   Adaptive icon background layer
ic_launcher_monochrome_432   Android 13+ themed-icon layer (black on transparent)
*_1024.png                   Hi-res copies of each; svg/ holds vector sources

Colors: ground #161826 ramp, accent #9184d9, light #e4e7f5.
res/mipmap-anydpi-v26/ic_launcher.xml:
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@mipmap/ic_launcher_background"/>
  <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
  <monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>
</adaptive-icon>
