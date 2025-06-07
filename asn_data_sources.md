# 📦 ASN Data Sources

## 📂 Source Index

### 📡 RIR WHOIS & Routing Databases

These are the primary sources directly from the official RIRs:

```json
{
  "https://ftp.afrinic.net/pub/dbase/afrinic.db.gz": "afrinic.db",
  "https://ftp.apnic.net/apnic/whois/apnic.db.domain.gz": "apnic.db.domain",
  "https://ftp.apnic.net/apnic/whois/apnic.db.inet-rtr.gz": "apnic.db.inet-rtr",
  "https://ftp.apnic.net/apnic/whois/apnic.db.inetnum.gz": "apnic.db.inetnum",
  "https://ftp.apnic.net/apnic/whois/apnic.db.irt.gz": "apnic.db.irt",
  "https://ftp.apnic.net/apnic/whois/apnic.db.organisation.gz": "apnic.db.organisation",
  "https://ftp.apnic.net/apnic/whois/apnic.db.peering-set.gz": "apnic.db.peering-set",
  "https://ftp.apnic.net/apnic/whois/apnic.db.role.gz": "apnic.db.role",
  "https://ftp.apnic.net/apnic/whois/apnic.db.route-set.gz": "apnic.db.route-set",
  "https://ftp.apnic.net/apnic/whois/apnic.db.route.gz": "apnic.db.route",
  "https://ftp.arin.net/pub/rr/arin.db.gz": "arin.db",
  "https://ftp.lacnic.net/lacnic/dbase/lacnic.db.gz": "lacnic.db",
  "https://ftp.ripe.net/ripe/dbase/ripe.db.gz": "ripe.db"
}

🛰️ Additional IRR Mirrors

These databases are maintained by ISPs, NRENs, and IRR mirrors around the world:

{
  "ftp://ftp.altdb.net/pub/altdb/altdb.db.gz": "altdb.db",
  "ftp://whois.in.bell.ca/bell.db.gz": "bell.db",
  "ftp://irr.bboi.net/bboi.db.gz": "bboi.db",
  "https://whois.canarie.ca/dbase/canarie.db.gz": "canarie.db",
  "ftp://irr-mirror.idnic.net/idnic.db.gz": "idnic.db",
  "ftp://ftp.nic.ad.jp/jpirr/jpirr.db.gz": "jpirr.db",
  "ftp://rr.Level3.net/level3.db.gz": "level3.db",
  "ftp://ftp.nestegg.net/irr/nestegg.db.gz": "nestegg.db",
  "ftp://rr1.ntt.net/nttcomRR/nttcom.db.gz": "nttcom.db",
  "ftp://ftp.panix.com/pub/rrdb/panix.db.gz": "panix.db",
  "ftp://ftp.radb.net/radb/dbase/radb.db.gz": "radb.db",
  "ftp://ftp.radb.net/radb/dbase/reach.db.gz": "reach.db",
  "ftp://ftp.bgp.net.br/tc.db.gz": "tc.db"
}

🗂 Additional IPv4/IPv6 and ASN Statistics

Provided by Geoff Huston's Potaroo:

    IPv4 Allocated: https://bgp.potaroo.net/stats/allocspace-prefix.txt

    IPv4 Free: https://bgp.potaroo.net/stats/freespace-prefix.txt

    IPv6 Allocated: https://bgp.potaroo.net/stats/allocspace-prefix6.txt

    IPv6 Free: https://bgp.potaroo.net/stats/freespace-prefix6.txt

Historical / Archive

    IANA IPv6 Assignments:
    https://bgp.potaroo.net/stats/iana/archive/2022/06/ipv6-unicast-address-assignments-20220618.xml

    ASN Allocation:
    https://bgp.potaroo.net/stats/iana/archive/2022/06/as-numbers-20220618.xml

    IPv4 Address Space:
    https://bgp.potaroo.net/stats/iana/archive/2022/06/ipv4-address-space-20220618.xml

    Reserved Advertised IPv4:
    https://bgp.potaroo.net/stats/apnic/reserved_advertised_ipv4.txt

    Reserved Unadvertised IPv4:
    https://bgp.potaroo.net/stats/apnic/reserved_unadvertised_ipv4.txt
