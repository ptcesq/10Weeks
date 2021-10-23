# Py Script to classify spam and ham 

#Load pandas 
import pandas as pd
import matplotlib.pyplot as plt  

# File local 
fileIn = "/home/ec2-user/projects/10Weeks/week_01_SMS/data/SMS"

# read in the file 
df = pd.read_csv(fileIn,sep='\t',header=(0))
df.columns =['class', 'text']
classes = df['class'].tolist()

ham_class = classes.count('ham') 
spam_class = classes.count('spam') 




