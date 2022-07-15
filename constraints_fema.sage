### This file contains the original constraint set and all 7 other modiciations

fema = [
	(1,1,'init',0),
	(1,2,'prec',0),
	(2,3,'succ',0),
	(3,4,'succ',0),
	(4,5,'prec',0),
	(5,6,'prec',0),
	(5,7,'prec',0),
	(5,6,'orresp',7),
	(7,8,'succ',0),
	(8,9,'weak_resp',0),
	(9,10,'succ',0),
	(1,9,'prec',0)
	]

save(fema,'fema_modnull_constraints')

fema_mod1_to_save = [x for x in fema if x!=(1,9,'prec',0)] + [(8,9,'prec',0)]
save(fema_mod1_to_save,'fema_mod1_constraints')

fema_mod2_to_save = fema + [(4,11,'resp',0),(11,8,'prec',0)]
save(fema_mod2_to_save,'fema_mod2_constraints')

fema_mod3_to_save = [x for x in fema if x!=(4,5,'prec',0)] + [(1,5,'prec',0)]
save(fema_mod3_to_save,'fema_mod3_constraints')


def stakeholder1(t,activities): 
	Real_activities = [x for x in [4,5,8,11] if x in activities]
	truth_value = False
	for x in Real_activities:
		truth_value = truth_value or mybool(t,(x,x,'must_exist',0))
	return truth_value

def stakeholder2(t,activities): 
	Real_activities = [x for x in [4,5,8,11] if x in activities]
	truth_value = True
	for x in Real_activities:
		truth_value = truth_value and mybool(t,(x,x,'must_exist',0))
	return truth_value

def stakeholder3(t,activities): 
	answer = (mybool(t,(7,7,'must_exist',0)) and ( mybool(t,(4,7,'prec',0)) or mybool(t,(5,7,'prec',0)) ))
	answer = answer or ( mybool(t,(6,6,'must_exist',0)) and ( mybool(t,(4,6,'prec',0)) or mybool(t,(5,6,'prec',0))  ) )
	answer = answer or ( mybool(t,(11,11,'must_exist',0)) and ( mybool(t,(4,11,'prec',0)) or mybool(t,(5,11,'prec',0))  ) )
	return answer

def print_stakeholder_utilities(List):
	for name in List:
		print(name,":",); 
		A=load(name+'_traces')
		actions=load(name+'_activities_set')
		value1 = log(1+mynewcount(stakeholder1,A,actions))/log(1+len(A))
		value2 = log(1+mynewcount(stakeholder2,A,actions))/log(1+len(A))
		value3 = log(1+mynewcount(stakeholder3,A,actions))/log(1+len(A))
		#print("#traces=",len(A),"and #S1 traces= ",mycount(stakeholder1,A)," S1 utility=",N(value1,digits=6),"and #S2 traces= ",mycount(stakeholder2,A)," S2 utility=",N(value2,digits=6))
		print(len(A),"&",mynewcount(stakeholder1,A,actions),"&",N(value1,digits=6),"&",mynewcount(stakeholder2,A,actions),"&",N(value2,digits=6),"&",mynewcount(stakeholder3,A,actions),"&",N(value3,digits=6))

def mynewcount(stakename,Traces,activities):
    count = 0
    for t in Traces:
        if stakename(t,activities):
            count = count + 1
    return count

def get_stakeholder_traces(name,stakename):
	A=load(name+'_traces')
	actions=load(name+'_activities_set')
	B=[]
	for t in A:
		if stakename(t,actions):
			B.append(t)
	return B

	
