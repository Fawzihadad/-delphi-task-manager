program TaskManager;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  // Represents a single task in the system
  TTask = record
    Title: String;
    IsCompleted: Boolean;
  end;

var
  Tasks: array[1..100] of TTask;
  TaskCount: Integer = 0;

// Adds a new task to the list
procedure AddTask;
var
  title: String;
begin
  if TaskCount >= 100 then
  begin
    Writeln('Task limit reached.');
    Exit;
  end;

  Write('Enter task title: ');
  ReadLn(title);

  Inc(TaskCount);
  Tasks[TaskCount].Title := title;
  Tasks[TaskCount].IsCompleted := False;

  Writeln('Task added successfully.');
end;

// Displays all tasks
procedure ViewTasks;
var
  i: Integer;
begin
  if TaskCount = 0 then
  begin
    Writeln('No tasks available.');
    Exit;
  end;

  for i := 1 to TaskCount do
  begin
    Write(i, '. ', Tasks[i].Title);

    if Tasks[i].IsCompleted then
      Write(' [Completed]');

    Writeln;
  end;
end;

// Marks a task as completed
procedure CompleteTask;
var
  index: Integer;
begin
  Write('Enter task number to complete: ');
  ReadLn(index);

  if (index < 1) or (index > TaskCount) then
  begin
    Writeln('Invalid task number.');
    Exit;
  end;

  Tasks[index].IsCompleted := True;
  Writeln('Task marked as completed.');
end;

// Displays menu options
procedure ShowMenu;
begin
  Writeln;
  Writeln('1. Add Task');
  Writeln('2. View Tasks');
  Writeln('3. Complete Task');
  Writeln('4. Exit');
  Write('Choose an option: ');
end;

var
  choice: Integer;

begin
  repeat
    ShowMenu;
    ReadLn(choice);

    case choice of
      1: AddTask;
      2: ViewTasks;
      3: CompleteTask;
    end;

  until choice = 4;

  Writeln('Goodbye!');
  ReadLn;
end.