# The World Wide Web (WWW)

The Web is a system of linked documents and resources accessed over the Internet using a browser. The **Internet** is the network; the **Web** is one service running on it (others are email and file transfer).

| Component | Role |
|---|---|
| Web page | A document written in HTML, styled with CSS, made interactive with JavaScript |
| Website | A collection of related pages under one domain |
| URL | Address of a resource, e.g. `https://www.example.com/page.html` |
| Hyperlink | Link from one resource to another |
| Web browser | Client that requests and renders pages (Chrome, Firefox, Edge) |
| Web server | Program that stores and serves pages (Apache, Nginx, IIS) |
| HTTP/HTTPS | Protocol for requests and responses; HTTPS adds TLS encryption |
| DNS | Translates domain names into IP addresses |

## What happens when a URL is opened
1. The browser asks DNS for the server's IP address.
2. It sends an HTTP(S) request to the web server.
3. The server returns HTML (static) or runs code such as PHP that queries a database (dynamic) and returns the generated HTML.
4. The browser renders the page and loads images, CSS and scripts.

## Static vs dynamic pages
- **Static:** the same file for every visitor (plain HTML).
- **Dynamic:** generated per request from a database, e.g. the PHP + MySQL pages built in the Spring 2026 labs with XAMPP (Apache + MySQL + PHP).

Invented by Tim Berners-Lee at CERN in 1989.
