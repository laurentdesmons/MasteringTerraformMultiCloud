#
# Script to run Terraform with any action on any environment (based on the *.tfvars files)
# Before executing the specified action, the script will always execute : init, fmt, get, validate 
# Example (on Mac) : pwsh run.ps1 -env uat -action plan

# params
param ($env, $action)

# validate params
if ($env -notin ('dev', 'prd')) {
    Write-Host "Error: parameter 'env' not defined or invalid. Accepted values : dev | prd" -ForegroundColor Red
    return 
}

if ($action -notin ('validate', 'plan', 'apply', 'destroy')) {
    Write-Host "Error: parameter 'action' not defined or invalid. Accepted values : validate | plan | apply | destroy" -ForegroundColor Red
    return
}

# start
$backend_varfile = './environments/' + $env + '/terraform-backend-' + $env + '.tfvars'
$varfile = './environments/' + $env + '/terraform-' + $env + '.tfvars'
Write-Host ""
Write-Host "========================================"
Write-Host "Environment: $env" -ForegroundColor Yellow
Write-Host "Action: $action" -ForegroundColor Yellow
Write-Host "Backend file: $backend_varfile" -ForegroundColor Yellow
Write-Host "Variables file: $varfile" -ForegroundColor Yellow
Write-Host "========================================"
Write-Host ""

try {
    # init
    Write-Host "Executing: Terraform init"
    terraform init --backend-config=$backend_varfile -reconfigure -upgrade
    if ($? -ne "true") {
        throw 
    }

    # format
    Write-Host "Executing: Terraform fmt"
    terraform fmt --recursive
    if ($? -ne "true") {
        Pop-Location
        throw 
    }

    # get
    Write-Host "Executing: Terraform get"
    terraform get
    if ($? -ne "true") {
        throw 
    }

    # validate
    Write-Host "Executing: Terraform validate"
    terraform validate   
    if ($? -ne "true") {
        throw 
    } 

    if ($action -eq 'validate') {
        return
    }
    
    # execute action
    Write-Host "Executing: Terraform $action"
    terraform $action --var-file=$varfile 
    if ($? -ne "true") {
        throw 
    }
}
catch {
    Write-Host "Error: Terraform $action failed." -ForegroundColor Red
    return 
}


