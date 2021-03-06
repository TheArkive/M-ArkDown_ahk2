<toc>
<nav|Home=https://thearkive.github.io/M-ArkDown_ahk2/|Download=https://github.com/TheArkive/M-ArkDown_ahk2/archive/refs/heads/master.zip|Source=https://github.com/TheArkive/M-ArkDown_ahk2>

# (M)ArkDown Cheatsheet

## Emphesis (Italics)[underline]

*This text has emphesis.* `*This text has emphesis.*`
_This text also has emphesis._ `_This text also has emphesis._`

## Strong (Bold)[underline]

**This text is strong.** `**This text is strong.**`
__This text is strong.__ `__This text is strong.__`

## Emphesis + Strong (Italic + Bold)[underline]

***This text has strong + emphesis.*** `***This text has strong + emphesis.***`
___This text has strong + emphesis.___ `___This text has strong + emphesis.___`

## Spacing[underline]

As with regular markdown, spacing is mostly automatic.  If you want to combine manual line breaks use the backslash `\`.

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
## Table of Contents and Navigation code[underline]

You can place the `<toc>` and `<nav|...>` tags anywhere in your document.

Example Code:

```
<toc>
<nav|asdf1=www.google.com|asdf2=www.yahoo.com>
```

You can see the toc and nav icon in the top right: `&#9776;`

## Heading code[underline]

Headings, with or without underline.  If you want automatic underline for h1 and h2 without adding `[underline]`, just change the css (usually setting border-bottom property is best).

Example Code:

```
#### Heading 4
##### Heading 5[underline]
###### Heading 6
```

<spoiler=Click to see Headings>
#### Heading 4
##### Heading 5[underline]
###### Heading 6
</spoiler>

## Blockquote code[underline]

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
> | [link](http://test.com) | **bold**  `code` | *emphesis* |

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
> | [link](http://test.com) | **bold**  `code` | *emphesis* |
```

## Images[underline]

The 1st pic has width=200 set and is embedded in a hyperlink.

The 2nd pic is separated by a space, and on the same line having height=200 set.  If a pic is too large to fit on the same line, it will usually be put on the next line down.

The 3rd pic has no dimensions set and is full size.

[![Label 1](pic.jpg)(width=200)](http://test_url.com)  ![Label 2](pic.jpg)(height=200)

Third pic:\
![Label 3](pic.jpg)

Example:
```
[![Label 1](pic.jpg)(width=200)](http://test_url.com)  ![Label 2](pic.jpg)(height=200)

Third pic:\
![Label 3](pic.jpg)
```

## Horizontal Rule &lt;hr&gt;[underline]

Just like regular markdown, the `<hr>` can be added by `---`, `___`, and `***`.  In my version of markdown you can also use `===` for a double underline, and you can also specify style in an extra `[tag]`.  If you use `===` without a `[tag]` then it makes a normal single line.

<spoiler=Click to see &lt;hr&gt;>
---
===
---[red solid]
---[2px red dashed]
===[4px dashed blue]
===[4px double pink]
</spoiler>

Example Code:

```
---
===
---[red solid]
---[2px red dashed]
===[4px dashed blue]
===[4px double pink]
```

Please note, that in order to show a **double** line you must specify a style width of at least 3px or greater to actually see both lines.

## Unordered Lists[underline]

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

## Ordered Lists[underline]

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

## Tables[underline]

Tables are the same as regular markdown except for one key difference:  you can set the alignment of the headers and data separately.

Like markdown you use the colon `:` to determine alignment: `right:` , `:center:` , `left` (no colon for left).

If you want to use a colon in a header you can escape it with backslash: `\:`

Column headers and data will also take most inline formatting, like *emphesis* or **strong**.

Example Code:

```
|               *right\:*:| ~~left~~             |     :center\::      |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphesis*          |

The table/columns do not have to be perfectly spaced as shown above.
```

|               *right\:*:| ~~left~~             |     :center\::      |
|-------------------------|---------------------:|:-------------------:|
|aaaaaaaaaaaaaaaaaaaa     |bbbbbbbbbbbbbbbbbbbbbb|ccccccccccccccccccccc|
|1                        |2                     |3                    |
|manual line<br>break     | data2                | data3               |
| [link](http://test.com) | **bold**  `code`     | *emphesis*          |

## Spoiler[underline]

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
> | [link](http://test.com) | **bold**  `code` | *emphesis* |
</spoiler>
---[red 3px]

## Thats all folks!

Please remember, this is not normal markdown.  If you use all features of this flavor of markdown, then other platforms might give you some wonky results.  I will mostly be using this for generating fancy offline docs for scripts and libraries, and for generating GibHub Pages resources for my GitHub repos.

## To-Do List:

+ Add lots of :emojis: !