state("Spider-Man")
{
    int loading : 0x7AF85D0;
    int inGame  : 0x5D3580C; //0 on Main Menu, 1 when in game
    
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
            "LiveSplit | Marvel's Spider-Man (Steam)",
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
}

start
{
	return (old.loading == 0 && current.loading == 1 && current.inGame == 1);
}

isLoading
{
	return current.loading == 1;
}

exit
{
	timer.IsGameTimePaused = true;
}
