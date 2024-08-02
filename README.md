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
Plug 'Maluscat/vim-less-autocompile'
```


## Usage
There is no global configuration (yet?). Everything is configured on a per-file basis:

To use, simply put a comment on the first line of your Less file that specifies the
configuration you want to use (see below). It is a comma separated list of arguments that are passed
to the `lessc` command. An argument itself is denoted as a colon separated key-value pair.

### Mandatory arguments
Every file that should be compiled must have one of two mandatory arguments: `out` or `main`.

The `out` argument specifies the destination path for the CSS file
that will get compiled on save.
- `// out: ./path/to/output.css`

You can also redirect the compilation to another file using the `main` argument instead
of `out` (recursively, if needed).
This is useful if the specified files are not intended for direct compilation
because they are dependencies of the main file, which should be compiled instead.
Multiple files are separated by a pipe without spaces:
- `// main: ./path/to/main.less`
- `// main: ./main1.less|../main2.less|main3.less`



### Basic example
Assuming both files are in the same folder:

*colors.less*:
```less
// main: styles.less
@color: red;
```
*styles.less*:
```less
// out: styles.css
@include 'colors.less';
body {
  color: @color;
}
```
Now, when saving of any of the two files, it compiles to:

*styles.css*
```css
body {
  color: red;
}
```

Any compilation errors will be accumulated and passed on to Vim.

### Other arguments
Besides the mandatory arguments above, any other arguments of the `lessc` command line tool
may be applied in the same manner.
For readability (and laziness) purposes, only double-dash arguments may be specified,
meaning `lint` (from `lessc --lint`) is fine, but `l` (from `lessc -l`) will be nonsensical.

The following will compile to a `./main.css` with the arguments `--lint --source-map=main-map.map`:
```less
// out: main.css, lint, source-map: main-map.map
...
```

When specifying additional arguments in a file that has a `main` instead of an `out`,
they are merged with the arguments of the main file (recursively, if needed).


## Contribution
Any reported issues, feedback, ideas and other contributions are greatly appreciated!
