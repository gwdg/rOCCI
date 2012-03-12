#!/usr/bin/env python

# Deploy, start, stop, restart, refresh and delete ec2 compute instances.
#
# The location of the last deployed compute instance is saved and is available
# for future invocation. This way you can do:
#       ./occiec2client.py compute deploy
#       ./occiec2client.py compute delete
# without passing the location of the created instance every time.
#
# Author: Max Guenther
#

# for parsing args
import argparse

# for http methods
from tornado.httpclient import HTTPClient, HTTPError
import tornado.httpclient

# for path checks...
import os.path
import os

# conf where the last deployed compute instance is written to
_home = home = os.getenv('USERPROFILE') or os.getenv('HOME')
_conf_path = _home + "/.occiec2client.conf"

class HTTPRequest(tornado.httpclient.HTTPRequest):
	""" HTTPRequest with some defaults set. """

	def __init__(self, url, method="GET", headers=dict(), body=""):
		request_timeout = 60.0
		connect_timeout = 60.0
		always_headers = {"User-Agent": "tornado", "Accept": "*/*"}
		headers = dict(headers, **always_headers)
		tornado.httpclient.HTTPRequest.__init__(self, 
		                                        url, 
		                                        method=method,
		                                        headers=headers,
		                                        body=body,
		                                        request_timeout=request_timeout,
		                                        connect_timeout=connect_timeout)

	def create_curl_command(self):
		command = "curl -v -X"
		command += " %s" % self.method
		for name in self.headers:
			if name in ["Accept", "User-Agent", "Expect", "Pragma"]:
				continue
			command += " --header '%s: %s'" % (name, self.headers[name])
		command += " %s" % self.url
		return command

def last_compute_location():
	""" Return the compute location of the last deployed compute instance. """
	if not os.path.exists(_conf_path):
		raise IOError("There is no last created compute location.")
	file = open(_conf_path, "r")
	compute_location = file.read()
	file.close()
	return compute_location

def _write_last_compute_location(location):
	""" Write the compute location of the last deployed compute instance. """
	file = open(_conf_path, "w")
	file.write(location)
	file.close()

def _http_exit(code):
	if code == 200:
		sys.exit(0)
	else:
		sys.exit(1)

def compute_deploy(args):
	""" Deploy a compute instance. """
	resource_template = args.resource_template
	os_template = args.os_template
	uri = args.uri

	# category for launching a compute instance
	com_category = 'compute; scheme="http://schemas.ogf.org/occi/infrastructure#";class="kind";'
	# category for the image template
	com_category += ',%s; scheme="http://mycloud.org/templates/os#";class="mixin";' % os_template
	# category for the instance type / resource template
	com_category += ',%s; scheme="http://mycloud.org/templates/compute#";class="mixin";' % resource_template

	# assign a name
	com_attribute ='occi.core.title="My VM",'

	# location (completes the URI)
	com_location = uri + "/compute/"

	# set the approriate headers
	headers = dict()
	headers["X-OCCI-Attribute"] = com_attribute
	headers["Category"] = com_category

	client = HTTPClient()
	request = HTTPRequest(url=com_location,
	                      method="POST",
	                      headers=headers,
	                      body="")
	                      
	print request.create_curl_command()

	try:
		response = client.fetch(request)
		if response.code == 200:
			_write_last_compute_location(response.body)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)

def compute_refresh(args):
	""" Refresh a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)

	com_action = "refresh"
	com_action_category = 'refresh; scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#";class="action";'
	com_action_attribute = 'method="refresh"'

	headers = dict()
	headers["Category"] = com_action_category
	headers["X-OCCI-Attribute"] = com_action_attribute
	url = "%s?action=%s" % (compute_location, com_action)

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="POST",
	                      headers=headers,
	                      body="")
	                      
	print request.create_curl_command()

	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)

def compute_stop(args):
	""" Stop a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)

	com_action= 'stop'
	com_action_category='stop; scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#";class="action";'
	#com_action_attribute = 'method="stop"'

	headers = dict()
	headers["Category"] = com_action_category
	#headers["X-OCCI-Attribute"] = com_action_attribute
	url = "%s?action=%s" % (compute_location, com_action)

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="POST",
	                      headers=headers,
	                      body="")

	print request.create_curl_command()

	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)

def compute_delete(args):
	""" Delete or terminate a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)

	url = compute_location

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="DELETE",
	                      body=None)

	print request.create_curl_command()
	
	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)

def compute_start(args):
	""" Start a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)

	com_action= 'start'
	com_action_category='start; scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#";class="action";'
	#com_action_attribute = 'method="start"'

	headers = dict()
	headers["Category"] = com_action_category
	#headers["X-OCCI-Attribute"] = com_action_attribute
	url = "%s?action=%s" % (compute_location, com_action)

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="POST",
	                      headers=headers,
	                      body="")

	print request.create_curl_command()

	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)

def compute_restart(args):
	""" Restart a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)

	com_action= 'restart'
	com_action_category='restart; scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#";class="action";'
	#com_action_attribute = 'method="restart"'

	headers = dict()
	headers["Category"] = com_action_category
	#headers["X-OCCI-Attribute"] = com_action_attribute
	url = "%s?action=%s" % (compute_location, com_action)

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="POST",
	                      headers=headers,
	                      body="")

	print request.create_curl_command()

	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)
		
def compute_query(args):
	""" Query a compute instance. """
	# get the compute location.
	compute_location = args.location
	if compute_location == None:
		try:
			compute_location = last_compute_location()
		except IOError as ex:
			print >> sys.stderr, ex.message
			sys.exit(1)


	headers = dict()
	url = compute_location

	client = HTTPClient()
	request = HTTPRequest(url=url,
	                      method="GET",
	                      headers=headers,
	                      body=None)
	                      
	print request.create_curl_command()

	try:
		response = client.fetch(request)
		print response.body
	except HTTPError as ex:
		print >> sys.stderr, ex.message
		_http_exit(ex.code)
    
if __name__ == "__main__":
	import sys

	# create the parser
	parser = argparse.ArgumentParser(prog="occiec2client")
	subparsers = parser.add_subparsers(help="Choose what to create or on what to perform an action.")

	# sub command compute
	parser_compute = subparsers.add_parser("compute", help="Launch, delete, start, stop. etc. Compute instances.")
	subparsers_compute = parser_compute.add_subparsers(help="what to do with compute")
	
	# compute deploy
	deploy_compute = subparsers_compute.add_parser("deploy", help="Create/deploy a compute instance. The location of the created instance will be written to stdout. Note that this will also start the instance.")
	deploy_compute.add_argument("--os-template", default="ami-973b06e3", required=False, help="The EC2 os/image template do use. Default is \"ami-973b06e3\".")
	deploy_compute.add_argument("--resource-template", default="t1.micro", required=False, help="The EC2 resource template/instance type to use.")
	deploy_compute.add_argument("uri", default="http://localhost:3000", nargs="?", help="The URI of the occi server. Default0 is \"http://localhost:3000\".")
	deploy_compute.set_defaults(func=compute_deploy)

	# compute start
	start_compute = subparsers_compute.add_parser("start", help="Start a stopped compute instance.")
	start_location = start_compute.add_argument("location", nargs="?", help="The location of the compute instance to be started. If not specified the location of the compute instance created last is used.")
	start_compute.set_defaults(func=compute_start)

	# compute stop
	stop_compute = subparsers_compute.add_parser("stop", help="Stop a started compute instance.")
	stop_location = stop_compute.add_argument("location", nargs="?", help="The location of the compute instance to be stopped. If not specified the location of the compute instance created last is used.")
	stop_compute.set_defaults(func=compute_stop)

	# compute restart
	restart_compute = subparsers_compute.add_parser("restart", help="Restart a started compute instance.")
	restart_location = restart_compute.add_argument("location", nargs="?", help="The location of the compute instance to be restarted. If not specified the location of the compute instance created last is used.")
	restart_compute.set_defaults(func=compute_restart)

	# compute refresh
	refresh_compute = subparsers_compute.add_parser("refresh", help="Refresh a started compute instance. This prints information about the current state of the instance.")
	refresh_location = refresh_compute.add_argument("location", nargs="?", help="The location of the compute instance to be refreshed. If not specified the location of the compute instance created last is used.")
	refresh_compute.set_defaults(func=compute_refresh)

	# compute delete
	delete_compute = subparsers_compute.add_parser("delete", help="Delete/terminate a compute instance.")
	delete_location = delete_compute.add_argument("location", nargs="?", help="The location of the compute instance to be deleted/terminated. If not specified the location of the compute instance created last is used.")
	delete_compute.set_defaults(func=compute_delete)
	
	# compute query
	query_compute = subparsers_compute.add_parser("query", help="Query a compute instance.")
	query_location = query_compute.add_argument("location", nargs="?", help="The location of the compute instance to be queried. If not specified the location of the compute instance created last is used.")
	query_compute.set_defaults(func=compute_query)
	
	# parse and do!
	args = parser.parse_args()
	args.func(args)
	
	
	
