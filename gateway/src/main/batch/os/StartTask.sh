#!/bin/bash
# #####################################################################################################################################################################
# Usage: StartTask -p <project name> -m <microflow name> -s <session_id> -a <use_case_id>
#       :
#       : <project name>   = name of the aptitude project which will be invoked
#       : <microflow name> = name of the microflow within <project name> which will be invoked
#       : <session_id>     = value of the session id processed from the <microflow name>
#       : <UseCaseId>      = name of the use case for which the session id will be processed
#       :
#       : e.g. :
#       : StartTask.sh -p AptitudeProject -m AptitudeMicroflow -s SessionID -a UseCaseId
#       : StartTask.sh -p g77_src_g71 -m contract_publish -s 'G71_12345 -a 'G71'
# #####################################################################################################################################################################

RET=0
FAILURE_RETURN_CODE=3

#################################
# Load the common functions
#################################
. common.sh

#################################
usage()
#################################
{
  logMsg ${LM_INFO} "usage:      StartTask.sh -p AptitudeProject -m AptitudeMicroflow -s SessionID -a UseCaseId -r UC4RunID (Optional)"
  logMsg ${LM_INFO} "example:    StartTask.sh -p g77_src_g71 -m contract_publish -s 'G71_12345 -a 'UCN1064' -r 012345"
}

#################################
loadArgs()
#################################
{
  while getopts :p:m:s:a:r:d:t:h option
  do
    case $option in

        p)      L_PROJECT_NAME=${OPTARG}
                ;;

        m)      L_MICROFLOW_NAME=${OPTARG}
                ;;

        s)      L_SESSION_ID=${OPTARG}
                ;;

        a)      L_USE_CASE_ID=${OPTARG}
                ;;

        r)      L_UC4_RUN_ID=${OPTARG}
                ;;
                
        d)      L_MAINTAIN_DATA_ID=${OPTARG}
                ;;
                
        t)      L_MESSAGE_TEXT=${OPTARG}
                ;;
                
        h)      usage
                exit
                ;;

        *)      logMsg ${LM_ERROR} "ERROR: Incorrect paramater provided."
                usage
                RET=1
    esac
  done
  shift $((OPTIND-1))
}
#################################
setupEnvironment()
#################################
{
    L_PATH_TO_LOG_FILE=${BATCH_LOGS}/${L_UC4_RUN_ID}.log
    if [ ! -d ${BATCH_LOGS} ]
    then
        mkdir -p ${BATCH_LOGS}
        RET=$?

        if (( $RET != 0 ))
        then
                logMsg ${LM_ERROR} "Failed to create log directory: ${BATCH_LOGS}"
        fi
    fi
}

#################################
validateParameters()
#################################
{
    if  [ -z ${L_PROJECT_NAME} ]
    then
        L_PROJECT_NAME="* project name required *"
        logMsg ${LM_ERROR} "The mandatory 'L_PROJECT_NAME' parameter was not supplied with -p option."
        usage
        RET=${FAILURE_RETURN_CODE}
    fi
    if [ -z ${L_MICROFLOW_NAME} ]
    then
          L_MICROFLOW_NAME="* microflow name required *"
        logMsg ${LM_ERROR} "The mandatory 'L_MICROFLOW_NAME' parameter was not supplied with -m option."
        usage
        RET=${FAILURE_RETURN_CODE}
    fi
    if [ -z ${L_SESSION_ID} ]
    then
          L_SESSION_ID="* session id required *"
        logMsg ${LM_ERROR} "The mandatory 'L_SESSION_ID' parameter was not supplied with -s option."
        usage
        RET=${FAILURE_RETURN_CODE}
    fi
    if [ -z ${L_USE_CASE_ID} ]
    then
          L_USE_CASE_ID="* use case id required *"
        logMsg ${LM_ERROR} "The mandatory 'L_USE_CASE_ID' parameter was not supplied with -a option."
        usage
        RET=${FAILURE_RETURN_CODE}
    fi
}
#################################
  printLogMessage()
#################################
{
  logMsg ${1} "[${L_UC4_RUN_ID}] [${L_USE_CASE_ID}] [${L_SESSION_ID}] [${L_PROJECT_NAME}] [${L_MICROFLOW_NAME}] [${L_MAINTAIN_DATA_ID}] ${2}" "UC4" $$
}
#################################
printCompletionMessage()
#################################
{
    C_DURATION=$SECONDS;

    if (( ${RET} == 0 || ${RET} == 9 ))
    then
      printLogMessage ${LM_INFO} "[$(($C_DURATION / 60)) min] [$(($C_DURATION % 60)) s] Complete"
    else

      if [[ ! -z ${L_ERROR_MSG} ]]
      then
        printLogMessage ${LM_ERROR} "${L_ERROR_MSG}"
      fi

      printLogMessage ${LM_ERROR} "[$(($C_DURATION / 60)) min] [$(($C_DURATION % 60)) s] FAIL"
    fi
}
#################################
refreshAptitudeCache()
#################################
{
  # Limit number of parallel cache refreshes on the same project
  L_LOCKFILE=${APT_SCRIPTS}/$(basename $0)_${L_PROJECT_NAME}_refresh_cache.lock
  L_CACHE_ERR=${APT_SCRIPTS}/$(basename $0)_${L_PROJECT_NAME}_refresh_cache.err

  lockfile -r0 "${L_LOCKFILE}" 2>/dev/null
  LOCK_FILE_EXISTS=$?

        if [[ ${LOCK_FILE_EXISTS} == 0 ]]
        then
          printLogMessage ${LM_INFO} "Refreshing Aptitude cache"
    L_CACHE_MSG=`aptProjectController.sh -c cache -p ${L_PROJECT_NAME} 2>&1`
          RET=$?

          if (( ${RET} == 0 ))
    then
      printLogMessage ${LM_INFO} "Cache successfully refreshed"
      # If all ok, remove any .err
      rm -f ${L_CACHE_ERR}
    else
      L_ERROR_MSG="ERROR: Failed to refresh cache:"$'\n'"${L_CACHE_MSG}"
      # Create an .err so parallel refreshes know the cache refresh failed
      touch ${L_CACHE_ERR}
    fi

    rm -f "${L_LOCKFILE}"

  else
    printLogMessage ${LM_INFO} "${L_LOCKFILE} exists"
    printLogMessage ${LM_INFO} "Aptitude cache refreshed by parallel process. Waiting to finish"
    printLogMessage ${LM_INFO} "If this process is still waiting after 10 minutes it will time out"
    counter=0

    while [[ ${LOCK_FILE_EXISTS} != 0  && ${counter} -lt 600 ]]
    do
        if [[ ! -e ${L_LOCKFILE} ]]
        then
          LOCK_FILE_EXISTS=0
          printLogMessage ${LM_INFO} "${L_LOCKFILE} Released"

          if [[ -e ${L_CACHE_ERR} ]]
          then
                # Something was wrong with the previous cache refresh, re-run
                printLogMessage ${LM_INFO} "Parallel instance of Aptitude cache refresh failed. Rerun the refresh"
                refreshAptitudeCache
          fi
        fi
      sleep 1
      counter=$(( $counter + 1 ))
    done
      if [[ ${counter} == 600 ]]
      then
        printLogMessage ${LM_INFO} "${L_LOCKFILE} still exists after 10 minutes, refresh timed out"
        exit 1
      fi
  fi
}
#################################
executeBatchStep()
#################################
{
  printLogMessage ${LM_INFO} "Start"

  java -Dlog4JLogFile=${L_PATH_TO_LOG_FILE} -server -cp ${BATCH_SCRIPTS}/batch.jar uk.co.microgen.batch.control.task.StartTask ${APT_HOST} ${APT_BUS_PORT} ${APT_EXECUTION_FOLDER} ${APT_UTILS} ${L_PROJECT_NAME} ${L_MICROFLOW_NAME} ${L_SESSION_ID} ${L_USE_CASE_ID} ${L_UC4_RUN_ID:-0} ${L_MAINTAIN_DATA_ID:-TEST} ${L_MESSAGE_TEXT:-Start}
  RET=$?

  if (( ${RET} != 0 && ${RET} != 9 ))
  then
     while IFS= read -r errm || [[ -n $errm ]];
        do
                   printLogMessage ${LM_ERROR} "$errm"
      done < ${L_PATH_TO_LOG_FILE}
  fi

}
#################################
#Main
#################################
{
  ##################################
  # Load the parameters            #
  ##################################
        loadArgs "$@"

  ##################################
  # Validate the parameters        #
  ##################################
  if (( $RET == 0 ))
  then
    validateParameters
  fi

  ##################################
  # Set-up the Environment         #
  ##################################
  if (( $RET == 0 ))
  then
    setupEnvironment
  fi

  ##################################
  # Refresh the cache              #
  ##################################
  if (( $RET == 0 ))
  then
    refreshAptitudeCache
  fi

  ##################################
  # Execute the Batch Step         #
  ##################################
  if (( $RET == 0 ))
  then
    executeBatchStep
  fi

  ##################################
  # Print completion message       #
  ##################################
  printCompletionMessage
}
