'''
Created on Apr 4, 2014

Written for Python 2.x.

This file will take a tab-separated CSV of genetic data and concatenate
the columns of a matching VCF file of the same genetic data.

@author: Ross Eldridge
'''

import sys
import copy
from time import clock

# Reads in an already created tab-separated CSV file to add VCF column data to it
def readXLSCSV(filename):
    with open(filename,'r') as f:
        lines = f.readlines()
        for k in lines:
            lines[lines.index(k)] = k.translate(None,'"')
    return lines

# Reads in data in the VCF format
def readVCF(filename):
    with open(filename,'r') as f:
        lines = f.readlines()
        lines_iter = copy.deepcopy(lines)
        # Remove comment (#) lines
        for k in lines_iter:
            if k[0] == '#' and k[1] == '#':
                lines.remove(k)
    return lines

def concatVCF(file1,file2):
    print "Filenames:",file1,"\t",file2
    print "Reading VCF ... ",
    vcf = readVCF(file1)
    print "done.\nReading XLS ... ",
    xls = readXLSCSV(file2)
    print "done."
    mm = 0
    output = xls[0].rstrip('\n')+'\t'+vcf[0]
    print "Concatenation Progress [",
    for i in range(1,len(vcf)-1):
        # Split lines by tab
        vcft = vcf[i].split('\t')
        xlst = xls[i].split('\t')
        # Case: Insertion
        if xlst[4] == '-':
            d = len(vcft[3].split(',')[0])-1
        # Case: Deletion
        elif xlst[5] == '-':
            d = len(vcft[4].split(',')[0])
        # Case: SNV
        else:
            d = 0
        # Mismatch conditional statement based on reported "start" location
        if int(vcft[1]) + d != int(xlst[2]):
            print vcft[1]+"   "+xlst[2]+"   "+str(d)
            mm += 1
        else:
            # Console progress bar
            if i / (len(vcf)/10) != (i-1) / (len(vcf)/10):
                print ".",
            # Concatenation of tab-separated columns
            output += xls[i].rstrip('\n')+'\t'+vcf[i]
    print "]\nMismatches:",mm
    # Save combined file as CSV
    outfile = "XLS-VCF-"+str(xlst[0])+".csv"
    with open(outfile,'w') as o:
        o.write(output)
    if mm == 0:
        return 1
    return 0

def main(argv):
    clock()
    l = len(argv)/2
    scount = 0
    # Process multiple files in pairs
    for i in range(l):
        scount += concatVCF(argv[i*2],argv[i*2+1])
    print "File-pairs successfully concatenated:",str(scount)+"/"+str(l)
    end_scr = clock()
    print "Script completed in",end_scr,"seconds.\n"

if __name__ == '__main__':
    main(sys.argv[1:])