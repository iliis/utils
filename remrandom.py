#!/usr/bin/env python

import pexpect
import sys
import signal

if len(sys.argv) != 2:
	sys.exit("usage: "+sys.argv[0]+" foobar.c")

input_file_path = sys.argv[1]

def signal_handler(signal, frame):
	print "canceled by user"
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def check_output(modified_file):
	sdcc = pexpect.spawn("sdcc-sdcc", [modified_file])
	last_line = ""
	try:
		for line in expected:
			last_line = line
			#print "checking line '"+line+"' ...",
			sdcc.expect_exact(line)
			#print "OK"
		sdcc.close()
		return 1
	except:
		print "FAIL on "+last_line
		sdcc.close()
		return 0



expected = ''
with open('expected_output.txt', 'r') as f:
	expected = f.read()
	expected = expected.split('\n')

if not expected:
	sys.exit("ERROR: cannot read exptected_output.txt")

if not check_output(input_file_path):
	sys.exit("ERROR: unmodified file doesn't produce expected output!")

input_file = ''
with open(input_file_path, 'r') as f:
	input_file = f.read()
	input_file = input_file.split('\n')

if not input_file:
	sys.exit("ERROR: input file (" + input_file_path + ") is empty.")

print "file has", len(input_file), "lines"
good_file = list(input_file)

i = 0
while i < len(good_file):
	print "deleting line", i, "of", len(good_file),
	modified_file = list(good_file)
	print "[[["+modified_file[i]+"]]]",
	#del modified_file[i]
	modified_file[i] = "" # just clear line

	with open("tempfile.c", "w") as f:
		f.write("\n".join(modified_file))
	print " ... ",
	if check_output("tempfile.c"):
		print "OK"
		# don't incremet line counter, it already points to a new line
		good_file = modified_file
	else:
		# print "FAIL"
		modified_file = good_file # restore last good configuration
	i=i+1

with open("outputfile.c", "w") as f:
	f.write("\n".join(good_file))
