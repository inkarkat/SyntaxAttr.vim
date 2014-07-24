" EXAMPLE SETUP
"
" Show the syntax group name of the item under cursor.
"	map -a	:call SyntaxAttr#SyntaxAttr()<CR>

function! SyntaxAttr#Get( mode )
     let synid = ""
     let fg = ""
     let bg = ""
     let attr   = ""

     let id1  = synID(line("."), col("."), 1)
     let tid1 = synIDtrans(id1)

     if synIDattr(id1, "name", a:mode) != ""
	  let synid = synIDattr(id1, "name", a:mode)
	  if (tid1 != id1)
	       let synid = synid . '->' . synIDattr(tid1, "name", a:mode)
	  endif
	  let id0 = synID(line("."), col("."), 0)
	  if (synIDattr(id1, "name", a:mode) != synIDattr(id0, "name", a:mode))
	       let synid = synid .  " (" . synIDattr(id0, "name", a:mode)
	       let tid0 = synIDtrans(id0)
	       if (tid0 != id0)
		    let synid = synid . '->' . synIDattr(tid0, "name", a:mode)
	       endif
	       let synid = synid . ")"
	  endif
     endif

     " Use the translated id for all the color & attribute lookups; the linked id yields blank values.
     let fg = s:GetColorFormat(a:mode, 'fg', s:Color(synIDattr(tid1, "fg", a:mode), synIDattr(tid1, "fg#", a:mode)))
     let bg = s:GetColorFormat(a:mode, 'bg', s:Color(synIDattr(tid1, "bg", a:mode), synIDattr(tid1, "bg#", a:mode)))
     if (synIDattr(tid1, "bold"     , a:mode))
	  let attr   = attr . ",bold"
     endif
     if (synIDattr(tid1, "italic"   , a:mode))
	  let attr   = attr . ",italic"
     endif
     if (synIDattr(tid1, "reverse"  , a:mode))
	  let attr   = attr . ",reverse"
     endif
     if (synIDattr(tid1, "inverse"  , a:mode))
	  let attr   = attr . ",inverse"
     endif
     if (synIDattr(tid1, "standout"  , a:mode))
	  let attr   = attr . ",standout"
     endif
     if (synIDattr(tid1, "underline", a:mode))
	  let attr   = attr . ",underline"
     endif
     if (synIDattr(tid1, "undercurl", a:mode))
	  let attr   = attr . ",undercurl"
     endif
     if ! empty(synIDattr(tid1, "font", a:mode))
	  let attr   = attr . " font=" . synIDattr(tid1, "font", a:mode)
     endif
     if (attr != ""                  )
	  let attr   = substitute(attr, "^,", " attr=", "")
     endif

     return [synid, fg . bg . attr]
endfunction
function! s:Color( colorName, colorRgb )
     return (a:colorName ==? a:colorRgb ? a:colorRgb : printf('%s(%s)', a:colorName, a:colorRgb))
endfunction
function! s:GetColorFormat( mode, attr, color )
     return (empty(a:color) || a:color == -1 ? '' : printf(' %s%s=%s', a:mode, a:attr, a:color))
endfunction
function! SyntaxAttr#SyntaxAttr()
     let l:mode = (has('gui_running') ? 'gui' : (&t_Co > 2 ? 'cterm' : 'term'))
     echohl MoreMsg
     let message = "group: " . join(SyntaxAttr#Get(l:mode), '')
     if message == ""
	  echohl WarningMsg
	  let message = "<no syntax group here>"
     endif
     echo message
     echohl None
endfunction
