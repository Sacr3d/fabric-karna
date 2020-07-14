

function createOrg4 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org4.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org4.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:13054 --caname ca-org4 --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-org4.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-org4.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-org4.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-org4.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-org4 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-org4 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-org4 --id.name org4admin --id.secret org4adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org4.example.com/peers
  mkdir -p organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp --csr.hosts peer0.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls --enrollment.profile tls --csr.hosts peer0.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/org4.example.com/users
  mkdir -p organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp/config.yaml



  echo
  echo "Register orderer"
  echo
  set -x
  fabric-ca-client register --caname ca-org4 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/org4.example.com/orderers
  mkdir -p organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/msp --csr.hosts orderer0.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:13054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls --enrollment.profile tls --csr.hosts orderer0.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/orderers/orderer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


}