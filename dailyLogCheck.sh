#/bin/sh
PATH=/bin:/usr/bin:

#env
TMP_IP_CNT="/tmp/tmp_ip_count.tmp"
TMP_UA="/tmp/tmp_UA_count.tmp"
TMP_REQ="/tmp/tmp_REQ_count.tmp"
LOGFILE="/tmp/tmp_accesslog.tmp"
ACCESSLOG="/var/log/httpd/access_log"
DISPLINE=15

# pre file create
GREPTODAY=`LANG=C date '+%-d/%h/%Y'`
grep "$GREPTODAY" $ACCESSLOG  > $LOGFILE

# title
echo "HTTPD log watcher ($GREPTODAY)"

# IP/ASN count
echo "---Source IP/ASN counts---"
echo -e "COUNT\tIP\tASN"

cat $LOGFILE | awk '{print $1}'| sort | uniq -c | sort -nr| head -n $DISPLINE > $TMP_IP_CNT

cat $TMP_IP_CNT | while read line
do
  CNT=`echo $line | awk '{print $1}'`
  IP=`echo $line | awk '{print $2}'`
  ASN=`geoiplookup $IP| grep ASNum | sed -e 's/^.*GeoIP\ ASNum\ Edition://g'`
  echo -e " $CNT\t$IP\t$ASN"
done

# UA
echo "---UserAgent counts---"
cat $LOGFILE | awk -F\" '{print $6}' | sort | uniq -c | sort -nr > $TMP_UA
echo "==TOP5=="
head $TMP_UA -n $DISPLINE
echo "==TAIL5=="
tail $TMP_UA -n $DISPLINE

#Request
echo "---Request---"
cat $LOGFILE | awk -F\" '{print $2}' | sort | uniq -c | sort -nr > $TMP_REQ
#echo "==TOP5=="
#head $TMP_REQ -n $DISPLINE
#echo "==TAIL5=="
#tail $TMP_REQ -n $DISPLINE
# ALL
 cat $TMP_REQ

# File remove
rm $TMP_IP_CNT
rm $TMP_UA
rm $TMP_REQ
rm $LOGFILE
