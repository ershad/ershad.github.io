---
layout: single
type: post
title: How to parse JSON in command line using jq
published: true
comments: true
status: publish
author: ershad
---
[jq](https://stedolan.github.io/jq) is an exceptional tool to parse JSON in command line. In this post, we will go through its various options and usages.

### Installation

If you are on Ubuntu or Debian, you can install `jq` using `apt`.

{% highlight bash %}
sudo apt-get install jq
{% endhighlight %}

On macOS, you can install it using Homebrew.

{% highlight bash %}
brew install jq
{% endhighlight %}

### Usage

To demonstrate the the usage of `jq`, we will use the sample JSON data provided by [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com). Its `/users` endpoint lists 10 sample users in the following format.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  },
.....
{% endhighlight %}

💡 `curl -s` runs `curl` in quiet mode, else it shows the request progress meter.
{: .notice--info}

**1.** Extract the name from the first user.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users | \
    jq '.[0] .name'
"Leanne Graham"
{% endhighlight %}

`'.'` refers to the entire JSON object.

`'.[0]'` refers to the first object in the JSON array.

`'.[0] .name'` refers to the `name` attribute in the first object in the JSON array.

We can use `-r` switch in `jq` to remove the quotes from the output.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users | \
    jq -r '.[0] .name'
Leanne Graham
{% endhighlight %}

**2.** Extract the names of all users.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users | \
    jq -r '.[] .name'
Leanne Graham
Ervin Howell
Clementine Bauch
Patricia Lebsack
Chelsey Dietrich
.....
{% endhighlight %}

`'.[]'` refers to all objects in the JSON array.

**3.** Extract selected attributes.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users | \
    jq '.[0] | { name: .name, city: .address.city}'
{
  "name": "Leanne Graham",
  "city": "Gwenborough"
}
{% endhighlight %}

Notice how we extract `city` field using `.address.city` expression. It looks inside `address` object for the `city` attribute of the user.

**4.** Extract selected attributes of all users.

{% highlight bash %}
$ curl -s https://jsonplaceholder.typicode.com/users | \
    jq '[.[] | { name: .name, city: .address.city}]'
[
  {
    "name": "Leanne Graham",
    "city": "Gwenborough"
  },
  {
    "name": "Ervin Howell",
    "city": "Wisokyburgh"
  },
.....
]
{% endhighlight %}

Wrapping the expression inside `[]` encloses the result in an array.
