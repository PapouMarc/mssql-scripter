#!/bin/bash
#only for ubuntu

name_log_file=./build_`date +"%Y%m%d"`_`date +"%H%M%S%N"`.log
echo "############## Start Build Package msqsql-scripter "`date +"%Y%m%d"`" "`date +"%H:%M:%S"`" ##############" > ${name_log_file} 2>&1
#clean directory old build
for ndir in ./build ./mssql_scripter.egg-info ./dist ./__pycache__ ./sqtoolsservice; do
    if [ -d ${ndir} ]; then
        rm -Rf ${ndir}
    fi
done

#trap package 4.5.0.15 sqltoolservice release
version_sqltoolservice=https://github.com/microsoft/sqltoolsservice/releases/download/4.5.0.15/
dir_sqltoolservice=(./sqltoolsservice/manylinux1 ./sqltoolsservice/macosx_10_11_intel ./sqltoolsservice/win_amd64 ./sqltoolsservice/win32)
name_sqltoolservice=(Microsoft.SqlTools.ServiceLayer-rhel-x64-net6.0.tar.gz Microsoft.SqlTools.ServiceLayer-osx-x64-net6.0.tar.gz Microsoft.SqlTools.ServiceLayer-win-x64-net6.0.zip Microsoft.SqlTools.ServiceLayer-win-x86-net6.0.zip)
for ndwl in 0 1 2 3;do
    if [ ! -d ${dir_sqltoolservice[${ndwl}]} ]; then
        mkdir -p ${dir_sqltoolservice[${ndwl}]}
    fi
    wget -P ${dir_sqltoolservice[${ndwl}]} ${version_sqltoolservice}${name_sqltoolservice[${ndwl}]} >> ${name_log_file} 2>&1
done

#run build
python3 build.py build manylinux1_x86_64 >> ${name_log_file} 2>&1
echo "############## End Build Package msqsql-scripter "`date +"%Y%m%d"`" "`date +"%H:%M:%S"`" ##############" >> ${name_log_file} 2>&1
