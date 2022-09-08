/*
Shoutouts to JHobz for getting me all the addresses required for the EGS version, and big thanks to Canegar 
for being my guinea pig during the testing phase of the autosplitter :D
*/

state("Spider-Man", "Steam v1.812")
{
    int loading      : 0x7AF85D0; // basically a bool
    uint objective   : 0x701DE44; // 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah.
    int docSmack     : 0x5D1EF18; // goes from 166-167 at the final split time when doc gets a big ol smack
    int acqBackpacks : 0x701B19C; // iz backpacks lul
    //int obj2     : 0x701DE48
    //int obj3     : 0x701DE4C
}

state("Spider-Man", "EGS v1.812")
{
    int loading    : 0x7B08B50; // basically a bool
} 

state("Spider-Man", "Steam v1.817")
{
    int loading    : 0x7AF95D0; // basically a bool. When scanning, make sure to look for interior loads, checkpoint loads, fast travel loads. Should be around 7A
    uint objective : 0x6F3E8D8; // 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah. 6F region of memory seems faster, theres a similar one in the 70 region.
} 

state("Spider-Man", "Steam v1.824")
{
    int loading    : 0x7B1A510; // basically a bool. When scanning, make sure to look for interior loads, checkpoint loads, fast travel loads. Should be around 7A-7B
    uint objective : 0x6E90258; // 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah. 
    // 6E-6F region of memory seems faster, theres a similar one in the 70 region.
    // make sure obj is 0 on main menu
} 


state("Spider-Man", "Steam v1.907")
{
    int loading    : 0x7B1BA70; // basically a bool. When scanning, make sure to look for interior loads, checkpoint loads, fast travel loads. Should be around 7A-7B
    uint objective : 0x6E91288; // 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah. 
    // 6E-6F region of memory seems faster, theres a similar one in the 70 region.
    // make sure obj is 0 on main menu
} 

init
{
    vars.loading = false;

    switch (modules.First().ModuleMemorySize) 
    {
        case 139841536: 
            version = "Steam v1.812";
            break;
        case 139845632: 
            version = "Steam v1.817";
            break;
        case 139911168: 
            version = "EGS v1.812";
            break;
        case 139980800 : 
            version = "Steam v1.824";
            break;
        case 139984896 : 
            version = "Steam v1.907";
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
		case "Steam v1.812": case "Steam v1.817": case "EGS v1.812": case "Steam v1.824": case "Steam v1.907":
			vars.loading = current.loading == 1;
			break;
	}

}

start
{
	return (old.objective == 0 && current.objective == 648768089);
}

split 
{ 	return
    //Ignore the following commented out objective values, only for testing/updating purposes.
    // You can scan for the following 4Byte values to find the objective address.
    // 0 on main menu
    // 648768089 on first cutscene
    // 3959482847 on swing tutorial
    // 1081701888 when the objective marker for "Clearing The Way" pops up
    // at this point, go back to main menu and search for 0 again. Only gonna be one address remaining
    (current.objective == 1230831290) && (old.objective != 1230831290) || // Moves from Clearing The Way - The Main Event 
	(current.objective == 911656026)  && (old.objective != 911656026)  || // Moves from The Main Event - My OTHER Other Job 
    (current.objective == 316826671)  && (old.objective != 316826671)  || // Moves from My OTHER Other Job - Keeping the Peace 
    (current.objective == 404089728)  && (old.objective != 404089728)  || // Moves from Keeping the Peace - Something Old, Something New
    (current.objective == 436592259)  && (old.objective != 436592259)  || // Moves from Something Old, Something New - Fisk Hideout & Landmarking
    (current.objective == 1229283555) && (old.objective != 1229283555) || // Moves from Fisk Hideout & Landmarking - For She's a Jolly Good Fellow
    (current.objective == 13877668)   && (old.objective != 13877668)   || // Moves from For She's A Jolly Good Fellow - Don't Touch The Art
    (current.objective == 3594905414) && (old.objective != 3594905414) || // Moves from Don't Touch The Art - A Shocking Comeback [if dbl, try 3251659580]
    (current.objective == 3472337876) && (old.objective != 3472337876) || // Moves from A Shocking Comeback - The Mask
    (current.objective == 2697528745) && (old.objective != 2697528745) || // Moves from The Mask - Day To Remember
    (current.objective == 2157044585) && (old.objective != 2157044585) || // Moves from Day To Remember - Harry's Passion Project
    (current.objective == 2036655449) && (old.objective != 2036655449) || // Moves from Harry's Passion Project - Financial Shock
    (current.objective == 2819266385) && (old.objective != 2819266385) || // Moves from Financial Shock - Wheels Within Wheels
    (current.objective == 721949320)  && (old.objective != 721949320)  || // Moves from Wheels Within Wheels - Home Sweet Home [ALT 3531790871]
    (current.objective == 3232178045) && (old.objective != 3232178045) || // Moves from Home Sweet Home - Stakeout && Couch Surfing [ALT 582408544]
    (current.objective == 3974304245) && (old.objective != 3974304245) || // Moves from Stakeout && Couch Surfing - Straw Meet Camel 
    (current.objective == 508893510)  && (old.objective != 508893510)  || // Moves from Straw Meet Camel - And The Award Goes To... (Apparently didnt work, dunno why)
    (current.objective == 1898405954) && (old.objective != 1898405954) || // Moves from And The Award Goes To... - Dual Purpose
    (current.objective == 1344066272) && (old.objective != 1344066272) || // Moves from Dual Purpose - Hidden Agenda
    (current.objective == 2346266155) && (old.objective != 2346266155) || // Moves from Hidden Agenda - A Fresh Start
    (current.objective == 316826671)  && (old.objective != 316826671)  || // Moves from A Fresh Start - Dinner Date
    (current.objective == 3332005264) && (old.objective != 3332005264) || // Moves from Dinner Date - Up The Water Spout...
    (current.objective == 1946090111) && (old.objective != 1946090111) || // Moves from Up The Water Spout... - What's In The Box? 
    (current.objective == 3917257570) && (old.objective != 3917257570) || // Moves from What's In The Box?  - Back To School
    (current.objective == 2641677965) && (old.objective != 2641677965) || // Moves from Back To School - Spider-Hack
    (current.objective == 139569742)  && (old.objective != 139569742)  || // Moves from Spider-Hack - Uninvited
    (current.objective == 1654122386) && (old.objective != 1654122386) || // Moves from Uninvited - Strong Connections
    (current.objective == 316826671)  && (old.objective != 316826671)  || // Moves from Strong Connections - First Day 
    (current.objective == 647221538)  && (old.objective != 647221538)  || // Moves from First Day - Collision Course {REPLACE}
    (current.objective == 2963508943) && (old.objective != 2963508943) || // Moves from Collision Course - The One That Got Away
    (current.objective == 1243652699) && (old.objective != 1243652699) || // Moves from The One That Got Away - Breakthrough
    (current.objective == 316826671)  && (old.objective != 316826671)  || // Moves from Breakthrough - Reflection & Out of The Frying Pan
    (current.objective == 2080745987) && (old.objective != 2080745987) || // Moves from Out of the Frying Pan... - Into The Fire 
    (current.objective == 858338621)  && (old.objective != 858338621)  || // Moves from Into The Fire - Picking Up The Trail
    (current.objective == 95081780)   && (old.objective != 95081780)   || // Moves from Picking Up The Trail - 
    (current.objective == 316826671)  && (old.objective != 316826671)  || // Moves from Streets of Poison - Supply Run 
    (current.objective == 637965749)  && (old.objective != 637965749)  || // Moves from Supply Run - Heavy Hitter
    (current.objective == 1425281762) && (old.objective != 1425281762) || // Moves from Heavy Hitter - Step Into My Parlor
    (current.objective == 1930171772) && (old.objective != 1930171772) || // Moves from Step Into My Parlor - The Heart of The Matter
    (current.objective == 3166672678) && (old.objective != 3166672678); // Moves from The Heart of The Matter - Pax in Bello (REPLACE)
    //(current.docSmack  == 167) && (old.docSmack  == 166) && (current.objective == 3934225188); // splits when doc gets a big ol smack
}

//bad values, dont use
//1279309092
//3064705042
//2254468055
//3549062773
//316826671

//3145605413 is kinda ehhhh cause its basically the "leave the lab" obj. Keeping for now cause it might work... but might not.

isLoading
{
    return vars.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}
