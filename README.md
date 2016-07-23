# swanest

The goals is to realise a little CLI program that would retrieve the daily close prices and the volumes from the Apple stock (http://finance.yahoo.com/q/hp?s=AAPL) between the 1st January 1991 and the 4th of May 2016. Then pushing the code to Github and sending me a link to the repo.

NOTE: Because of the complexity of the code in the above yahoo.com link, the same exercise was done on the Indian edition of yahoo finance at 'https://in.finance.yahoo.com/q/hp?s=AAPL&a=00&b=01&c=1991&d=04&e=4&f=2016&g=d'

Constraints:
- You cannot download the CSV downloadable on Yahoo
- You cannot use a library that would do most of the job for you. I want you to retrieve the HTML source and parse it and then navigate through the pagination of the page I mentioned.
- The program will then output a file (CSV) with the following format:
Date(ISO8601 format), close,volume
Example:
2016-05-04T00:00:00.000Z,94.19,41025500
2016-05-03T00:00:00.000Z,95.18,56831300
- The program needs to take as an argument, the destination of the file.
