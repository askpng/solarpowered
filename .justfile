build-tmp:
    #!/usr/bin/env bash
    bluebuild build --skip-validation -a ./ ./recipes/images/tmp.yml
    rm -f ./tmp.tar.gz ./temporary.tar.gz
    rm -rf ./.bluebuild-scripts_*

    
