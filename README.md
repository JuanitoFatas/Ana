# Ana :sparkling_heart: :yellow_heart: :blue_heart: :purple_heart: :green_heart: :heart: :gift_heart:

Ana knows a lot of things about RubyGems.

A command-line tool for [RubyGems.org][1].

## Installation

    $ gem install ana

## List of Command and its alias

```bash
$ ana command args
```

|Command|Alias|Purpose|
|----|----|----|
| `version` | `-v`| Returns the version of Ana. |
| `version` | `--version`| Returns the version of Ana. |
| `gem_infos` | `info` | Get information of a RubyGem. |
| `gem_dependencies` | `deps` | List Runtime/Development Dependencies of a RubyGem. |
| `latest_version` | `lv` | Return latest version of a RubyGem. |
| `versions` | `vs` | Return (default last 10) versions of a RubyGem. |
| `find_version` | `fv` | Find if a RubyGem has given version. |
| `search` | `s` | Exact Search a RubyGem with given name. |
| `fuzzy_search` | `fs` | Fuzzy search a gem via `gem search -r`. |
| `open` | `o` | Open a RubyGem's URI: homepage, doc, wiki...etc. |
| `download` | `dl` | Download a RubyGem in browser. |

## Usage

Type `ana` to get some help:

    $ ana

Type `ana help COMMANDS` to get help for specific command:

    $ ana help version

### Available commands of Ana

#### List infomation of Given Gem

```
$ ana info rails
Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It encourages beautiful code by favoring convention over configuration.
Has been downloaded for 29911559 times!
The Latest version is 4.0.1.
Respectful Author(s): David Heinemeier Hansson.
LICENSE under MIT
```

#### List Runtime or Development Dependencies of Given Gem

```bash
$ ana deps rails runtime
actionmailer         = 4.0.1
actionpack           = 4.0.1
activerecord         = 4.0.1
activesupport        = 4.0.1
bundler              < 2.0, >= 1.3.0
railties             = 4.0.1
sprockets-rails      ~> 2.0.0
```

#### Get latest version of a Given Gem

```bash
$ ana lv rails
Latest version is 4.0.1.
```


#### Get latest version of a Given Gem

```bash
ana vs rails
Last 10 versions of rails are...
2013-11-01 : 4.0.1
2013-10-30 : 4.0.1.rc4
2013-10-23 : 4.0.1.rc3
2013-10-21 : 4.0.1.rc2
2013-10-17 : 4.0.1.rc1
2013-10-16 : 3.2.15
2013-10-11 : 3.2.15.rc3
2013-10-04 : 3.2.15.rc2
2013-10-03 : 3.2.15.rc1
2013-07-22 : 3.2.14
```

#### Find specific version of a given gem

```bash
$ ana fv rails 4.1
This version could not be found.
```

#### (Exact) Search of a given gem name

```bash
$ ana s rails
Latest version is 4.0.1.
```

#### (Fuzzy) Search of a given gem name

```bash
$ ana fs rails

*** REMOTE GEMS ***
...
zurui-sass-rails (0.0.4)
```

Via `gem search -r`.

#### Open a Gem's URI page

Available URI: Project Page, Homepage, Wiki, Documentation, Mailing List,
               Source Code, Bug Tracker.

```bash
$ ana o rails doc
will open the documentation of rails in your default browser.
```

via [launchy][2] gem.

#### Download a Gem

```bash
$ ana dl rails
will open the browser and download rails gem.
```

## Requirements

Ruby >= 2.0

## TODO

* Add tests.
* Download via wget/curl.
* Download gem and its runtime dependencies in a zip/tar or in files.

## Contributing

1. Fork it ( https://github.com/juanitofatas/ana/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: https://rubygems.org/
[2]: https://github.com/copiousfreetime/launchy