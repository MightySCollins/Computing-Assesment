program Task3Debug;
// By Sam Collins

{$APPTYPE CONSOLE}
{$R *.res}
{
  This program is designed to open files created by my other program so they are
  readable to help me fix any bugs that there are and to detect if the file is
  changing.
}

uses
  System.SysUtils;

Type
  gameRec = record
    name: string[30];
    skill: Integer;
    str: Integer;
    modif: Integer;
  end;

var
  gameFile, game: file of gameRec;
  p1, p2, t1, t2, t3, t4: gameRec;
  level: Integer;

procedure show;
begin
  writeln(t1.name, '''s stats');
  writeln('Skill: ', t1.skill);
  writeln('Strength: ', p1.str);
  writeln;
  writeln(t2.name, '''s stats');
  writeln('Skill: ', t2.skill);
  writeln('Strength: ', t2.str);
  writeln;
  writeln('Skill Modifier: ', t2.modif);
  writeln('Strength Modifier: ', t1.modif);
end;

procedure update;
begin
  t1 := p1;
  t2 := p2;
end;

begin
  try
    writeln('Sam''s File Tester');
    FileMode := fmOpenRead;
    assignFile(gameFile, 'N:\gamerec.dat');
    assignFile(game, 'N:\game.dat');
    write('What level of testing do you want: ');
    readln(level);

    if fileExists('N:\gamerec.dat') then
    begin
      reset(gameFile);
      read(gameFile, p1);
      read(gameFile, p2);
      closeFile(gameFile);
      writeln('Gamerec.dat found, reading');
      t3 := p1;
      t4 := p2;
      writeln(t3.name, '''s stats');
      writeln('Skill: ', t3.skill);
      writeln('Strength: ', t3.str);
      writeln;
      writeln(t4.name, '''s stats');
      writeln('Skill: ', t4.skill);
      writeln('Strength: ', t4.str);
      writeln;
      writeln('Skill Modifier: ', t4.modif);
      writeln('Strength Modifier: ', t3.modif);
      writeln;
    end;

    if fileExists('N:\game.dat') then
    begin
      reset(game);
      read(game, p1);
      read(game, p2);
      closeFile(game);
      writeln('Game.dat found, reading');
      update;
      show;
      writeln;
    end;

    writeln('File Tester Running...');
    repeat
      sleep(50);
      reset(game);
      read(game, p1);
      read(game, p2);
      closeFile(game);

      if (p1.name <> t1.name) or (p2.name <> t2.name) then
      begin
        writeln('Changes detected in game.dat');
        update;
        show;
        writeln;
        writeln('Press ENTER to keep scanning');
        readln;
      end
      else if (level > 2) and (((p1.skill <> t1.skill) or (p1.str <> t1.str)) or
        ((p2.skill <> t2.skill) or (p2.str <> t2.str))) then
      begin
        writeln('Changes detected in game.dat');
        update;
        show;
        writeln;
      end;

      reset(gameFile);
      read(gameFile, p1);
      read(gameFile, p2);
      closeFile(gameFile);
      if (p1.name <> t3.name) or (p2.name <> t4.name) then
      begin
        writeln('Changes detected in gamerec.dat');
        t3 := p1;
        t4 := p2;
        show;
        writeln;
        writeln('Press ENTER to keep scanning');
        readln;
      end;

    until false;
  except
    on E: Exception do
    begin
      writeln('ERROR: ', E.Message);
      readln;
      readln;
    end;
  end;

end.
