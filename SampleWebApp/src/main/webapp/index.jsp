<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seyi's Music Lifestyle Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;
            padding: 20px;
        }
        form {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1, p {
            text-align: center;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            width: auto;
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

    <h1>Welcome to Seyi's Music Lifestyle Form</h1>
    <p>Seyifunmi is a Nigerian with a passion for exploring new horizons. He loves to travel, meet new people, and constantly improve himself in every way possible. Seyi has a deep curiosity for life and technology, spending hours working on his computer and learning new skills that help him become a better version of himself every day. He's not just focused on work; Seyi is also a huge fan of music. Whether it’s playing an instrument or listening to his favorite genres, music brings balance and creativity into his life.</p>
    <p>Seyi enjoys discovering new music and staying up-to-date with the latest trends in the music world. Through this form, we want to learn more about your music preferences and how music fits into your own lifestyle. Let’s dive in and explore the world of music together!</p>

    <form action="submitForm.jsp" method="post" enctype="multipart/form-data">
        <!-- Music Genre Selection -->
        <label for="genre">Select your favourite genre of music:</label>
        <select name="genre" id="genre">
            <option value="rock">Rock</option>
            <option value="pop">Pop</option>
            <option value="reggae">Reggae</option>
            <option value="jazz">Jazz</option>
            <option value="afro-beat">Afro Beat</option>
        </select>

        <!-- Music Service Selection -->
        <label for="service">Select your favourite music service:</label>
        <select name="service" id="service">
            <option value="itunes">iTunes</option>
            <option value="spotify">Spotify</option>
            <option value="pandora">Pandora</option>
            <option value="fish-fm">Fish FM</option>
        </select>

        <!-- Device Used for Listening to Music -->
        <label for="device">What device do you listen to music on?</label>
        <input type="text" id="device" name="device" placeholder="e.g., iPod, Smartphone">

        <!-- Instruments Played -->
        <label for="instruments">Select the instruments you're capable of playing:</label>
        <select name="instruments" id="instruments" multiple>
            <option value="guitar">Guitar</option>
            <option value="drum">Drum</option>
            <option value="keyboard">Keyboard</option>
            <option value="shekere">Shekere</option>
            <option value="trumpet">Trumpet</option>
        </select>

        <!-- Song Upload -->
        <label for="song">Upload your song (mp3 format only):</label>
        <input type="file" id="song" name="song" accept=".mp3">

        <!-- Email Subscription -->
        <label for="email">Enter Your Email to subscribe to our weekly newsletter:</label>
        <input type="email" id="email" name="email" placeholder="Your Email">

        <!-- Age Input -->
        <label for="age">Age:</label>
        <input type="number" id="age" name="age" min="10" max="100">

        <!-- Gender Selection -->
        <label>Gender:</label>
        <input type="radio" id="male" name="gender" value="male">
        <label for="male">Male</label>
        <input type="radio" id="female" name="gender" value="female">
        <label for="female">Female</label>
        <input type="radio" id="other" name="gender" value="other">
        <label for="other">Other</label>

        <!-- Bio Data Section -->
        <h2>Bio Data</h2>
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required>

        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required>

        <label for="dob">Date of Birth:</label>
        <input type="
