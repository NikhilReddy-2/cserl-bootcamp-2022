void
get_siblings_info(void)
{
	static char *states[] = {
		[UNUSED]    "unused",
  		[EMBRYO]    "embryo",
  		[SLEEPING]  "sleep ",
  		[RUNNABLE]  "runable",
  		[RUNNING]   "run   ",
  		[ZOMBIE]    "zombie"
	};
	struct proc *p;
	struct proc *curproc = myproc();
	int cur_par_pid = curproc->parent->pid;
  	acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if(p->parent->pid == cur_par_pid){
			cprintf("%d %s\n", p->pid, states[p->state]);
		}
	}
	release(&ptable.lock);
}


