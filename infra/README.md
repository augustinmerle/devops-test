# INFRA

## Directory structure

    /
        environments/  <= this directory is generated
            env1/
                layer1/
                    main.tf
                layer2/
                    main.tf
                layer3/
                    main.tf
                ...
            env2/
            ...
        layers/  <= this directory contains Terraform template files (EJS format)
            layer1.tmpl.tf
            layer2.tmpl.tf
            layer3.tmpl.tf
            ...
        modules/ <= this directory contains pure Terraform modules
            layer1/
                main.tf
                outputs.tf
                variables.tf
            layer2/
                main.tf
                outputs.tf
                variables.tf
            layer3/
                main.tf
                outputs.tf
                variables.tf
            ...


## Useful commands

    make init
    make plan
    make apply
    make refresh


