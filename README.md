Templatron: an easy to use scaffold tool [![Gem Version](https://badge.fury.io/rb/templatron.svg)](http://badge.fury.io/rb/templatron)
===

## Installation

```console
gem install templatron
```

## Usage

```console
Usage:
    templatron [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    build                         Build from templates
    list                          List available templates

Options:
    -h, --help                    print help
    -v, --verbose                 Enable verbose mode (default: false)
    --version                     Show the current version
```

**/!\** Since it uses [clamp](https://github.com/mdub/clamp) as its cli framework, you'll have to put flags before the command.

## What?

Templatron lets you quickly generate directory/file structure based on templates. Templates are as simple as directories put in the right place (<HOME_DIR>/.templatron) which can contains many files with placeholders.

## How?

By replacing every occurences of `{$0}` (where 0 is the argument index) by the given argument value.

Let's see an example of how it works, it's very simple.

When you call `templatron build base/profile sample_project "John Doe"`, it looks for a folder at the location `<HOME_DIR>/.templatron/base/profile`.

If no one is found, it will let you know, otherwise, it will process each entries of this folder. For example, let's say we have this hierarchy:

- {$0}.txt
- README.md
- {$1 authors}/
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

## Subcommands

### list

With the `list` subcommand, you can explore your templates. Just type `templatron list DIR` where `DIR` could be a subfolder.

If you want to list the content of the folder `base/profile/{$1 authors}`, you can simply replace the placeholder markup with its default value, so it becomes `templatron list base/profile/authors`. The same applies for the `build` command.

### build

Main command to build your structure from a directory template. As mentionned in the `list` subcommand, you can build directly a nested directory by passing the path to the command.

For example, in the basic example, if you only want to build the sub folder `base/profile/{$1 authors}` into `/home/john/test`, you can type `templatron build -o /home/john/test base/profile/authors $2=avatar_value` and you'll end up with:

- /home/
    - /john/
        - /test/
            - avatar_value.png

## Why?

I wanted a simple application to generate base structure for a lot of stuff I find myself repeating over and over, so I've decided to write this tiny application.

## Development

Clone this repository `git clone git@github.com:YuukanOO/templatron.git`, install dependencies `bundle install` and install the gem `rake install`.