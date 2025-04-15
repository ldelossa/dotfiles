#!/bin/bash
project=${1}
zone=${2}
machine_type=${3}

function log() {
	echo -e ""
	echo -e "\e[34m${1}\e[0m"
}

set -e

log "Creating virtual machine..."
gcloud compute instances create ldelossa-devel \
    --project="${project}" \
    --zone="${zone}" \
    --machine-type="${machine_type}" \
    --network-interface=network-tier=PREMIUM,nic-type=GVNIC,stack-type=IPV4_ONLY,subnet=default \
    --metadata=ssh-keys=louis:ssh-rsa\ AAAAB3NzaC1yc2EAAAADAQABAAABAQDQ3ngyWHpYRWCoxCRafIUoAApq\+jss7csZSLgPJwa\+S6Tq8Z6XEScj2kQoCewpiPE9wqfLw2lLsW\+aN6DEN147OyM62c/ncaqsxcn3n/qA8xYxFVaVILDsswSnfv3H8XAuCYR68kudQ5ZU5VTSes5IkpAtD7/QM4aqupq0m3JFMHAWey9HwBc80ujdjWYr8U9nYNcIxwN8ypudAo9EfJxP1t2OyXNcsXcMJ1hDUX9oaBmI8AJpFx4aJS278pNLGa9/VVLREAhZ4u4AtxKaWFFna3Yuin3B8BYWqDUFHMCfJiOLtiBYU4z9Ma72epN761F19Lq62fkit/79VDLIGewd\ delossantosl@vimny-delol-lm.local,serial-port-enable=1 \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=171187002445-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=ldelossa-devel,image=projects/rocky-linux-cloud/global/images/rocky-linux-9-optimized-gcp-v20240815,mode=rw,size=60,type=pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

log "Enabling serial port..."
gcloud compute instances add-metadata ldelossa-devel \
	--zone="${zone}" \
    --metadata serial-port-enable=TRUE

ip=$(gcloud compute instances describe ldelossa-devel --zone="${zone}" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
if [[ -z $ip ]]; then
	log "Could not resolve a public IP for VM"
	exit
fi

log "Virtual machine created: $ip"

log "Waiting for ssh to become available..."
while ! nc -vz "$ip" 22; do
	sleep 5
done

log "Enabling root login..."
while ! ssh louis@"$ip" "sudo passwd && \
			   	 		 sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
						 sudo systemctl restart sshd && \
						 sudo cat /home/louis/.ssh/authorized_keys | sudo tee -a /root/.ssh/authorized_keys > /dev/null"; do
	log "Waiting for ssh login to succeed..."
	sleep 10
done

# in GCP the default VCP network MTU is 1420 but docker by default will setup
# the docker0 and veths with MTU 1500. This causes TCP issues and we must tell
# docker to use MTU 1420
log "Setting docker's MTU settings for GCP"
ssh root@"$ip" 'mkdir -p /etc/docker && echo "{ \"mtu\": 1460 }" > /etc/docker/daemon.json'

log "Virtual machine creation finished successfully"
