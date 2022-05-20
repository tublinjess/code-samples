#! /usr/bin/env python3
import sys
import logging
import xlrd
import csv
import pymysql

db_username = ""
db_password = ""
dbname = ''
filename = 'error queries.sql'


try:
    conn = pymysql.connect("", user=db_username, passwd=db_password, db=dbname, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()
cur = conn.cursor()

#read in queries
fd = open(filename, 'r')
sqlFile = fd.read()
fd.close()

sqlCommands = sqlFile.split(';')

#run queries 1 by 1
for i in sqlCommands:
    print(i)
    cur.execute(i)
    output = cur.fetchall()
    print(output)



