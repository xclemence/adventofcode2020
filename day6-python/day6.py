import urllib.request

with open('./data') as file:
    content = file.readlines()

content = [x.strip() for x in content] 

currentGroup=26*[0]
results = []

# Part 1

for line in content:
   if (line == ''):
      results.append(sum(currentGroup))
      currentGroup=26*[0]
   for x in line:
      currentGroup[ord(x) - 97] = 1
   
print(sum(results))

#Part 2

currentGroup=26*[0]
results = []
personNumber = 0

for line in content:
   if (line == ''):
      results.append(len(list(filter(lambda x: x == personNumber, currentGroup))))
      currentGroup=26*[0]
      personNumber = 0
   else:
      for x in line:
         currentGroup[ord(x) - 97] += 1
      personNumber+=1

print(sum(results))
