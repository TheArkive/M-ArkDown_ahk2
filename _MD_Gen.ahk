; ================================================
; Example Script - this just asks for a file and
; uses make_html() to convert the M-ArkDown into html.
; ================================================

file_path := FileSelect("1",A_ScriptDir,"Select markdown file:","Markdown (*.md)")
If !file_path
    ExitApp

SplitPath file_path,,&dir,,&file_title

If FileExist(dir "\" file_title ".html")
    FileDelete dir "\" file_title ".html"

md_txt := FileRead(file_path)

css := FileRead("style.css")

options := {css:css
          , font_name:"Segoe UI"
          , font_size:16
          , font_weight:400
          , line_height:"1.6"} ; 1.6em - put decimals in "" for easier accuracy/handling.

html := make_html(md_txt, options, true) ; true/false = use some github elements

FileAppend html, dir "\" file_title ".html", "UTF-8"

Run dir "\" file_title ".html" ; open and test

dbg(_in) { ; AHK v2
    Loop Parse _in, "`n", "`r"
        OutputDebug "AHK: " A_LoopField
}

; ================================================
; make_html(_in_html, options_obj:="", github:=false)
;
;   Ignore the last 2 params.  Those are used internally.
;
;   See above for constructing the options_obj.
;
;   The "github" param is a work in progress, and tries to enforce some of the expected basics
;   that are circumvented with my "flavor" of markdown.
;
;       Current effects when [ github := true ]:
;           * H1 and H2 always have underline (the [underline] tag still takes effect when specified)
;           * the '=' is not usable for making an <hr>, but --- *** and ___ still make <hr>
;
; ================================================

make_html(_in_text, options:="", github:=false, final:=true, md_type:="") {
    
    If !RegExMatch(_in_text,"[`r`n]+$") && (final) && md_type!="header" { ; add trailing CRLF if doesn't exist
        _in_text .= "`r`n"
    }
    
    html1 := "<html><head><style>`r`n"
    html2 := "`r`n</style></head>`r`n`r`n<body>"
    toc_html1 := '<div id="toc-container">'
               . '<div id="toc-icon" align="right">&#9776;</div>' ; hamburger (3 horizontal lines) icon
               . '<div id="toc-contents">'
    toc_html2 := "</div></div>" ; end toc-container and toc-contents
    html3 := '<div id="body-container"><div id="main">`r`n' ; <div id=" q "body-container" q ">
    html4 := "</div></div></body></html>" ; </div>
    
    body := ""
    toc := [], do_toc := false
    do_nav := false, nav_arr := []
    ref := Map() ; for future use
    link_ico := "•" ; 🔗 •
    Static chk_id := 0 ; increments throughout entire document
    
    If (final)
        css := options.css
    
    a := StrSplit(_in_text,"`n","`r")
    i := 0
    
    While (i < a.Length) { ; ( ) \x28 \x29 ; [ ] \x5B \x5D ; { } \x7B \x7D
        
        i++, line := strip_comment(a[i])
        ul := "", ul2 := ""
        ol := "", ol2 := "", ol_type := ""
        
        If final && RegExMatch(line, "^<nav\|") && a.Has(i+1) && (a[i+1] = "") {
            do_nav := True
            nav_arr := StrSplit(Trim(line,"<>"),"|")
            nav_arr.RemoveAt(1)
            Continue
        }
        
        If (final && line = "<toc>") {
            do_toc := True
            Continue
        }
        
        code_block := "" ; code block
        If (line = "``````") || (line = "````````") {
            ; dbg("CODEBLOCK")
            
            match := line
            If !line_inc()
                Break
            
            While (line != match) {
                code_block .= (code_block?"`r`n":"") line
                If !line_inc()
                    Break
            }
            
            body .= (body?"`r`n":"") "<pre><code>" convert(code_block) "</code></pre>"
            Continue
        }
        
        ; header h1 - h6
        If RegExMatch(line, "^(#+) (.+?)(?:\x5B[ \t]*(\w+)[ \t]*\x5D)?$", &n) {
            ; dbg("HEADER H1-H6")
            
            depth := StrLen(n[1]), title := inline_code(Trim(n[2]," `t"))
            _class := (depth <= 2 || n[3]="underline") ? "underline" : ""
            
            id := RegExReplace(RegExReplace(StrLower(title),"[\[\]\{\}\(\)\@\!]",""),"[ \.]","-")
            opener := "<h" depth (id?' id="' id '" ':'') (_class?' class="' _class '"':'') '>'
            
            body .= (body?"`r`n":"") opener title
                  . '<a href="#' id '"><span class="link">' link_ico '</span></a>'
                  . '</h' depth '>'
            
            toc.Push([depth, title, id])
            Continue
        }
        
        ; alt header h1 and h2
        ; ------ or ======= as underline in next_line
        next_line := a.Has(i+1) ? strip_comment(a[i+1]) : ""
        If next_line && line && RegExMatch(next_line,"^(\-+|=+)$") {
            depth := (SubStr(next_line,1,1) = "=") ? 1 : 2
            
            id := RegExReplace(RegExReplace(StrLower(line),"[\[\]\{\}\(\)\@\!<>\|]",""),"[ \.]","-")
            opener := "<h" depth ' id="' id '" class="underline">'
                    
            body .= (body?"`r`n":"") opener inline_code(line)
                  . '<a href="#' id '"><span class="link">' link_ico '</span></a>'
                  . '</h' depth '>'
            
            toc.Push([depth, line, id]), i++ ; increase line count to skip the ---- or ==== form next_line
            Continue
        }
        
        ; check list
        If RegExMatch(line,"^\- \x5B([ xX])\x5D (.+)",&n) {
            body .= (body?"`r`n":"") '<ul class="checklist">'
            While RegExMatch(line,"^\- \x5B([ xX])\x5D (.+)",&n) {
                chk := (n[1]="x") ? 'checked=""' : ''
                body .= '`r`n<li><input type="checkbox" id="check' chk_id '" disabled="" ' chk '>'
                               . '<label for="check' chk_id '">  ' n[2] '</label></li>'
                chk_id++
                If !line_inc()
                    Break
            }
            body .= '</ul>'
            Continue
        }
        
        ; spoiler
        spoiler_text := ""
        If RegExMatch(line, "^<spoiler=([^>]+)>$", &match) {
            disp_text := match[1]
            If !line_inc()
                Break
            
            While !RegExMatch(line, "^</spoiler>$") {
                spoiler_text .= (spoiler_text?"`r`n":"") line
                If !line_inc()
                    throw Error("No closing </spoiler> tag found.",-1)
            }
            
            body .= (body?"`r`n":"") '<p><details><summary class="spoiler">'
                  . disp_text "</summary>" make_html(spoiler_text,,github,false,"spoiler") "</details></p>"
            Continue
        }
        
        ; hr
        if RegExMatch(line, "^(\-{3,}|_{3,}|\*{3,}|={3,})(?:\x5B[ \t]*([^\x5D]+)*[ \t]*\x5D)?$", &match) {
        
            ; dbg("HR: " line)
            
            hr_style := ""
            
            If match[2] {
                For i, style in StrSplit(match[2]," ","`t") {
                    If (SubStr(style, -2) = "px")
                        hr_style .= (hr_style?" ":"") "border-top-width: " style ";"
                    Else If RegExMatch(style, "(dotted|dashed|solid|double|groove|ridge|inset|outset|none|hidden)")
                        hr_style .= (hr_style?" ":"") "border-top-style: " style ";"
                    Else If InStr(style,"opacity")=1
                        hr_style .= (hr_style?" ":"") style ";"
                    Else
                        hr_style .= (hr_style?" ":"") "border-top-color: " style ";"
                }
                
            } Else {
                hr_style := "border-top-style: solid; border-top-width: 4px; opacity: 0.25;"
            }
            
            body .= (body?"`r`n":"") '<hr style="' hr_style '">'
            Continue
        }
        
        blockquote := "" ; blockquote
        While RegExMatch(line, "^\> *(.*)", &match) {
            ; dbg("BLOCKQUOTE 1")
            
            blockquote .= (blockquote?"`r`n":"") match[1]
            
            If !line_inc()
                Break
        }
        
        
        If (blockquote) {
            ; dbg("BLOCKQUOTE 2")
            
            body .= (body?"`r`n":"") "<blockquote>" make_html(blockquote,,github, false, "blockquote") "</blockquote>"
            Continue
        }
        
        table := "" ; table
        While RegExMatch(line, "^\|.*?\|$") {
            ; dbg("TABLE 1")
            
            table .= (table?"`r`n":"") line
            
            If !line_inc()
                Break
        }
        
        If (table) {
            ; dbg("TABLE 2")
            
            body .= (body?"`r`n":"") '<table class="normal">'
            b := [], h := []
            
            Loop Parse table, "`n", "`r"
            {
                body .= "<tr>"
                c := StrSplit(A_LoopField,"|"), c.RemoveAt(1), c.RemoveAt(c.Length)
                
                If (A_Index = 1) {
                    For i, t in c { ; table headers
                        txt := inline_code(Trim(t," `t")) ; , align := "center"
                        If RegExMatch(txt,"^(:)?(.+?)(:)?$",&m) {
                            align := (m[1]&&m[3]) ? "center" : (m[3]) ? "right" : "left"
                            txt := m[2], h.Push([align,txt])
                        } Else
                            h.Push(["",txt])
                    }
                    
                } Else If (A_Index = 2) {
                    For i, t in c {
                        align := "left"
                        If RegExMatch(t,"^(:)?\-+(:)?$",&m)
                            align := (m[1]&&m[2]) ? "center" : (m[2]) ? "right" : "left"
                        b.Push(align)
                        body .= '<th align="' (h[i][1]?h[i][1]:align) '">' h[i][2] '</th>'
                    }
                    
                } Else {
                    For i, t in c
                        body .= '<td align="' b[i]  '">' Trim(inline_code(t)," `t") '</td>'
                    
                }
                body .= "</tr>"
            }
            body .= "</table>"
            Continue
        }
        
        ; unordered lists
        If RegExMatch(line, "^( *)[\*\+\-] (.+?)(\\?)$", &n) {
            
            ; dbg("UNORDERED LISTS")
            
            While RegExMatch(line, "^( *)([\*\+\-] )?(.+?)(\\?)$", &n) { ; previous IF ensures first iteration is a list item
                ul2 := ""
                
                If !n[1] && n[2] && n[3] {
                    ul .= (ul?"</li>`r`n":"") "<li>" make_html(n[3],,github,false,"ul item")
                    
                    If n[4]
                        ul .= "<br>"
                    
                    If !line_inc()
                        Break
                    
                    Continue

                } Else If !n[2] && n[3] {
                    ul .= make_html(n[3],,github,false,"ul item append")
                    
                    If n[4]
                        ul .= "<br>"
                    
                    If !line_inc()
                        Break
                    
                    Continue
                
                } Else If n[1] && n[3] {
                    
                    While RegExMatch(line, "^( *)([\*\+\-] )?(.+?)(\\?)$", &n) {
                        If (Mod(StrLen(n[1]),2) || !n[1] || !n[3])
                            Break
                        
                        ul2 .= (ul2?"`r`n":"") SubStr(line, 3)
                        
                        If !line_inc()
                            Break
                    }
                    
                    ul .= "`r`n" make_html(ul2,,github,false,"ul")
                    Continue
                }
                
                If !line_inc()
                    Break
            }
        }
        
        If (ul) {
            body .= (body?"`r`n":"") "<ul>`r`n" ul "</li></ul>`r`n"
            Continue
        }
        
        ; ordered lists
        If RegExMatch(line, "^( *)[\dA-Za-z]+(?:\.|\x29) +(.+?)(\\?)$", &match) {
            
            ; dbg("ORDERED LISTS")
            
            While RegExMatch(line, "^( *)([\dA-Za-z]+(?:\.|\x29) )?(.+?)(\\?)$", &match) { ; previous IF ensures first iteration is a list item
                ol2 := ""
                
                If !match[1] && match[2] && match[3] {
                    ol .= (ol?"</li>`r`n":"") "<li>" make_html(match[3],,github,false,"ol item")
                    
                    If (A_Index = 1)
                        ol_type := 'type="' RegExReplace(match[2], '[\.\) ]','') '"'
                    
                    If match[4]
                        ol .= "<br>"
                    
                    If !line_inc()
                        Break
                    
                    Continue

                } Else If !match[2] && match[3] {
                    ol .= make_html(match[3],,github,false,"ol item append")
                    
                    If match[4]
                        ol .= "<br>"
                    
                    If !line_inc()
                        Break
                    
                    Continue
                
                } Else If match[1] && match[3] {
                    
                    While RegExMatch(line, "^( *)([\dA-Za-z]+(?:\.|\x29) )?(.+?)(\\?)$", &match) {
                        If (Mod(StrLen(match[1]),2) || !match[1] || !match[3])
                            Break
                        
                        ol2 .= (ol2?"`r`n":"") SubStr(line, 3)
                        
                        If !line_inc()
                            Break
                    }
                    
                    ol .= "`r`n" make_html(ol2,,github,false,"ol")
                    Continue
                }
                
                If !line_inc()
                    Break
            }
        }
        
        If (ol) {
            body .= (body?"`r`n":"") "<ol " ol_type ">`r`n" ol "</li></ol>`r`n"
            Continue
        }
        
        ; =======================================================================
        ; ...
        ; =======================================================================
        
        If RegExMatch(md_type,"^(ol|ul)") { ; ordered/unordered lists
            body .= (body?"`r`n":"") inline_code(line)
            Continue
        } Else If RegExMatch(line, "^(<nav|<toc)") { ; nav toc
            Continue
        } Else If RegExMatch(line, "\\$") { ; manual line break at end \
            body .= (body?"`r`n":"") "<p>"
            reps := 0
            
            While RegExMatch(line, "(.+)?\\$", &match) {
                reps++
                body .= ((A_Index>1)?"<br>":"") inline_code(match[1])
                
                If !line_inc()
                    Break
            }
            
            body .= line ? ((reps?"<br>":"") inline_code(line) "</p>") : "</p>"
        } Else If line {
            If md_type != "header"
                body .= (body?"`r`n":"") "<p>" inline_code(line) "</p>"
            Else
                body .= (body?"`r`n":"") inline_code(line)
        }
    }
    
    ; processing toc ; try to process exact height
    final_toc := "", toc_width := 0, toc_height := 0
    If (Final && do_toc) {
        temp := Gui()
        temp.SetFont("s" options.font_size, options.font_name)
        
        depth := toc[1][1]
        diff := (depth > 1) ? depth - 1 : 0
        indent := "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        
        For i, item in toc { ; 1=depth, 2=title, 3=id
            depth := item[1] - diff - 1
            
            ctl := temp.Add("Text",, rpt("     ",depth) "• " item[2])
            ctl.GetPos(,,&w, &h)
            toc_width := (w > toc_width) ? w : toc_width
            toc_height += options.font_size * 2
            
            final_toc .= (final_toc?"`r`n":"") '<a href="#' item[3] '">'
                       . '<div class="toc-item">' (depth?rpt(indent,depth):"")
                       . "• " item[2] "</div></a>"
        }
        
        temp.Destroy()
    }
    
    ; processing navigation menu
    nav_str := ""
    If (final && do_nav) {
        temp := Gui()
        temp.SetFont("s" options.font_size, options.font_name)
        
        Loop nav_arr.Length {
            title := SubStr((txt := nav_arr[A_Index]), 1, (sep := InStr(txt, "=")) - 1)
            
            ctl := temp.Add("Text",,title)
            ctl.GetPos(,,&w)
            toc_width := (w > toc_width) ? w : toc_width
            toc_height += options.font_size * 2
            
            nav_str .= (final_toc?"`r`n":"") '<a href="' SubStr(txt, sep+1) '" target="_blank" rel="noopener noreferrer">'
                       . '<div class="toc-item">' title '</div></a>'
        }
        
        (do_toc) ? nav_str .= "<hr>" : ""
        temp.Destroy()
    }
    
    ; processing TOC
    user_menu := ""
    If Final && (do_nav || do_toc)
        user_menu := toc_html1 nav_str final_toc toc_html2
    
    If final {
        If (do_nav && do_toc)
            toc_height += Round(options.font_size * Float(options.line_height)) ; multiply by body line-height
        
        css := StrReplace(css, "[_toc_width_]",toc_width + 25) ; account for scrollbar width
        css := StrReplace(css, "[_toc_height_]",Round(toc_height))
        css := StrReplace(css, "[_font_name_]", options.font_name)
        css := StrReplace(css, "[_font_size_]", options.font_size)
        css := StrReplace(css, "[_font_weight_]", options.font_weight)
        css := StrReplace(css, "[_line_height_]", Round(options.line_height,1))
        
        If (do_toc || do_nav)
            result := html1 . css . html2 . user_menu . html3 . body . html4
        Else
            result := html1 . css . html2 . html3 . body . html4
    } Else
        result := body
    
    return result
    
    ; =======================================================================
    ; Local Functions
    ; =======================================================================
    
    inline_code(_in) {
        output := _in, check := ""
        
        While (check != output) { ; repeat until no changes are made
            check := output
            
            ; inline code
            While RegExMatch(output, "``(.+?)``", &x) {
                
                If RegExMatch(x[1],"^\#[\da-fA-F]{6,6}$")
                || RegExMatch(x[1],"^rgb\(\d{1,3}, *\d{1,3}, *\d{1,3}\)$")
                || RegExMatch(x[1],"^hsl\(\d{1,3}, *\d{1,3}%, *\d{1,3}%\)$") {
                    output := '<code>' x[1] ' <span class="circle" style="background-color: ' x[1] ';'
                                                                      . ' width: ' (options.font_size//2) 'px;'
                                                                      . ' height: ' (options.font_size//2) 'px;'
                                                                      . ' display: inline-block;'
                                                                      . ' border: 2px solid ' x[1] ';'
                                                                      . ' border-radius: 50%;"></span></code>'
                } Else If !IsInCode()
                    output := StrReplace(output, x[0], "<code>" convert(x[1]) "</code>",,,1)
            }
            
            ; escape characters
            While RegExMatch(output,"(\\)(.)",&x)
                output := StrReplace(output,x[0],"&#" Ord(x[2]) ";")
            
            ; image
            While RegExMatch(output, "!\x5B *([^\x5D]*) *\x5D\x28 *([^\x29]+) *\x29(\x28 *[^\x29]* *\x29)?", &x) && !IsInCode() {
                dims := (dm:=Trim(x[3],"()")) ? " " dm : ""
                output := StrReplace(output, x[0], '<img src="' x[2] '"' dims ' alt="' x[1] '" title="' x[1] '">',,,1)
            }
            
            ; link / url
            While RegExMatch(output, "\x5B *([^\x5D]+) *\x5D\x28 *([^\x29]+) *\x29", &x) && !IsInCode()
                output := StrReplace(output, x[0], '<a href="' x[2] '" target="_blank" rel="noopener noreferrer">' x[1] "</a>",,,1)
            
            ; strong + emphasis (bold + italics)
            While (RegExMatch(output, "(?<![\*\w])[\*]{3,3}([^\*]+)[\*]{3,3}", &x)
               ||  RegExMatch(output, "(?<!\w)[\_]{3,3}([^\_]+)[\_]{3,3}", &x)) && !IsInCode() {
                output := StrReplace(output, x[0], "<em><strong>" x[1] "</strong></em>",,,1)
            }
            
            ; strong (bold)
            While (RegExMatch(output, "(?<![\*\w])[\*]{2,2}([^\*]+)[\*]{2,2}", &x)
               ||  RegExMatch(output, "(?<!\w)[\_]{2,2}([^\_]+)[\_]{2,2}", &x)) && !IsInCode() {
                output := StrReplace(output, x[0], "<strong>" x[1] "</strong>",,,1)
            }
            
            ; emphasis (italics)
            While (RegExMatch(output, "(?<![\*\w])[\*]{1,1}([^\*]+)[\*]{1,1}", &x)
               ||  RegExMatch(output, "(?<![\w])[\_]{1,1}([^\_]+)[\_]{1,1}", &x)) && !IsInCode() {
                output := StrReplace(output, x[0], "<em>" x[1] "</em>",,,1)
            }
            
            ; strikethrough
            While RegExMatch(output, "(?<!\w)~{2,2}([^~]+)~{2,2}", &x) && !IsInCode()
                output := StrReplace(output, x[0], "<del>" x[1] "</del>",,,1)
        }
        
        return output
        
        IsInCode() => ((st := x.Pos[0]-6) < 1) ? false : RegExMatch(output,"<code> *\Q" x[0] "\E",,st) ? true : false
    }
    
    line_inc(esc:=false) {
        (i < a.Length) ? (line := strip_comment(a[++i]), result:=true) : (line := "", result:=false) ; use <= ???
        esc ? escape_txt(line) : ""
        return result
    }
    
    strip_comment(_in_) => RTrim(RegExReplace(_in_,"^(.+)<\!\-\-[^>]+\-\->","$1")," `t")
    
    convert(_in_) { ; convert markup chars so they don't get recognized
        output := _in_
        For i, v in ["&","<",">","\","*","_","-","=","~","``","[","]","(",")","!","{","}"]
            output := StrReplace(output,v,"&#" Ord(v) ";")
        return output
    }
    
    rpt(x,y) => StrReplace(Format("{:-" y "}","")," ",x) ; string repeat ... x=str, y=iterations
    
    escape_txt(_in_) { ; not yet used ...
        output := _in_
        While r := RegExMatch(output,"\\(.)",&_m)
            output := StrReplace(output,_m[0],"&#" Ord(_m[1]) ";")
        return output
    }
    
    ; IsInTag(tag, haystack) { ; no longer used ...
        ; start := InStr(haystack, tag) + StrLen(tag)
        ; sub_str := SubStr(haystack, start)
        
        ; tag_start := InStr(sub_str,"<")
        ; tag_end := InStr(sub_str,">")
        
        ; return ((!tag_start && tag_end) || (tag_end < tag_start)) ? true : false
    ; }
    
    ; IsInCode(needle, haystack) { ; no longer used ...
        ; start := InStr(haystack, needle) + StrLen(needle)
        ; sub_str := SubStr(haystack, start)
        
        ; code_start := InStr(sub_str,"<code>")
        ; code_end := InStr(sub_str,"</code>")
        
        ; return ((!code_start && code_end) || (code_end < code_start)) ? true : false
    ; }
    
    ; ContainsTag(haystack) { ; no longer used ...
        ; If !(RegExMatch(haystack,"<([^>]+)>[^<]+</([^>]+)>",&_m))
            ; return false
        ; return (_m[1]=_m[2]) ? true : false
    ; }
}