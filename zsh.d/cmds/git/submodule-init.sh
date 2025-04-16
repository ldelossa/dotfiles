desc="Recurisvely initialize git submodules"
args=("--extra:Any extra arguments")
help=("submodule-init.sh", "Recurisvely initialize git submodules")

execute() {
	git submodule update --init --recursive "${extra}"
}
