Bisu 홀
========

Bisu manages your app iOS, Android and RoR localization files for you. No more copy+paste induced errors!

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

1. Create in your project base folder a translatable.yml:

  ```
  type: <iOS|Android|RoR>

  dictionary:
    type: google_sheet
    sheet_id: <GOOGLE-DRIVE-SHEET-ID>
    keys_column: <GOOGLE-DRIVE-KEY-COLUMN-TITLE>

  translate:
    - in: path/to/1st/file.translatable
      out: path/to/%{locale}/strings.xml
      out_en: path/to/default/strings.xml
    - in: path/to/2nd/file.translatable
      out: path/to/2nd-%{locale}/strings.xml

  languages:
    - locale:   en
      language: en
    - locale:   en-US
      language: en
    - locale:   pt
      language: pt
  ```

  Also available generic URL source:
  ```
  dictionary:
    type: url
    url: <A-GET-URL>
  ```

  Also available [OneSky](https://www.oneskyapp.com) integration:
  ```
  dictionary:
    type: one_sky
    api_key: <ONE-SKY-API-KEY>
    api_secret: <ONE-SKY-API-SECRET>
    project_id: <ONE-SKY-PROJECT-ID>
    file_name: <ONE-SKY-FILE-NAME>
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
  "klRequestName"    = "$kRequestName%{user_name: %@}$";
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
      <string name="request_name">$kRequestName%{user_name: %s}$</string>
  </resources>
  ```

1. Create a \*.translatable version for your **RoR** localization files:

  ```
  $specialKLocale$:
    resources:
      delete: $kDelete$
      cancel: $kCancel$
      close: $kClose$
    messages:
      request_name: $kRequestName$
  ```
