{ ... }:
{
  # Git shortcuts for interactive Fish, kept as aliases for muscle memory.
  # Many come from oh-my-zsh's git plugin.
  programs.fish.shellAliases = {
    gri = "git rebase -i $(git log --oneline --color=always | fzf --ansi | awk '{print $1}')";
    gs = "git show $(git log --oneline --color=always | fzf --ansi | awk '{print $1}')";
    grt = "cd \"$(git rev-parse --show-toplevel || echo .)\"";
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gap = "git add --patch";
    gau = "git add --update";
    gav = "git add --verbose";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\"";
    gam = "git am";
    gama = "git am --abort";
    gamc = "git am --continue";
    gamscp = "git am --show-current-patch";
    gams = "git am --skip";
    gapl = "git apply";
    gapt = "git apply --3way";
    gbs = "git bisect";
    gbsb = "git bisect bad";
    gbsg = "git bisect good";
    gbsn = "git bisect new";
    gbso = "git bisect old";
    gbsr = "git bisect reset";
    gbss = "git bisect start";
    gbl = "git blame -w";
    gb = "git --no-pager branch";
    gba = "git branch --all";
    gbd = "git branch --delete";
    gbD = "git branch --delete --force";
    gbgd = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '{print $1}' | xargs git branch -d";
    gbgD = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '{print $1}' | xargs git branch -D";
    gbm = "git branch --move";
    gbnm = "git --no-pager branch --no-merged";
    gbr = "git branch --remote";
    ggsup = "git branch --set-upstream-to=origin/$(git_current_branch)";
    gbg = "LANG=C git branch -vv | grep \": gone\\]\"";
    gco = "git checkout";
    gcor = "git checkout --recurse-submodules";
    gcb = "git checkout -b";
    gcB = "git checkout -B";
    gcp = "git cherry-pick";
    gcpa = "git cherry-pick --abort";
    gcpc = "git cherry-pick --continue";
    gclean = "git clean --interactive -d";
    gcl = "git clone --recurse-submodules";
    gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";
    gcam = "git commit --all --message";
    gcas = "git commit --all --signoff";
    gcasm = "git commit --all --signoff --message";
    gcs = "git commit --gpg-sign";
    gcss = "git commit --gpg-sign --signoff";
    gcssm = "git commit --gpg-sign --signoff --message";
    gcmsg = "git commit --message";
    gcsm = "git commit --signoff --message";
    gc = "git commit --verbose";
    gca = "git commit --verbose --all";
    "gca!" = "git commit --verbose --all --amend";
    "gcan!" = "git commit --verbose --all --no-edit --amend";
    "gcans!" = "git commit --verbose --all --signoff --no-edit --amend";
    "gcann!" = "git commit --verbose --all --date=now --no-edit --amend";
    "gc!" = "git commit --verbose --amend";
    gcn = "git commit --verbose --no-edit";
    "gcn!" = "git commit --verbose --no-edit --amend";
    gcf = "git config --list";
    gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
    gd = "git diff";
    gdca = "git diff --cached";
    gdcw = "git diff --cached --word-diff";
    gds = "git diff --staged";
    gdw = "git diff --word-diff";
    gdt = "git diff-tree --no-commit-id --name-only -r";
    gf = "git fetch";
    gfa = "git fetch --all --tags --prune --jobs=10";
    gfo = "git fetch origin";
    gg = "git gui citool";
    gga = "git gui citool --amend";
    ghh = "git help";
    glgg = "git log --graph";
    glgga = "git log --graph --decorate --all";
    glgm = "git log --graph --max-count=10";
    glods = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\" --date=short";
    glod = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\"";
    glola = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --all";
    glols = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --stat";
    glol = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
    glo = "git log --oneline --decorate";
    glog = "git log --oneline --decorate --graph";
    gloga = "git log --oneline --decorate --graph --all";
    glg = "git log --stat";
    glgp = "git log --stat --patch";
    gignored = "git ls-files -v | grep \"^[[:lower:]]\"";
    gfg = "git ls-files | grep";
    gm = "git merge";
    gma = "git merge --abort";
    gmc = "git merge --continue";
    gms = "git merge --squash";
    gmff = "git merge --ff-only";
    gmtl = "git mergetool --no-prompt";
    gmtlvim = "git mergetool --no-prompt --tool=vimdiff";
    gl = "git pull";
    gpr = "git pull --rebase";
    gprv = "git pull --rebase -v";
    gpra = "git pull --rebase --autostash";
    gprav = "git pull --rebase --autostash -v";
    ggpull = "git pull origin \"$(git_current_branch)\"";
    gluc = "git pull upstream $(git_current_branch)";
    gp = "git push";
    gpd = "git push --dry-run";
    gpf = "git push --force-with-lease --force-if-includes";
    gpsup = "git push --set-upstream origin (git_current_branch)";
    gpsupf = "git push --set-upstream origin (git_current_branch) --force-with-lease --force-if-includes";
    gpv = "git push --verbose";
    gpoat = "git push origin --all && git push origin --tags";
    gpod = "git push origin --delete";
    ggpush = "git push origin \"$(git_current_branch)\"";
    gpu = "git push upstream";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    grbo = "git rebase --onto";
    grbs = "git rebase --skip";
    grf = "git reflog";
    gr = "git remote";
    grv = "git remote --verbose";
    gra = "git remote add";
    grrm = "git remote remove";
    grmv = "git remote rename";
    grset = "git remote set-url";
    grup = "git remote update";
    grh = "git reset";
    gru = "git reset --";
    grhh = "git reset --hard";
    grhk = "git reset --keep";
    grhs = "git reset --soft";
    gpristine = "git reset --hard && git clean --force -dfx";
    gwipe = "git reset --hard && git clean --force -df";
    groh = "git reset origin/$(git_current_branch) --hard";
    grs = "git restore";
    grss = "git restore --source";
    grst = "git restore --staged";
    gunwip = "git rev-list --max-count=1 --format=\"%s\" HEAD | grep -q \"\\--wip--\" && git reset HEAD~1";
    grev = "git revert";
    greva = "git revert --abort";
    grevc = "git revert --continue";
    grm = "git rm";
    grmc = "git rm --cached";
    gcount = "git shortlog --summary --numbered";
    gsh = "git show";
    gsps = "git show --pretty=short --show-signature";
    gstall = "git stash --all";
    gstaa = "git stash apply";
    gstc = "git stash clear";
    gstd = "git stash drop";
    gstl = "git stash list";
    gstp = "git stash pop";
    gsta = "git stash push";
    gsts = "git stash show --patch";
    gst = "git status";
    gss = "git status --short";
    gsb = "git status --short --branch";
    gsi = "git submodule init";
    gsu = "git submodule update";
    gsd = "git svn dcommit";
    gsr = "git svn rebase";
    gsw = "git switch";
    gswc = "git switch --create";
    gta = "git tag --annotate";
    gts = "git tag --sign";
    gtv = "git tag | sort -V";
    gignore = "git update-index --assume-unchanged";
    gunignore = "git update-index --no-assume-unchanged";
    gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
    gwt = "git worktree";
    gwta = "git worktree add";
    gwtls = "git worktree list";
    gwtmv = "git worktree move";
    gwtrm = "git worktree remove";
    gstu = "gsta --include-untracked";
  };

  # Autoloaded from the generated functions/ directory, so scripts can use them.
  programs.fish.functions = {
    # Outputs the name of the current branch, or the short hash when detached.
    # Usage example: git pull origin (git_current_branch)
    # --quiet keeps symbolic-ref from failing (128) outside a symbolic ref.
    git_current_branch = ''
      set ref (git symbolic-ref --quiet HEAD 2> /dev/null)
      set res $status

      if test $res -eq 128
        return
      else if test $res -ne 0
        set ref (git rev-parse --short HEAD 2> /dev/null)
        if test $status -ne 0
          return
        end
      end
      echo (string replace 'refs/heads/' ''' $ref)
    '';

    gbda = {
      description = "Delete all branches merged in current HEAD";
      body = ''
        git branch --merged | \
          command grep -vE '^\*|^\s*(master|main|develop)\s*$' | \
          command xargs -n 1 git branch -d
      '';
    };
  };
}
