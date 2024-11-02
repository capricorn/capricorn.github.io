import sys

from bs4 import BeautifulSoup

def insert_analytics():
    ''' Insert the google analytics script directly after <head> '''
    with open('../templates/google_analytics.html', 'r') as f:
        google_script = BeautifulSoup(f.read(), 'html.parser')
    
    html = '\n'.join(sys.stdin.readlines())
    index = BeautifulSoup(html, 'html.parser')
    index.html.insert(2, google_script)

    return index

if __name__ == '__main__':
    print(insert_analytics())