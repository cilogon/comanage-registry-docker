EDUCOURSE_OID = 'urn:oid:1.3.6.1.4.1.5923.1.6.1.'
EDUPERSON_OID = 'urn:oid:1.3.6.1.4.1.5923.1.1.1.'
EDUMEMBER1_OID = 'urn:oid:1.3.6.1.4.1.5923.1.5.1.'
LDAPGVAT_OID = 'urn:oid:1.2.40.0.10.2.1.1.' # ldap.gv.at definitions as specified in http://www.ref.gv.at/AG-IZ-PVP2-Version-2-1-0-2.2754.0.html
UCL_DIR_PILOT = 'urn:oid:0.9.2342.19200300.100.1.'
X500ATTR_OID = 'urn:oid:2.5.4.'
LDAPGVAT_UCL_DIR_PILOT = UCL_DIR_PILOT
LDAPGVAT_X500ATTR_OID = X500ATTR_OID
NETSCAPE_LDAP = 'urn:oid:2.16.840.1.113730.3.1.'
NOREDUPERSON_OID = 'urn:oid:1.3.6.1.4.1.2428.90.1.'
PKCS_9 = 'urn:oid:1.2.840.113549.1.9.1.'
SCHAC = 'urn:oid:1.3.6.1.4.1.25178.1.2.'
SIS = 'urn:oid:1.2.752.194.10.2.'
UMICH = 'urn:oid:1.3.6.1.4.1.250.1.57.'
OPENOSI_OID = 'urn:oid:1.3.6.1.4.1.27630.2.1.1.' #openosi-0.82.schema http://www.openosi.org/osi/display/ldap/Home

MAP = {
    'identifier': 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
    'fro': {
        X500ATTR_OID+'42': 'givenName',
        X500ATTR_OID+'4': 'sn',
        EDUPERSON_OID+'6': 'eduPersonPrincipalName',
    },
    'to': {
        'givenName': X500ATTR_OID+'42',
        'sn': X500ATTR_OID+'4',
        'eduPersonPrincipalName': EDUPERSON_OID+'6',
    }
}
