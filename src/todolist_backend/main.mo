import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import List "mo:base/List";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

actor TodoList {
  // タスクの定義
  type Task = {
    id: Nat;
    description: Text;
    completed: Bool;
    createdAt: Time.Time;
    updatedAt: ?Time.Time;
  };

  // ユーザーごとのタスクマップ
  private stable var taskEntries : [(Principal, [Task])] = [];
  private var tasks = Map.HashMap<Principal, List.List<Task>>(0, Principal.equal, Principal.hash);

  // システム初期化
  system func preupgrade() {
    // List<Task>から[Task]に変換してから保存
    taskEntries := Iter.toArray(
      Iter.map<(Principal, List.List<Task>), (Principal, [Task])>(
        tasks.entries(),
        func((p, tasks): (Principal, List.List<Task>)): (Principal, [Task]) {
          (p, List.toArray(tasks))
        }
      )
    );
  };

  system func postupgrade() {
    // [Task]からList<Task>に変換して復元
    for ((principal, taskArray) in Iter.fromArray(taskEntries)) {
      let taskList = List.fromArray<Task>(taskArray);
      tasks.put(principal, taskList);
    };
    taskEntries := [];
  };

  // 新しいタスクの作成
  public shared(msg) func createTask(description : Text) : async Nat {
    let caller = msg.caller;
    let userTasks = switch (tasks.get(caller)) {
      case null List.nil<Task>();
      case (?userTasks) userTasks;
    };
    
    let taskId = List.size(userTasks);
    let newTask : Task = {
      id = taskId;
      description = description;
      completed = false;
      createdAt = Time.now();
      updatedAt = null;
    };
    
    let updatedTasks = List.push(newTask, userTasks);
    tasks.put(caller, updatedTasks);
    
    return taskId;
  };

  // タスク一覧の取得
  public shared(msg) func getTasks() : async [Task] {
    let caller = msg.caller;
    let userTasks = switch (tasks.get(caller)) {
      case null List.nil<Task>();
      case (?userTasks) userTasks;
    };
    
    return List.toArray(userTasks);
  };

  // タスクの更新
  public shared(msg) func updateTask(id : Nat, description : Text, completed : Bool) : async Bool {
    let caller = msg.caller;
    let userTasks = switch (tasks.get(caller)) {
      case null return false;
      case (?userTasks) userTasks;
    };
    
    let updatedTasks = List.map<Task, Task>(
      userTasks,
      func (task) {
        if (task.id == id) {
          return {
            id = id;
            description = description;
            completed = completed;
            createdAt = task.createdAt;
            updatedAt = ?Time.now();
          };
        } else {
          return task;
        }
      }
    );
    
    tasks.put(caller, updatedTasks);
    return true;
  };

  // タスクの削除
  public shared(msg) func deleteTask(id : Nat) : async Bool {
    let caller = msg.caller;
    let userTasks = switch (tasks.get(caller)) {
      case null return false;
      case (?userTasks) userTasks;
    };
    
    let filteredTasks = List.filter<Task>(
      userTasks,
      func (task) { task.id != id }
    );
    
    tasks.put(caller, filteredTasks);
    return true;
  };
}