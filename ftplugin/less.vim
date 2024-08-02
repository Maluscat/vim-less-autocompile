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
        if len(split_option) == 1:
            split_option.append('');
        options[split_option[0].strip()] = split_option[1].strip()

    result = ''
    if 'main' in options:
        main_files = options['main'].split('|')
        del options['main']

        for main_file in main_files:
            main_file_path = path.parent / main_file
            output = less_to_CSS(main_file_path, options)
            if output:
                result += '\n-----\n' + output
        return result
    elif 'out' in options:
        out_file = options['out']
        del options['out']

        sourcemap = ('sourcemap' in options) and options['sourcemap']
        output = subprocess.run([
            'lessc',
            '--no-color',
            str(path),
            str(path.parent / out_file)
        ], stderr=subprocess.PIPE).stderr
        if output:
          absolute_out_file = str(pathlib.Path(path.parent / out_file).resolve())
          result += 'Error compiling ' + absolute_out_file + ':\n'
          result += output.decode('UTF-8')
        return result


def read_first_line(file_name):
    with open(file_name) as file:
        return file.readline()

output = less_to_CSS(pathlib.Path(vim.eval('expand("%:p")')))
if output:
    print(output)

EOF
endfunction
endif
