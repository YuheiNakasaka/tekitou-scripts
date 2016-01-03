# tekitou scripts

tekitou scripts

# Requirements
mecab

# Install

```
$ git clone https://github.com/YuheiNakasaka/tekitou-scripts.git
```

# USAGE

## snack_name_generator

get snack names and generate funny snack name automatically from it.

```
$ cd tekitou-scripts/
$ ruby scripts/snack_name_generator.rb
スナック フィボナッチ渋
```

increase snack name data

- 1) go [東京スナックナビ](http://snacknavi.com/)
- 2) fetch a line name from urls like http://snacknavi.com/area/THIS_IS_LINE_NAME/
- 3) set it to @targets in scripts/snack_name_generator.rb
- 4) set SnackCrawler.new(true) and run the script

