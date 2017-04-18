Platform: Windows 10
Code implementation:
	global constant c;
	answer = algo(n);
	jump to result;
	
algo(n):
	answer = 0;
	if(n < 2) answer = 1;
	answer *= c
	if(answer != 0):
		return answer;
	else:
		(push current return address to stack)
		(push current argument to stack)
		n = n / 2;
		temp = algo(n);
		(pop current argument)
		answer = 2 * temp + c * n
		(pop current return address)
		return answer;