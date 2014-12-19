# upload alignments and partition file to server, submit jobs, then download results once
# all jobs finish

scp RunRaxml* $CLUSTER:shell/
scp -r Analyses/partitions.txt Analyses/Alignments/Phylip $CLUSTER:
ssh $CLUSTER mkdir Trees
ssh $CLUSTER bash shell/SubmitAll.bash
status=0
while [ $status -lt 1 ]
do
  sleep 3600
  status=$(ssh $CLUSTER qstat |grep "ho13001.* [RQ] " > /dev/null; echo $?;)
  echo "waiting..."
done
scp -r $CLUSTER:Trees Analyses/