BEGIN {
	hpkid=0;
	d=0;
	d1=0;
	pp=0;
	pp1=0;
	avgdel=0;
}
{
	event = $1;
	time = $2;
	from = $3;
	to = $4;
	type = $5;
	size = $6;
	flowid = $8;
	src = $9;
	dest = $10;
	seq = $11;
	p_id = $12;

	
	if(p_id>hpkid)
		hpkid=p_id;
	if(type!="rtProtoDV")
	{
	if (event == "+" &&  from == 0)
		{start[p_id] = time;
		start1[p_id]=-1;
		}
	
	if (event == "r" && to == 5 && src == 0  )
	{
		stop[p_id] = time;
		stop1[p_id] = -1;
	}
	
	if (event == "+" && from == 1 )
		{start[p_id] = -1;
		start1[p_id]=time;
		}
	
	if (event == "r" && to == 5 && src == 1  )
	{
		stop[p_id] = -1;
		stop1[p_id] = time;
	}
	
	}
}
END {
	for(p_id=0;p_id<hpkid;p_id++)
	{

	if(start[p_id]!=-1 && start[p_id]!=0 && stop[p_id]!=-1 && stop[p_id]!=0 )
		{d=d+stop[p_id]-start[p_id];
		pp++;
		}	
	if(start1[p_id]!=-1 && start1[p_id]!=0 && stop1[p_id]!=-1 && stop1[p_id]!=0)
		{d1=d1+stop1[p_id]-start1[p_id];
		pp1++;
		}	
	}
	avgdel=(a/pp+d1/pp1)/2;
	printf("delay:%f\n",avgdel)

}
