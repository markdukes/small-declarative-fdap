# This part is for generating all valid traces of the four prcesses from the constraints.

attach('pt1.sage')
List_Processes = [
	'fema_modnull_constraints',
	'fema_mod1_constraints',
	'fema_mod2_constraints',
	'fema_mod3_constraints']
for x in List_Processes:
	name = x + '_traces'
	A=load(x)
	print("Doing",x)
	Z = mylog(A,-1)
	save(Z,name)
for x in List_Processes:
	name = x + '_activities_set'
	A=load(x)
	List= list(set_of_acts(A))
	List.sort()
	save(List,name)

# This part is for calculating the stakeholder utilities from the traces files.

attach('pt1.sage')
List_Processes = [
	'fema_modnull_constraints',
	'fema_mod1_constraints',
	'fema_mod2_constraints',
	'fema_mod3_constraints']
print_stakeholder_utilities(List_Processes)

# For printing out the stakeholder preferences for each process/stakeholder pair:
B=get_stakeholder_traces('fema_mod2_constraints',stakeholder2)
save(B,'stakeholder2_mod2_traces')
# Now simple_trace_print the new file.

