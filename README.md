# stox
A Swift command-line tool to view and export tickers from finviz.com stock screener.

<p align="center">
  <img src="https://img.shields.io/badge/language-swift5.4-f48041.svg?style=flat"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
  <a href="https://twitter.com/twannl">
      <img src="https://img.shields.io/badge/contact-@NikolaiShelehov-blue.svg?style=flat" alt="Twitter: @NikolaiShelehov" />
  </a>
</p>


Stox helps you with:

- [x] Create and save watchlists from stock screener URL's
- [x] View and export tickers

![](Presentation/export.png)

### Requirements
- Xcode 12.4 and up

## Installation

### Using [Mint](https://github.com/yonaskolb/mint):

```
$ mint install xbladesub/stox
```

### Development
- `cd` into the repository
- run `swift package generate-xcodeproj` (Generates an Xcode project for development)
- Run the following command to try it out:

```bash
$ swift run stox --help
```

## Usage

### Create lists

```
$ stox new
```

![](Presentation/new.png)

### Change export settings

```
$ stox set
```

![](Presentation/set.png)

```
$ stox --help

OVERVIEW: Display and export stock tickers from 'finviz.com' screener URLs

USAGE: stox <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  list (default)          View or export tickers from given lists
  all                     View or export all tickers from all lists
  new                     Create new tickers list by a given screener URL
  del                     Delete tickers lists
  set                     Specify tickers export options
  dir                     Display tickers export directory
```
