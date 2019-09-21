script "Badger2.ash";

# A badge-creation script by Tinsin
# with Frankensteined bits from cc_snapshot.ash

	record mytype{
		string namefield;
		string typefield;
	};
	
	mytype [int] itemlist;

	boolean load_current_map(string fname, mytype [int] map)
	{
		file_to_map(fname, map);
		return true;
	}

	
	boolean debug = true;
	void debug(string s)
	{
		if (debug) { print(s, "blue"); }
	}
	
	boolean verbose = true;
	boolean badges = true;
	
	int totalamt;

	string [string] results;
	

int i_a(string name)
{
	item i = to_item(name);
	if(i == $item[none])
	{
		return 0;
	}

	int amt = item_amount(i) + closet_amount(i) + equipped_amount(i) + storage_amount(i);
	amt += display_amount(i) + shop_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[]
	{
		if(have_familiar(fam) && fam != my_familiar())
		{
			if(i == familiar_equipped_equipment(fam))
			{
				amt += 1;
			}
		}
	}

	//Thanks, Bale!
	if(get_campground() contains i) amt += 1;
	return amt;
}

boolean hasItem(string name)
{
	int amt = i_a(name);
	if(amt > 0)
	{
	return true;
	}else{
	return false;
	}
}

void checkList(string filename, string src)
{
	load_current_map(filename, itemlist);
	print("Checking: " + src + "...", "olive");
	totalamt = 0;
	foreach x in itemlist
	{
		if(itemlist[x].typefield == "item"){
			if (hasItem(itemlist[x].namefield)){
				totalamt+=1;
				
				if (verbose){
				print("Have item: " + itemlist[x].namefield + "!", "green");
				}
				
				
			}else{
			if (verbose){
				print("Lacking item: " + itemlist[x].namefield + "...", "red");
				}
			}
		}
		if(itemlist[x].typefield == "familiar"){
			if (have_familiar(to_familiar(itemlist[x].namefield))){
				totalamt+=1;
				if (verbose){
				print("Have familiar: " + itemlist[x].namefield + "!", "green");
				}
				
				
			}else{
			if (verbose){
				print("Lacking familiar: " + itemlist[x].namefield + "...", "red");
				}
			}	
		}
		if(itemlist[x].typefield == "skill"){
			if (have_skill(to_skill(itemlist[x].namefield))){
				totalamt+=1;
				if (verbose){
				print("Have skill: " + itemlist[x].namefield + "!", "green");
				}
				
				
			}else{
			if (verbose){
				print("Lacking skill: " + itemlist[x].namefield + "...", "red");
				}
			}	
		}
		
	}
	print("You have " + totalamt + " out of " + count(itemlist) + ".", "olive");
		// calculate percentage
		float amount = totalamt;
		float total = count(itemlist);
		int altprog = amount/total*100;
		
		results[src] = altprog;
}

void main(string whichFile)
{
	if (whichFile == "")
	{
	}
	else
	{
	checkList("badger2-data/" + whichFile + ".txt", whichFile);
	}
}
