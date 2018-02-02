FROM sphericalcowgroup/comanage-registry-slapd

ARG OLC_SUFFIX
ARG OLC_ROOT_DN
ARG OLC_ROOT_PW

ENV OLC_SUFFIX ${OLC_SUFFIX:-dc=my,dc=org}
ENV OLC_ROOT_DN ${OLC_ROOT_DN:-cn=admin,dc=my,dc=org}
ENV OLC_ROOT_PW ${OLC_ROOT_PW:-password}

COPY docker-slapd-entrypoint /usr/local/bin/

COPY cilogonperson.ldif /etc/ldap/schema/cilogonperson.ldif

EXPOSE 389 636

CMD ["slapd", "-d", "256", "-h", "ldapi:/// ldap:/// ldaps:///", "-u", "openldap", "-g", "openldap"]

