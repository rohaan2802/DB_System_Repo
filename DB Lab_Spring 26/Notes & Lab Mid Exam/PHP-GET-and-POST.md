# PHP: `$_GET` and `$_POST`

Both are superglobal arrays holding form data as key–value pairs, where keys are the `name` attributes of the form fields.

| | `$_GET` | `$_POST` |
|---|---|---|
| How data is sent | Appended to the URL as a query string (`page.php?name=Ali`) | In the body of the HTTP request |
| Visible in URL / history | Yes | No |
| Size limit | Limited by URL length | Much larger |
| Bookmarkable | Yes | No |
| Use for | Searches, filters, links | Logins, passwords, inserting/updating data |

```html
<form action="save.php" method="post">
  <input type="text" name="username">
  <button type="submit">Save</button>
</form>
```
```php
<?php
$conn = mysqli_connect("localhost", "root", "", "labdb");
$name = mysqli_real_escape_string($conn, $_POST['username']);
mysqli_query($conn, "INSERT INTO users (username) VALUES ('$name')");
?>
```
Prepared statements (`mysqli_prepare`) are the safer way to insert user input and prevent SQL injection.
