---
layout: single
type: post
title: How to terminate EC2 instance by IP from terminal
published: false
comments: true
status: publish
description: This post demonstrates an way to terminate EC2 instances by IP from terminal
author: ershad
---
Here's a shortcut to terminate an [AWS EC2](https://aws.amazon.com/ec2/) instance by IP from terminal. It's handy when you have the IP, but not the instance_id.

{% highlight bash %}
# Function to terminate EC2 instance by IP
function terminate_instance(){
  instance_id=$(aws ec2 describe-instances --filter Name=private-ip-address,Values=$1 --query "Reservations[].Instances[].[InstanceId]" --output text)
  aws ec2 terminate-instances --instance-ids $instance_id
}

# Usage
terminate_instance 10.0.32.64
{% endhighlight %}
