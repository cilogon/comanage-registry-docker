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
CLAIMS = 'http://schemas.xmlsoap.org/claims/'
COM_WS_CLAIMS = 'http://schemas.xmlsoap.com/ws/2005/05/identity/claims/'
MS_CLAIMS = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/'
ORG_WS_CLAIMS = 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/'

MAP = {
    'identifier': 'urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified',
    'fro': {
        NETSCAPE_LDAP+'241': 'displayName',
        EDUPERSON_OID+'10': 'eduPersonTargetedID',
        X500ATTR_OID+'42': 'givenName',
        EDUMEMBER1_OID+'1': 'isMemberOf',
        UCL_DIR_PILOT+'3': 'mail',
        ORG_WS_CLAIMS+'emailaddress': 'emailAddress',
        X500ATTR_OID+'3': 'cn',
        X500ATTR_OID+'4': 'sn',
        NETSCAPE_LDAP+'3': 'employeeNumber',
        EDUPERSON_OID+'6': 'eduPersonPrincipalName',
        UCL_DIR_PILOT+'1': 'uid',
    },
    'to': {
        'displayName': NETSCAPE_LDAP+'241',
        'eduPersonTargetedID': EDUPERSON_OID+'10',
        'givenName': X500ATTR_OID+'42',
        'isMemberOf': EDUMEMBER1_OID+'1',
        'mail': UCL_DIR_PILOT+'3',
        'emailAddress': ORG_WS_CLAIMS+'emailaddress',
        'cn': X500ATTR_OID+'3',
        'sn': X500ATTR_OID+'4',
        'employeeNumber': NETSCAPE_LDAP+'3',
        'eduPersonPrincipalName': EDUPERSON_OID+'6',
        'uid': UCL_DIR_PILOT+'1',
    }
}
