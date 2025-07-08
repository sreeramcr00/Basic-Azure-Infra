#!/bin/bash
set -euo pipefail
check_az_cli(){
    if ! command -v az &> /dev/null; then
        echo " Azure CLI is not installed"
        return 1
    fi
}

install_az_cli(){
    echo "installing az cli"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    az --version
}
wait_for_vm(){
    local id=$1
    echo "Waiting for vm in running state..."
    while true; do
        state=$(az vm get-instance-view --ids $id --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" -o tsv)
        if [[ $state="VM running" ]]; then
            echo " VM $id is now running"
            break
        fi
        sleep 5
    done
}

create_vm(){
    local rg=$1
    local name=$2
    local os=$3
    local user=$4
    local ssh_key_rg="Access-rg"
    local ssh_key=$(az sshkey list --resource-group Access-rg --query "[].name" -o tsv)
    local ssh_public_key=$(az sshkey show --resource-group "$ssh_key_rg" --name "$ssh_key" --query "publicKey" -o tsv)

    if [[ -z "$ssh_public_key" ]]; then
        echo "Failed to retrieve SSH public key"
        exit 1
    fi
    vm_id=$(az vm create \
  --resource-group "$rg" \
  --name "$name" \
  --location centralus \
  --size Standard_B1s \
  --image "$os" \
  --admin-username "$user" \
  --ssh-key-values "$ssh_public_key" \
  --output json \
  --query "id" -o tsv
    )
    if [[ -z $vm_id ]]; then
        echo "Failed to create VM"
        exit 1
    fi
    echo "VM $name created successfully and running $vm_id"

}

main() {
    if ! check_az_cli; then
        install_az_cli
    fi
    echo " Creating VM"
    RG="practice-rg"
    Name="testvm0101"
    OS="Ubuntu2204"
    User="learn"

    create_vm "$RG" "$Name" "$OS" "$User"
    echo "creation completed"
    }
main "$@"