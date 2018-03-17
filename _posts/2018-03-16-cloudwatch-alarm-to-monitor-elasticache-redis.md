---
layout: single
title: CloudWatch alarm to monitor Elasticache Redis
date: 2018-03-16 14:10:29.000000000 +05:30
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Amazon Web Services
- This Week I Learned
tags:
- aws
- CloudWatch
- terraform
- ThisWeekILearned
meta:
  _edit_last: '1'
---
I'm starting a new blog series named [This Week I Learned](http://blog.ershadk.com/categories/#this-week-i-learned/). I will try to blog the new things I learn every week. Hope it would be helpful to someone.

Recently we had an outage in a high-traffic site I was working for. The culprit turned out to be a memory issue with Redis, caused by a short DDoS attack. The memory was fully used and Unicorn/Resque workers weren't able to read or write to the cache. As a result, we had an increased level of 5xx responses and background jobs stopped working. Our error tracker was filled with the following error.


> OOM command not allowed when used memory > 'maxmemory'

We solved the issue by upgrading Elasticache Redis instance. It took around 20 minutes to upgrade from cache.r3.large to cache.r3.xlarge. I was looking for ways to detect this issue before it happens and found a useful correlation between Redis [Eviction](https://en.wikipedia.org/wiki/Cache_replacement_policies) rate and the outage. Redis had started clearing old cache entries a few minutes before the site went down. If we had detected this earlier, we probably would have avoided the outage.

[![eviction]({{ site.baseurl }}/assets/eviction2.jpg)](http://ershadk.com/blog/wp-content/uploads/2018/03/eviction2.jpg)

CloudWatch alarm using the following Terraform configuration would alert us when Redis starts deleting old cache entries to free up memory.

{% highlight python %}
resource "aws_cloudwatch_metric_alarm" "redis_eviction_alarm" {
  alarm_name          = "production-redis-high-eviction-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  period              = "60"
  metric_name         = "Evictions"

  dimensions {
    CacheClusterId = "< Redis CluserId >"
  }

  namespace = "AWS/ElastiCache"
  statistic = "Sum"
  threshold = "0"

  actions_enabled    = "true"
  alarm_actions      = [ <alarm action> ]
  alarm_description  = "Monitors when production redis eviction rate > 0"
  treat_missing_data = "missing"
}
{% endhighlight %}

Alarm action could be an email or Slack notification using AWS [SNS](https://aws.amazon.com/sns/).

Happy Hacking!
