'''
Extract data about your iTunes library from the xml file, and display metrics in graphs
'''

from bs4 import BeautifulSoup
import pandas as pd
import csv

#Read in iTunes library xml file
with open('Point Python to your iTunes library xml file') as f:
    p = f.read()

soup = BeautifulSoup(p)
#Replace soup with the dictionary housing all music tracks
soup = soup.find("key", text="Tracks").find_next("dict")
#print(soup.prettify())

#Calculate the number of songs in the library by counting dict tags - 1 (1 header dict)
numsongs = len(soup.find_all("dict"))

"""
#Find very first dictionary
soup.find("dict")

#List with all children of first dict
print(soup.find("dict").findChildren())
"""

column_labels = ["Track ID", "Size", "Total Time", "Track Number", "Track Count", "Year", "Date Added", "Bit Rate", "Play Count", "Play Date UTC", "Skip Count", "Name", "Artist", "Album Artist", "Album", "Genre"] 

#Create empty data frame with column labels
df = pd.DataFrame()
for label in column_labels:
    df[label] = label

#For each song (dict), loop through the song info and add it do the data frame
for songnum, song in enumerate(soup.find_all("dict")):
    rowid = songnum + 1
    #Create dictionary to hold song data
    d = dict.fromkeys(column_labels)
    #Check each column and if the song contains data for that column, insert the value into the dictionary
    for column in column_labels:
        for songinfo in song.findChildren():
            if songinfo.text == column:
                d.update({songinfo.text: songinfo.findNextSibling().text})
                break
        else:
            pass
            #print("No matches found for column = ", column)
    #Add song data to data frame
    for key in d.keys():
        df.loc[rowid,key] = d[key]

print(df.head(n=15))
    
#Write data frame to csv
df.to_csv("iTunes Library Data.csv", index=False)


        




