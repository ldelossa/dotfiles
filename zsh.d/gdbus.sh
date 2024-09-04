function gdbus-intro-sys() {
	gdbus introspect -y -d "${1}" -o / -r
}

function gdbus-intro-sess() {
	gdbus introspect -e -d "${1}" -o / -r
}

function gdbus-call-sys() {
	gdbus call -y -d "${1}" -o "${2}" -m "${3}"
}

function gdbus-call-sesss() {
	gdbus call -e -d "${1}" -o "${2}" -m "${3}"
}
