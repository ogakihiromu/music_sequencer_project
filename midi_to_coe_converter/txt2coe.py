# -*- coding: utf-8 -*-

import os
import sys

# *** COMMAND FORMAT ***
# 31-16  15-12   11-0
# Param  Command  0
#
# Command 0: Jump Param=address
#
# *** NOTE FORMAT ***
# 31-24  23-20  19-16  15-12  11-0
#   0     Note  Octave Volume Length

output ='''
; Sample Initialization file for a 512x32bit RAM

memory_initialization_radix = 16 ;
memory_initialization_vector =
'''
RAM_MAX = 512
#RAM_MAX = 512 #for BASYS2
#RAM_MAX = 2048 #for Atlys
COMMENT = ";"

C	=	0 	# C
Db	=	1 	# C# is Db
D	=	2 	# D
Eb	=	3 	# D# is Eb
E	=	4 	# E
F	=	5 	# F
Gb	=	6 	# F# is Gb
G	=	7 	# G
Ab	=	8 	# G# is Ab
A	=	9 	# A
Bb	=	0xA # A# is Bb
B	=	0xB # B

# 	return rst_hex
def convert2music_code(note, octave, vol, length):
	# return "00%(note)X%(oct)s%(vol)X%(length)03X"%{"note": note, "oct": octave, "vol": int(vol), "length": int(length)}
	return "%(a)05X"%{"a": ((int (vol) & 0xF)) | ((((int (length)) // 12) & 0xFF) << 4) | ((((int(octave)) + 1) & 0xF) << 12) | ((note & 0xF) << 16)} 
def main():
	argvs = sys.argv
	argc = len(argvs)

	if argc < 2:
		print ("specify input files")
		quit()

	filename = os.path.basename(argvs[1]).split(".")
	fi = open(argvs[1],"r")
	fo = open("%s.coe"%filename[0],"w")

	fo.write(output)
	code_list = []
	line_num = 0
	for line in fi:
		print (line_num)
		line_num = line_num + 1
		# for comment
		if line[0] == COMMENT:
			continue
		if line == "\n":
			continue
		elem = line.rstrip().split(" ")

		# elem[2] == 0 : command mode
		# elem    [0]      [1]    [2]
		#     Parameter  Command   0
		# elem[2] != 0 : read note
		code = None
		if elem[0] == "CMD":
			mode = None
			(cmd, mode, param) = line.split(" ")
			dummy = 0
			code = "%04X%X%03X"%(int(param),int(mode),int(dummy))

		else:
			note = None
			(note_, vol, length) = line.split(" ")

			if len(list(note_)) == 2:
				(note, octave) = list(note_)
			elif len(list(note_)) == 1:
				note = "R"
				octave = ""
			elif len(list(note_)) == 3:
				note = note_[0]+note_[1]
				octave = note_[2]

			if note == "C":
				note = 0
				code = convert2music_code(note,octave,vol,length)
			elif note == "Db" or note == "C#":
				note = 1
				code = convert2music_code(note,octave,vol,length)
			elif note == "D":
				note = 2
				code = convert2music_code(note,octave,vol,length)
			elif note == "Eb" or note == "D#":
				note = 3
				code = convert2music_code(note,octave,vol,length)
			elif note == "E":
				note = 4
				code = convert2music_code(note,octave,vol,length)
			elif note == "F":
				note = 5
				code = convert2music_code(note,octave,vol,length)
			elif note == "Gb" or note == "F#":
				note = 6
				code = convert2music_code(note,octave,vol,length)
			elif note == "G":
				note = 7
				code = convert2music_code(note,octave,vol,length)
			elif note == "Ab" or note == "G#":
				note = 8
				code = convert2music_code(note,octave,vol,length)
			elif note == "A":
				note = 9
				code = convert2music_code(note,octave,vol,length)
			elif note == "Bb" or note == "A#":
				note = 0xA
				code = convert2music_code(note,octave,vol,length)
			elif note == "B":
				note = 0xB
				code = convert2music_code(note,octave,vol,length)
			elif note == "R":
				code = convert2music_code(0,0,"0",length)

		code_list.append(code)


	for x in range(0,RAM_MAX):
		if len(code_list) > x:
			fo.write(str(code_list[x]))
		else:
			fo.write("00000000")

		if x < RAM_MAX-1:
			fo.write(",")
		else:
			fo.write(";")

		if (x+1)%8 == 0 and x != 0:
			fo.write("\n")

if __name__ == '__main__':
	main()
