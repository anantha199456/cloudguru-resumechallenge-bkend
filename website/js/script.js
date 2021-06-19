// Some code thanks to @chrisgannon

var select = function(s) {
    return document.querySelector(s);
}

function randomBetween(min, max) {
    var number = Math.floor(Math.random() * (max - min + 1) + min);

    if (number !== 0) {
        return number;
    } else {
        return 0.5;
    }
}

var tl = new TimelineMax();

for (var i = 0; i < 20; i++) {

    var t = TweenMax.to(select('.bubble' + i), randomBetween(1, 1.5), {
        x: randomBetween(12, 15) * (randomBetween(-1, 1)),
        y: randomBetween(12, 15) * (randomBetween(-1, 1)),
        repeat: -1,
        repeatDelay: randomBetween(0.2, 0.5),
        yoyo: true,
        ease: Elastic.easeOut.config(1, 0.5)
    })

    tl.add(t, (i + 1) / 0.6)
}

tl.seek(50);

// api url


// Defining async function
async function updateCounter1() {
    const api_url =
        "https://pzxbb3hte0.execute-api.us-east-1.amazonaws.com/dev/visitor";
    // Storing response
    response = await fetch(api_url, {
        method: 'OPTIONS'
            // headers: headers
    });

    // Storing data in form of JSON
    var data = await response.json();
    alert(data.body);
    //var newD = response.body;
    // var new_res = await response.statusCode;
    // print(data);
    //console.log(data);
    //console.log(newD);
    // if (response) {
    //     hideloader();
    // }
    //show(data);
}

function show(data) {

    // Setting innerHTML as tab variable
    document.getElementById("visitor_count").innerHTML = data;
}

function updateCounter() {
    const api_url =
        "https://pzxbb3hte0.execute-api.us-east-1.amazonaws.com/dev/visitor";
    fetch(api_url, {
            method: 'OPTIONS'
                // headers: headers
        })
        .then(response => {
            if (
                response.ok
            ) {
                return response.json()
            } else {
                throw new Error('something went wrong!');
            }
        })
        .then(
            data => document.getElementById('visitor_count').value = data.statusCode)
        .catch(error => console.error(error))
}