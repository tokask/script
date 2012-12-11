def complementa(bin):
	
	compl = ""
	# controlliamo che il numero sia valido
	for i in range(0, len(bin)):
		if bin[i] != '0' and bin[i] != '1':
			return "Il numero dato in ingresso non e' valido!"
			
	
	# 1. individuo il primo 1 a partire dalla fine del numero
	
	i = len(bin) - 1 # N.B: len - 1!
	
	while i >= 0 and bin[i] != '1':
		compl = str(bin[i]) + compl
		i = i - 1
	
	# i e' posizionato nella cella dove ho trovato il primo 1
	# copio il primo uno...
	compl = str(bin[i]) + compl
	
	# 2. poi inverto tutti i bit rimanenti
	i = i - 1
	while i >= 0:
	
		if bin[i] == '0':
			compl = '1' + compl
		else:
			compl = '0' + compl
		i = i - 1
		dec = int(bin, 2)
		compl_hex=hex(int(str (compl),2))
	return compl, compl_hex, dec
		
