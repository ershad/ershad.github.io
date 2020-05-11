---
layout: single
type: post
title: How to configure a simple internet status widget in macOS Menu Bar
published: true
comments: true
status: publish
author: ershad
---
Sometimes during online calls, when we cannot hear the other person speaking, we would be wondering if it's an issue with our internet or theirs.

If it's an issue with our internet, we could try switching to a different network and resume the call. Just that we have to know it at the earliest so that we don't have to keep the other person waiting.

I had some internet connectivity issues a few months back and faced this problem. Each time when I couldn't hear the other person speaking I wondered if it was an issue with my internet. During those times I used `ping` command or refreshed pages in the browser to check the status of my connection. I wanted to automate this check and put together a solution using [BitBar](https://getbitbar.com).

BitBar is an opensource macOS utility to put the output of any executable script in the Mac menu bar. I wrote a small script to periodically check the internet connection and show an emoji (or latency) when the connection isn't stable. Here are the steps to configure it.

**Step 1:** Download, install and run [BitBar](https://getbitbar.com).

**Step 2:** Open its plugin folder.

![BitBar plugin directory](/assets/images/bitbar_plugin_dir.png){: .project-image}

**Step 3:** Copy this script with file name `check_internet.5s.sh` to the plugin folder.


{% highlight bash %}
#!/bin/bash
LATENCY_THRESHOLD=30
latency=$(ping -c1 8.8.8.8 -t 2 | \
    perl -n -e'/time=(\d+)/ && print $1')

if [[ ! -z "$latency" ]]; then
  if [ "$latency" -gt $LATENCY_THRESHOLD ]; then
    echo "✔︎ $latency"
  else
    echo "✔︎"
  fi
else
  echo "❎"
fi
{% endhighlight %}

**Step 4:** Make the script executable. Run the following command in terminal after replacing `<path to>` with the path of plugin folder.

{% highlight bash %}
chmod +x <path to>/check_internet.5s.sh
{% endhighlight %}

**Step 5:** Click `Refresh all`

![BitBar Refresh all](/assets/images/bitbar_refresh_all.png){: .project-image}

You are all set! BitBar now checks your internet every 5 seconds and it would show "❎" emoji in the menu bar when your internet isn't working.


![BitBar not connected](/assets/images/bitbar_not_connected.png){: .project-image}

When you have a stable internet, it shows a "✔︎".

![BitBar connected](/assets/images/bitbar_connected.png){: .project-image}

It would also show you the latency if it's above 30ms. This information would be useful when you have the internet but the connection isn't stable.


![BitBar not connected](/assets/images/bitbar_high_latency.png){: .project-image}

I hope it helped. Thanks for reading. Stay Safe.
