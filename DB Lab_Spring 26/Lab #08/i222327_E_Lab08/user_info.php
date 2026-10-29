<!DOCTYPE html>
<html>
<head>
    <title>User Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .main-box {
            width: 650px;
            margin: 40px auto;
            background-color: white;
            border: 1px solid #999;
            padding: 0;
        }

        .top-heading {
            background-color: #cfe8f5;
            padding: 12px 15px;
            font-size: 22px;
            font-weight: bold;
            border-bottom: 1px solid #999;
        }

        .content {
            padding: 15px;
        }

        .welcome {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .section-title {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 18px;
        }

        table {
            width: 100%;
        }

        td {
            padding: 8px;
            vertical-align: middle;
        }

        .label {
            width: 120px;
            font-weight: bold;
        }

        input[type="text"], select {
            width: 220px;
            padding: 6px;
            border: 1px solid #888;
        }

        .submit-btn {
            background-color: #4da6ff;
            color: white;
            border: none;
            padding: 8px 18px;
            cursor: pointer;
            border-radius: 3px;
            font-size: 14px;
        }

        .submit-btn:hover {
            background-color: #2d89ef;
        }

        .result-box {
            margin-top: 20px;
            padding: 12px;
            background-color: #e9fbe9;
            border: 1px solid #7fbf7f;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }
    </style>

    <script>
        function validateForm() {
            var name = document.forms["userForm"]["name"].value;
            var genderMale = document.getElementById("male").checked;
            var genderFemale = document.getElementById("female").checked;

            if (name.trim() == "") {
                alert("Please enter your name");
                return false;
            }

            if (!genderMale && !genderFemale) {
                alert("Please select your gender");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>

<div class="main-box">
    <div class="top-heading">User Information</div>

    <div class="content">
        <div class="welcome">Hello visitor!!</div>

        <form name="userForm" method="POST" action="" onsubmit="return validateForm()">
            <div class="section-title">Please provide us the requested information</div>

            <table>
                <tr>
                    <td class="label">Name:</td>
                    <td><input type="text" name="name"></td>
                </tr>

                <tr>
                    <td class="label">Gender:</td>
                    <td>
                        <input type="radio" name="gender" value="Male" id="male"> Male
                        <input type="radio" name="gender" value="Female" id="female"> Female
                    </td>
                </tr>

                <tr>
                    <td class="label">Education:</td>
                    <td>
                        <select name="education">
                            <option value="Masters">Masters</option>
                            <option value="Bachelors">Bachelors</option>
                            <option value="Intermediate">Intermediate</option>
                            <option value="Matric">Matric</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td><input type="submit" value="Submit" class="submit-btn"></td>
                </tr>
            </table>
        </form>

        <?php
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $name = $_POST["name"];
            $gender = $_POST["gender"];
            $education = $_POST["education"];

            echo "<div class='result-box'>";
            echo "<h3>Submitted Information</h3>";
            echo "<strong>Name:</strong> " . $name . "<br>";
            echo "<strong>Gender:</strong> " . $gender . "<br>";
            echo "<strong>Education:</strong> " . $education . "<br>";
            echo "</div>";
        }
        ?>
    </div>
</div>

</body>
</html>
