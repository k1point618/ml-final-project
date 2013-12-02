

def article_wordlist(article):
    toReturn = []
    for word in re.findall(r"[\w']+", article.BODY) + re.findall(r"[\w']+", article.TITLE):
        word = filter(lambda x: x in string.printable, word)
        word = word.lower()
        if wordnet.synsets(word):
            toReturn.append(word)
    return toReturn

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
        self.WORDLIST = article_wordlist(self)

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


# def article_number_list(article):
#     contexts = []
#     values = []
#     body_text = re.findall(r"[\w']+", article.BODY)+ re.findall(r"[\w']+", article.TITLE)
#     for i in range(len(body_text)):
#         word = body_text[i]
#         word = filter(lambda x: x in string.printable, word)
#         if word not in article.WORDLIST and i>0 and i < len(body_text)-1:
#             contexts.append(word[i-1] + " " + word[i+1])


def make_features_vector(article, swn):

    features = []

    # Time of the day in minutes
    time = parser.parse(article.TIME)
    features.append(time.time().hour * 60 + time.time().minute)

    # Day of the week
    features.append(time.weekday())

    # How long the title is in characters
    features.append(len(article.TITLE))

    # How many words in the totle
    features.append(len(article.TITLE.split(' ')))

    # Average length of words in title
    features.append((len(article.TITLE) - features[3] +1)/float(features[3]))

    wordlist = article.WORDLIST
    # Number of words in the body
    features.append(len(wordlist))

    # Number of characters in the body
    features.append(len(article.BODY))

    # Average word length
    features.append(sum([len(s) for s in wordlist])/len(wordlist))

    pos_score = 0
    neg_score = 0
    for word in article.WORDLIST:
        wns = swn.senti_synsets(word)
        pos = [wn.pos_score for wn in wns]
        neg = [wn.neg_score for wn in wns]

        if len(wns) > 0:
            pos_score += sum(pos)/len(pos)
            neg_score += sum(neg)/len(neg)

    features.append(pos_score);
    features.append(neg_score);
    return features


# Construct a dictionary based on all files in a certain directory.
import os
import glob
import string
import re
import sys
from nltk.corpus import wordnet
from dateutil import parser
from dateutil.relativedelta import *
from sentiwordnet import SentiWordNetCorpusReader, SentiSynset

swn_filename = 'SentiWordNet_3.0.0_20100705.txt'
swn = SentiWordNetCorpusReader(swn_filename)

DIR = "data_11302013/"
articles = []

if __name__ == "__main__":
    args = sys.argv[1:]

# Make article objects from files
for root, dirs, files in os.walk(DIR):
    for file_name in files:
        articles.append(read_from_file(os.path.join(root, file_name)))
print "... constructed article objects. Number of articles: " + str(len(articles))


# Collect features and write to file
outfile = open(DIR + "other_features.mat", 'w+')
for article in articles:
    if article != None:
        features = make_features_vector(article, swn)
        feature_str = str(features)[1:-1]
        outfile.write(feature_str + "\n")

outfile.close()
print "... wrote to " + str(outfile.name)




