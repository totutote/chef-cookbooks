#
# Cookbook Name:: aws-tools
# Attributes:: aws-tools
#

default[:aws_tools][:java_home] = "/usr/lib/jvm/default-java/jre"

default[:aws_tools][:url] = "http://ec2.ap-northeast-1.amazonaws.com"
default[:aws_tools][:resion] = "ap-northeast-1"

default[:aws_tools][:ec2][:dl_uri] = "http://s3.amazonaws.com/ec2-downloads"
default[:aws_tools][:ec2][:dl_file] = "ec2-api-tools.zip"
default[:aws_tools][:ec2][:file_name] = "ec2-api-tools-1.5.2.5"

default[:aws_tools][:sns][:dl_uri] = "http://sns-public-resources.s3.amazonaws.com"
default[:aws_tools][:sns][:dl_file] = "SimpleNotificationServiceCli-2010-03-31.zip"
default[:aws_tools][:sns][:file_name] = "SimpleNotificationServiceCli-1.0.3.0"

default[:aws_tools][:as][:dl_uri] = "http://ec2-downloads.s3.amazonaws.com"
default[:aws_tools][:as][:dl_file] = "AutoScaling-2011-01-01.zip"
default[:aws_tools][:as][:file_name] = "AutoScaling-1.0.49.1"

default[:aws_tools][:mon][:dl_uri] = "http://ec2-downloads.s3.amazonaws.com"
default[:aws_tools][:mon][:dl_file] = "CloudWatch-2010-08-01.zip"
default[:aws_tools][:mon][:file_name] = "CloudWatch-1.0.12.1"

default[:aws_tools][:elasticache][:dl_uri] = "https://s3.amazonaws.com/elasticache-downloads"
default[:aws_tools][:elasticache][:dl_file] = "AmazonElastiCacheCli-2011-07-15-1.5.000.zip"
default[:aws_tools][:elasticache][:file_name] = "AmazonElastiCacheCli-1.5.000"

default[:aws_tools][:elb][:dl_uri] = "http://ec2-downloads.s3.amazonaws.com"
default[:aws_tools][:elb][:dl_file] = "ElasticLoadBalancing.zip"
default[:aws_tools][:elb][:file_name] = "ElasticLoadBalancing-1.0.15.1"

default[:aws_tools][:cfn][:dl_uri] = "https://s3.amazonaws.com/cloudformation-cli"
default[:aws_tools][:cfn][:dl_file] = "AWSCloudFormation-cli.zip"
default[:aws_tools][:cfn][:file_name] = "AWSCloudFormation-1.0.9"

default[:aws_tools][:mon][:check_disk] = "--disk-path=/ --disk-path=/ebs/mysql --disk-path=/ebs/log"
default[:aws_tools][:mon][:check_metrics] = false
