/*
Shoutouts to JHobz for getting me all the addresses required for the EGS version, and big thanks to Canegar
for being my guinea pig during the testing phase of the autosplitter :D
_____________________________________________________________________________________________________________

Scanning Best Practices:

For LOADING  : basically a bool - 0 in game and 1 on loading screen.
When scanning, make sure to look for interior loads, checkpoint loads, fast travel loads. Should be around 7A/7B

For OBJECTIVE: 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah.
    - You can scan for the following 4Byte values to find the objective address.
    - 0 on main menu
    - 648768089 on first cutscene
    - 3959482847 on swing tutorial
    - 1081701888 when the objective marker for "Clearing The Way" pops up
    - at this point, go back to main menu and search for 0 again. Only gonna be one address remaining
*/

state("Spider-Man", "Steam v1.812")
{
    bool loading     : 0x7AF85D0;
    uint objective   : 0x701DE44;
    int docSmack     : 0x5D1EF18; // really bad lol, find another one
    int acqBackpacks : 0x701B19C; // number of collected backpacks, havent bothered maintaining since no one really seems to run backpacks
}

state("Spider-Man", "EGS v1.812")
{
    bool loading     : 0x7B08B50;
}

state("Spider-Man", "Steam v1.817")
{
    bool loading    : 0x7AF95D0;
    uint objective  : 0x6F3E8D8;
}

state("Spider-Man", "Steam v1.824")
{
    bool loading    : 0x7B1A510;
    uint objective  : 0x6E90258;
}

state("Spider-Man", "Steam v1.907")
{
    bool loading    : 0x7B1BA70;
    uint objective  : 0x6E91288;
}

state("Spider-Man", "Steam v1.919")
{
    bool loading    : 0x7B1F230;
    uint objective  : 0x6E94958;
}

state("Spider-Man", "Steam v1.1006")
{
    bool loading    : 0x7B63A10;
    uint objective  : 0x6ED6FA8;
}

state("Spider-Man", "Steam v1.1014")
{
    bool loading    : 0x7B69B30;
    uint objective  : 0x6EDB228;
}

state("Spider-Man", "Steam v2.217")
{
    bool loading    : 0x7B720D0;
    uint objective  : 0x7091304;
}

state("Spider-Man", "Steam v2.512")
{
    bool loading    : 0x7B74190;
    uint objective  : 0x6EE5658;
}

state("Spider-Man", "Steam v2.1012")
{
    bool loading    : 0x7B774D0;
    uint objective  : 0x6EEA798;

    /*These addresses were added due to the fact that some missions do not have an end marker. How markers were selected: filtering was done using "Spider-Man.exe" so that there was no need to search for an absolute address and the changed values ​​were compared at the time the mission ended.*/
    
    /* Эти адреса были добавлены из-за того что у некоторых миссий нет маркера окончания. Как выбирались маркеры: фильтрация шла по "Spider-Man.exe" чтоб не надобыло искать абсолютный адрес и сравнивались изменённые значения на момент кончания миссии.
    */
    int final       : 0x5D93F60;
    int fisk        : 0x620EB94;
    int enigma      : 0x6D1C418;
    uint taskmaster : 0x6F83628;

    uint hammer     : 0x77761B0;
    int arson       : 0x6D1EDA0;
    uint hand       : 0x6D1E808;
}

init
{
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
        case 140001280 :
            version = "Steam v1.919";
            break;
        case 140296192 :
            version = "Steam v1.1006";
            break;
        case 140320768 :
            version = "Steam v1.1014";
            break;
        case 140357632 :
            version = "Steam v2.217";
            break;
        case 140431360 :
            version = "Steam v2.512";
            break;
        case 140443648 :
            version = "Steam v2.1012";
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
    //print(modules.First().ModuleMemorySize.ToString());
    print(current.loading.ToString());
    //print(current.objective.ToString());
}

start
{
    return
    (current.objective == 648768089)  && (old.objective == 0)          || // Start of Main Story        / Начало Основной сюжетной линии
    (current.objective == 4005150524) && (old.objective != 4005150524) || // Start of DLC The Heist     / Начало DLC Ограбление
    (current.objective == 2295251211) && (old.objective != 2295251211) || // Start of DLC Turf Wars     / Начало DLC Войны банд
    (current.objective == 1262575096) && (old.objective != 1262575096);   // Start of DLC Silver Lining / Начало DLC Серебряный луч
}

// Note 1:
// If you enter the laboratory or F.E.A.S.T. The split will work just like that, but in a speedrun, why waste time on this and just go in like that.
// To avoid this, you need to find other addresses like "final" and "fisk"

// Примечание 1:
// Если заходить в лабораторию или П.И.Р. просто так и выходить будет срабатывать разделение, но в спидране зачем тратить на это время и просто так заходить.
// Чтоб этого небыло нужно найти другие адреса на подобие final и fisk

split
{
    return

    // Main Story - Act 1
    (current.objective == 1230831290) && (old.objective == 3238381551) || //  1 Clearing the Way / Расчистить путь
    (current.objective == 911656026)  && (old.objective == 3238381551) || //  2 The Main Event / Главное событие
    (current.objective == 3549062773) && (old.objective == 316826671)  || //  3 My OTHER Other Job / Моя СОВСЕМ другая работа
    (current.objective == 404089728)  && (old.objective == 3808387118) || //  4 Keeping the Peace / На страже мира
    (current.objective == 436592259)  && (old.objective == 316826671)  || //  5 Something Old, Something New / Старое и новое
    (current.objective == 2626097188) && (current.fisk == 1919111936) && (old.fisk == 1919090688) || //  6 Fisk Hideout / Тайник Фиска
    (current.objective == 1229283555) && (current.taskmaster == 341316431) && (old.taskmaster == 336117196) || //  7 Landmarking / Достопримечательности
    (current.objective == 3777655995) && (old.objective == 13877668)   || //  8 For She's a Jolly Good Fellow / Очень хорошая подруга
    (current.objective == 3594905414) && (old.objective == 4117803965) || //  9 Don't Touch the Art / Экспонаты руками не трогать
    (current.objective == 2865168134) && (old.objective == 3472337876) || // 10 A Shocking Comeback / Шокирующее возвращение
    (current.objective == 833531996)  && (old.objective == 2697528745) || // 11 The Mask / Маска
    (current.objective == 3549062773) && (old.objective == 2157044585) || // 12 Day to Remember / Незабываемый день
    (current.objective == 2036655449) && (current.taskmaster == 0) && (old.taskmaster == 606681206) || // 13 Harry's Passion Project / Любимый проект Гарри
    (current.objective == 3068724914) && (old.objective == 2819266385) || // 14 Financial Shock / Финансовый шок
    (current.objective == 721949320)  && (old.objective == 3531790871) || // 15 Wheels within Wheels / Запутанный клубок
    (current.objective == 3479506770) && (old.objective == 3232178045) || // 16 Home Sweet Home / Дом, милый дом
    (current.objective == 3136146485) && (current.enigma == 1) && (old.enigma == 0) || // 17 Stakeout / Загадка
    (current.objective == 833531996)  && (old.objective == 1279309092) || // 18 Couch Surfing / Поиск ночлега
    (current.objective == 508893510)  && (old.objective == 2440400581) || // 19 Straw, Meet Camel / Солома и верблюд
    (current.objective == 353420733)  && (old.objective == 1898405954) || // 20 And the Award Goes to... / И награда вручается...
    // Main Story - Act 2
    (current.objective == 3804164526) && (old.objective == 1344066272) || // 21 Dual Purpose / Двойное назначение
    (current.objective == 833531996)  && (old.objective == 2320960380) || // 22 Hidden Agenda / Тайные планы
    (current.objective == 3549062773) && (old.objective == 316826671)  || // 23 A Fresh Start / Новый этап
    (current.objective == 3479506770) && (old.objective == 3332005264) || // 24 Dinner Date / Свидание за ужином
    (current.objective == 1533167463) && (old.objective == 822423863)  || // 25 Up the Water Spout... / Вверх по течению...
    (current.taskmaster == 0)        && (old.taskmaster == 2434940301) || // 26 What's in the Box? / Что в коробке?
    (current.objective == 2641677965) && (old.objective == 373391364)  || // 27 Back to School / Снова в школу
    (current.objective == 139569742)  && (old.objective == 100720858)  || // 28 Spider-Hack / Паучий взлом
    (current.objective == 1654122386) && (old.objective == 1336589667) || // 29 Uninvited / Без приглашения
    (current.objective == 3549062773) && (old.objective == 316826671)  || // 30 Strong Connections / Прочные связи
    (current.objective == 833531996)  && (old.objective == 1279309092) || // 31 First Day / Первый день
    (current.objective == 2963508943) && (old.objective == 1892526492) || // 32 Collision Course / Конфликт интересов
    (current.objective == 1243652699) && (old.objective == 4063612993) || // 33 The One That Got Away / Тот, который скрылся
    (current.objective == 3549062773) && (old.objective == 316826671)  || // 34 Breakthrough / Прорыв
    (current.objective == 833531996)  && (old.objective == 1279309092) || // 35 Reflection / Отражение
    (current.objective == 4113332621) && (old.objective == 1538366734) || // 36 Out of the Frying Pan... / Из огня...
    // Main Story - Act 3
    (current.objective == 198504022)  && (old.objective == 858338621)  || // 37 ...Into the Fire / ...да в полымя
    (current.objective == 3530937685) && (current.final == 126) && (old.final == 77) || // 38 Picking up the Trail / По следу
    (current.objective == 3549062773) && (old.objective == 316826671)  || // 39 Streets of Poison / Ядовитые улицы
    (current.objective == 637965749)  && (old.objective == 4270247385) || // 40 Supply Run / Снабжение
    (current.objective == 1425281762) && (old.objective == 1108743238) || // 41 Heavy Hitter / Сильный удар
    (current.objective == 2723761626) && (old.objective == 1930171772) || // 42 Step Into My Parlor... / Заходите в гости...
    (current.objective == 833531996)  && (old.objective == 3064705042) || // 43 The Heart of the Matter / Суть вопроса
    (current.objective == 3934225188) && (current.final == 3) && (old.final == 6) || // 44 Pax in Bello / Пакс ин белло

    // DLC The Heist / Ограбление
    (current.objective  == 3556406812) && (old.objective  == 3045455919) || //  1 The Maria / "Мария"
    (current.objective  == 1557540777) && (current.arson  == 0) && (old.arson == 257) || //  2 The Trouble with Arson / Поджигатели
    (current.objective  == 643598106)  && (old.objective  == 1298453331) || //  3 Long Lost Loot / Утраченная добыча
    (current.objective  == 833979517)  && (old.objective  == 3482294712) || //  4 Like Old Times / Как в старые времена
    (current.taskmaster == 0)          && (old.taskmaster == 3171616002) || //  5 Something is Screwy / Кто-то что-то учудил
    (current.taskmaster == 3692335819) && (old.taskmaster == 296041762)  || //  6 Trail of the Cat / След кошки
    (current.objective  == 2553580923) && (old.objective  == 1948030466) || //  7 Pursuing the Truth / В погоне за правдой
    (current.objective  == 3917257570) && (old.objective  == 2537613679) || //  8 Newsflash / Экстренные новости
    (current.taskmaster == 1578489142) && (old.taskmaster == 689445737)  || //  9 Cover for the Cat / Прикрыть кошку
    (current.objective  == 2079938729) && (old.objective  == 200786147)  || // 10 Follow the Money / Жизнь по средствам

    // DLC Turf Wars / Войны банд
    (current.objective  == 4160888572) && (old.objective  == 3550084153) || //  1 Blindsided / Ошеломление
    (current.objective  == 2145992100) && (old.objective  == 1016982143) || //  2 The Bar With No Name / Безымянный бар
    (current.objective  == 2007888496) && (current.hand   == 0) && (old.hand == 4294967295) || //  3 Jury Rigging / На скорую руку
    (current.objective  == 935994307)  && (old.objective  == 3822110823) || //  4 Last Stand / Последний рывок
    (current.taskmaster == 118173392)  && (old.taskmaster == 2806294129) || //  5 Season Two / Второй сезон
    (current.taskmaster == 2650963818) && (old.taskmaster == 2065888505) || //  6 Lockup / Хранилище
    (current.taskmaster == 1557738183) && (old.taskmaster == 921691888)  || //  7 Yuri's Revenge / Месть Юри
    (current.objective  == 1134081948) && (old.objective  == 680423152)  || //  8 Bring the Hammer Down / Обезвредить Кувалду

    // DLC Silver Lining / Серебрянный луч
    (current.objective  == 2348154884) && (old.objective  == 4243665042) || //  1 Old Friends / Старые друзья
    (current.objective  == 2042748813) && (old.objective  == 2547644565) || //  2 Season 3 / Третий сезон
    (current.objective  == 227408241)  && (current.hand   == 0) && (old.hand == 4294967295) || //  3 Rio Bravo / Рио Браво
    (current.taskmaster == 882777474)  && (old.taskmaster == 1417167336) || //  4 Together But Alone / Вместе, но порознь
    (current.objective  == 2064914118) && (old.objective  == 2586444071) || //  5 Humanitarian Aid / Гуманитарная помощь
    (current.objective  == 3294404121) && (old.objective  == 332621095)  || //  6 Trust Issues / Вопрос доверия
    (current.objective  == 1286912590) && (old.objective  == 2067832768) || //  7 Getting Deep / Погружение
    (current.objective  == 3099571838) && (old.objective  == 1286912590) || //  8 Mysterious Mystery / Таинственная тайна
    (current.objective  == 886277244)  && (current.hammer == 0) && (old.hammer == 2648935993);   //  9 One Plus One Equals Win / Один плюс один равно победа
}

isLoading
{
    return current.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}
