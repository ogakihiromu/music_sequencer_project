import pretty_midi
import re
import sys
import os

DEBUG = False
COMMENT = ";"

def main():

	argvs = sys.argv
	argc = len(argvs)

	if argc < 2:
		print("specify input files")
		quit()

	filename = os.path.basename(argvs[1]).split(".")
	if os.path.isdir("%s"%(filename[0])) == False:
		os.makedirs("%s"%(filename[0]))
	filepath = "%s/"%filename[0]

	midi_data = pretty_midi.PrettyMIDI(argvs[1])
	track_number = 0
	for instrument in midi_data.instruments:
		prev_end = 0
		total_length = 0

		if len(instrument.notes) == 0:
			continue

		fo = open(filepath+"%d_"%track_number
			+pretty_midi.constants.INSTRUMENT_MAP[instrument.program]+".txt","w")

		fo.write(COMMENT+pretty_midi.constants.INSTRUMENT_MAP[instrument.program]+"\n")
		for note in instrument.notes:
			start = midi_data.time_to_tick(note.start)
			end = midi_data.time_to_tick(note.end)
			length = end - start
			pitch = note.pitch
			velocity = note.velocity // 8
			octave = int(pitch / 12 - 2)
			note_num = pitch %  12


			if note_num == 0:
				note_code = "C"
			elif note_num == 1:
				note_code = "Db"
			elif note_num == 2:
				note_code = "D"
			elif note_num == 3:
				note_code = "Eb"
			elif note_num == 4:
				note_code = "E"
			elif note_num == 5:
				note_code = "F"
			elif note_num == 6:
				note_code = "Gb"
			elif note_num == 7:
				note_code = "G"
			elif note_num == 8:
				note_code = "Ab"
			elif note_num == 9:
				note_code = "A"
			elif note_num == 10:
				note_code = "Bb"
			elif note_num == 11:
				note_code = "B"

			if DEBUG == True:
				fo.write("%s%s %s %s %s\n"%(COMMENT,str(note_code)+str(octave) , start, end, length))

			if prev_end > start:
				continue
				# print str(note_code)+str(octave) , start, end, length

			rest_length = start - prev_end

			# if rest_length > 0:
			# 	while rest_length > 4000:
			# 		fo.write("R 0 %s\n"%4000)
			# 		rest_length -= 4000
			# 		total_length += 4000
			# 	fo.write("R 0 %s\n"%rest_length)
			# 	total_length += rest_length
			if rest_length > 0:
				while rest_length > 255:
					fo.write("R 0 %s\n"%255)
					rest_length -= 255
					total_length += 255
				fo.write("R 0 %s\n"%rest_length)
				total_length += rest_length

			fo.write("%s %s %s\n"%(str(note_code)+str(octave), int(velocity) ,length))
			prev_end = end

			total_length += length
		fo.write("CMD 0 0\n")
		fo.write("%sTotal length %s\n\n"%(COMMENT,total_length))
		track_number += 1

if __name__ == '__main__':
	main()
