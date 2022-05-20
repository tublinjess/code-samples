 #! /usr/bin/env python3
import sys
import logging
import xlrd
import csv
import pymysql

db_username = ""
db_password = ""
dbname = ''


try:
    conn = pymysql.connect("", user=db_username, passwd=db_password, db=dbname, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()
cur = conn.cursor()



#split all entries in county list with commas
counties = "Broward, Palm Beach, Miami-Dade, Alachua, Baker, Bradford, Brevard, Charlotte, Citrus, Clay, Collier, Columbia, DeSoto, Dixie, Duval, Flagler, Gilchrist, Glades, Hardee, Hendry, Hernando, Highlands, Hillsborough, Indian River, Lake, Lee, Levy, Manatee, Marion, Martin, Monroe, Nassau, Okeechobee, Orange, Osceola, Pasco, Pinellas, Polk, Putnam, Sarasota, Seminole, St. Johns, St. Lucie, Sumter, Union, Volusia"

#leave interior of split function if deliminated by whitespace
#otherwise, use ","
counties = counties.split(",") 


#put state code here, look it up in SQL beforehand
stateCode = 12 # Florida

#get all counties from SQL
countyQuery = "SELECT * FROM FIPS_Data WHERE Summary_Level = 50"

cur.execute(countyQuery)
myList = cur.fetchall()

mySum = 0

for i in counties:
    for j in myList:
        
        #check state FIPS code and then county
        #strip County, Parish, and Borough leaving only county name
        #2 of the 3 should be redundant, most states use County, but Louisiana uses Parish and Alaska uses borough
        #Virginia has independent cities
        #DO VIRGINIA COUNTIES BY HAND UNTIL FURTHER NOTICE
        if j[2] == stateCode and j[7].replace("County", "").replace("Parish", "").replace("Borough", "").replace("city","").strip() == i.strip():
            mySum += 1
            print(j[3])

print(mySum)

cur.close()




