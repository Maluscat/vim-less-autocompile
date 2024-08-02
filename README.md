# vim-less-autocompile
Tiny vim plugin that takes care of automatically compiling [Less](https://lesscss.org/)
files into a corresponding CSS file on save.

This plugin came about for personal use and is very simple, so it might not handle some
edge cases (like unreadable files, etc.). If you find anything lacking, please feel free
to open an issue or contribute yourself!


## Prerequisites
In order to utilize this plugin, [Less](https://lesscss.org/) needs to be installed.
This is done globally via NodeJS:
```sh
npm install -g less
```

It is also recommended to have a Less file type (syntax highlighting) plugin installed.
[vim-less](https://github.com/groenewege/vim-less) is a good choice.


## Installation
Install using your favorite Vim plugin manager. For example, using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'maluscat/vim-less-autocompile'
```


## Usage
There is no global configuration (yet?). Everything is configured on a per-file basis:

To use, simply put a comment on the first line of your Less file that specifies the
configuration you want to use. It is a comma separated list of arguments that are passed
to the `lessc` command. An argument itself is denoted as a colon separated key-value pair.

There are two mutually exclusive mandatory arguments:
- `out: ./path/to/output.css` specifies the destination path for the compiled CSS file.
- `main: ./path/to/main.less` specifies another Less file that will be compiled instead of this one.
  This is useful if this file is not intended for direct compilation and instead is a dependency
  of the main file (like a `colors.less`). This works recursively.

Assuming both files are in the same folder:<br>
*colors.less*:
```less
// main: main.less
@color: red;
```
*main.less*:
```less
// out: main.css

@include 'colors.less';
body {
  color: @color;
}
```
Now, when saving of any of the two files, it compiles to:<br>
*main.css*
```css
body {
  color: red;
}
```

Any compilation errors will simply be passed on from `lessc` to Vim.

### Other arguments
Besides the mandatory arguments above, any other arguments of the `lessc` command line tool
may be applied in the same format.
For readability (and laziness) purposes, only double-dash arguments may be specified,
meaning `lint` is fine, but `l` (which are both options for `lessc`) will be nonsensical.

Example using arbitrary arguments:
```less
// out: main.css, lint, source-map: main-map.map
```

When specifying additional arguments in a file that has a `main` instead of an `out`,
they are merged with the arguments of the main file (recursively, if needed).


## Contribution
Any reported issues, feedback, ideas and other contributions are greatly appreciated!
