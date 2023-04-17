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

It is not necessary to escape characters when using code blocks or inline code:

````
`inline code`

```
code blocks
```
````

All these escape sequences should line up seamlessly with the GitHub spec.  There are some exceptions for this special abilities of this markdown variety, and these exceptions will be listed where applicable.

## Emphasis (Italics)

*This text has emphasis.* `*This text has emphasis.*`
_This text also has emphasis._ `_This text also has emphasis._`

## Strong (Bold)

**This text is strong.** `**This text is strong.**`
__This text is strong.__ `__This text is strong.__`

## Emphasis + Strong (Italic + Bold)

***This text has strong + emphasis.*** `***This text has strong + emphasis.***`
___This text has strong + emphasis.___ `___This text has strong + emphasis.___`

## Bold + Italics nesting

You can *also **nest*** the code **in a *variety*** of different ways.

```
You can *also **nest*** the code **in a *variety*** of different ways.
```

And don't forget that starting a line with `***` or `___` expects to end with a corresponding `***` or `___`.

When nesting, it generally helps for readability to alternate between using `*` and `_`, rather than using, ie. `*` and `**` together.

## Spacing

As with regular markdown, spacing is mostly automatic.  If you want to use manual line breaks use the backslash `\`.

Testing a manual line\
break.

```
Testing a manual line\
break.
```

Example without the backslash `\`.

Testing a manual line
break.

```
Testing a manual line
break.
```

You can add additional blank lines like so:

```
Here is a line with 2 blank lines beneath.\
\
\
Next visible line.
```

Here is a line with 2 blank lines beneath.\
\
\
Next visible line.

## Colors

`#FF0000`
`rgb(0,255,0)`
`hsl(25, 100%, 50%)`

Example code:

```
`#FF0000`
`rgb(0,255,0)`
`hsl(25, 100%, 50%)`
```

## Check lists

Here is a checklist:
- [x] Check item
- [ ] Unchecked item
- [x] Check item
- [ ] Unchecked item

Check the included css file to see how you can customize the checkbox.  Search for `input[type="checkbox"]`.

Example code:

```
Here is a checklist:
- [x] Check item
- [ ] Unchecked item
- [x] Check item
- [ ] Unchecked item
```

## Table of Contents and Navigation code

You can place the `<toc>` and `<nav|...>` tags anywhere in your document.

Example Code:

```
<toc>
<nav|asdf1=www.google.com|asdf2=www.yahoo.com>
```

You can see the toc and nav icon in the top right: `☰`

This feature is not compatible with GitHub markdown.

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

## Blockquote code

> This is testing a blockquote.
>
> [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
>  
> Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> `Even:`
>
> # Headings
> are parsed, but are not added to the Table of Contents.\
> You can add manual line breaks\
> with a backslash (`\`).
>
> > This is a nested blockquote.
> >
> > [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
> >  
> > Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> > `Even:`
> >
> > # Headings
> > are parsed, but are not added to the Table of Contents.\
> > You can add manual line breaks\
> > with a backslash (`\`).
>
> | *right\:*:| ~~left~~  |:\:center\::|
> |---------|:-------:|--------:|
> |aaaaaaaaaaaaaaaaaaaa        |bbbbbbbbbbbbbbbbbbbbbb        |ccccccccccccccccccccc         |
> |1        |2        |3         |
> |manual line<br>break | data2   | data3     |
> | [link](http://test.com) | **bold**  `code` | *emphasis* |

Example Code:

```
> This is testing a blockquote.
>
> [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
>  
> Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> `Even:`
>
> # Headings
> are parsed, but are not added to the Table of Contents.\
> You can add manual line breaks\
> with a backslash (`\`).
>
> > This is a nested blockquote.
> >
> > [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
> >  
> > Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> > `Even:`
> >
> > # Headings
> > are parsed, but are not added to the Table of Contents.\
> > You can add manual line breaks\
> > with a backslash (`\`).
>
> | *right\:*:| ~~left~~  |:\:center\::|
> |---------|:-------:|--------:|
> |aaaaaaaaaaaaaaaaaaaa        |bbbbbbbbbbbbbbbbbbbbbb        |ccccccccccccccccccccc         |
> |1        |2        |3         |
> |manual line<br>break | data2   | data3     |
> | [link](http://test.com) | **bold**  `code` | *emphasis* |
```

## Images

The 1st pic has width=200 set and is embedded in a hyperlink.

The 2nd pic is separated by a space, and on the same line having height=200 set.  If a pic is too large to fit on the same line, it will usually be put on the next line down.

The 3rd pic has no dimensions set and is full size.

The 2nd set of parenthesis to specify the dimensions is not supported with the GitHub spec.  You would need to do this with HTML.

[![Label 1](pic.jpg)(width=200)](http://test_url.com)  ![Label 2](pic.jpg)(height=200)

Third pic:\
![Label 3](pic.jpg)

Example:
```
[![Label 1](pic.jpg)(width=200)](http://test_url.com)  ![Label 2](pic.jpg)(height=200)

Third pic:\
![Label 3](pic.jpg)
```

## Horizontal Rule \<hr\>

Just like regular markdown, the `<hr>` can be added by `---`, `___`, and `***` (according to the GitHub spec).  In my version of markdown you can also use `===`.

Another extra feature, not supported in GitHub, is the ability to define the style of the `<hr>` with an extra `[style tag]`.  Note that each individual style must NOT have spaces, meaning the `opacity:0.5` must be typed without spaces within the `[style tag]`.  Other styles not listed here can also be added and will function normally, as long as the style is separated by a space and contain no spaces.

<spoiler=Click to see &lt;hr&gt;>

---

___

***

---[red solid]

---[2px red dashed opacity:0.25]

===[4px dashed blue]

***[4px double pink opacity:0.5]
</spoiler>

Example Code:

```
---

___

***

---[red solid]

---[2px red dashed opacity:0.25]

===[4px dashed blue]

***[4px double pink opacity:0.5]
```

Please note, that in order to show a **double** line you must specify a style width of at least 3px or greater to actually see both lines.

Also, in the GitHub spec, you don't make a `<hr>` with `===`, unless you are making an h1 Header (see Header section).

## Unordered Lists

* item 1  <!--* this is a wasted comment -->
* item 2  <!--* this is a wasted comment -->
* item 3\ <!--* this is a wasted comment -->
item 3 line 2\
item 3 line 3\
item 3 line 4
+ item 4
  + item 1 [a link](http://link.com)
  + item 2
    + *item 1*
    + item 2\
    **item 2 line 2**
      - item 1
      - item 2
- item 5
  - item 1
  - item 2


The above list is generated by:

```
* item 1
* item 2
* item 3\
item 3 line 2\
item 3 line 3\
item 3 line 4
+ item 4
  + item 1 [a link](http://link.com)
  + item 2
    + *item 1*
    + item 2\
    **item 2 line 2**
      - item 1
      - item 2
- item 5
  - item 1
  - item 2
```

## Ordered Lists

A. asdf 1
B. **asdf 2** text
  1) item 1
  2) text *item 2* text
    i. item 1
    ii. text [item 2](http://www.google.com) text
    iii. item 3
    iii. item 4
      I) asdf 1
      II) ~~asdf 2~~ text
      III) asdf 3
      I) asdf 4
      I) asdf 5
C. asdf 3
  a) blah 1
  b) text `blah 2`
  c) blah 3
D. asdf 4

The above list is generated by:

```
A. asdf 1
B. **asdf 2** text
  1) item 1
  2) text *item 2* text
    i. item 1
    ii. text [item 2](http://www.google.com) text
    iii. item 3
    iii. item 4
      I) asdf 1
      II) ~~asdf 2~~ text
      III) asdf 3
      I) asdf 4
      I) asdf 5
C. asdf 3
  a) blah 1
  b) text `blah 2`
  c) blah 3
D. asdf 4
```

## Tables

Tables are the same as regular markdown except for one key difference:  you can set the alignment of the headers and data separately.

Like markdown you use the colon `:` to determine alignment: `right:` , `:center:` , and `:left` or `left`.

If you want to use a literal colon in a header you must escape it with backslash: `\:`.  On GitHub this will also display a literal `:`. 

If you don't specify alignment for column headers, then they will use the alignment specified in the 2nd row, and if no alignment is specified, then the default center alignment will be used for column headers, just like the GitHub spec.

Column headers and data will also take most inline formatting, like *emphasis* or **strong**.

Example Code:

```
|               *right\:*:| ~~left~~             |     :center\::      |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphasis*          |

The table/columns do not have to be perfectly spaced as shown above.
```

|               *right\:*:| ~~left~~             |     :center\::      |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphasis*          |

## Spoiler

Shortcut code:

```
<spoiler=Spoiler Title>
spoiler content!
...
plus a little more in the example... just to show off :P
</spoiler>
```

---[red 3px]

<spoiler=Spoiler Title>
spoiler content `that` is *also* formatted **and** stuff!

> This is testing a blockquote.
>
> [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
>  
> Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> `Even:`
>
> # Headings
> are parsed, but are not added to the Table of Contents.\
> You can add manual line breaks\
> with a backslash (`\`).
>
> > This is a nested blockquote.
> >
> > [Google link](https://www.google.com) / [Yahoo link](https://www.yahoo.com)
> >  
> > Tada!  *Most nested markdown inside* a blockquote is **properly parsed**.
> > `Even:`
> >
> > # Headings
> > are parsed, but are not added to the Table of Contents.\
> > You can add manual line breaks\
> > with a backslash (`\`).
>
> | *right\:*:| ~~left~~  |:\:center\::|
> |---------|:-------:|--------:|
> |aaaaaaaaaaaaaaaaaaaa        |bbbbbbbbbbbbbbbbbbbbbb        |ccccccccccccccccccccc         |
> |1        |2        |3         |
> |manual line<br>break | data2   | data3     |
> | [link](http://test.com) | **bold**  `code` | *emphasis* |
</spoiler>

---[red 3px]

Sadly, this feature is not available in this form on the GitHub spec.  But you can use the following HTML to get the same effect:

```
<details>

<summary>Tips for collapsed sections</summary>

### You can add a header

You can add text within a collapsed section. 

You can add an image or a code block, too.

</details>
```

## Thats all folks!

Please remember, while this version of markdown is compatible with GitHub, the "extra features" are not.  I will mostly be using this for generating fancy offline docs for scripts and libraries, and for generating GibHub Pages resources for my GitHub repos.  Or as an offline means to check what a `README.md` might look like on GitHub.

## To-Do List:

+ Add lots of :emojis: ?
+ Add reference links