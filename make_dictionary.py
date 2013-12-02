
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


def article_wordlist(article):
    toReturn = []
    for word in re.findall(r"[\w']+", article.BODY) + re.findall(r"[\w']+", article.TITLE):
        word = filter(lambda x: x in string.printable, word)
        word = word.lower()
        if wordnet.synsets(word):
            toReturn.append(word)
    return toReturn

# Make dictionary from articles
def make_dictionary(articles):
    wordlist = set()
    for article in articles:
        if article != None:
            wordlist = wordlist.union(set(article_wordlist(article)))
            wordlist.add(article.TICKER.lower())
    sorted_list = sorted(wordlist, key=lambda item: (float('inf'), item)) # sort a set
    sorted_list = sorted_list[sorted_list.index("a"):]
    return sorted_list

# Construct a dictionary based on all files in a certain directory.
import os
import glob
import string
import re
from nltk.corpus import wordnet
import sys

DIR = "data_11302013/"
articles = []
TITLE_ONLY = False

if __name__ == "__main__":
    args = sys.argv[1:]
    if len(args) > 0 and args[0] == 'title_only':
        print "TITLE ONLY"
        TITLE_ONLY = True

# Make article objects from files
for root, dirs, files in os.walk(DIR):
    for file_name in files:
        articles.append(read_from_file(os.path.join(root, file_name)))
print "... constructed article objects. Number of articles: " + str(len(articles))

# If ONLY want title: remove BODY. 
if TITLE_ONLY:
    for article in articles:
        if article != None:
            article.BODY = "";

# Make dictionary from Artcles.
dictionary = make_dictionary(articles)
print "... finished generating dictionary. Length of dictionary: " + str(len(dictionary))

# Should probably write dicationry to file.
if TITLE_ONLY:
    outfile = open(DIR + "dictionary_title_only.mat", 'w+')
else:
    outfile = open(DIR + "dictionary.mat", 'w+')

for i in range(len(dictionary)):
    outfile.write(str(i+1) + '\t' + str(dictionary[i]) + '\n')
outfile.close()
print "... write dictionary to file at: " + str(outfile.name)

#Filter dictionary
articles = filter(lambda x: x != None, articles)

# Write each article into file. 
if TITLE_ONLY:
    outfile = open(DIR + "news_title_only.mat", 'w+')
else:
    outfile = open(DIR + "news.mat", 'w+')

for article in articles:
    wordlist = article_wordlist(article)
    vector = [0] * len(dictionary)
    i = dictionary.index(article.TICKER.lower())
    vector[i] += 1
    for word in wordlist:
        if word in dictionary:
            i = dictionary.index(word)
            vector[i] += 1

    vector_str = str(vector)[1:-1]
    outfile.write(vector_str + "\n")
outfile.close()
print "... wrote to " + str(outfile.name)




