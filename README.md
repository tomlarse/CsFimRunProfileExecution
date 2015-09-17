# CsFimRunProfileExecution
Automating FIM Run Profiles for Lync

## Use

Simply load the functions in your current powershell session and run

`CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Full`

or

`CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Delta`

and the run profiles should be executed in order. For automation just add one of the above to the end of the script and run that in a windows task scheduler. One delta update a day is often enough, but if the environment is very dynamic you might want to run it more often.

If you set `$debugpreference="Continue"` it'll display the status after each operation as well.
