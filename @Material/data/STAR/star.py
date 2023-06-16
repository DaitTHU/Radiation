from selenium import webdriver
from selenium.webdriver.support.select import Select
from os.path import exists, getsize

PARTICLE = ('e', 'p', 'a')
FILE_SIZE = (5000, 10000, 8000)
BEGIN_LINE = (3, 4, 4)

driver = webdriver.Chrome()
for particle, file_size, begin_line in zip(PARTICLE, FILE_SIZE, BEGIN_LINE):
    url = 'https://physics.nist.gov/PhysRefData/Star/Text/' + particle.upper() + 'STAR-t.html'
    driver.get(url)
    select_bar = Select(driver.find_element('name', 'matno'))
    for i in range(len(select_bar.options)):
        path = particle + 'star_data/' + str(i + 1) + '.txt'
        if path == 'pstar_data/9.txt':
            continue
        while not exists(path) or getsize(path) < file_size:
            select_bar.select_by_index(i)
            driver.find_element('xpath', '//input[@value="Submit"]').click()
            with open(path, 'w+', encoding='utf-8') as f:
                y = driver.page_source.split('<br> <br>')
                f.write('\n'.join(_.replace('<br>', '\n') for _ in y[begin_line:]))
            driver.get(url)
            select_bar = Select(driver.find_element('name', 'matno'))



