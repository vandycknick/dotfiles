status is-interactive || exit
test "$TERM_PROGRAM" = tern || exit

# Tern titles its tabs through its own shell integration: the command line
# while one runs, the directory's name at the prompt. fish's default
# fish_title fights it on every Enter (`/p/t/dir` for a frame, then Tern's
# label again), which jiggles the Float layout's centered tab pill. fish
# writes no title at all when fish_title prints nothing.
function fish_title
end
