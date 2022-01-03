; ================================================
; Example Script - this just asks for a file and
; uses make_html() to convert the M-ArkDown into html.
; ================================================

file_path := FileSelect("1",,"Select markdown file:","Markdown (*.md)")
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
          , font_weight:400}

html := make_html(md_txt, options, false) ; true/false = use some github elements

FileAppend html, dir "\" file_title ".html", "UTF-8"

Run dir "\" file_title ".html" ; open and test

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
    Static q := Chr(34)
    
    If !RegExMatch(_in_text,"[`r`n]+$") && (final) ; add trailing CRLF if doesn't exist
        _in_text .= "`r`n"
    
    html1 := "<html><head><style>`r`n"
    html2 := "`r`n</style></head>`r`n`r`n<body>"
    toc_html1 := "<div id=" q "toc-container" q ">"
               . "<div id=" q "toc-icon" q " align=" q "right" q ">&#9776;</div>"
               . "<div id=" q "toc-contents" q ">"
    toc_html2 := "</div></div>" ; end toc-container and toc-contents
    html3 := "<div id=" q "body-container" q "><div id=" q "main" q ">`r`n" ; <div id=" q "body-container" q ">
    html4 := "</div></div></body></html>" ; </div>
    
    body := ""
    toc := [], do_toc := false
    do_nav := false, nav_arr := []
    
    table_done := false
    
    If (final)
        css := options.css
    
    a := StrSplit(_in_text,"`n","`r")
    i := 0
    
    While (i < a.Length) {                                          ; ( ) \x28 \x29
        i++, line := a[i]                                           ; [ ] \x5B \x5D
        blockquote := "", ul := "", ul2 := "", code_block := ""     ; { } \x7B \x7D
        ol := "", ol2 := "", ol_type := ""
        table := ""
        
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
        
        ; header h1 - h6
        If RegExMatch(line, "^(#+) (.+)", &match) {
            depth := match[1], _class := "", title := ltgt(match[2])
            
            If RegExMatch(line, "\x5B *([\w ]+) *\x5D$", &_match)
                _class := _match[1], title := SubStr(title, 1, StrLen(match[2]) - _match.Len(0))
            
            If (github && (match.Len(1) = 1 || match.Len(1) = 2))
                _class := "underline"
            
            id := RegExReplace(RegExReplace(StrLower(title),"[\[\]\{\}\(\)\@\!]",""),"[ \.]","-")
            opener := "<h" match.Len(1) (id?" id=" q id q " ":"") (_class?" class=" q _class q:"") ">"
                    
            body .= (body?"`r`n":"") opener title
                  . "<a href=" q "#" id q "><span class=" q "link" q ">•</span></a>"
                  . "</h" match.Len(1) ">"
            
            toc.Push([StrLen(depth), title, id])
            Continue
        }
        
        ; spoiler
        If RegExMatch(line, "^<spoiler=([^>]+)>$", &match) {
            disp_text := ltgt(match[1])
            spoiler_text := ""
            i++, line := a[i]
            While !RegExMatch(line, "^</spoiler>$") {
                spoiler_text .= (spoiler_text?"`r`n":"") line
                i++, line := a[i]
            }
            
            body .= (body?"`r`n":"") "<p><details><summary class=" q "spoiler" q ">"
                  . disp_text "</summary>" make_html(spoiler_text,,github,false,"spoiler") "</details></p>"
            Continue
        }
        
        ; hr
        If RegExMatch(line, "^([=\-\*_]{3,}[=\-\*_]*)(?:\x5B *[^\x5D]* *\x5D)?$", &match) {
            hr_style := ""
            
            If (github && SubStr(match[1],1,1) = "=")
                Continue
            
            If RegExMatch(line, "\x5B *([^\x5D]*) *\x5D", &match) {
                hr_str := match[1]
                arr := StrSplit(hr_str," ")
                
                For i, style in arr {
                    If (SubStr(style, -2) = "px")
                        hr_style .= (hr_style?" ":"") "border-top-width: " style ";"
                    Else If RegExMatch(style, "(dotted|dashed|solid|double|groove|ridge|inset|outset|none|hidden)")
                        hr_style .= (hr_style?" ":"") "border-top-style: " style ";"
                    Else
                        hr_style .= (hr_style?" ":"") "border-top-color: " style ";"
                }
            }
            body .= (body?"`r`n":"") "<hr style=" q hr_style q ">"
            Continue
        }
        
        ; blockquote - must come earlier because of nested elements
        While RegExMatch(line, "^\> ?(.*)", &match) {
            blockquote .= (blockquote?"`r`n":"") match[1]
            
            If a.Has(i+1)
                i++, line := Trim(a[i]," `t")
            Else
                Break
        }
        
        If (blockquote) { 
            body .= (body?"`r`n":"") "<blockquote>" make_html(blockquote,,github, false, "blockquote") "</blockquote>"
            Continue
        }
        
        ; code block
        If (line = "``````") {
            If (i < a.Length)
                i++, line := a[i]
            Else
                Break
            
            While (line != "``````") {
                code_block .= (code_block?"`r`n":"") line
                If (i < a.Length)
                    i++, line := a[i]
                Else
                    Break
            }
            
            body .= (body?"`r`n":"") "<pre><code>" StrReplace(StrReplace(code_block,"<","&lt;"),">","&gt;") "</code></pre>"
            Continue
        }
        
        ; table
        While RegExMatch(line, "^\|.*?\|$") {
            table .= (table?"`r`n":"") line
            
            If a.Has(i+1)
                i++, line := a[i]
            Else
                Break
        }
        
        If (table) {
            table_done := true
            
            body .= (body?"`r`n":"") "<table class=" q "normal" q ">"
            b := []
            
            Loop Parse table, "`n", "`r"
            {
                body .= "<tr>"
                c := StrSplit(A_LoopField,"|"), c.RemoveAt(1), c.RemoveAt(c.Length)
                
                If (A_Index = 1) {
                    Loop c.Length {
                        If RegExMatch(c[A_Index], "^[ \t]*:(.+?)(?<!\\):[ \t]*$", &match) {
                            ; msgbox "center: " match[1]
                            
                            m := inline_code(match[1])
                            body .= "<th align=" q "center" q ">" StrReplace(m,"\:",":") "</th>"
                        } Else If RegExMatch(c[A_Index], "^([^:].+?)(?<!\\):$", &match) {
                            m := inline_code(match[1])
                            body .= "<th align=" q "right" q ">" StrReplace(m,"\:",":") "</th>"
                        } Else {
                            m := inline_code(c[A_Index])
                            body .= "<th align=" q "left" q ">" StrReplace(m,"\:",":") "</th>"
                        }
                    }
                } Else If (A_Index = 2) {
                    Loop c.Length {
                        If RegExMatch(c[A_Index], "^:\-+:$", &match)
                            b.Push("center")
                        Else If RegExMatch(c[A_Index], "^\-+:$", &match)
                            b.Push("right")
                        Else
                            b.Push("left")
                    }
                } Else {
                    Loop c.Length {
                        m := inline_code(c[A_Index]) ; make_html(c[A_Index],, false, "table data")
                        body .= "<td align=" q b[A_Index] q ">" Trim(m," `t") "</td>"
                    }
                }
                body .= "</tr>"
            }
            body .= "</table>"
            Continue
        }
        
        ; unordered lists
        If RegExMatch(line, "^( *)[\*\+\-] (.+?)(\\?)$", &match) {
            
            While RegExMatch(line, "^( *)([\*\+\-] )?(.+?)(\\?)$", &match) { ; previous IF ensures first iteration is a list item
                ul2 := ""
                
                If !match[1] && match[2] && match[3] {
                    ul .= (ul?"</li>`r`n":"") "<li>" make_html(match[3],,github,false,"ul item")
                    
                    If match[4]
                        ul .= "<br>"
                    
                    If (i < a.Length)
                        i++, line := a[i]
                    Else
                        Break
                    
                    Continue

                } Else If !match[2] && match[3] {
                    ul .= make_html(match[3],,github,false,"ul item append")
                    
                    If match[4]
                        ul .= "<br>"
                    
                    If (i < a.Length)
                        i++, line := a[i]
                    Else
                        Break
                    
                    Continue
                
                } Else If match[1] && match[3] {
                    
                    While RegExMatch(line, "^( *)([\*\+\-] )?(.+?)(\\?)$", &match) {
                        If (Mod(StrLen(match[1]),2) || !match[1] || !match[3])
                            Break
                        
                        ul2 .= (ul2?"`r`n":"") SubStr(line, 3)
                        
                        If (i < a.Length)
                            i++, line := a[i]
                        Else {
                            line := ""
                            Break
                        }
                    }
                    
                    ul .= "`r`n" make_html(ul2,,github,false,"ul")
                    Continue
                }
                
                If (i < a.Length)
                    i++, line := a[i]
                Else
                    Break
            }
        }
        
        If (ul) {
            body .= (body?"`r`n":"") "<ul>`r`n" ul "</li></ul>`r`n"
            Continue
        }
        
        ; ordered lists
        If RegExMatch(line, "^( *)[\dA-Za-z]+(?:\.|\x29) ?(.+?)(\\?)$", &match) {
            
            While RegExMatch(line, "^( *)([\dA-Za-z]+(?:\.|\x29) )?(.+?)(\\?)$", &match) { ; previous IF ensures first iteration is a list item
                ol2 := ""
                
                If !match[1] && match[2] && match[3] {
                    ol .= (ol?"</li>`r`n":"") "<li>" make_html(match[3],,github,false,"ol item")
                    
                    If (A_Index = 1)
                        ol_type := "type=" q RegExReplace(match[2], "[\.\) ]","") q
                    
                    If match[4]
                        ol .= "<br>"
                    
                    If (i < a.Length)
                        i++, line := a[i]
                    Else
                        Break
                    
                    Continue

                } Else If !match[2] && match[3] {
                    ol .= make_html(match[3],,github,false,"ol item append")
                    
                    If match[4]
                        ol .= "<br>"
                    
                    If (i < a.Length)
                        i++, line := a[i]
                    Else
                        Break
                    
                    Continue
                
                } Else If match[1] && match[3] {
                    
                    While RegExMatch(line, "^( *)([\dA-Za-z]+(?:\.|\x29) )?(.+?)(\\?)$", &match) {
                        If (Mod(StrLen(match[1]),2) || !match[1] || !match[3])
                            Break
                        
                        ol2 .= (ol2?"`r`n":"") SubStr(line, 3)
                        
                        If (i < a.Length)
                            i++, line := a[i]
                        Else {
                            line := ""
                            Break
                        }
                    }
                    
                    ol .= "`r`n" make_html(ol2,,github,false,"ol")
                    Continue
                }
                
                If (i < a.Length)
                    i++, line := a[i]
                Else
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
            
            While RegExMatch(line, "(.+)\\$", &match) {
                reps++
                body .= ((A_Index>1)?"<br>":"") inline_code(match[1])
                
                If (i < a.Length)
                    i++, line := a[i]
                Else
                    Break
            }
            
            If line
                body .= (reps?"<br>":"") inline_code(line) "</p>"
            Else
                body .= "</p>"
        } Else If line {
            ; A_Clipboard := body
            ; msgbox line
            body .= (body?"`r`n":"") "<p>" inline_code(line) "</p>"
            ; A_Clipboard := body
            ; msgbox "check clipboard 2"
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
            
            final_toc .= (final_toc?"`r`n":"") "<a href=" q "#" item[3] q ">"
                       . "<div class=" q "toc-item" q ">" (depth?rpt(indent,depth):"")
                       . "• " ltgt(item[2]) "</div></a>"
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
            
            nav_str .= (final_toc?"`r`n":"") "<a href=" q SubStr(txt, sep+1) q " target=" q "_blank" q " rel=" q "noopener noreferrer" q ">"
                       . "<div class=" q "toc-item" q ">" title "</div></a>"
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
            toc_height += Round(options.font_size * 1.6) ; multiply by body line-height
        
        css := StrReplace(css, "[_toc_width_]",toc_width + 25) ; account for scrollbar width
        css := StrReplace(css, "[_toc_height_]",toc_height)
        css := StrReplace(css, "[_font_name_]", options.font_name)
        css := StrReplace(css, "[_font_size_]", options.font_size)
        css := StrReplace(css, "[_font_weight_]", options.font_weight)
        
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
        output := _in
        
        ; inline code
        While RegExMatch(output, "``(.+?)``", &match) {
            output := StrReplace(output, match[0], "<code>" ltgt(match[1]) "</code>",,,1)
        }
        
        ; A_Clipboard := output
        ; msgbox "check clipboard"
        
        ; blank out <code> tags to prevent parsing markdown within <code> tags
        ; output2 := output
        ; While RegExMatch(output2,"<code>.+?</code>",&match) {
            
        ; }
        
        ; image
        r := 1
        While (s := RegExMatch(output, "!\x5B *([^\x5D]*) *\x5D\x28 *([^\x29]+) *\x29(\x28 *[^\x29]* *\x29)?", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            dims := Trim(match[3],"()")
            output := StrReplace(output, match[0], "<img src=" q match[2] q (dims?" " dims:"")
                    . " alt=" q ltgt(match[1]) q " title=" q ltgt(match[1]) q ">",,,1)
        }
        
        ; link / url
        r := 1
        While (s := RegExMatch(output, "\x5B *([^\x5D]+) *\x5D\x28 *([^\x29]+) *\x29", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            output := StrReplace(output, match[0], "<a href=" q match[2] q " target=" q "_blank" q " rel=" q "noopener noreferrer" q ">"
                    . match[1] "</a>",,,1)
        }
        
        ; strong + emphesis (bold + italics)
        While (s := RegExMatch(output, "(?<!\w)[\*]{3,3}([^\*]+)[\*]{3,3}", &match, r))
           || (s := RegExMatch(output, "(?<!\w)[\_]{3,3}([^\_]+)[\_]{3,3}", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            output := StrReplace(output, match[0], "<em><strong>" ltgt(match[1]) "</strong></em>",,,1)
        }
        
        ; strong (bold)
        While (s := RegExMatch(output, "(?<!\w)[\*]{2,2}([^\*]+)[\*]{2,2}", &match, r))
           || (s := RegExMatch(output, "(?<!\w)[\_]{2,2}([^\_]+)[\_]{2,2}", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            output := StrReplace(output, match[0], "<strong>" ltgt(match[1]) "</strong>",,,1)
        }
        
        ; emphesis (italics)
        While (s := RegExMatch(output, "(?<!\w)[\*]{1,1}([^\*]+)[\*]{1,1}", &match, r))
           || (s := RegExMatch(output, "(?<!\w)[\_]{1,1}([^\_]+)[\_]{1,1}", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            output := StrReplace(output, match[0], "<em>" ltgt(match[1]) "</em>",,,1)
        }
        
        ; strikethrough
        While (s := RegExMatch(output, "(?<!\w)~{2,2}([^~]+)~{2,2}", &match, r)) {
            If IsInCode(match[0], output) || IsInTag(match[0], output) {
                r := s + match.Len(0)
                Continue
            }
            output := StrReplace(output, match[0], "<del>" ltgt(match[1]) "</del>",,,1)
        }
        
        ; While (s := RegExMatch(output, "\\([^\s])", &match, r)) {
            ; If IsInCode(match[0], output) || IsInTag(match[0], output) {
                ; r := s + match.Len(0)
                ; Continue
            ; }
            ; output := StrReplace(output, match[0], ..
        ; }
        
        return output
    }
    
    ltgt(_in) {
        return StrReplace(StrReplace(_in,"<","&lt;"),">","&gt;")
    }
    
    rpt(_in, reps) {
        final_str := ""         ; Had to change "final" var to "final_str".
        Loop reps               ; This may still be a bug in a133...
            final_str .= _in
        return final_str
    }
    
    IsInTag(needle, haystack) {
        start := InStr(haystack, needle) + StrLen(needle)
        sub_str := SubStr(haystack, start)
        
        tag_start := InStr(sub_str,"<")
        tag_end := InStr(sub_str,">")
        
        If (!tag_start && tag_end) Or (tag_end < tag_start)
            return true
        Else
            return false
    }
    
    IsInCode(needle, haystack) {
        start := InStr(haystack, needle) + StrLen(needle)
        sub_str := SubStr(haystack, start)
        
        code_start := InStr(sub_str,"<code>")
        code_end := InStr(sub_str,"</code>")
        
        If (!code_start && code_end) Or (code_end < code_start)
            return true
        Else
            return false
    }
}

dbg(_in) { ; AHK v2
    Loop Parse _in, "`n", "`r"
        OutputDebug "AHK: " A_LoopField
}