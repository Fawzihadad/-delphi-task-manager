program TaskManager;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  // Represents a single task
  TTask = record
    Title: String;
    IsCompleted: Boolean;
  end;

var
  Tasks: array[1..100] of TTask;
  TaskCount: Integer = 0;

// Save tasks to file
procedure SaveTasksToFile;
var
  fileHandle: TextFile;
  i: Integer;
begin
  AssignFile(fileHandle, 'tasks.txt');
  Rewrite(fileHandle);

  for i := 1 to TaskCount do
    Writeln(fileHandle, Tasks[i].Title, '|', Tasks[i].IsCompleted);

  CloseFile(fileHandle);
end;

// Load tasks from file
procedure LoadTasksFromFile;
var
  fileHandle: TextFile;
  line: String;
begin
  if not FileExists('tasks.txt') then Exit;

  AssignFile(fileHandle, 'tasks.txt');
  Reset(fileHandle);

  TaskCount := 0;

  while not Eof(fileHandle) do
  begin
    ReadLn(fileHandle, line);
    Inc(TaskCount);
    Tasks[TaskCount].Title := Copy(line, 1, Pos('|', line) - 1);
    Tasks[TaskCount].IsCompleted := Pos('True', line) > 0;
  end;

  CloseFile(fileHandle);
end;

// Add new task
procedure AddTask;
var
  title: String;
begin
  if TaskCount >= 100 then
  begin
    Writeln('Maximum task limit reached (100 tasks).');
    Exit;
  end;

  Write('Enter task title: ');
  ReadLn(title);

  Inc(TaskCount);
  Tasks[TaskCount].Title := title;
  Tasks[TaskCount].IsCompleted := False;

  SaveTasksToFile;
  Writeln('Task added successfully.');
end;

// View tasks
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

// Mark task as complete
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
  SaveTasksToFile;
  Writeln('Task marked as completed.');
end;

// Delete task
procedure DeleteTask;
var
  index, i: Integer;
begin
  Write('Enter task number to delete: ');
  ReadLn(index);

  if (index < 1) or (index > TaskCount) then
  begin
    Writeln('Invalid task.');
    Exit;
  end;

  for i := index to TaskCount - 1 do
    Tasks[i] := Tasks[i + 1];

  Dec(TaskCount);
  SaveTasksToFile;
  Writeln('Task deleted.');
end;

// Menu
procedure ShowMenu;
begin
  Writeln;
  Writeln('1. Add Task');
  Writeln('2. View Tasks');
  Writeln('3. Complete Task');
  Writeln('4. Delete Task');
  Writeln('5. Exit');
  Write('Choose an option: ');
end;

var
  choice: Integer;

begin
  LoadTasksFromFile;

  repeat
    ShowMenu;
    ReadLn(choice);

    case choice of
      1: AddTask;
      2: ViewTasks;
      3: CompleteTask;
      4: DeleteTask;
    end;

  until choice = 5;

  Writeln('Goodbye!');
  ReadLn;
end.
