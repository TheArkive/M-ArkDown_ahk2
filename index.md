<toc>
<nav|Home=https://thearkive.github.io/M-ArkDown_ahk2/|Download=https://github.com/TheArkive/M-ArkDown_ahk2/archive/refs/heads/master.zip|Source=https://github.com/TheArkive/M-ArkDown_ahk2>

# (M)ArkDown Cheatsheet

This markdown spec has been designed to adhere to the GitHub standard of markdown, except for elements that deal with GitHub specific items, like commits, comments, etc.

A few extensions have also been added for flexibility.

The `\` character is used to escape any character and translate it to the corresponding HTML entity, ie. `&#[code];`.

So this \*text\* is not formatted since it has the \_backslash\_ prior to the markup elements.

```
So this \*text\* is not formatted since it has the \_backslash\_ prior to the markup elements.
```

It is not necessary to escape characters when using `inline code`.

```
It is not necessary to escape characters when using `inline code`.
```

It is also not necessary to escape characters using code blocks.

````
```
This is a code block.
```
````

Check out the [Basic writing and formatting synatx](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) on GitHub.  I used this page as a reference for how to render the markdown, and most of the content listed on this link should work with this script.

## Reference-Style Links

Reference style links and images can be put anywhere in the document, and the will not appear until used.

Create a reference-style link:

```
[name]: link_or_image_link "title"
```

------------------------

Note that there cannot be any whitespace before the `[name]`.  The `title` is put in the *title attribute* of the HTML code.  The `title` is optional.  At a minimum you must specify a reference *name*, and the *link*.

In this example, the reference links are defined at the bottom of this section, but you will not see them unless you look at the markdown document.  Defining the example reference links looks like this:

```
[ref tag 1]: pic.jpg "test reference-style image"

[google]: https://www.google.com "googly eyes" <!-- doesn't matter where you put it-->

[yahoo]: https://www.yahoo.com <!-- doesn't matter where you put it-->
```

------------------------

Example code:

```
[yahoo]

[This is the google link][google] (<- hover here)

![optional alt text][ref tag 1]
```

Result:

[yahoo]

[This is the google link][google] (<- hover here)

![optional alt text][ref tag 1] <- hover here

------------------------

Note that when defining the url to a web page or image in a reference link, you can use relative links.

It is a best practice to not place reference link definitions inside other markdown (such as block-quotes, etc).  If you do, it may work, but unexpected things are also likely to happen.

[ref tag 1]: pic.jpg "test reference-style image"

[google]: https://www.google.com "googly eyes" <!-- doesn't matter where you put it-->

[yahoo]: https://www.yahoo.com <!-- doesn't matter where you put it-->

## Emphasis (Italics)

Example: 

```
*This text has emphasis.*
_This text also has emphasis._
```

Result:

*This text has emphasis.*
_This text also has emphasis._

## Strong (Bold)

Example:

```
**This text is strong.**
__This text is also strong.__
```

Result:

**This text is strong.**
__This text is also strong.__

## Emphasis + Strong (Italic + Bold)

Example:

```
***This text has strong + emphasis.***
___This text has strong + emphasis.___
```

Result:

***This text has strong + emphasis.***
___This text has strong + emphasis.___

## Bold + Italics nesting

Example:

```
You can *also **nest*** the code **in a *variety*** of different ways.
```

Result:

You can *also **nest*** the code **in a *variety*** of different ways.

------------------------

And don't forget that starting a line with `***` or `___` expects to end with a corresponding `***` or `___`.

When nesting, it generally helps for readability to alternate between using `*` and `_`, rather than using, ie. `*` and `**`, or `_` and `__`.

## Spacing

As with regular markdown, spacing is mostly automatic.  If you want to use manual line breaks use the backslash `\`.

Example:

```
Testing a manual line\
break.
```

Result:

Testing a manual line\
break.

------------------------

And without the backslash `\` ...

Example:

```
Testing a manual line
break (no backslash).
```

Result:

Testing a manual line
break (no backslash).

------------------------

You can also add additional blank lines.

Example:

```
Here is a line with 2 blank lines beneath.\
\
\
Next visible line.
```

Result:

Here is a line with 2 blank lines beneath.\
\
\
Next visible line.

## Colors

Example:

```
`#FF0000`
`rgb(0,255,0)`
`hsl(25, 100%, 50%)`
```

Result:

`#FF0000`
`rgb(0,255,0)`
`hsl(25, 100%, 50%)`

## Check lists

Example:

```
Here is a checklist:
- [x] Checked item
- [ ] Unchecked item
- [x] Checked item
- [ ] Unchecked item
```

Result:

Here is a checklist:
- [x] Check item
- [ ] Unchecked item
- [x] Check item
- [ ] Unchecked item

----------------------

Check the included css file to see how you can customize the checkbox.  Search for `input[type="checkbox"]`.

## Table of Contents and Navigation code

You can place the `<toc>` and `<nav|...>` tags anywhere in your document.

Example Code:

```
<toc>
<nav|asdf1=www.google.com|asdf2=www.yahoo.com>
```

You can see the toc and nav icon in the top right: `☰`

This feature is not compatible with GitHub markdown.  But GitHub does the same thing automatically with an icon on the top-left of your markdown documents.

## Heading code

Headings, with or without underline.  If you want automatic underline for h1 and h2 without adding `[underline]` tag, just change the css (usually setting border-bottom property is best).

For consistency with the `[underline]` tag, if you want to show brackets (`[]`) then use the `\` to escape them.  Escaping brackets will still be compatible with GitHub markdown.

Note that the `[underline]` tag is not compatible with GitHub markdown.

Example Code:

```
#### \[Heading 4\]
##### Heading 5[underline]
###### Heading <6>

Alt H1 (one or more '=' below)
=

Alt H2 (one or more '-' below)
-
```

Result:

---[2px solid cyan]

<spoiler=Click to see Headings>
> #### \[Heading 4\]
> ##### Heading 5[underline]
> ###### Heading <6>
> 
> Alt H1 (one or more '=' below)
> =
> 
> Alt H2 (one or more '-' below)
> -
</spoiler>

---[2px solid cyan]

## Blockquote code

Example Code:

```
> This is testing a blockquote.
>
> [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
```

Result:

> This is testing a blockquote.
>
> [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)

--------------------------------------------------

Note that you can put almost any markdown element into a blockquote, even another blockquote.

## Images

Example:
```
[![Label 1](pic.jpg)(width=200)](https://www.google.com)  ![Label 2](pic.jpg)(height=200)

Third pic (using reference-style link):\
![Label 3][ref tag 1]
```

Result:

[![Label 1](pic.jpg)(width=200)](https://www.google.com)  ![Label 2](pic.jpg)(height=200)

Third pic (using reference-style link):\
![Label 3][ref tag 1]

--------------------------------------------------

The 1st pic has width=200 set and is also a link.

The 2nd pic is separated by a space, and on the same line having height=200 set.  If a pic is too large/wide to fit on the same line, it will usually be put on the next line down.

The 3rd pic has no dimensions set and is full size, and is also a reference style link.  The reference link was defined above in the [Reference-Style Links](#reference-style-links) section.

The 2nd set of parenthesis to specify the dimensions is not supported with the GitHub spec.  You would need to do this with HTML.

## Horizontal Rule \<hr\>

Just like regular markdown, the `<hr>` can be added by `---`, `___`, and `***` (according to the GitHub spec).  In my version of markdown you can also use `===`.

Another extra feature, not supported in GitHub, is the ability to define the style of the `<hr>` with an extra `[style tag]`.  Note that each individual style must NOT have spaces, meaning the `opacity:0.5` must be typed without spaces within the `[style tag]`.  Other styles not listed here can also be added and will function normally, as long as the style is separated by a space and contain no spaces.

--------------------------------------------------

Example:

```
---

___

***

---[red solid]

---[2px red dashed opacity:0.25]

===[4px dashed blue]

***[4px double pink opacity:0.5]
```

--------------------------------------------------

Result:

<spoiler=Click to see &lt;hr&gt;>

The first 3 are the default without a `[tag]`.

---

___

***

The rest are custom.

---[red solid]

---[2px red dashed opacity:0.25]

===[4px dashed blue]

***[4px double pink opacity:0.5]
</spoiler>



Please note, that in order to show a **double** line you must specify a style width of at least 3px or greater to actually see both lines.

Also, in the GitHub spec, you don't make a `<hr>` with `===`, unless you are making an h1 Header (see Header section).

## Lists

### Basic List Formatting

Ordered lists use only numbers, but you can set the format to one of the following formats:

| Symbol | Type                      |
|:------:|---------------------------|
| `A, a` | alphabetical numbering    |
| `I, i` | Roman numeral numbering   |
|   `1`  | normal Arabic numbering   |

By default, an ordered list is numbered with Arabic numbers (the numbers you are used to looking at).

Unordered lists use `*`, `-`, or `+`.

- This is an
- unordered list.

Ordered lists use `1.` or `1)`.

1. This is an
2. ordered list.

-----------------------

Alignment is important no matter what type of list you make.  A single list can be indented, but must be indented equally for all items.  Indenting a list will not change how it is displayed.

Example:

```
    1. Item 1
    2. Item 2

- Item 1
- Item 2
```

Result:

    1. Item 1
    2. Item 2

- Item 1
- Item 2

-----------------------

### Ordered List Formatting Issues

Note than when making an ordered list, the numbers must be sequential.

If you don't use the proper numerical sequence in an ordered list, then list parsing is halted at the point where the proper sequence is broken.

Example:

```
1. Item 1
2. Item 2
4. Item 3
```

Result:

1. Item 1
2. Item 2
4. Item 3

-----------------------

### Unordered List Format

And when making an unordered list, the symbol you use must be the same for the entire list.

If you don't do this, then the point wher the bullet symbol changes will start a new list.

Example:

```
- Item 1
- Item 2
+ Item 3
+ Item 4
```

Result:

- Item 1
- Item 2
+ Item 3
+ Item 4

-----------------------

### Nesting Lists

You can nest ordered and unordered lists in any combination, and to any depth (theoretically).  When doing so you need to ensure that the number/bullet for the nested list item starts where the list item text starts, or goes past that point.

Example:

```
- Item 1
  - Item 2

1. Item 1
   1. Item 2

* Item 1        (you can indent a full 4 spaces
    * Item 2    and go past the item text from the previous line)
```

Result:

- Item 1
  - Item 2

1. Item 1
   1. Item 2

* Item 1
    * Item 2

-----------------------

### Custom List Numbering (Ordered)

For ordered lists, you can define custom list types by specifying `[type=?]` on the first line of the list, where `?` is `1`, `A`, `a`, `I`, or `i`.  Make sure to not put spaces around the equal sign (`=`).

Example:

```
1. Item 1[type=I]
2. Item 2
3. Item 3
    - Item 4
    - Item 5
    - Item 6
        1. Item 7[type=A]
        2. Item 8
        3. Item 9
4. Item 10
5. Item 11
```

Result:

1. Item 1[type=I]
2. Item 2
3. Item 3
    - Item 4
    - Item 5
    - Item 6
        1. Item 7[type=A]
        2. Item 8
        3. Item 9
4. Item 10
5. Item 11

Note that the default numbering format for this script, and GitHub is as follows:

```
1. Item 1                   (type = 1)  Level 1
    i. Item 2               (type = i)  Level 2
        a. Item 3           (type = a)  Level 3 and beyond ...
            ...             Type I and A (upper case) are not used by default
```

This is not copatible with GitHub markdown.  For consistency, if you want to use `[` and `]` in your list items, escape them with `\`, ie. `\[` and `\]`.

-----------------------

### Custom List Symbol (Unordered)

For unordered lists you can define custom bullet symbols by specifying `[type=?]` on the first line of the list, where `?` is `disc`, `circle`, `square`, or `none`.

Type `none` is useful if you want to use custom symbols (ie. emojis - ✅).

Example:

```
- item 1 (disc) [type=disc]
    - item 2 (circle) [type=circle]
        - item 3 (square) [type=square]
            - ✅ item 4 (none) [type=none]
```

Result:

- item 1 (disc) [type=disc]
    - item 2 (circle) [type=circle]
        - item 3 (square) [type=square]
            - ✅ item 4 (none) [type=none]

Note that the default symbols for unordered lists are as follows:

```
- item 1            (type = disc)   Level 1
    - item 2        (type = circle) Level 2
        - item 3    (type = square) Level 3 and beyond ...
            ...
```

This is not copatible with GitHub markdown.  For consistency, if you want to use `[` and `]` in your list items, escape them with `\`, ie. `\[` and `\]`.

## Tables

Tables are the same as GitHub markdown except you can set the alignment of the headers and data separately.

Like markdown you use the colon `:` to determine alignment: `right:` , `:center:` , and `:left` or `left` (no colon).

If you want to use a literal colon in a header you must escape it with backslash: `\:`.  Eescaping the `:` is compatible with GitHub. 

If you don't specify alignment for column headers, then they will use the alignment specified in the 2nd row, and if no alignment is specified, then the default center alignment will be used for column headers, just like GitHub markdown.

Column headers and data will also take most inline formatting, like *emphasis*, **strong**, links, and others.

Example:

```
|               *right\:*:| ~~left~~             |      center\:       |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphasis*          |

The table/columns do not have to be perfectly spaced as shown above.
```

Result:

|               *right\:*:| ~~left~~             |     :center\::      |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphasis*          |

## Spoiler

Example:

```
<spoiler=Spoiler Title>
spoiler content `that` is *also* formatted **and** stuff!
</spoiler>
```

Result:

<spoiler=Spoiler Title>
spoiler content `that` is *also* formatted **and** stuff!
</spoiler>

-----------------------------------------

Sadly, this feature is not available in this form on the GitHub spec.  But you can use the following HTML to get the same effect:

Example:

```
<details>
<summary>Spoiler Title</summary>
spoiler content `that` is *also* formatted **and** stuff!
</details>
```

Result:

<details>
<summary>Spoiler Title</summary>
spoiler content `that` is *also* formatted **and** stuff!
</details>

Any markdown or HTML element can go inside a spoiler.

## Thats all folks!

Please remember, while this version of markdown is compatible with GitHub, the "extra features" are not.

## To-Do List:

+ Add lots of :emojis: ?

