attach('constraints_fema.sage')

def shuffle_seq_into_list_of_seqs(x,A):
	Answer=[]
	alen=len(A)
	counter = 0
	for t in A:
		B=shuffle_seq(x,t)		
		Answer = Answer + B
		counter = counter +1
		if (counter%10==0):
			print("Done",counter,"of",alen)
	return Answer

def shuffle_seq_into_list_of_seqs_special(x,A,Special_constraints):
	Answer=[]
	alen=len(A)
	counter = 0
	for t in A:
		B=shuffle_seq(x,t)		
		C = logsatisfies(Special_constraints,B)
		Answer = Answer + C
		counter = counter +1
		if (counter%10==0):
			print("Done",counter,"of",alen)
	return Answer

def shuffle_seq(x,A):
	# returns a list of lists where each list has length |x|+|Array|
	# and each list has x in its original order and the other entries are
	# entries in Array
	# shuffle_prod([3,5],[1,2]) will return
	# ([1,2,3,5],[1,3,2,5],[1,3,5,2],[3,1,2,5],[3,1,5,2],...
	Answer=[]
	Array=copy(A)
	lenx=len(x)
	lenarray=len(list(Array))
	n=len(x)+len(Array)
	for X in Subsets(n,lenx):
		for p in [Array]:
			currentx=0
			currentX=0
			Temp=[]
			for i in [1..n]:
				if i in X:
					Temp.append(x[currentx])
					currentx=currentx+1
				elif i not in X:
					Temp.append(p[currentX])
					currentX = currentX+1
				else:
					print("i,X=",i,X)
					exit(1)
			Answer.append(Temp)
	return Answer

def shuffle_seq_after_m(x,A,m):
	# returns a list of lists where each list has length |x|+|Array|
	# and each list has x in its original order and the other entries are
	# entries in Array after position/index m
	# shuffle_prod([3,5],[1,2]) should return
	# ([1,2,3,5],[1,3,2,5],[1,3,5,2],[3,1,2,5],[3,1,5,2],...
	Answer=[]
	Array=copy(A)
	lenx=len(x)
	lenarray=len(Array)
	n=len(x)+len(Array)
	for X in Subsets(n,lenx):
		if min(X)>m+1:  
			for p in [Array]:
				currentx=0
				currentX=0
				Temp=[]
				for i in [1..n]:
					if i in X:
						Temp.append(x[currentx])
						currentx=currentx+1
					elif i not in X:
						Temp.append(p[currentX])
						currentX = currentX+1
					else:
						print("i,X=",i,X)
						exit(1)
				Answer.append(Temp)
	return Answer

def shuffle_prod(x,A):
	# returns a list of lists where each list has length |x|+|Array|
	# and each list has x in its original order and the other entries are
	# filled with a permutation of entries in Array
	# shuffle_prod([3,5],[1,2]) should return
	# ([1,2,3,5],[1,3,2,5],[1,3,5,2],[3,1,2,5],[3,1,5,2],...
	Answer=[]
	Array=copy(A)
	Array.sort()
	lenx=len(x)
	lenarray=len(Array)
	n=len(x)+len(Array)
	for X in Subsets(n,lenx):
		for p in Permutations(Array):
			currentx=0
			currentX=0
			Temp=[]
			for i in [1..n]:
				if i in X:
					Temp.append(x[currentx])
					currentx=currentx+1
				elif i not in X:
					Temp.append(p[currentX])
					currentX = currentX+1
				else:
					print("i,X=",i,X)
					#print "i,X=",i,X
					exit(1)
			Answer.append(Temp)
	return Answer
		
def my_meld(A,B):		
	# take two listings of traces, and meld them together
	Log = copy(A)
	b=len(B)
	counter=0
	for x in B:
		counter = counter + 1
		if (counter %1000==0):
				print(counter,"/",b)
		if (x not in Log):
			Log.append(x)
	return Log

def simple_d_remove(A):
	if (A==[]):
		return A
	else: 
		Log = []
		Log.append(A[0])
		for i in [0..len(A)-2]:
			if (A[i]!=A[i+1]):
				Log.append(A[i+1])
		return Log

def tidy_traces(Log,min_length,max_length):
	Output=[]
	for i in [min_length..max_length]:
		T=[]
		for x in Log:
			if len(x)==i:
				T.append(x)
		T.sort()
		Output = Output+T
	return Output

def list_perms(m,n): 	
	# make a list of all permuations of length m up to length n
	A=[]
	for i in [m..n]:
		for p in Permutations(i):
			A.append(p)
	return A

def set_of_acts(Constraints):
	# make set of all vertices listed in Constraints
	Vp=[]
	for (a,b,type,Q) in Constraints:
		Vp = Vp+[a,b,Q]
	V=Set(Vp).difference(Set([0]))
	return V

def check_for_init(Constraints):
	Answer = False
	for (a,b,type,Q) in Constraints:
		if (type=='init'):
			Answer=True
	return Answer

def value_of_init(Constraints):
	for (a,b,type,Q) in Constraints:
		if (type=='init'):
			return a

def mymake_element_depends(Cons):
	V = set_of_acts(Cons)
	if (V!=Set([])):
		m=max(V)
	else:
		m=1
	myList=[[]]*(m+1)
	for (a,b,t,Q) in Cons:
		#print myList
		if (t=='succ'):
			myList[a] = myList[a]+[b]
		elif (t=='resp'):
			myList[a] = myList[a]+[b]
		elif (t=='chain_resp'):
			myList[a] = myList[a]+[b]
	return myList

def mylog(Constraints,extra_value):
	V = set_of_acts(Constraints)
	init_in_constraints=check_for_init(Constraints)
	v=V.cardinality()
	print("Set of actions for this constrain set =",V)
	Depend_List = mymake_element_depends(Constraints)
	print("List of actions in constraints=",Depend_List)
	Log=[]
	current_largest_subset_length=0
	subset_index=0
	if init_in_constraints:
		# strip init value out
		init_value = value_of_init(Constraints)
		VV=V.difference(Set([init_value]))
		if check_process([],Constraints):
					Log.append([])
		for S in Subsets(VV):
			print("Length ",len(S),"/",VV.cardinality()," : S={",init_value,"}+",S)
			s=S.cardinality()
			Total_to_check = factorial(s)
			for p in Permutations(list(S)):
				xx=copy(p)
				xxx=[init_value]+list(xx)
				if check_process(xxx,Constraints):
					Log.append(xxx)
	else:
		for S in Subsets(V):
			print("Length ",len(S)," : S=",S)
			s=S.cardinality()
			Total_to_check = factorial(s)
			for p in Permutations(list(S)):
				xx=copy(p)
				if check_process(xx,Constraints):
					Log.append(list(xx))
	print("Leaving mylog with |Log| =",len(Log))
	return Log

def logsatisfies(Cons,Log):
	BigLog=[]
	num = len(Log)
	counter=0
	value=True
	for x in Log:
		counter = counter + 1
		if (counter % 100000==0):
			print( counter,"/",num)
		myvalue = satisfies(Cons,x)
		if (myvalue==True):
			BigLog.append(x)
		if (value==False):
			print(x)
	return BigLog

def satisfies(Cons,x):	
	# check that x satisfies the set of constraints Cons
	value = True
	for (a,b,type,Q) in Cons:
		value = value & check_process(x,[(a,b,type,Q)])
	return value

def check_process(A,data):
	answer = True
	debug= 0	# 0/1: set to 1 to print values
	for (i,j,type,l) in data:
		if (answer==True):
			if (type=='coexist'):
				answer = answer & check_type_coexist(A,i,j)
			elif (type=='not_coexist'):
				answer = answer & check_type_not_coexist(A,i,j)
			elif (type=='prec'):
				answer = answer & check_type_prec(A,i,j)
			elif (type=='weak_prec'):
				answer = answer & check_type_weak_prec(A,i,j)
			elif (type=='resp'):
				answer = answer & check_type_resp(A,i,j)
			elif (type=='weak_resp'):
				answer = answer & check_type_weak_resp(A,i,j)
			elif (type=='not_succ'):
				answer = answer & check_type_not_succ(A,i,j)
			elif (type=='succ'):
				answer = answer & check_type_succ(A,i,j)
			elif (type=='weak_succ'):
				answer = answer & check_type_weak_succ(A,i,j)
			elif (type=='succxor'):
				answer = answer & check_type_succxor(A,i,j,l)
			elif (type=='chain_resp'):
				answer = answer & check_type_chain_resp(A,i,j)
			elif (type=='chain_succ'):
				answer = answer & check_type_chain_succ(A,i,j)
			elif (type=='resp_exist'):
				answer = answer & check_type_resp_exist(A,i,j)
			elif (type=='not_resp'):
				answer = answer & check_type_not_resp(A,i,j)
			elif (type=='init'):
				answer = answer & check_type_init(A,i,j)
			elif (type=='final'):
				answer = answer & check_type_final(A,i,j)
			elif (type=='exclusivetwo'):
				answer = answer & check_type_exclusivetwo(A,i,j,l)
			elif (type=='orresp'):
				answer = answer & check_type_orresp(A,i,j,l)
			elif (type=='must_exist'):
				answer = answer & check_type_must_exist(A,i,j)
			else:
				exit(0)
		else:
			break
	return answer

def check_type_coexist(A,i,j):  
	X=set(A)
	if ((i in X) and (j in X)):
		Answer= True
	elif ((i not in X) and (j not in X)):
		Answer=True
	else:
		Answer=False
	return Answer

def check_type_must_exist(A,i,j):  
	# events i and j must occur in A
	Answer = (i in A and j in A)
	return Answer
	
def check_type_prec(A,i,j):
	# event j should only occur if event i has already occurred
	if ((j not in A)):
		answer=True
	elif ((j in A) & (i in A)):
		answer = ( A.index(i) < A.index(j) ) 
	elif ((j in A) & (i not in A)):
		answer = False
	else:
		exit(1)
	return answer

def check_type_weak_prec(A,i,j):
	# event j should only occur if event i has already occurred but does not have to
	if ((j not in A)):
		answer=True
	elif ((j in A) & (i in A)):
		answer = ( A.index(i) < A.index(j) ) 
	elif ((j in A) & (i not in A)):
		answer = False
	else:
		exit(1)
	return answer

def check_type_resp(A,i,j):
	# when i occurs, j should occur sometime after
	answer = True
	if (i in A)&(j in A):
			answer = (A.index(i)<A.index(j))
	elif (i in A)&(j not in A):
			answer=False
	elif (i not in A)&(j in A):
			answer=True 
	elif (i not in A)&(j not in A):
			answer=True
	else:
		exit(1)
	return answer

def check_type_weak_resp(A,i,j):
	# when i occures, j can occur sometime after but does not have to
	if (i in A)&(j in A):
			answer = (A.index(i)<A.index(j))
	elif (i in A)&(j not in A):
			answer=True
	elif (i not in A)&(j in A):
			answer=True
	elif (i not in A)&(j not in A):
			answer=True
	else:
		exit(1)
	return answer


def check_type_not_succ(A,i,j):
	# before j there cannot be i and after i there cannot be j
	if (i in A and j in A):
		Answer = (A.index(i)>A.index(j))	
	else:
		Answer = True
	return Answer

def check_type_not_coexist(A,i,j):
	# i and j cannot both be in A
	answer=True
	if (j in A)&(i in A):
		answer = False
	return answer
				
def check_type_succ(A,i,j):
	answer = check_type_prec(A,i,j) & check_type_resp(A,i,j)
	return answer

def check_type_weak_succ(A,i,j):
	answer = check_type_weak_prec(A,i,j) & check_type_weak_resp(A,i,j)
	return answer

def check_type_succxor(A,i,jone,jtwo):
	if (i in A)&((jone in A)|(jtwo in A)):
		answer = check_type_succ(A,i,jone)^^check_type_succ(A,i,jtwo)
	elif (i in A)&(jone not in A)&(jtwo not in A):
		answer = False
	elif (i not in A)&(jone not in A)&(jtwo not in A):
		answer = True
	else:
		answer=False
	return answer

def check_type_cond_succ(A,i,j):
	# conditional succession
	# true if i or (check_type_succ(A,i,j) = True)
	answer = (i in A) | (check_type_succ(A,i,j) == True)
	return answer

def check_type_chain_resp(A,i,j):
	# always (if i has occurred then j must follow immediately afterwards)
	if (i in A)&(j in A):
		answer = ((1+A.index(i))==A.index(j))
	elif (i in A) & (j not in A):
		answer=False
	elif (i not in A):
		answer=True
	return answer

def check_type_chain_succ(A,i,j):
	# always (if i has occurred then j must follow immediately afterwards)
	if (i in A)&(j in A):
		answer = ((1+A.index(i))==A.index(j))
	elif (i in A) & (j not in A):
		answer=False
	elif (i not in A) & (j in A):
		answer=False
	else:
		answer=True
	return answer

def check_type_resp_exist(A,i,j):
	# if i occurs in A then j must also occur 
	if (i in A)&(j in A):
		answer = True
	elif (i in A) & (j not in A):
		answer=False
	elif (i not in A) & (j not in A):
		answer=True
	elif (i not in A) & (j in A):
		answer=True
		# case might need to be revised in future
	return answer

def check_type_not_resp(A,i,j):
	if (i in A)&(j in A):
		answer = (A.index(i)>A.index(j))
	elif (i in A) & (j not in A):
		answer=True
	elif (i not in A) & (j not in A):
		answer=True
	elif (i not in A) & (j in A):
		answer=True
	return answer

def check_type_init(A,i,j): 	
	# if i happens occurs in A then it is first to occur
	if (i in A):
		answer = (A[0]==i)
	elif (i not in A):
		answer=True
	return answer

def check_type_final(A,i,j): 	
	# if i happens occurs in A then it is the last to occur
	if (i in A and A!=[]):
		answer = (A[len(A)-1]==i)
	elif (A==[]):
		answer=True
	elif (i not in A):
		answer==True
	return answer

def check_type_exclusivetwo(A,i,j,l): 	
	# exclusive choice 2 of 3
    # description: only two activities (from A, B and C) have to be executed.
    # LTL formula: ( ( ( ( <>("A") /\ <>( "B" ) ) \/ ( <>("A") /\ <>( "C" ) ) ) \/  ( <>("B") /\ <>( "C" ) ) ) /\ ! ( ( ( <>( "A" ) /\ <>( "B" ) ) /\ <>( "C" ) ) ) )
	answer = ((((i in A) and (j in A)) or ((i in A) and (l in A))) or ((j in A) and (l in A))) and not( (i in A) and (j in A) and (l in A))
	return answer

def check_type_orresp(A,i,j,l): 	
	if (i in A and j in A and l in A):
		answer = (A.index(i)< min(A.index(j),A.index(l)))
	elif (i in A and j in A and l not in A):
		answer = (A.index(i)<A.index(j))
	elif (i in A and j not in A and l in A):
		answer = (A.index(i)<A.index(l))
	elif (i not in A and j not in A and l not in A):
		answer = True
	else:
		answer = False
	return answer

def mybool(t,condition):
	return satisfies([condition],t)

def mycount(stakename,A):
	count = 0
	for t in A:
		if stakename(t):
			count = count + 1
	return count

def mycount_activities_depend(stakename,A,activities):
	count = 0
	for t in A:
		if stakename(t):
			count = count + 1
	return count

