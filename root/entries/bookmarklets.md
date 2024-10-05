# Bookmarklets

Drag and drop onto the browser's bookmarks bar to install.

- [Hacker News Hide Thread Replies](javascript:document.getElementsByClassName('comment-tree')[0].getElementsByTagName('tbody')[0].replaceChildren( ...Array.from(document.getElementsByClassName('athing comtr')).filter((e) => {return e.getElementsByClassName('ind')[0].getAttribute('indent') == 0})))