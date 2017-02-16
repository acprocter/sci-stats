'''Script that opens a Vensim .mdl file and creates a list
containing all variables and their units.  Outputs the list as a CSV file.
Also outputs:  list of unique units as a CSV, and list of variables
and their causes and uses CSVs
Takes a couple min to run'''

# open model file

f = open("LRP v2.50 20160429.mdl", "r") # Enter the mdl filename here

import csv
c = csv.writer(open("variables.csv", "wb"))
u = csv.writer(open("units.csv", "wb"))


text = f.read()

start_of_vars = '{UTF-8}\n' #'\n'
end_of_vars = '*****'  #this marks the end of the variables in the text file
                       # and the beginning of control and graphics settings

text = text[len(start_of_vars):text.find(end_of_vars)] #remove the control and graphics settings

print text

print len(text) #984601   all of the script so far runs quickly.


###### The main split ##############################################

begin = 0
end = text.find('|\n\n') # this marks the end of text for a given variable
length = len(text)
units_index = []
var_index = []

while True:

    phrase = text[begin:end]
    print phrase
    
    # read variable name
    var_name = phrase[0:phrase.find('=')]

    if '(' in var_name: #some tables don't have '='
        var_name = var_name[0:var_name.find('(')]

    if var_name[-1] == ' ': # some variables have an extra space at the end
        var_name = var_name[0:-1]

    if '\n' in var_name: # some variables have '\' followed by tabs at the end
        var_name = var_name[0:-4]

    var_index.append(var_name) ############ Note: this doesn't include Time.  Maybe append at end?
    
    # read units
    var_units = phrase.split('\n\t~\t')[1]
    print var_units, var_name
    if var_units not in units_index:
        units_index.append(var_units) # the first word before =

    c.writerow([var_units,var_name])
    
    #shift the reading frame forward, beyond '|\n\n'
    begin = end+3 
    end = text.find('|\n\n', begin) #find next instance
    
    if begin >= length: # reached the end of the text
        break #3062 variables

# write index of unique units
print units_index
for unit in units_index:
    u.writerow([unit])


# read causes ###########################################################

causes_dict = {}

e = csv.writer(open("causes.csv", "wb"))
begin = 0
end = text.find('|\n\n')
total_vars = len(var_index)
index = 0

var_index.append('Time') # add the variable Time

while True:

    phrase = text[begin:end]
    causes = []
    phrase = phrase[0:phrase.find('~')]     # clip to just the equation
    print phrase

    # Find all the variables in a given phrase
    var_name = var_index[index]
    search_list = sorted(var_index[:], key=len, reverse=True)             #copy the list. could be faster to sort var_index once at beginning?
    search_list.remove(var_name)            # a variable won't be defined in terms of itself
    causes.append(var_name)                 # the first item will be the variable name
    phrase = phrase[:phrase.find(var_name)] + phrase[phrase.find(var_name)+len(var_name):]

    for var in search_list:
        if var in phrase:
            causes.append(var)
            while var in phrase:            # repeat until all duplicates are removed
                phrase = phrase[:phrase.find(var)] + phrase[phrase.find(var)+len(var):] # remove the found var from the phrase
            print phrase

    e.writerow(causes)
    causes_dict[var_name] = causes[1:]

    #shift the reading frame forward, beyond '|\n\n'
    begin = end+3 
    end = text.find('|\n\n', begin)         #find next instance
    index +=1
    
    if begin >= length:                     # reached the end of the text
        break                               #3062 variables
    

# find uses #############################################
'''this makes a dictionary of uses and prints it to CSV'''

f = csv.writer(open("uses.csv", "wb"))

uses_dict = {}

for i in var_index:                 # cycle thru list of variables
    uses = []                       # clear uses
    for j in causes_dict.keys():    # cycle thru keys in causes dictionary
        if i in causes_dict[j]:     # if variable is in the list of causes
            uses.append(j)  #add the key to the list of uses

                            #after cycling through the causes dictionary
    uses_list = [i]+uses
    f.writerow(uses_list)
    uses_dict[i] = uses     #make an entry in the uses dictionary
