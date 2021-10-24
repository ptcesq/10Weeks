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

# Plot the results 
labels = ['good', 'spam']

values = [ham_class, spam_class]
fig1, ax1 = plt.subplots()
ax1.pie(values, labels=labels, autopct='%1.1f%%')
plt.show() 




