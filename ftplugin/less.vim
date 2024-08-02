augroup lesstocss
  autocmd!
  autocmd BufWritePost *.less call LessToCSS()
augroup END

if !exists("*LessToCSS")
function LessToCSS()
python3 << EOF

import vim
import pathlib
import subprocess

def less_to_CSS(path, options = {}):
    firstline = read_first_line(path)

    if not firstline.startswith('//'):
      return

    firstline = firstline[2:]

    for option in firstline.split(','):
        if option == '\n':
            continue
        split_option = option.split(':')
        options[split_option[0].strip()] = split_option[1].strip()

    if 'main' in options:
        for main_file in options['main'].split('|'):
            main_file_path = path.parent / main_file
            return less_to_CSS(main_file_path, options)
    elif 'out' in options:
        sourcemap = ('sourcemap' in options) and options['sourcemap']
        return subprocess.run([
            'lessc',
            '--no-color',
            ('--source-map' if sourcemap == 'true' else ''),
            str(path),
            str(path.parent / options['out'])
        ], stderr=subprocess.PIPE).stderr


def read_first_line(file_name):
    with open(file_name) as file:
        return file.readline()

output = less_to_CSS(pathlib.Path(vim.eval('expand("%:p")')))
if output:
  output = output.decode('UTF-8')
  if output:
    print(output)

EOF
endfunction
endif
