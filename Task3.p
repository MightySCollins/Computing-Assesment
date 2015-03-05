program Task3;
 {$APPTYPE CONSOLE}
 {$R *.res}

uses
  SysUtils;

Type
  gameRec = record
    name: string[30];
    skill: Integer;
    str: Integer;
    modif: Integer;
  end;

Var
  gameFile, game: file of gameRec;
  p1, p2: gameRec;
  awn: string;
  dice1, dice2: Integer;
  out , dev: boolean;
  //dev
  //turn:integer;

procedure stats; forward;
procedure showsavedstats; forward;

procedure writeGame;
begin
  reWrite(game);
  write(game, p1);
  write(game, p2);
  closeFile(game);
  if dev = true then
   begin
    write('writing');
    showSavedStats;
    //stats;
  end;
end;

procedure writeFile;
begin
  reWrite(gameFile);
  write(gameFile, p1);
  write(gameFile, p2);
  closeFile(gameFile);
  if dev = true then
   begin
   write('writing file');
    //showSavedStats;
    //stats;
  end;
end;

Procedure diceroll;
var
  dicecount, dicerolls: Integer;
begin
  writeLn(p1.name, '''s go');
  dicerolls := Random(7) + 3;
  if dev = false then
  begin
    for dicecount := 1 to dicerolls do
    //showSavedStats;
  end;
  dice1 := Random(6) + 1;
  writeLn('You got ', dice1);
  //readLn;
  writeLn(p2.name, '''s go');
  dicerolls := Random(7) + 3;
  if dev = false then
  begin
    for dicecount := 1 to dicerolls do
    begin
      dice2 := Random(6) + 1;
      writeLn(dice2);
      sleep(400);
    end
  end;
  dice2 := Random(6) + 1;
  writeLn('You got ', dice2);
  //readLn;
end;

Procedure showStats;
begin
  Reset(game);
  read(game, p1);
  read(game, p2);

  writeLn;
  writeLn(p1.name, '''s stats');
  if p1.skill < 0 then
  begin
    writeLn('Skill : Depleated');
    p1.skill := 0;
  end
  else
    writeLn('Skill: ', p1.skill);
  if p1.str < 0 then
    writeLn('Strength: Dead')
  else
    writeLn('Strength: ', p1.str);
  writeLn;
  writeLn(p2.name, '''s stats');
  if p2.skill < 0 then
  begin
    writeLn('Skill : Depleated');
    p2.skill := 0;
  end
  else
    writeLn('Skill: ', p2.skill);
  if p2.str < 0 then
    writeLn('Strength: Dead')
  else
    writeLn('Strength: ', p2.str);

  writeLn;
  writeLn('Skill Modifier: ', p2.modif);
  writeLn('Strength Modifier: ', p1.modif);
  writeLn;
  closeFile(game);
end;

Procedure showSavedStats;
begin
  Reset(gameFile);
  read(gameFile, p1);
  read(gameFile, p2);
  writeLn;
  writeLn(p1.name, '''s stats');
  writeLn('Skill: ', p1.skill);
  writeLn('Strength: ', p1.str);
  writeLn;
  writeLn(p2.name, '''s stats');
  writeLn('Skill: ', p2.skill);
  writeLn('Strength: ', p2.str);
  writeLn;
  writeLn('Skill Modifier: ', p2.modif);
  writeLn('Strength Modifier: ', p1.modif);
  writeLn;
  closeFile(gameFile);
end;

procedure modifier;
begin
  p1.modif := (p1.str - p2.str) div 5; // p1.modif is str
  p2.modif := (p1.skill - p2.skill) div 5; // p2.modif is skill
  p1.modif := ABS(p1.modif); // make sure it is positive, more efficent than if  but not sure what it actuall is ued for juswt found onlion e
  p2.modif := ABS(p2.modif);

  if p1.modif = 0 then // Added to make the game playable
    p1.modif := 1;
  if p2.modif = 0 then
    p2.modif := 1;
end;

Procedure play;
begin
  readLn;
  FileMode := fmOpenReadWrite;
  Reset(game);
  read(game, p1);
  read(game, p2);

  writeLn;
  writeLn('Let''s roll the dice');
  writeLn;
  //sleep(800);

  diceroll;
  modifier;

  if dice1 = dice2 then
    writeLn('Draw, try again')
  else if dice1 > dice2 then
  begin
    writeLn(p1.name, ' won!');
    p1.str := p1.str + p1.modif;
    p1.skill := p1.skill + p2.modif;
    p2.str := p2.str - p1.modif;
    p2.skill := p2.skill - p2.modif;
    writeGame;
    showStats;
  end
  else if dice1 < dice2 then
  begin
    writeLn(p2.name, ' won!');
    p1.str := p1.str - p1.modif;
    p1.skill := p1.skill - p2.modif;
    p2.str := p2.str + p1.modif;
    p2.skill := p2.skill + p2.modif;
    writeGame;
    showStats;
  end
  else
  begin
    writeLn('Sorry there seems to be an error with your dice');
    //sleep(500);
    writeLn('Rolling again');
    writeLn;
    play;
  end;
end;

procedure stats;
var
  ran12, ran4: Integer;
begin
  ran12 := Random(12) + 1;
  ran4 := Random(4) + 1;
  p1.skill := 10 + (ran12 div ran4);

  ran12 := Random(12) + 1;
  ran4 := Random(4) + 1;
  p1.str := 10 + (ran12 div ran4);

  ran12 := Random(12) + 1;
  ran4 := Random(4) + 1;
  p2.skill := 10 + (ran12 div ran4);

  ran12 := Random(12) + 1;
  ran4 := Random(4) + 1;
  p2.str := 10 + (ran12 div ran4);
end;

procedure resetsf;
var
  namelen: Integer;
  namepass: boolean;
  name: string;
begin
  writeLn('Creating new save');
  namelen := 0;
  namepass := false;

  repeat
    write('What is player 1''s name: ');
    readLn(name);
    namelen := length(name);
    if name = 'dev' then
      exit; // remove at some time
    if (namelen > 2) and (namelen < 30) then
    begin
      name[1] := upcase(name[1]);
      p1.name := name;
      namepass := true;
    end
    else
      writeLn('You name must be between 3 and 30 characters');
  until namepass = true;

  namepass := false;

  repeat
    write('What is player 2''s name: ');
    Read(name);
    namelen := length(name);
    if (namelen > 2) and (namelen < 30) then
    begin
      name[1] := upcase(name[1]);
      p2.name := name;
      namepass := true;
    end
    else
      writeLn('You name must be between 3 and 30 characters');
  until namepass = true;
  writeFile;
  writeGame;
  stats;
  modifier;
end;

procedure runGame;
begin
  //repeat
    repeat

    play;
    //turn:= turn + 1;
    if p1.str <= 0 then
    begin
      writeLn(p2.name, ' won, Congratuations');
      out := true;
    end;

    if p2.str <= 0 then
    begin
      writeLn(p1.name, ' won, Congratuations');
      out := true;
    end;
    until (p1.str <= 0)or (p1.skill <= 0);
  //until out = true;
  //writeln(turn);
  readLn;
  writeLn('Thanks fot playing, feel free to have another go');
  // possible repete
end;

procedure delay;
var
  dots, dotWait, dotCount: Integer;
begin
  write(' ');
  dots := Random(5) + 1;
  for dotCount := 1 to dots do
  begin
    dotWait := Random(800) + 500;
    sleep(dotWait);
    write('.');
  end;
  dotWait := Random(800) + 500;
  sleep(dotWait);
  writeLn('.');
end;

begin
  try
    dev := true; // REMOVE
    //out := true;
    FileMode := fmOpenRead;
    assignFile(gameFile, 'gamerec.dat');
    assignFile(game, 'game.dat');
    Randomize;
    writeLn('GCSE Controled Assesment Task 3, Exercise 3');
    writeLn('By Sam Collins');
    writeLn;
    writeLn;
    writeLn('Dice Game');
    if fileExists('game.dat') then
      if fileExists('gamerec.dat') then
      begin
        write('Do you want to use an old save file (y/n): ');
        readLn(awn);
        writeLn;
        if awn = 'n' then
          resetsf
        else
        begin
          writeLn('Here are your stats');
          writeGame;
        end;
      end
      else
        resetsf
    else
      resetsf;
    //showSavedStats;
    readln;
    runGame;
  except
    on E: Exception do
      if E.Message = 'File not found' then
      begin
        writeLn('Sorry the data files cannot be found, try adding ''gamerec.dat'' and ''game.dat'' into this directory');
        write('Would you like to generate new stats, if you chose no the game will quit (y/n): ');
          readLn(awn);
          if awn = 'y' then
            resetsf
          else
          begin
            writeLn('The application will now quit');
            exit;
            readln;
          end;
      end
      else
      begin
        writeLn('Sorry you seems to have encountered an error please restart the program');
        writeLn('ERROR: ', E.Message);
        readLn;
        readln;
      end;
  end;
end.
