int
get_ancestors(int n, int *array)
{
	int i = 0;
	struct proc *curproc = myproc();
	acquire(&ptable.lock);
	while(n > 0 && curproc->pid != 1){
		array[i] = curproc->parent->pid;
		curproc = curproc->parent;
		i++;
		n--;
	}
	release(&ptable.lock);
	return n == 0;
}
