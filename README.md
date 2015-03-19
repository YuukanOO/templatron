Templatron: an easy to use scaffold tool

## Installation

```console
gem install templatron
```

## Usage

```console
Usage: templatron TEMPLATE_NAME [args] [-o output_dir]

Features:
    -o, --output PATH                Where to put the generated files

Common options:
    -v, --verbose                    Verbose mode
    -h, --help                       Show this message
        --version                    Show version

Templates path: <HOME_DIR>/.templatron
```

## What?

Templatron lets you quickly generate directory/file structure based on templates. Templates are as simple as directories put in the right place (<HOME_DIR>/.templatron) which can contains many files with placeholders.

## How?

By replacing every occurences of `{$0}` (where 0 is the argument index) by the given argument value.

Let's see an example of how it works, it's very simple.

### Basic usage

When you call `templatron base/profile sample_project "John Doe"`, it looks for a folder at the location `<HOME_DIR>/.templatron/base/profile`.

If no one is found, it will let you know, otherwise, it will process each entries of this folder. For example, let's say we have this hierarchy:

- {$0}.txt
- README.md
- {$1}/
  - {$2-avatar}.png

It will be translated to:

- sample_project.txt
- README.md
- John Doe/
  - avatar.png

As you can see, occurences of `{$n}` as been replaced by the argument value at the `n` index. You can also pass default values for placeholders as shown in  `{$2-avatar}.png`. You can replaced the `-` with any non whitespace character and it will still work.

The same applies for file content. So if you had this text in the template file `README.md`:

```markdown
{$0 Untitled}
===

Project created by {$1|Unknown maintainer}
```

It will be converted to

```markdown
sample_project
===

Project created by John Doe
```

### Fixed index arguments

In the previous example, what if you want to only give the second argument a value. That's simple, just pass it to the command: `templatron base/profile $1="John Doe"`

## Development

Clone this repository `git clone git@github.com:YuukanOO/templatron.git`, install dependencies `bundle install` and install the gem `rake install`.