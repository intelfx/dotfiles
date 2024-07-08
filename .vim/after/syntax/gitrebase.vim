syn match   gitrebaseRefHead        "\<refs/heads/" nextgroup=gitrebaseName skipwhite contained
hi def link gitrebaseUpdateRef      Exception
hi def link gitrebaseRefHead        gitrebaseComment
