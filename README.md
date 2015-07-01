Bisu 홀
========

Bisu manages your app iOS and Android localization files for you. No more copy+paste induced errors!

---

Instalation
-----
  
```
gem install bisu
```

Usage
-----

1. Open terminal in app project base
1. Run: `bisu`
1. That's it!*

*given that someone already configured Bisu

Configuration
-----

1. Create in your **iOS/Android** app project base folder a translatable.yml:

  ```
  type: <iOS/Android/RoR>
  
  sheet_id: <GOOGLE-DRIVE-SHEET-ID>
  keys_column: <GOOGLE-DRIVE-KEY-COLUMN-TITLE>
  
  in:
    - path/to/1st/file.translatable
    - path/to/2nd/file.translatable
  
  out_path: path/to/%{locale}.lproj/%{out_name}
  out:
    - locale:   en
      language: english
      path:     default_path/%{out_name}
    - locale:   ko
      language: korean
  ```

1. Create a \*.translatable version for your **iOS** localization files:

  ```
  // $specialKComment1$
  // $specialKComment2$
  
  // Locale: $specialKLocale$; Language used: $specialKLanguage$
  
  /***********
  *  General
  ************/
  
  "klGeneral_Delete" = "$kDelete$";
  "klGeneral_Cancel" = "$kCancel$";
  "klGeneral_Close"  = "$kClose$";
  ```

1. Create a \*.translatable version for your **Android** localization files:

  ```
  <?xml version="1.0" encoding="utf-8"?>
  
  <!-- $specialKComment1$ -->
  <!-- $specialKComment2$ -->
  <!-- Locale: $specialKLocale$; Language used: $specialKLanguage$ -->
  
  <resources>
      <string name="delete">$kDelete$</string>
      <string name="cancel">$kCancel$</string>
      <string name="close">$kClose$</string>
  </resources>
  ```
  
1. Create a \*.translatable version for your **RoR** localization files:

  ```
  $specialKLocale$:
    resources:
      delete: $kDelete$
      cancel: $kCancel$
      close: $kClose$
  ```
