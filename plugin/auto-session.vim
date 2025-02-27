if exists('g:loaded_auto_session') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

let g:in_pager_mode = 0

let LuaSaveSession = luaeval('require("auto-session").SaveSession')
let LuaRestoreSession = luaeval('require("auto-session").RestoreSession')
let LuaDeleteSession = luaeval('require("auto-session").DeleteSession')

let LuaAutoSaveSession = luaeval('require("auto-session").AutoSaveSession')
let LuaAutoRestoreSession = luaeval('require("auto-session").AutoRestoreSession')

" Available commands
command! -nargs=* SaveSession call LuaSaveSession(expand('<args>'))
command! -nargs=* RestoreSession call LuaRestoreSession(expand('<args>'))

aug StdIn
  autocmd!
  autocmd StdinReadPre * let g:in_pager_mode = 1
aug END

augroup autosession
  autocmd!
  autocmd VimEnter * nested if g:in_pager_mode == 0 | call LuaAutoRestoreSession() | endif
  autocmd VimLeave * if g:in_pager_mode == 0 | call LuaAutoSaveSession() | endif
  " TODO: Experiment with saving session on more than just VimEnter and VimLeave
  " autocmd BufWinEnter * if g:in_pager_mode == 0 | call LuaAutoSaveSession() | endif
  " autocmd BufWinLeave * if g:in_pager_mode == 0 | call LuaAutoSaveSession() | endif
augroup end

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_auto_session = 1
