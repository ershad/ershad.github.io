---
layout: single
type: post
title: How to terminate EC2 instance by IP from terminal
published: true
comments: true
status: publish
author: ershad
---
Here's an easy command line shortcut to terminate an [AWS EC2](https://aws.amazon.com/ec2/) instance if you know the private IP address but not the instance ID.

{% highlight bash %}
# Function to terminate EC2 instance by IP
function terminate_instance(){
  instance_id=$(aws ec2 describe-instances --filter Name=private-ip-address,Values=$1 --query "Reservations[].Instances[].[InstanceId]" --output text)
  aws ec2 terminate-instances --instance-ids $instance_id
}

# Usage
# $ terminate_instance <private IP address>

# Example
# $ terminate_instance 10.0.32.64
{% endhighlight %}

This shortcut often saves me a visit to the EC2 Dashboard 😄
