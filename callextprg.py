
#/usr/bin/python    
		# pipe the output of calendar.prmonth() to a string:
import subprocess
code_str = \ 
		"""
    import calendar
    calendar.prmonth(2012, 11)
    """
    # save the code
filename = "nov2012.py"
fout = open(filename, "w")
fout.write(code_str)
fout.close()
# execute the .py code and pipe the result to a string
test = "python " + filename
process = subprocess.Popen(test, shell=True, stdout=subprocess.PIPE)
# important, wait for external program to finish
process.wait()
print process.returncode # 0 = success, optional check
# read the result to a string
month_str = process.stdout.read()
print month_str


## More in general

    import subprocess
    # put in the corresponding strings for
    # "mycmd" --> external program name
    # "myarg" --> arg for external program
    # several args can be in the list ["mycmd", "myarg1", "myarg2"]
    # might need to change bufsize
    p = subprocess.Popen(["mycmd", "myarg"], bufsize=2048, shell=True,
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, close_fds=True)
    # write a command to the external program
    p.stdin.write("some command string here")
    # allow external program to work
    p.wait()
    # read the result to a string
    result_str = p.stdout.read()



