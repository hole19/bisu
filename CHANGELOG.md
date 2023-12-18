# Change Log
All notable changes to this project will be documented in this file.
`Bisu` adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

#### Fixed
- Fixes handling of % character on iOS localization

## [2.0.0](https://github.com/hole19/bisu/releases/tag/v2.0.0)
Released on 2023/12/07

### Added
- Add [Tolgee](https://tolgee.io/) as a source.

### Maintenance
- Upgrade to ruby 3.2

## [1.10.2](https://github.com/hole19/bisu/releases/tag/v1.10.2)
Released on 2021/08/30

#### Fixed
- Fixes bug where we were assuming "key" would always be the translations-key column title

## [1.10.1](https://github.com/hole19/bisu/releases/tag/v1.10.1)
Released on 2021/08/30

#### Fixed
- Crash caused by an unexpected redirect

## [1.10.0](https://github.com/hole19/bisu/releases/tag/v1.10.0)
Released on 2021/08/30

#### Fixed
- Google Spreadsheet option stopped working due to a change in the API. This version fixes that.

Note: You'll need a new setup. View README.

## [1.9.0](https://github.com/hole19/bisu/releases/tag/v1.9.0)
Released on 2021/05/21

#### Added
- Adds a new option to surpress missing params when that's intentional: add "//ignore-params" to the end of the translation key

## [1.8.0](https://github.com/hole19/bisu/releases/tag/v1.8.0)
Released on 2020/04/30

#### Added
- Adds a new option: allows a single translation to have a specific fallback language (example: "es-MX" fallback to "es")

## [1.7.3](https://github.com/hole19/bisu/releases/tag/v1.7.3)
Released on 2020/03/09

#### Added
- Correctly handles percentage sign on iOS platform

## [1.7.2](https://github.com/hole19/bisu/releases/tag/v1.7.2)
Released on 2020/03/09

#### Added
- Correctly handles percentage sign on Android platform

## [1.7.1](https://github.com/hole19/bisu/releases/tag/v1.7.1)
Released on 2019/03/04

#### Added
- Applies the same new line behaviour in every platform

## [1.7.0](https://github.com/hole19/bisu/releases/tag/v1.7.0)
Released on 2019/02/18

#### Added
- Adds support for a dictionary source from generic URL

## [1.6.0](https://github.com/hole19/bisu/releases/tag/v1.6.0)
Released on 2019/02/18

#### Added
- Merges changes from [Onfido's fork](https://github.com/onfido/bisu)
  - Removes the restriction for keys to start with k
  - Adds a strict mode to fail if there's any warning

## [1.5.0](https://github.com/hole19/bisu/releases/tag/v1.5.0)
Released on 2019/01/19

#### Added
- Adds an option to skip downloading i18n dictionary from an external source and loads it directly from a local file in that format

## [1.4.7](https://github.com/hole19/bisu/releases/tag/v1.4.7)
Released on 2018/07/24

#### Added
- Fixes bug handling already escaped single quotes coming from OneSky

## [1.4.6](https://github.com/hole19/bisu/releases/tag/v1.4.6)
Released on 2017/08/27

#### Added
- Fixes crash when final file does not exist

## [1.4.5](https://github.com/hole19/bisu/releases/tag/v1.4.5)
Released on 2017/06/26

#### Added
- Fixes https://github.com/hole19/bisu/issues/3

## [1.4.4](https://github.com/hole19/bisu/releases/tag/v1.4.4)
Released on 2017/03/13

#### Added
- Removed dependency from onesky-ruby gem

## [1.4.3](https://github.com/hole19/bisu/releases/tag/v1.4.3)
Released on 2016/12/22

#### Added
- Fixed a bug related to OneSky integration related to new line character handling

## [1.4.2](https://github.com/hole19/bisu/releases/tag/v1.4.2)
Released on 2016/12/12

#### Added
- Fixed a missing gem dependency

## [1.4.1](https://github.com/hole19/bisu/releases/tag/v1.4.1)
Released on 2016/12/01

#### Added
- *nothing*

## [1.4.0](https://github.com/hole19/bisu/releases/tag/v1.4.0)
Released on 2016/11/18

#### Added
- OneSky integration
- New option to save a local copy of the dictionary

## [1.3.1](https://github.com/hole19/bisu/releases/tag/v1.3.1)
Released on 2016/11/15

#### Added
- Generic code refactors to (soon) support new dictionary sources
- Better error handling when parsing Dictionary

## [1.3.0](https://github.com/hole19/bisu/releases/tag/v1.3.0)
Released on 2016/11/02

#### Added
- New config file format
- Better error handling when parsing config file

## [1.2.4](https://github.com/hole19/bisu/releases/tag/v1.2.4)
Released on 2016/10/23

#### Added
- Convertion of all tests to Rspec
- Generic code refactors to (soon) support new dictionary sources

## [1.2.3](https://github.com/hole19/bisu/releases/tag/v1.2.3)
Released on 2016/10/14

#### Added
- Fixes bug when translating '@' character in Android

## [1.2.2](https://github.com/hole19/bisu/releases/tag/v1.2.2)
Released on 2016/03/03

#### Added
- Logs error when missing translation parameter

## [1.2.1](https://github.com/hole19/bisu/releases/tag/v1.2.1)
Released on 2015/07/31

#### Added
- Default language support

## [1.2.0](https://github.com/hole19/bisu/releases/tag/v1.2.0)
Released on 2015/07/01

#### Added
- Localized text with parameters

## [1.1.1](https://github.com/hole19/bisu/releases/tag/v1.1.1)
Released on 2015/07/01

#### Added
- Fixes bug when generating Android locale

## [1.1.0](https://github.com/hole19/bisu/releases/tag/v1.1.0)
Released on 2015/07/01

#### Added
- RoR project support

## [1.0.2](https://github.com/hole19/bisu/releases/tag/v1.0.2)
Released on 2015/02/02

#### Added
- *nothing*

## [1.0.1](https://github.com/hole19/bisu/releases/tag/v1.0.1)
Released on 2015/01/28.

#### Added
- [#1](https://github.com/hole19/bisu/issues/1): Now bisu creates output files if they do not exist
- [#2](https://github.com/hole19/bisu/issues/2): Fixes missing dependecies error

## [1.0.0](https://github.com/hole19/bisu/releases/tag/v1.0.0)
Released on 2015/01/28
