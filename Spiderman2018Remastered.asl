/*
Shoutouts to JHobz for getting me all the addresses required for the EGS version, and big thanks to Canegar 
for being my guinea pig during the testing phase of the autosplitter :D
*/

state("Spider-Man", "Steam v1.812.1.0")
{
    int loading    : 0x7AF85D0; // basically a bool
    uint objective : 0x701DE44; // 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah.
    //int docSmack   : 0x5D1EF18; // goes from 166-167 at the final split time when doc gets a big ol smack
    //int obj2     : 0x701DE48
    //int obj3     : 0x701DE4C
}

state("Spider-Man", "EGS v1.812.1.0")
{
    int loading    : 0x7B08B50; // basically a bool
} 

init
{
    vars.loading = false;

    switch (modules.First().ModuleMemorySize) 
    {
        case 139841536: 
            version = "Steam v1.812.1.0";
            break;
        case 139911168: 
            version = "EGS v1.812.1.0";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
  {
		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Marvel's Spider-Man",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

update
{
//DEBUG CODE 
//print(current.loading.ToString()); 
//print(current.objective.ToString());

        //Use cases for each version of the game listed in the State method
		switch (version) 
	{
		case "Steam v1.812.1.0": case "EGS v1.812.1.0":
			vars.loading = current.loading == 1;
			break;
	}

}

start
{
	return (old.loading == 0 && current.objective == 648768089);
}

isLoading
{
    return vars.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}
