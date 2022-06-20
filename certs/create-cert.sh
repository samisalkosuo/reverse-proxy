#creates certificate for given domain
#certificate is signed using CA in this directory

if [ "$1" = "" ]; then
  echo "Host name not given."
  echo "Usage: $0 reverseproxy example.com"
  exit 1
fi

if [ "$2" = "" ]; then
  echo "Domain not given."
  echo "Usage: $0 reverseproxy example.com"
  exit 1
fi

__base_name=$1
__domain=$2
__organization="Sami Salkosuo"

__validity_days=3650
__common_name=${__base_name}.${__domain}
__csr_config_file=host.csr.txt
__key_file=host.key
__crt_file=host.crt

  
cat > ${__csr_config_file} << EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
x509_extensions = req_ext
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=FI
O=${__organization}
emailAddress=mr.smith@${__domain}
CN = ${__common_name}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${__base_name}
DNS.2 = ${__common_name}
DNS.3 = ${__common_name}.local
EOF

#create registry certificate key
openssl genrsa -out ${__key_file} 4096

#create CSR
openssl req -new -sha256 -key ${__key_file} -out host.csr -config ${__csr_config_file}
  
#sign CSR usign CA cert
openssl x509 -req \
            -extfile ${__csr_config_file} \
            -extensions req_ext \
            -in host.csr \
            -CA ca.crt \
            -CAkey ca.key  \
            -CAcreateserial \
            -out ${__crt_file} \
            -days ${__validity_days} \
            -sha256 
