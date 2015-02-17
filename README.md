H19-Bisu
========

Bisu manages your app iOS and Android localization files for you. No more copy+paste induced errors!

---

Instalation
-----

1. Download gem file: [bisu.gem](https://github.com/hole19/h19-bisu/blob/master/bisu.gem?raw=true)
1. Run in terminal: `gem install path/to/bisu.gem`

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
  type: <iOS/Android>
  
  sheet_id: <GOOGLE-DRIVE-SHEET-ID>
  keys_column: <GOOGLE-DRIVE-KEY-COLUMN-TITLE>
  
  in:
    - path/to/1st/file.translatable
    - path/to/2nd/file.translatable
  
  out:
    - language: english
      folder:   path/to/en.lproj/
    - language: korean
      folder:   path/to/ko.lproj/
  ```

1. Replace your **iOS** localization files with *.translatable* versions:

  ```
  // $specialKComment1$
  // $specialKComment2$
  
  // $specialKLanguage$
  
  /***********
  *  General
  ************/
  
  "klGeneral_Delete" = "$kDelete$";
  "klGeneral_Cancel" = "$kCancel$";
  "klGeneral_Close"  = "$kClose$";
  ```

1. Replace your **Android** localization files with *.translatable* versions:

  ```
  <?xml version="1.0" encoding="utf-8"?>
  
  <!-- $specialKComment1$ -->
  <!-- $specialKComment2$ -->
  <!-- $specialKLanguage$ -->
  
  <resources>
      <string name="delete">$kDelete$</string>
      <string name="cancel">$kCancel$</string>
      <string name="close">$kClose$</string>
  </resources>
  ```
