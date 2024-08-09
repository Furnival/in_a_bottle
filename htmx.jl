

htmx_start = """
<html> 
    <head>
        <title>
            Blue November
        </title>
        <link rel="icon" type="image/x-icon" href="static/favicon.ico">
        <script src="static/htmx.min.js"></script>
        <link rel="stylesheet" href="static/story.css">
    </head>
    <body>
        <div class="center"><img src="http://www.byothermeans.org/images/russian_doll.png" width="450" height="600" alt="russian doll"></div>
            <h2 class="center">blue november</h2>
            <div class="quote" >"Keep thinking. You can hear our brains rattling around inside us, like the littler Russian dolls." -- Matthew Tobin Anderson</div>
            <button class="center" hx-get="/story" hx-swap="outerHTML">Start Story</button>
        </div>
    </body>
</html>
"""

htmx_page1 = """

<div class="center"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/GeorgeSPatton.jpg/440px-GeorgeSPatton.jpg" width="170" height="200" alt="george s. patton"> </div>

"Fuck! -- you think this Artificial Intelligence stuff is magic!" shouts Ruth. <i>'Twist his balls and kick the living shit out of him!'"</i> 

"Calm down Ruth!" I say. 

<i>“Lead me, follow me, or get out of my way!”</i> Ruth shouts. Although quoting Patton, there is no doubt she means it.

How did I get here? 

Let me explain, how our school day started with a [[wargame.| Start wargame]] 

"""