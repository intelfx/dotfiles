syn match   gitrebaseRefHead        "\<refs/heads/" nextgroup=gitrebaseName contained
hi! def link gitrebaseUpdateRef      Exception
hi! def link gitrebaseRefHead        gitrebaseComment
