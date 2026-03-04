desc="Deploy and bootstrap a GCP instance running Rocky Linux"
args=("--project:The project the machine is deployed in" \
	  "--zone:The zone the machine is deployed in" \
      "--machine_type:The machine type to deploy" \
      "--name:[o] optional nameo of instance (default: ldelossa-devel")
help=("gcloud-dev-box", "Deploy and bootstrap a GCP instance running Rocky Linux.

 This script will deploy a Rocky Linux instance and bootstrap it.
 Once the machine is created the script with SSH to it.
 SSH access by the root user will be enabled and an MTU fix for Docker to
 correctly function will be applied.

 This script requires the gcloud tool is installed and logged in correctly.

 Example: cmds automation gcloud-dev-box.sh --machine_type c2-standard-8 --project cilium-dev --zone us-east1-b
 ")

execute() {
	set -e

	# set name variable, overwrite if user provides one as argumetn
	if (( !${+name} )); then
		name="ldelossa-devel"
	fi

	lib_info "Creating virtual machine..."
	gcloud compute instances create "${name}" \
		  --project="${project}" \
		  --zone="${zone}" \
		  --machine-type="${machine_type}" \
		  --network-interface=network-tier=PREMIUM,nic-type=GVNIC,stack-type=IPV4_ONLY,subnet=default \
		  --metadata=ssh-keys=louis:ssh-rsa\ AAAAB3NzaC1yc2EAAAADAQABAAABAQDQ3ngyWHpYRWCoxCRafIUoAApq\+jss7csZSLgPJwa\+S6Tq8Z6XEScj2kQoCewpiPE9wqfLw2lLsW\+aN6DEN147OyM62c/ncaqsxcn3n/qA8xYxFVaVILDsswSnfv3H8XAuCYR68kudQ5ZU5VTSes5IkpAtD7/QM4aqupq0m3JFMHAWey9HwBc80ujdjWYr8U9nYNcIxwN8ypudAo9EfJxP1t2OyXNcsXcMJ1hDUX9oaBmI8AJpFx4aJS278pNLGa9/VVLREAhZ4u4AtxKaWFFna3Yuin3B8BYWqDUFHMCfJiOLtiBYU4z9Ma72epN761F19Lq62fkit/79VDLIGewd\ delossantosl@vimny-delol-lm.local,serial-port-enable=1 \
		  --maintenance-policy=MIGRATE \
		  --provisioning-model=STANDARD \
		  --service-account=171187002445-compute@developer.gserviceaccount.com \
		  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
		  --image-family=rocky-linux-10-optimized-gcp \
		  --image-project=rocky-linux-cloud \
		  --boot-disk-size=250GB \
		  --boot-disk-type=pd-ssd \
		  --boot-disk-device-name="${name}" \
		  --boot-disk-auto-delete \
		  --no-shielded-secure-boot \
		  --shielded-vtpm \
		  --shielded-integrity-monitoring \
		  --labels=goog-ec-src=vm_add-gcloud \
		  --reservation-affinity=any

	lib_info "Enabling serial port..."
	gcloud compute instances add-metadata ldelossa-devel \
		--zone="${zone}" \
		--metadata serial-port-enable=TRUE

	ip=$(gcloud compute instances describe ldelossa-devel --zone="${zone}" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
	if [[ -z $ip ]]; then
		lib_err "Could not resolve a public IP for VM"
		exit 1
	fi

	lib_info "Virtual machine created: $ip"

	lib_info "Waiting for ssh to become available..."
	while ! nc -vz "$ip" 22; do
		sleep 5
	done

	lib_info "Enabling root login..."
	while ! ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null louis@"$ip" "sudo passwd && \
							 sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
							 sudo systemctl restart sshd && \
							 sudo cat /home/louis/.ssh/authorized_keys | sudo tee -a /root/.ssh/authorized_keys > /dev/null"; do
		log_info "Waiting for ssh login to succeed..."
		sleep 10
	done

	# in GCP the default VCP network MTU is 1420 but docker by default will setup
	# the docker0 and veths with MTU 1500. This causes TCP issues and we must tell
	# docker to use MTU 1420
	lib_info "Setting docker's MTU settings for GCP"
	ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@"$ip" 'mkdir -p /etc/docker && echo "{ \"mtu\": 1460 }" > /etc/docker/daemon.json'

	lib_info "Virtual machine creation finished successfully"
}

