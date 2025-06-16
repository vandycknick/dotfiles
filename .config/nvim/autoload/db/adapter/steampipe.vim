function! db#adapter#steampipe#canonicalize(url) abort
  return db#url#canonicalize_file(a:url)
endfunction

function! s:path(url) abort
  let path = db#url#file_path(a:url)
  if path =~# '^[\/]\=$'
    if !exists('s:session')
      let s:session = tempname() . '.steampipe3'
    endif
    let path = s:session
  endif
  return path
endfunction

function! db#adapter#steampipe#dbext(url) abort
  return {'dbname': s:path(a:url)}
endfunction

function! db#adapter#steampipe#input(url, in) abort
  return ['steampipe', '--workspace', 'default', 'query', a:in]
endfunction

function! db#adapter#steampipe#auth_input() abort
  return v:false
endfunction

" https://github.com/turbot/steampipe/issues/3875#issuecomment-1727142772
function! db#adapter#steampipe#tables(url) abort
  return db#systemlist(['steampipe', '--workspace', 'default', 'query', 'select table_name as table from information_schema.tables where table_schema = ''aws'';', '--output=csv', '--header=false', '--progress=false'])
endfunction
