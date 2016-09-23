# coding: utf-8
import sys, time
import requests
from bs4 import BeautifulSoup
import re

def fetch_page(url):
    time.sleep(1)
    target_page = requests.get(url)
    if target_page.status_code == 200:
        soup = BeautifulSoup(target_page.text, "lxml")
        return soup
    else:
        return None

if __name__ == "__main__":
    entry_url = "http://www.fashion-press.net/brands/shop/{}"
    pattern = re.compile(r'^(.*)取り扱い店舗')
    for i in range(1, 5000+1):
        soup = fetch_page(entry_url.format(i))
        page_title = soup.title.text
        store_name = pattern.search(page_title).group(1)
        print(store_name)
