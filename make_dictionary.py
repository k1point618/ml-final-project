
# Define a class representing an Article
class ArticleFile:

    def __init__(self, ticker, source, url, title, time, body, fileid):
        self.TICKER = ticker
        self.SOURCE = source
        self.URL = url
        self.TITLE = title
        self.TIME = time
        self.BODY = body
        self.id = fileid

    def __str__(self):
        return "FILE_ID" + str(self.id) + "\n" \
            + "TICKER:" + str(self.TICKER) + "\n" \
            + "SOURCE:" + str(self.SOURCE) + "\n" \
            + "URL:" + str(self.URL) + "\n" \
            + "TITLE:" + str(self.TITLE) + "\n" \
            + "TIME:" + str(self.TIME) + "\n" \
            + "BODY:" + str(self.BODY) + "\n";

def read_from_file(filename):
    file = open(filename)
    filename = file.name.split('/')[-1]
    if filename.endswith('.data'):
        filename = filename[:-5]
        fileid = filename.split('_')[1]
        ticker = filename.split('_')[0]

        line_num = 0
        body = ""
        for line in file:
            if line_num == 1:
                source = line.strip()
            elif line_num == 2:
                url = line.strip()
            elif line_num == 3:
                title = line.strip()
            elif line_num == 4:
                time = line.strip()
            elif line_num >= 5:
                body += line.strip()

            line_num += 1

        return ArticleFile(ticker, source, url, title, time, body, fileid)
    pass

# Construct a dictionary based on all files in a certain directory.
import os
import glob
import string
import re

DIR = "data_11262013/"
wordlist = set()
articles = []

# Make article objects from files
for root, dirs, files in os.walk(DIR):
    for file_name in files:
        articles.append(read_from_file(os.path.join(root, file_name)))


# Make dictionary from articles
for article in articles:
    if article != None:
        for word in re.findall(r"[\w']+", article.BODY) + re.findall(r"[\w']+", article.TITLE):
            word = filter(lambda x: x in string.printable, word)
            word = word.lower()
            if word not in wordlist:
                wordlist.add(word)
    
sorted_list = sorted(wordlist, key=lambda item: (float('inf'), item))
sorted_list = sorted_list[sorted_list.index('a'):]
print sorted_list
print len(sorted_list)






