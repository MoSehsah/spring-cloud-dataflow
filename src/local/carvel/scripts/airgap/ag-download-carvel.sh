
#!/bin/bash
## **This is an autogenerated file, do not change it manually**

if test -z "$BASH_VERSION"; then
  echo "Please run this script using bash, not sh or any other shell." >&2
  exit 1
fi

install() {
  set -euo pipefail


  if [ -x "$(command -v wget)" ]; then
    dl_bin="wget -nv -O-"
  else
    dl_bin="curl -s -L"
  fi

  shasum -v 1>/dev/null 2>&1 || (echo "Missing shasum binary" && exit 1)
  
  binary_type="${CARVEL_DOWNLOAD_BINARY_TYPE:-linux-amd64}"

  if [[ $binary_type == "darwin-amd64" ]]; then
    ytt_checksum=fb9cc00c4b6285e04595c493df73da425a2d5f9a551630e52559dd9ee2d58252
    imgpkg_checksum=76a9290361e7f445da3c1adc51660507775e24b431e6140095c645bdf7fa2f7a
    kbld_checksum=f0cdc652e4c8d56ec9f6f61030e353699e57faa2a0aedd1e786d44eb738f8ac1
    kapp_checksum=d3bf8bc733ed781ca5371ee6de008cb7682731995f1a9fb7748d2b21a6e7a9ff
    kwt_checksum=555d50d5bed601c2e91f7444b3f44fdc424d721d7da72955725a97f3860e2517
    vendir_checksum=33c9654e6e5e865f45f411bf45ea12e28590fdcb43961f758b6d3b28be4c1caf
    kctrl_checksum=b41bef1c6eeca32030e0be055a47788eb9dafa646541dd5a52dac154c3942604
  else
    ytt_checksum=c047bd7084beea2b4a585b13148d7c1084ee6c4aee8a68592fc8ed7d75ecebc5
    imgpkg_checksum=db5b3f7d8f87790b6df3a4c0fda4ad58e74b8ccf1a3cd6c3c113bf142597190c
    kbld_checksum=6a933fa76aa581b6c92c810c4c35877fad68187e2e9320b86876e00ec6852185
    kapp_checksum=6b53e0d866fb3cdcb781475c23973eab6c37959e53c22094bc81f998884d74ae
    kwt_checksum=92a1f18be6a8dca15b7537f4cc666713b556630c20c9246b335931a9379196a0
    vendir_checksum=0d8a45d2d85647ce932e1d630d49668e96552140ad33c6adad5f589bb800bb8a
    kctrl_checksum=053962a5e40210059256db2625bdc1e15e3d4617cee1c9d28dd7dfcc034b9a32
  fi

  echo "Downloading ${binary_type} binaries..."
  mkdir -p carvel-download

  #TODO: variables for versions
  echo "Downloading ytt..."
  $dl_bin github.com/carvel-dev/ytt/releases/download/v0.44.3/ytt-${binary_type} > ./carvel-download/ytt-${binary_type}
  echo "${ytt_checksum}  ./carvel-download/ytt-${binary_type}" | shasum -c -
  echo "Downloaded ytt v0.44.3"
  
  echo "Downloading imgpkg..."
  $dl_bin github.com/carvel-dev/imgpkg/releases/download/v0.36.0/imgpkg-${binary_type} > ./carvel-download/imgpkg-${binary_type}
  echo "${imgpkg_checksum}  ./carvel-download/imgpkg-${binary_type}" | shasum -c -
  echo "Downloaded imgpkg v0.36.0"
  
  echo "Downloading kbld..."
  $dl_bin github.com/carvel-dev/kbld/releases/download/v0.36.4/kbld-${binary_type} > ./carvel-download/kbld-${binary_type}
  echo "${kbld_checksum}  ./carvel-download/kbld-${binary_type}" | shasum -c -
  echo "Downloaded kbld v0.36.4"
  
  echo "Downloading kapp..."
  $dl_bin github.com/carvel-dev/kapp/releases/download/v0.54.3/kapp-${binary_type} > ./carvel-download/kapp-${binary_type}
  echo "${kapp_checksum}  ./carvel-download/kapp-${binary_type}" | shasum -c -
  echo "Downloaded kapp v0.54.3"
  
  echo "Downloading kwt..."
  $dl_bin github.com/carvel-dev/kwt/releases/download/v0.0.6/kwt-${binary_type} > ./carvel-download/kwt-${binary_type}
  echo "${kwt_checksum}  ./carvel-download/kwt-${binary_type}" | shasum -c -
  echo "Downloaded kwt v0.0.6"
  
  echo "Downloading vendir..."
  $dl_bin github.com/carvel-dev/vendir/releases/download/v0.32.5/vendir-${binary_type} > ./carvel-download/vendir-${binary_type}
  echo "${vendir_checksum}  ./carvel-download/vendir-${binary_type}" | shasum -c -
  echo "Downloaded vendir v0.32.5"
  
  echo "Downloading kctrl..."
  $dl_bin github.com/carvel-dev/kapp-controller/releases/download/v0.44.6/kctrl-${binary_type} > ./carvel-download/kctrl-${binary_type}
  echo "${kctrl_checksum}  ./carvel-download/kctrl-${binary_type}" | shasum -c -
  echo "Downloaded kctrl v0.44.6"
  
}

install
