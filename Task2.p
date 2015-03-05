program Task2;
// By Sam Collins

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  skillsFile: Text;
  player: integer;

const
  players: integer = 20; //Saves the current number of players to add flexability

procedure generate;
var
  ran12, ran4, skill, str: integer;
begin
  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  skill := 10 + (ran12 div ran4);
  ran12 := random(12) + 1;
  ran4 := random(4) + 1;
  str := 10 + (ran12 div ran4);
  writeln(skillsFile, 'Player ', player, ',', skill, ',', str);
end;

begin
  try
    writeln('Skill file generator');
    writeln('By Sam Collins');
    assign(skillsFile, 'N:\GameFile.csv');
    rewrite(skillsFile);
    writeln(skillsFile, 'Player,Skill,Strength');
    randomize;
    player := 0;
    for player := 1 to players do
      generate;
    close(skillsFile);
    readln;

  except
    on E: Exception do
    begin
      if E.ClassName = 'EInOutError' then
        writeln('File is already open')
      else
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
      readln;
    end;
  end
end.
