build-tmp:
    #!/usr/bin/env bash
    bluebuild build --skip-validation -a ./ ./recipes/images/tmp.yml -v
    rm -f ./tmp.tar.gz ./temporary.tar.gz
    rm -rf ./.bluebuild-scripts_*
