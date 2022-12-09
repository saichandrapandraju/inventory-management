import pandas
from datetime import date, timedelta
sdate=date(2021, 5, 1)
edate=date(2021, 6 , 1)
date_range=pandas.date_range(sdate,edate-timedelta(days=1),freq='d')

# print(date_range)
date_range1 = [str(d.date()) for d in date_range]

result=[]
print(len(date_range1))
to_insert= "insert into sale(id,sale_date) values("

# for i,j in zip(date_range1,range(1,311)):
#     t1=");"
#     temp=f'{to_insert}{j},\'{i}\');'
#     result.append(temp)

l1=list(range(1,32))
l2=list(range(32,63))
l3=list(range(63,94))
l4=list(range(94,125))
l5=list(range(125,156))
l6=list(range(156,187))
l7=list(range(187,218))
l8=list(range(218,249))
l9=list(range(249,280))
l10=list(range(280,311))

total_list=[]
total_list.append(l1)
total_list.append(l2)
total_list.append(l3)
total_list.append(l4)
total_list.append(l5)
total_list.append(l6)
total_list.append(l7)
total_list.append(l8)
total_list.append(l9)
total_list.append(l10)

# v=[]

# for i in total_list:
#     for j in i:
#         v.append(j)

# a=f'v:{len(v)}'
# print(a)

# for l in total_list:
#     for i,j in zip(date_range1,l):
#             t1=");"
#             temp=f'{to_insert}{j},\'{i}\');'
#             result.append(temp)
# print(len(result))
# for i in result:
#     print(i)


import random

fin_string="insert  into product_sale(sale_id,product_id,quantity) values ("; # 1,101,10);"
# res=[]
# for i in range(1,32):
#     temp=i+random.randint(0,10)
#     print(fin_string +str(i)+",101,"+str(temp)+");" )
r2=[]
# for l in total_list:
#     for i,j in zip(range(1,11),l):
#             temp=random.randint(0,50)
#             str=f'{fin_string}1,{i},{temp}");"' 
#             r2.append(str)


for i in l10:
    temp=random.randint(1,20)

    str=f'{fin_string}{i},10,{temp});'
    r2.append(str)

for i in r2:
    print(i)
