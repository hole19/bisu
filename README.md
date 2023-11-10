Bisu 홀
========

[![Status](https://travis-ci.org/hole19/bisu.svg?branch=master)](https://travis-ci.org/hole19/bisu?branch=master)
[![Gem](https://img.shields.io/gem/v/bisu.svg?style=flat)](http://rubygems.org/gems/bisu "View this project in Rubygems")

Bisu manages your app [iOS](#ios), [Android](#android) and [RoR](#ruby-on-rails) localization files for you. No more copy+paste induced errors!

It works with the following sources out of the box:
- [URL](#url)
- [Tolgee](#tolgee)
- [Google Sheets](#google-sheets)
- [OneSky](#onesky)

<p align="center">
  <img src="https://raw.githubusercontent.com/hole19/bisu/master/README_explanation.png" width="500">
</p>

Installation
-----

```
gem install bisu
```

Usage
-----

1. Open terminal in app project base
1. Run: `bisu`
1. That's it!*

\*_given that someone already configured Bisu_

Setup your configuration file
-----

1. Create in your project base folder a translatable.yml:

  ```
  type: <iOS|Android|RoR>

  dictionary:
    (see options below)

  translate:
    - in: path/to/1st/file.translatable
      out: path/to/%{locale}/strings.xml
      out_en: path/to/default/strings.xml
    - in: path/to/2nd/file.translatable
      out: path/to/2nd-%{locale}/strings.xml

  languages:
    - locale: en
      language: en # the language as it appears in the dictionary
    - locale: en-US
      language: en-us
      fallback_language: en
    - locale: pt
      language: pt
  ```

#### Sources

##### URL

  ```
  dictionary:
    type: url
    url: <A-GET-URL>
  ```

##### Tolgee

  ```
  dictionary:
    type: tolgee
    api_key: <TOLGEE-API-KEY>
  ```

##### Google Sheets

1. First ["Publish to the web"](https://www.google.com/search?q=google+sheets+publish+to+web) your Google Sheet
1. Share only the sheet that contains the translations
1. Make sure you CSV format
1. First column should contain the translation keys
1. First row should contain the locale for each language

  ```
  dictionary:
    type: google_sheet
    url: <GOOGLE-DRIVE-SHEET-CSV-URL>
    keys_column: <GOOGLE-DRIVE-KEY-COLUMN-TITLE>
  ```

##### OneSky

  ```
  dictionary:
    type: one_sky
    api_key: <ONE-SKY-API-KEY>
    api_secret: <ONE-SKY-API-SECRET>
    project_id: <ONE-SKY-PROJECT-ID>
    file_name: <ONE-SKY-FILE-NAME>
  ```

Create translation templates
-----

Create a \*.translatable version for your platform specific localization files:

##### iOS
*example: Localizable.strings.translatable*

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
  "klRequestName"    = "$kRequestName{user_name: %@}$";
  ```

##### Android
*example: strings.xml.translatable*

  ```
  <?xml version="1.0" encoding="utf-8"?>

  <!-- $specialKComment1$ -->
  <!-- $specialKComment2$ -->
  <!-- Locale: $specialKLocale$; Language used: $specialKLanguage$ -->

  <resources>
      <string name="delete">$kDelete$</string>
      <string name="cancel">$kCancel$</string>
      <string name="close">$kClose$</string>
      <string name="request_name">$kRequestName{user_name: %s}$</string>
  </resources>
  ```

##### Ruby on Rails
*example: config/locales/yml.translatable*

  ```
  $specialKLocale$:
    resources:
      delete: $kDelete$
      cancel: $kCancel$
      close: $kClose$
    messages:
      request_name: $kRequestName$
  ```
