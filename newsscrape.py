import requests
from bs4 import BeautifulSoup

def write_to_file(tags, responses):
    for i in range(len(tags)):
        r = responses[i]
        name = tags[i]
        f = open(str(name) + ".html." + str(i+1), 'w+')
        f.write(r.content)

# should return K urls, one for each tik
def make_GF_urls(params):
    urls = []
    ticks = []
    for p in params:
        for start in range(NUM_PAGES):
            urls.append("http://www.google.com/finance/company_news?q=NASDAQ%3A" 
                + str(p) + "&start=" + str(start*NUM_PER_PAGE) + "&num=" 
                + str(NUM_PER_PAGE))
            ticks.append(p)
    return (ticks, urls)


def make_requests(urls):
    return [requests.get(u) for u in urls]


def make_soups(responses):
    return [BeautifulSoup(a.content) for a in responses]


def get_news_urls(ticks, responses):
    soups = make_soups(responses)

    urls = []
    return_ticks = []
    for i in range(len(soups)):
        soup = soups[i]
        tic = ticks[i]
        spans = soup.find_all('span')
        for span in spans:
            # match for <span class=name>
            if 'class' in span.attrs and span.attrs['class'][0] == 'name':
                url = span.contents[1].get('href')
                urls.append(url)
                return_ticks.append(tic)

    return (return_ticks, urls)


def get_sources(news_urls):
    sources = []
    for url in news_urls:
        if url.find("www.reuters.com") >=0 and url.find("http://") != 0:
            sources.append("reuters.dev")
        else:
            real_url = url.split('url=http://')[1]
            source = real_url.split('/')[0]
            sources.append(source)
    return sources


class Article:

    COUNT = 0

    def __init__(self, ticker, source, url, title, time, body):
        self.TICKER = ticker
        self.SOURCE = source
        self.URL = url
        self.TITLE = title
        self.TIME = time
        self.BODY = body
        self.id = Article.COUNT
        Article.COUNT += 1

    def __str__(self):
        return str(self.TICKER) + "\n\n" \
            + str(self.SOURCE) + "\n\n" \
            + str(self.URL) + "\n\n" \
            + str(self.TITLE) + "\n\n" \
            + str(self.TIME) + "\n\n" \
            + str(self.BODY) + "\n\n";

    def write_to_file(self):
        f = open("data/" + str(self.TICKER) + str(Article.COUNT) + ".data", 'w+')
        f.write(str(self))
        f.close()
        print "... wrote " + str(Article.COUNT) + " file to disk"


class Counter:
    NUM_BAD_HTML = 0

def parse_reuters(tick, url):
    if url.find("http:") != 0:
        url = "http:" + url
    
    response = requests.get(url)

    #print ("Parsing Reuters", tick, response)
    
    soup = BeautifulSoup(response.content)

    # Find title
    headers = soup.find_all('h1')
    title = ""
    for h in headers:
        title = h.string.encode('utf-8').strip()
    #print ("title", title)
    
    # match for <div id="sigDevArticleText">
    articleTags = soup.find_all(id="sigDevArticleText")
    if len(articleTags) == 0:
        f = open("data/badHTML" + str(Counter.NUM_BAD_HTML), 'w+')
        f.write(response.content)
        f.close()
        Counter.NUM_BAD_HTML += 1
        return

    articleTag = soup.find_all(id="sigDevArticleText").pop()
    body = articleTag.find_all('p').pop().contents[0].encode('utf-8').strip()
    #print ("text", body)

    spans = articleTag.find_all('span')
    time = ""
    for span in spans:
        if 'class' in span.attrs and span.attrs['class'][0] == 'timestamp':
            time = str(span.contents[0])
    #print ("time", time)

    article = Article(tick, None, url, title, time, body)
    return article


def parse_valuewalk(tick, url):
    # response = requests.get(url)
    # print ("Parsing Valuewalk", tick, response)
    pass    

def parse_seekingalpha(tick, url):
    # response = requests.get(url)
    # print ("Parsing Seekingalpha", tick, response)
    pass

def parse_nextiphone(tick, url):
    # response = requests.get(url)
    # print ("Parsing nextiphonenews", tick, response)
    pass

# Each output article should have the following format:
# TICKER
# Date
# Title
# content
def write_data(tick, source, url):
    article = None

    if source == SOURCES[0]:
        article = parse_reuters(tick, url)
    elif source == SOURCES[1]:
        parse_valuewalk(tick, url)
    elif source == SOURCES[2]:
        parse_seekingalpha(tick, url)
    elif source == SOURCEs[3]:
        parse_nextiphon(tick, url)
    else:
        print "Unfiltered source. Exit. "
        return

    if article != None:
        article.SOURCE = source
        article.write_to_file()


## Start ##
   
COMP_TICKS = ["AAPL", "MSFT", "GOOG", "FB", "YHOO", "ORCL", "IBM", "AMZN", "NOK"]
#COMP_TICKS = ["AAPL"]
#SOURCES = ["www.reuters.com", "www.valuewalk.com", "seekingalpha.com", "www.nextiphonenews.com"]
SOURCES = ["reuters.dev"]
K = len(COMP_TICKS)
NUM_PAGES = 3
NUM_PER_PAGE = 100

# Make urls for Google Finance (GF)
# GF_urls is array of tuples (TICKER, GF_url)
(tic, GF_urls) = make_GF_urls(COMP_TICKS)

GF_responses = make_requests(GF_urls)
#write_to_file(COMP_TICKS, GF_responses)

# Use HTML Parser to get news_urls
# news_urls is an array of tuples (TICKER, url)
(tic, news_urls) = get_news_urls(tic, GF_responses)

# Make sure size of tic is the same as size of urls
assert (len(tic) == len(news_urls))

print "Found total of " + str(len(news_urls)) + " articles"

sources = get_sources(news_urls)

#-----
seen = set()
seen_add = seen.add
uniq =  [ x for x in sources if x not in seen and not seen_add(x)]

ranking = []
for source in uniq:
    ranking.append((sources.count(source), source))
ranking.sort()
ranking.reverse()
print ranking
num_article = sum([a[0] for a in ranking[0:3]])
print num_article
#------

filt_news_urls = []
filt_ticks = []
filt_sources = []
# Filter to limited sources
for i in range(len(news_urls)):
    if sources[i] in SOURCES:
        filt_sources.append(sources[i])
        filt_ticks.append(tic[i])
        filt_news_urls.append(news_urls[i])


#write_to_file(tic, news_responses)

for i in range(len(filt_ticks)):
    write_data(filt_ticks[i], filt_sources[i], filt_news_urls[i])








