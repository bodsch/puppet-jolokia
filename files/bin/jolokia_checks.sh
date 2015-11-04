#!/bin/bash
#
# CRON Job to build jolokia Checks
#
#
#
#

# ----------------------------------------------------------------------------------------

SCRIPTNAME=$(basename $0 .sh)
VERSION="2.6.0"
VDATE="28.09.2015"

# ----------------------------------------------------------------------------------------

NRPE_DEFAULTS="/usr/local/share/nrpe_defaults.sh" # /usr/lib64/nagios/plugins/utils.sh
SERVICES="/etc/coremedia/services"
JOLOKIA_RC="/etc/jolokia.rc"

[ -f "${NRPE_DEFAULTS}" ] && {
  . ${NRPE_DEFAULTS}
} || {

  [ -f "/usr/lib64/nagios/plugins/utils.sh" ] && {
    . /usr/lib64/nagios/plugins/utils.sh
  } || {
    echo "nrpe defaults missing"
    echo "please install nrpe plugins"
    exit 1
  }
}

[ -f "${SERVICES}" ] && {
  . ${SERVICES}
} || {
  echo "services missing"
  exit 1
}

[ -f "${JOLOKIA_RC}" ] && {
  . ${JOLOKIA_RC}
} || {
  echo "${JOLOKIA_RC} missing"
  exit 1
}

DAEMON=false
PORTS=

# ----------------------------------------------------------------------------------------

version() {

  help_format_title="%-9s %s\n"

  echo ""
  printf  "$help_format_title" "jolokia Checks and Results"
  echo ""
  printf  "$help_format_title" " Version $VERSION ($VDATE)"
  echo ""
}

usage() {

  help_format_title="%-9s %s\n"
  help_format_desc="%-9s %-10s %s\n"
  help_format_example="%-9s %-30s %s\n"

  version

  printf  "$help_format_title" "Usage:" \
          "$SCRIPTNAME [-h] [-v] [-D]"

  printf  "$help_format_desc" "" \
          "-h" ": Show this help"

  printf  "$help_format_desc" "" \
          "-v" ": Prints out the Version"

  printf  "$help_format_desc" "" \
          "-D" ": run as Daemon (only uasable with /etc/init.d/jolokia_checks)"

}

# ----------------------------------------------------------------------------------------

buildChecks() {

  for p in ${PORTS}
  do
#    echo "port: ${p}"
    jmx=JMX_${p}
#    echo ${!jmx}

    for c in ${!jmx}
    do
#      echo "check: ${c}"

      file_tpl="${TEMPLATE_DIR}/${c}.json.tpl"

      dir="${TMP_DIR}/${p}"
      [ -d ${dir} ] || mkdir -p ${dir}

      file_dst="${dir}/${c}.json"

      if [ -f "${file_dst}" ]
      then
        filemtime=$(stat -c %Y ${file_dst})
        currtime=$(date +%s)
        diff=$(( (currtime - filemtime) / 86400 ))
#        echo " .. ${filemtime} / ${currtime} : ${diff}"
        if [ ${diff} -gt ${MAX_JSON_TIME} ]
        then
          rm -f ${file_dst}
        fi
      fi

      if [ -f "${file_tpl}" ]
      then

        if ( [ ${c} = "SolrReplicationHandler" ] && ( [ ${p} -eq 44099 ] || [ ${p} -eq 45099 ] ) )
        then

          for s in live preview studio
          do
            file_dst_solr="${dir}/${c}.${s}.json"

            if [ -f ${file_dst_solr} ]
            then
              continue
            fi

            cp ${file_tpl} ${file_dst_solr}

            sed -i "s/%SHARD%/${s}/g" ${file_dst_solr}
            sed -i "s/%PORT%/${p}/g"  ${file_dst_solr}

          done
        else
          if [ -f ${file_dst} ]
          then
            continue
          fi

          sed -e "s/%PORT%/${p}/g" ${file_tpl} > ${file_dst}
        fi
      fi

    done
  done
}

runChecks() {

  for p in ${PORTS}
  do

    dir="${TMP_DIR}/${p}"
    if [ ! -d ${dir} ]
    then
      buildChecks
    fi

    for i in $(ls -1 ${dir}/*.json)
    do
      dst="$(echo ${i} | sed 's/\.json/\.result/g')"
      tmp="$(echo ${i} | sed 's/\.json/\.tmp/g')"

      touch ${tmp}

      ionice -c2 nice -n19  curl --silent --request POST --data "$(cat $i)" http://localhost:8080/jolokia/ | json_reformat > ${tmp}
      sleep 1s

      [ $(stat -c %s ${tmp}) -gt 0 ] && {
        mv ${tmp} ${dst}
      } || {
        rm -f ${tmp}
      }
    done

    if ( [ ${p} -eq 44099 ] || [ ${p} -eq 45099 ] )
    then
      port="$(echo ${p} | sed 's|99|80|g')"
      for s in live preview studio
      do
        dst="${dir}/solr.${s}.result"
        tmp="${dir}/solr.${s}.tmp"

        touch ${tmp}

        ionice -c2 nice -n19  curl --silent --request GET "http://localhost:${port}/solr/${s}/replication?command=details&wt=json" | json_reformat > ${tmp}
        sleep 1s

        [ $(stat -c %s ${tmp}) -gt 0 ] && {
          mv ${tmp} ${dst}
        } || {
          rm -f ${tmp}
        }
      done
    fi

  done

  touch ${TMP_DIR}/jolokia-check.run
}

# ----------------------------------------------------------------------------------------

run() {

  pid=$(netstat -tlnp | grep ":8080" | grep LISTEN | awk -F ' ' '{print $7}')

  if [ -z "{pid}" ]
  then
    echo "no jolokia tomcat running"
    exit 2
  fi

  if [ ! -f ${JOLOKIA_PORT_CACHE} ]
  then
    echo "no ports cache found"
    exit 2
  else
    filemtime=$(stat -c %Y ${JOLOKIA_PORT_CACHE})
    currtime=$(date +%s)
    diff=$(( (currtime - filemtime) / 30 ))
#        echo " .. ${filemtime} / ${currtime} : ${diff}"
    if [ ${diff} -gt 30 ]
    then
      echo "port cache is older than 30 minutes"
    fi
  fi

  . ${JOLOKIA_PORT_CACHE}

  if [ $(echo "${PORTS}" | wc -w) -eq 0 ]
  then
    echo "no valid ports found"
#    rm -f ${TMP_DIR}/jolokia*
    exit 2
  fi

  if [ ${DAEMON} = true ]
  then
    while sleep "${INTERVAL}"
    do
      runChecks

#       if [ -f ${JOLOKIA_PORT_CACHE} ]
#       then
#         filemtime=$(stat -c %Y ${JOLOKIA_PORT_CACHE})
#         currtime=$(date +%s)
#         diff=$(( (currtime - filemtime) / 60 ))
# #        echo " .. ${filemtime} / ${currtime} : ${diff}"
#         if [ ${diff} -gt 60 ]
#         then
#           getRunningApplications
#         fi
#       else
#         getRunningApplications
#       fi
    done
  else
    runChecks
  fi

}



# ----------------------------------------------------------------------------------------

# Parse parameters
while [ $# -gt 0 ]
do
  case "$1" in
    -h|--help) shift
      usage;
      exit 0
      ;;
    -v|--version) shift
      version;
      exit 0
      ;;
    -D|--daemon)
      DAEMON=true
      ;;
    *)  echo "Unknown argument: $1"
      exit $STATE_UNKNOWN
      ;;
  esac
shift
done

# ----------------------------------------------------------------------------------------

run

# EOF
