program Task3;
{$APPTYPE CONSOLE}
{$R *.res}

uses
  SysUtils;

type
  gameRec = record // Creates record with varibles
    name: string[30];
    skill: Integer;
    str: Integer;
    modif: Integer;
  end;

  { Code Explanation
    This program creates 2 files for the same record. 1 is for the game save
    file which is created when he user fills in there stats and details and
    the other is made to save the current games progress. The reason for this
    is if i was to in the future extend my program I would allow the user to
    open an already started game but not a finished one and I would also allow
    them to keep using the same profile again and again. The code also has 2
    try�s and excepts which support custom error messages if I was to extend the
    program I would add more custom messages.
  }
var
  gameFile, game: file of gameRec; // assins game and gamefile to the record
  p1, p2: gameRec; // adds the recourds
  awn: string; // String for accepting user input
  dice1, dice2: Integer;
  dev, pass: boolean;
  turn: Integer;

procedure stats; forward; // Allows me to call the program at anytime

procedure writeGame; // Writes the game's current information to the file
begin
  rewrite(game);
  write(game, p1);
  write(game, p2);
  closeFile(game);
end;

procedure writeFile; // Writes the start game stats to a file
begin
  rewrite(gameFile);
  write(gameFile, p1);
  write(gameFile, p2);
  closeFile(gameFile);
end;

procedure diceRoll;
var
  dicecount, dicerolls: Integer;
begin
  writeln(p1.name, '''s go');
  dicerolls := random(5 + 3);
  if dev = false then
  begin
    for dicecount := 1 to dicerolls do
    begin
      dice1 := random(6) + 1;
      writeln(dice1);
      sleep(400);
    end
  end;
  dice1 := random(6) + 1;
  writeln('You got ', dice1);
  readLn;
  writeln(p2.name, '''s go');
  if dev = false then
  begin
    for dicecount := 1 to dicerolls do
    begin
      dice2 := random(6) + 1;
      writeln(dice2);
      sleep(400);
    end
  end;
  dice2 := random(6) + 1;
  writeln('You got ', dice2);
  readLn;
end;

procedure showStats;
begin
  Reset(game); // Shows the stats from the game file that are currently in use
  read(game, p1);
  read(game, p2);
  writeln;
  writeln(p1.name, '''s stats');
  if p1.skill < 0 then
  begin
    writeln('Skill : Depleated');
    p1.skill := 0;
  end
  else
    writeln('Skill: ', p1.skill);
  if p1.str < 0 then
    writeln('Strength: Dead')
  else
    writeln('Strength: ', p1.str);
  writeln;
  writeln(p2.name, '''s stats');
  if p2.skill < 0 then
  begin
    writeln('Skill : Depleated');
    // Shows the user depleates as oppsed to 0 or anything less when the user requests them
    p2.skill := 0;
  end
  else
    writeln('Skill: ', p2.skill);
  if p2.str < 0 then
    writeln('Strength: Dead')
  else
    writeln('Strength: ', p2.str);

  writeln;
  writeln('Skill Modifier: ', p2.modif);
  writeln('Strength Modifier: ', p1.modif);
  writeln;
  closeFile(game);
end;

procedure showSaved; // Outputs the saved stats in the savefile
begin
  Reset(gameFile);
  read(gameFile, p1);
  read(gameFile, p2);
  writeln;
  writeln(p1.name, '''s stats');
  writeln('Skill: ', p1.skill);
  writeln('Strength: ', p1.str);
  writeln;
  writeln(p2.name, '''s stats');
  writeln('Skill: ', p2.skill);
  writeln('Strength: ', p2.str);
  writeln;
  writeln('Skill Modifier: ', p2.modif);
  writeln('Strength Modifier: ', p1.modif);
  writeln;
  closeFile(gameFile);
end;

procedure modifier;
begin
  p1.modif := (p1.str - p2.str) div 5 + 2; // p1.modif is str
  p2.modif := (p1.skill - p2.skill) div 5 + 2; // p2.modif is skill
  p1.modif := ABS(p1.modif);
  // make sure it is positive, more efficent than dividing by -1
  p2.modif := ABS(p2.modif); // adde one for speed

  if p1.modif = 0 then // Added to make the game playable
    p1.modif := 1;
  if p2.modif = 0 then
    p2.modif := 1;
end;

procedure play;
begin
  Reset(game);
  read(game, p1);
  read(game, p2);
  readLn;
  writeln;
  writeln('Let''s roll the dice');
  writeln;

  diceRoll;
  modifier;
  if dice1 = dice2 then
    writeln('Draw, try again') // Does nothing if 2 players have the same number
  else if dice1 > dice2 then
  begin
    writeln(p1.name, ' won!');
    p1.str := p1.str + p1.modif;
    p1.skill := p1.skill + p2.modif;
    p2.str := p2.str - p1.modif;
    p2.skill := p2.skill - p2.modif;
    writeGame;
    showStats;
  end
  else if dice1 < dice2 then
  begin
    writeln(p2.name, ' won!');
    p1.str := p1.str - p1.modif;
    p1.skill := p1.skill - p2.modif;
    p2.str := p2.str + p1.modif;
    p2.skill := p2.skill + p2.modif;
    writeGame;
    showStats;
  end
  else
  begin
    writeln('Sorry there seems to be an error with your dice');
    sleep(500);
    writeln('Rolling again');
    writeln;
    play; // Calls the loop again as opposed to repeting it as will not oftern be used
  end;
end;

procedure stats;
// Generates the stats if the user decides they do not want to input them.
var
  ran12, ran4: Integer; // ran 12 is the random dice with 12 sides
begin
  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  p1.skill := 10 + (ran12 div ran4);

  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  p1.str := 10 + (ran12 div ran4);

  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  p2.skill := 10 + (ran12 div ran4);

  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  p2.str := 10 + (ran12 div ran4);
end;

procedure skillenter; // Allows people to enter there own skills
var
  awnI: Integer; // Integer equivilent of the users input
begin
  repeat
    try
      pass := false;
      write('Player 1 Skill: ');
      readLn(awn);
      awnI := strtoint(awn);
      if (awnI < 1) or (awnI > 30) then
        writeln('Enter a skill from 1 to 30')
      else
      begin
        p1.skill := awnI;
        pass := true;
      end;
    except
      on E: EConvertError do
        writeln('You must enter a integer');
    end;
  until pass = true;
  repeat
    try
      pass := false;
      write('Player 1 Strenth: '); // Makes it easier to
      readLn(awn);
      awnI := strtoint(awn); // Turns the awnser into an integer
      if (awnI < 1) or (awnI > 30) then // Makes sure it's in the accepted range
        writeln('Enter a strength from 1 to 30') // Displays an error message
      else
      begin
        p1.str := awnI;
        pass := true;
      end;
    except
      on E: EConvertError do // When something dosnt convert correctly
        writeln('You must enter a integer'); //
    end;
  until pass = true;
  repeat
    try
      pass := false;
      write('Player 2 Skill: ');
      readLn(awn);
      awnI := strtoint(awn);
      if (awnI < 1) or (awnI > 30) then
        writeln('Enter a skill from 1 to 30')
      else
      begin
        p2.skill := awnI;
        pass := true;
      end;
    except
      on E: EConvertError do
        writeln('You must enter a integer');
    end;
  until pass = true;
  repeat
    try
      pass := false;
      write('Player 2 strength: ');
      readLn(awn);
      awnI := strtoint(awn);
      if (awnI < 1) or (awnI > 30) then
        writeln('Enter a strength from 1 to 30')
      else
      begin
        p2.str := awnI;
        pass := true;
      end;
    except
      on E: EConvertError do
        writeln('You must enter a integer');
    end;
  until pass = true;
end;

procedure resetSave;
var
  namelen, count: Integer; // The lengh of the name
  name: string; // Varible for keeping name
  letters: set of 'A' .. 'z'; // makes a list of letters
  sym: boolean;
begin
  letters := ['A' .. 'z']; // Fills letters
  writeln('Creating new save');
  namelen := 0;
  pass := false;

  repeat
    write('What is player 1''s name: ');
    readLn(name);
    namelen := length(name);
    sym := false;
    for count := 1 to namelen do
      if not(name[count] in letters) then
        sym := true; // Conaitins symbl
    if sym = false then
      if (namelen > 2) and (namelen < 30) then
      // This name test is important because my recoud only supports upto 30chars, this is why it goes into a string first.
      begin
        name := lowercase(name);
        name[1] := upcase(name[1]); // Makes first letter capitle
        p1.name := name;
        // If name passes valuation the program will accept it to the recourd to stop crashes
        pass := true;
      end
      else
        writeln('You name must be between 3 and 30 characters')
    else
      writeln('You must enter letters');

  until pass = true; // Keeps loop going until name saved

  pass := false;
  repeat
    write('What is player 2''s name: ');
    readLn(name);
    namelen := length(name);
    sym := false;
    for count := 1 to namelen do
      if not(name[count] in letters) then
        sym := true;
    if sym = false then
      if (namelen > 2) and (namelen < 30) then
      begin
        name := lowercase(name);
        name[1] := upcase(name[1]); // Makes first letter capitle
        p2.name := name;
        pass := true;
      end
      else
        writeln('You name must be between 3 and 30 characters')
    else
      writeln('You must enter letters');
  until pass = true;
  pass := false;
  repeat
    write('Would you like to enter your own stats: ');
    readLn(awn);
    awn := lowercase(awn);
    writeln;
    if (awn = 'no') or (awn = 'n') then
    begin
      stats;
      pass := true; // Allows exit of loop
    end
    else if (awn = 'yes') or (awn = 'y') then
    begin
      skillenter; // Allows the user to enter there own skill
      pass := true;
    end
    else
      writeln('Sorry you must enter ''yes or no''');
  until pass = true;
  modifier;
  writeFile;
  if uppercase(p1.name) = 'DEV' then
  begin
    dev := true;
    p1.name := 'Sam'; // Makes the name used when playing Sam
    writeln('DEV account detected'); // Notifies me I am using a dev version
  end;
  writeGame;
end;

procedure runGame;
var
  winner: boolean; // Varible to store if player has won
begin
  winner := false; // Makes sure winner if false before entering loop
  repeat
    play;
    turn := turn + 1; // Turn increases by 1, later displayed to user

    if p1.str <= 0 then
    begin
      writeln(p2.name, ' won, Congratuations in ', turn, ' turns');
      winner := true;
    end;

    if p2.str <= 0 then
    begin
      writeln(p1.name, ' won, Congratuations in ', turn, ' turns');
      winner := true; // Sets winner to true to exit loop
    end;
  until winner = true;
  readLn;

  writeln('Thanks for playing, feel free to have another go');
  sleep(10000);
  exit;
end;

begin
  try
    filemode := fmOpenRead;
    assignfile(gameFile, 'N:\gamerec.dat');
    // Assigns file to location student drive
    assignfile(game, 'N:\game.dat');
    randomize;
    writeln('GCSE Controled Assesment Task 3, Exercise 3');
    writeln('By Sam Collins');
    writeln;
    writeln;
    writeln('Dice Game');
    if fileexists('N:\game.dat') and fileexists('N:\gamerec.dat') then
      if ((p1.skill > 0) or (p2.skill > 0)) then
      begin
        writeln('Game file corruption detected');
        writeln('Sorry but the game will have to reset the stats');
        writeln;
        resetSave; // Runs procedure to make sure it
      end
      else
      begin
        pass := false;
        repeat
          write('Do you want to use an old save file (y/n): ');
          readLn(awn);
          awn := lowercase(awn);
          writeln;
          if (awn = 'no') or (awn = 'n') then
          begin
            pass := true;
            resetSave;
          end
          else if (awn = 'yes') or (awn = 'y') then
          begin
            Reset(gameFile); // Reads files
            read(gameFile, p1);
            read(gameFile, p2);
            close(gameFile);
            if p1.name = 'DEV' then
            begin
              dev := true;
              p1.name := 'Sam';
              writeln('DEV account detected');
            end;
            writeln('Here are your stats');
            writeGame;
            pass := true;
          end
          else
            writeln('Sorry you must enter ''yes or no''');
        until pass = true;
      end
    else
      resetSave;
    showSaved;
    readLn; // Waits for user input
    runGame; // Runs the game
  except
    on E: Exception do
      if E.Message = 'File not found' then
      // Tests if file is missing so it can offer reset
      begin
        writeln('Sorry the data files cannot be found, try adding ''gamerec.dat'' and ''game.dat'' into this directory');
        pass := false; // Makes sure the pass varible is set to false
        repeat
          write('Would you like to generate new stats, if you chose no the game will quit (y/n): ');
          readLn(awn);
          awn := lowercase(awn); // Makes sure the program
          if (awn = 'yes') or (awn = 'y') then
            resetSave
          else if (awn = 'no') or (awn = 'n') then
          begin
            writeln('The application will now quit');
            sleep(500);
            // Sleeps before the program exits to make sure reader sees the message
            exit;
          end
          else
            writeln('Sorry you must enter ''yes or no''') until pass = true;
        end
      else
      begin
        writeln('Sorry you seems to have encountered an error please restart the program');
        // Tells the user there was a problem
        writeln('ERROR: ', E.Message);
        // Displays more information about the error
        readLn;
      end;
  end;

end.
